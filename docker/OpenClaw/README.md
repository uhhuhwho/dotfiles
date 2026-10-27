# OpenClaw Docker Setup & Operational Guide

A lightweight, secure, and isolated deployment of [OpenClaw](https://docs.openclaw.ai/) running inside Docker Compose.

---

## 📌 Architecture & File Isolation

To protect your host machine and ensure the agent only interacts with files you explicitly allow, OpenClaw runs in a restricted container sandbox:

```text
Host System                                         Container (/home/node)
├── ~/OpenClaw               ──[Volume Mount]──>   ~/.openclaw/workspace  (ONLY working folder)
├── ./data/config            ──[Volume Mount]──>   ~/.openclaw            (Settings, DB, tokens)
└── ./data/secrets           ──[Volume Mount]──>   ~/.config/openclaw     (Auth secrets)
```

* **Restricted Workspace**: The agent can **only** read, edit, execute scripts, and create files inside `~/OpenClaw` (`/home/badreddine/OpenClaw`).
* **Host Isolation**: The rest of your host system (`~/.ssh`, `~/Documents`, `~/Downloads`, etc.) is **completely invisible and inaccessible** to the container.
* **Hardened Security**: The Docker socket (`docker.sock`) is not mounted, capabilities `NET_RAW` and `NET_ADMIN` are dropped, and `no-new-privileges` is enforced.

---

## 🚀 Quick Reference

| Feature | Details |
| :--- | :--- |
| **Control Web UI** | [http://127.0.0.1:18789](http://127.0.0.1:18789) |
| **Direct Auth Link** | Print it with: `echo "http://127.0.0.1:18789/#token=$(grep '^OPENCLAW_GATEWAY_TOKEN=' .env \| cut -d= -f2)"` |
| **Gateway Token** | Lives in `.env` as `OPENCLAW_GATEWAY_TOKEN`. **Never paste it into this file** — this README is snapshotted into the public dotfiles repo by `dotsync`. |
| **Workspace Folder** | `/home/badreddine/OpenClaw` (`~/OpenClaw`) |
| **Docker Image** | `ghcr.io/openclaw/openclaw:latest` |

---

## 🤖 Configured AI Models

The `xixiapi.io` Anthropic preset has been **removed**. Claude now authenticates through the **Claude CLI subscription token** (no API key), and GPT models come from the **Codex** provider.

### 1. Anthropic Claude — via Claude CLI token (no API key)
No `ANTHROPIC_API_KEY` / `ANTHROPIC_BASE_URL` is set, and no `baseUrl` override remains in `openclaw.json`, so Claude resolves to the official endpoint using an OAuth token minted by the host's Claude CLI.

The container has **no `claude` binary** (the CLI lives on the host at `/usr/sbin/claude`), so the token is minted on the host and pasted in:

```bash
# 1. On the HOST (interactive, needs a TTY + an active Claude subscription)
claude setup-token

# 2. Paste it into OpenClaw (run from this directory)
docker compose run --rm openclaw-cli models auth paste-token --provider anthropic

# 3. Verify
docker compose run --rm openclaw-cli models auth list
docker compose run --rm openclaw-cli models list
```

Re-run `claude setup-token` and step 2 whenever the token expires. This keeps the host-isolation guarantee above intact — the container never sees `~/.claude`.

### 2. Codex / GPT models (OpenAI-compatible API)
* **Base URL**: `https://xixiapi.io/v1` (`OPENAI_BASE_URL`)
* **Key**: `OPENAI_API_KEY` in `.env`
* **Catalog**: `~/Downloads/codex-models.json` — routed through Sub2API, reasoning levels `low` / `medium` / `high` / `xhigh`:
  * `gpt-5.2`
  * `gpt-5.3-codex`
  * `gpt-5.3-codex-spark`
  * `gpt-5.4`
  * `gpt-5.5`
  * `gpt-5.6-sol`
  * `gpt-6-astra`

### Switching Models
* **In the Web UI**: Use the model dropdown in the chat header.
* **Via Terminal**:
  ```bash
  # Confirm which slugs the gateway actually resolves first
  docker compose run --rm openclaw-cli models list

  # Claude (via the CLI token)
  docker compose run --rm openclaw-cli models set anthropic/claude-sonnet-5

  # Codex
  docker compose run --rm openclaw-cli models set gpt-5.3-codex
  ```

> The default model is still `anthropic/claude-sonnet-5` from the old preset. That slug was previously served by xixiapi — confirm it against `models list` once the CLI token is in place and `models set` a valid one if it does not resolve.

---

## 📱 Telegram Bot Setup

OpenClaw is integrated with your personal Telegram bot so you can chat with it from your phone:

* **Access Control**: By default, OpenClaw blocks strangers on Telegram. Only your approved Telegram User ID is allowed to send prompts and execute tasks.
* **Pairing Approvals**: If you ever connect from a new Telegram account or device, approve the pending request using:
  ```bash
  docker compose run --rm openclaw-cli pairing list
  docker compose run --rm openclaw-cli pairing approve <PAIRING_CODE>
  ```
  *(Or approve with one click in the Web UI notification bell).*

---

## 🛠️ Daily Docker Operations

Run these commands from this directory (`/home/badreddine/Documents/Docker/OpenClaw`):

### Start the Gateway
```bash
docker compose up -d openclaw-gateway
```

### Stop the Gateway
```bash
docker compose down
```

### View Live Logs
```bash
docker compose logs -f openclaw-gateway
```

### Check Service Health
```bash
docker compose ps
```

### Run CLI Commands
```bash
# Check model auth and status
docker compose run --rm openclaw-cli models status

# List all available models
docker compose run --rm openclaw-cli models list

# Run a single turn from CLI
docker compose run --rm openclaw-cli agent --model glm/glm-5.3-flash --message "Hello"

# Health check & diagnostics
docker compose run --rm openclaw-cli doctor
```

---

## 📁 Directory Structure

```text
/home/badreddine/Documents/Docker/OpenClaw/
├── docker-compose.yml   # Multi-service container definitions
├── .env                 # API keys, tokens, and directory paths
├── README.md            # This documentation
└── data/                # Persistent storage (auto-mounted to container)
    ├── config/          # openclaw.json, SQLite database, session state
    └── secrets/         # Auth profile encryption keys
```

