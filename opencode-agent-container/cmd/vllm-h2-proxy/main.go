package main

import (
	"crypto/tls"
	"errors"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"strings"
)

var hopByHopHeaders = map[string]struct{}{
	"connection":          {},
	"keep-alive":          {},
	"proxy-authenticate":  {},
	"proxy-authorization": {},
	"proxy-connection":    {},
	"te":                  {},
	"trailer":             {},
	"transfer-encoding":   {},
	"upgrade":             {},
}

func main() {
	upstream, err := parseUpstream()
	if err != nil {
		log.Fatal(err)
	}

	listen := getenv("OPENCODE_VLLM_PROXY_ADDR", "127.0.0.1:11434")
	debug := strings.EqualFold(os.Getenv("VLLM_PROXY_DEBUG"), "true")

	transport := http.DefaultTransport.(*http.Transport).Clone()
	transport.Proxy = http.ProxyFromEnvironment
	transport.ForceAttemptHTTP2 = true
	transport.DisableCompression = true
	if transport.TLSClientConfig == nil {
		transport.TLSClientConfig = &tls.Config{}
	}

	client := &http.Client{Transport: transport}
	handler := http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/healthz" {
			w.WriteHeader(http.StatusOK)
			_, _ = w.Write([]byte("ok\n"))
			return
		}

		if err := proxyRequest(client, upstream, w, r, debug); err != nil {
			log.Printf("proxy error: %v", err)
			http.Error(w, "vllm proxy error", http.StatusBadGateway)
		}
	})

	if debug {
		log.Printf("vLLM HTTP/2 proxy listening on %s upstream=%s", listen, redactURL(upstream))
	}
	if err := http.ListenAndServe(listen, handler); err != nil {
		log.Fatal(err)
	}
}

func parseUpstream() (*url.URL, error) {
	raw := strings.TrimSpace(getenv("VLLM_PROXY_UPSTREAM_BASE_URL", os.Getenv("VLLM_CODE_BASE_URL")))
	if raw == "" {
		return nil, errors.New("VLLM_PROXY_UPSTREAM_BASE_URL or VLLM_CODE_BASE_URL is required")
	}

	upstream, err := url.Parse(raw)
	if err != nil {
		return nil, err
	}
	if upstream.Scheme != "https" || upstream.Host == "" {
		return nil, errors.New("upstream base URL must be an https URL")
	}
	return upstream, nil
}

func proxyRequest(client *http.Client, upstream *url.URL, w http.ResponseWriter, r *http.Request, debug bool) error {
	target := *upstream
	target.Path = r.URL.Path
	target.RawPath = r.URL.RawPath
	target.RawQuery = r.URL.RawQuery

	req, err := http.NewRequestWithContext(r.Context(), r.Method, target.String(), r.Body)
	if err != nil {
		return err
	}
	copyHeaders(req.Header, r.Header)
	req.Header.Set("Accept-Encoding", "identity")

	resp, err := client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	copyHeaders(w.Header(), resp.Header)
	w.WriteHeader(resp.StatusCode)

	if debug {
		log.Printf("%s %s -> %s %d", r.Method, r.URL.RequestURI(), redactURL(&target), resp.StatusCode)
	}

	buf := make([]byte, 32*1024)
	flusher, _ := w.(http.Flusher)
	for {
		n, readErr := resp.Body.Read(buf)
		if n > 0 {
			if _, writeErr := w.Write(buf[:n]); writeErr != nil {
				return writeErr
			}
			if flusher != nil {
				flusher.Flush()
			}
		}
		if readErr == nil {
			continue
		}
		if errors.Is(readErr, io.EOF) {
			return nil
		}
		return readErr
	}
}

func copyHeaders(dst, src http.Header) {
	for key, values := range src {
		if _, skip := hopByHopHeaders[strings.ToLower(key)]; skip {
			continue
		}
		for _, value := range values {
			dst.Add(key, value)
		}
	}
}

func getenv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}

func redactURL(value *url.URL) string {
	redacted := *value
	redacted.User = nil
	redacted.RawQuery = ""
	return redacted.String()
}
