# Containerized OpenCode Agent

This image uses Red Hat Universal Base Image Minimal as the final runtime image and defaults to the interactive OpenCode TUI. Developers mount their local project into `/workspace`; OpenCode reads `/workspace/config.json` by default so each workspace can carry its own LLM config.

The image is pinned to `registry.access.redhat.com/ubi10/ubi-minimal:10.1`, OpenCode `1.14.41`, and ripgrep `15.1.0` by default.

## Files

- `Dockerfile` builds from UBI Minimal, installs required RPM dependencies with `microdnf`, and copies pinned OpenCode and ripgrep release binaries into the final image.
- `entrypoint.sh` sets runtime defaults, normalizes identity header env vars, loads config from the mounted workspace, switches to `/workspace`, and starts `opencode`.
- `config.example.jsonc` defines OpenAI-compatible vLLM providers for coding and optional vision models.
- `.env.example` lists the environment variables developers should provide.

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

From the workspace you want OpenCode to edit:

```powershell
$agent = "E:\AI\workspaces\opencode-agent-container"
$workspace = (Get-Location).Path

docker run --rm -it `
  --env-file "$workspace\.env" `
  -v "${workspace}:/workspace" `
  ai-agent-opencode:local
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
