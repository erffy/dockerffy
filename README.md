<p>
  <img width="96" height="96" src="https://img.icons8.com/external-tal-revivo-bold-tal-revivo/96/228BE6/external-docker-a-set-of-coupled-software-as-a-service-logo-bold-tal-revivo.png" alt="docker_logo"/>
</p>

# Dockerffy

### Docker configuration I use for managing services on my server.

---

## System Overview

| Location | Hostname | CPU       | RAM | Disk  | OS            |
|----------|----------|-----------|-----|-------|---------------|
| Homelab  | fedora   | Intel N100| 8GB | 256GB | Fedora 42 Cloud|

---

## Installation

<p>
  <img src="https://img.icons8.com/windows/32/228BE6/down--v1.png" alt="down" width="24" height="24" style="vertical-align: middle;" />
  <strong>Installation Instructions</strong>
</p>

```bash
# 1. Clone the repository
git clone https://github.com/erffy/dockerffy.git
cd dockerffy

# 2. Run the install script
sudo ./install.sh

# 3. Access Dockge at:
http://localhost:1000
```

<p style="color:#b33; font-size: 0.9em;">
  <img src="https://img.icons8.com/fluency/24/error.png" alt="error" width="24" height="24" style="vertical-align: middle;" />
  <strong>Warning:</strong> This script may behave unexpectedly. Test before use.
</p>

---

## File Structure

<p>
  <img width="24" height="24" src="https://img.icons8.com/fluency/24/tree-structure.png" alt="tree-structure" style="vertical-align: middle;"/>
  <strong>Project Files</strong>
</p>

```plaintext
files/
├── apps/
│   ├── adguard/
│   │   └── compose.yaml
│   ├── convertx/
│   │   └── compose.yaml
│   ├── librespeed/
│   │   └── compose.yaml
│   ├── nextcloud/
│   │   └── compose.yaml
│   ├── pastebin/
│   │   └── compose.yaml
│   └── slimserve/
│       └── compose.yaml
├── core/
│   ├── dockge/
│   │   └── compose.yaml
│   └── postgresql/
│       ├── .env.example
│       └── compose.yaml
├── install.sh
├── uninstall.sh
├── utils.sh
└── README.md
```

---

<p>Made with ❤️ by <a href="https://github.com/erffy" target="_blank">erffy</a></p>
