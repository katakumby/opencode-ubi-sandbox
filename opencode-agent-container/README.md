# Containerized OpenCode Agent

This image uses Red Hat Universal Base Image Minimal as the final runtime image and defaults to the interactive OpenCode TUI. Developers mount their local project into `/workspace`; OpenCode reads `/workspace/config.json` by default so each workspace can carry its own LLM config.

The image is pinned to `registry.access.redhat.com/ubi10/ubi-minimal:10.1`, OpenCode `1.14.41`, and ripgrep `15.1.0` by default. A tiny Go helper is built in a Red Hat UBI Go Toolset builder stage and copied into the final UBI Minimal image.

## Files

- `Dockerfile` builds from UBI Minimal, installs required RPM dependencies with `microdnf`, and copies pinned OpenCode, ripgrep, and the local vLLM HTTP/2 proxy helper into the final image.
- `entrypoint.sh` sets runtime defaults, normalizes identity header env vars, optionally starts the local vLLM HTTP/2 proxy helper, loads config from the mounted workspace, switches to `/workspace`, and starts `opencode`.
- `cmd/vllm-h2-proxy/main.go` accepts local HTTP/1.1 requests from OpenCode and forwards them to the real HTTPS vLLM endpoint through `HTTP_PROXY` / `HTTPS_PROXY` with HTTP/2 enabled upstream.
- `config.example.jsonc` defines OpenAI-compatible vLLM providers for coding and optional vision models.
- `.env.example` lists the environment variables developers should provide.
- `localca.crt` is the corporate root CA baked into the image at build time.

## Configure

Create config and env files in each workspace:

```bash
cp /path/to/opencode-agent-container/config.example.jsonc ./config.json
cp /path/to/opencode-agent-container/.env.example ./.env
```

Edit `config.json` before running:

- Replace `<exact-vllm-coding-model-id>` with a real ID from `GET $VLLM_CODE_BASE_URL/models`.
- Keep `small_model` equal to `model` unless you add a separate lightweight model under `provider.vllm-code.models`.
- Set each model's `limit.context` and `limit.output` to the served model's real limits.
- Keep `attachment: false` and text-only `modalities` for non-vision models.
- Only keep `vllm-vision` enabled when that endpoint and model really support image input.

Edit `.env`:

```dotenv
VLLM_CODE_BASE_URL=https://your-vllm-code.example.com/v1
VLLM_VISION_BASE_URL=https://your-vllm-vision.example.com/v1
VLLM_API_KEY=replace-with-your-vllm-api-key
OPENCODE_HEADER_USER=alice
OPENCODE_HEADER_DOMAIN=engineering
```

The coding provider in `config.json` uses `OPENCODE_VLLM_CODE_BASE_URL`. The entrypoint sets it to `VLLM_CODE_BASE_URL` by default. When the local HTTP/2 forwarding helper is enabled, the entrypoint sets it to `http://127.0.0.1:11434/v1` and the helper forwards to `VLLM_CODE_BASE_URL`.

For corporate networks that require a proxy, add the proxy variables to the workspace `.env`. Put the proxy in `HTTP_PROXY` and `HTTPS_PROXY` explicitly because some runtimes ignore `ALL_PROXY` for HTTPS requests:

```dotenv
HTTPS_PROXY=http://proxy.example.com:8080
HTTP_PROXY=http://proxy.example.com:8080
ALL_PROXY=http://proxy.example.com:8080
NO_PROXY=localhost,127.0.0.1,.internal.example.com
```

When the DLP proxy is configured in Docker Desktop as a host-local listener, keep the corporate loopback value in `.env`:

```dotenv
HTTP_PROXY=http://127.0.0.1:8080
HTTPS_PROXY=http://127.0.0.1:8080
ALL_PROXY=http://127.0.0.1:8080
```

The entrypoint rewrites proxy URLs that use `127.0.0.1`, `localhost`, or `[::1]` to `host.docker.internal` inside the container. This does not bypass the DLP proxy; it makes the host proxy reachable from container networking. Do not add the vLLM or RunPod host to `NO_PROXY` when DLP inspection is mandatory.

If OpenCode reports `Malformed_HTTP_Response` behind a mandatory DLP proxy, enable the local forwarding helper:

```dotenv
OPENCODE_VLLM_PROXY_ENABLED=true
OPENCODE_VLLM_PROXY_ADDR=127.0.0.1:11434
```

This keeps OpenCode on a local HTTP/1.1 loopback endpoint while the helper sends the external vLLM request over HTTPS through the corporate proxy and lets Go negotiate HTTP/2 upstream. Set `VLLM_PROXY_DEBUG=true` only when you need helper request logs.

The corporate root CA is baked into the image from `localca.crt` in the image project directory during `docker build`. The final UBI trust bundle is refreshed with `update-ca-trust extract`, so normal runs do not need a certificate mount.

To rebuild with a changed corporate CA, replace `localca.crt` in this image project and rebuild the image.

OpenCode sends the API key through the OpenAI-compatible provider and sends these custom headers with every LLM request:

- `x-user: $OPENCODE_HEADER_USER`
- `x-domain: $OPENCODE_HEADER_DOMAIN`

## Build

```bash
docker build -t ai-agent-opencode:local .
```

To pin different base or tool versions:

```bash
docker build \
  --build-arg UBI_IMAGE=registry.access.redhat.com/ubi10/ubi-minimal:10.1 \
  --build-arg GO_TOOLSET_IMAGE=registry.access.redhat.com/ubi10/go-toolset:1.25 \
  --build-arg OPENCODE_VERSION=1.14.41 \
  --build-arg RIPGREP_VERSION=15.1.0 \
  -t ai-agent-opencode:local .
```

## Run On Linux Or macOS

From the workspace you want OpenCode to edit:

```bash
docker run --rm -it \
  --env-file .env \
  -e LOCAL_UID="$(id -u)" \
  -e LOCAL_GID="$(id -g)" \
  -v "$PWD:/workspace" \
  ai-agent-opencode:local
```

Run OpenCode CLI subcommands by passing them after the image name:

```bash
docker run --rm -it \
  --env-file .env \
  -v "$PWD:/workspace" \
  ai-agent-opencode:local models vllm-code
```

The default config path is `/workspace/config.json`. For an alternate path, pass `-e OPENCODE_CONFIG=/workspace/path/to/config.json`.

## Run From PowerShell

Prepare a workspace-local config and env file:

```powershell
$agent = "E:\AI\workspaces\opencode-agent-container"
$workspace = (Get-Location).Path

Copy-Item "$agent\config.example.jsonc" "$workspace\config.json"
Copy-Item "$agent\.env.example" "$workspace\.env"
```

Build the image from the agent image project:

```powershell
$agent = "E:\AI\workspaces\opencode-agent-container"

docker build -t ai-agent-opencode:local $agent
```

Run the TUI from the workspace you want OpenCode to edit:

```powershell
$workspace = (Get-Location).Path

docker run --rm -it `
  --env-file "$workspace\.env" `
  -v "${workspace}:/workspace" `
  ai-agent-opencode:local
```

List configured vLLM models:

```powershell
$workspace = (Get-Location).Path

docker run --rm -it `
  --env-file "$workspace\.env" `
  -v "${workspace}:/workspace" `
  ai-agent-opencode:local models vllm-code
```

Run a small non-editing smoke prompt:

```powershell
$workspace = (Get-Location).Path

docker run --rm -it `
  --env-file "$workspace\.env" `
  -v "${workspace}:/workspace" `
  ai-agent-opencode:local run --model vllm-code/qwen3-coder-30b-a3b-fp8 "Reply exactly: OK"
```

Check the OpenCode version:

```powershell
docker run --rm -it ai-agent-opencode:local --version
```

## Validation

Basic image checks:

```bash
docker run --rm -it ai-agent-opencode:local --version
docker run --rm -it ai-agent-opencode:local bash -lc 'cat /etc/os-release && rg --version'
docker run --rm -it \
  --env-file .env \
  -v "$PWD:/workspace" \
  ai-agent-opencode:local models vllm-code
```

To validate headers, point `VLLM_CODE_BASE_URL` at a mock OpenAI-compatible endpoint or your routing layer and confirm requests include:

- `Authorization: Bearer <VLLM_API_KEY>`
- `x-user: <OPENCODE_HEADER_USER>`
- `x-domain: <OPENCODE_HEADER_DOMAIN>`

Then smoke-test the TUI against a small mounted repository and confirm `edit` and `bash` actions ask for approval.
