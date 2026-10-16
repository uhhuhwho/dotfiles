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
| **Direct Auth Link** | [http://127.0.0.1:18789/#token=7e88d7838ee10988c6c25709eb56c965bc8e93ea0d6c5756ac944d9e61a0da2d](http://127.0.0.1:18789/#token=7e88d7838ee10988c6c25709eb56c965bc8e93ea0d6c5756ac944d9e61a0da2d) |
| **Gateway Token** | `7e88d7838ee10988c6c25709eb56c965bc8e93ea0d6c5756ac944d9e61a0da2d` |
| **Workspace Folder** | `/home/badreddine/OpenClaw` (`~/OpenClaw`) |
| **Docker Image** | `ghcr.io/openclaw/openclaw:latest` |

---

## 🤖 Configured AI Models (`xixiapi.io`)

Both Anthropic Claude and Z.ai GLM models are routed through your custom API provider (`xixiapi.io`):

### 1. Anthropic Claude (Native Messages API)
* **Base URL**: `https://xixiapi.io`
* **Models**:
  * `anthropic/claude-sonnet-5` *(Default)*
  * `anthropic/claude-sonnet-5-5`
  * `anthropic/claude-sonnet-4-6`

### 2. GLM & OpenAI Models (OpenAI-compatible API)
* **Base URL**: `https://xixiapi.io/v1`
* **Models**:
  * `glm/glm-5.3-flash` *(Fastest, reasoning enabled)*
  * `glm/glm-5-turbo`
  * `glm/glm-5.1`
  * `glm/glm-5.2`
  * `glm/glm-5.3`
  * `glm/gpt-5.4`
  * `glm/gpt-5.5`

### Switching Models
* **In the Web UI**: Use the model dropdown in the chat header.
* **Via Terminal**:
  ```bash
  # Switch to GLM 5.3 Flash
  docker compose run --rm openclaw-cli models set glm/glm-5.3-flash

  # Switch to Claude Sonnet
  docker compose run --rm openclaw-cli models set anthropic/claude-sonnet-5
  ```

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

