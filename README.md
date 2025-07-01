<div align="center">
  <img width="96" height="96" src="https://img.icons8.com/external-tal-revivo-bold-tal-revivo/96/228BE6/external-docker-a-set-of-coupled-software-as-a-service-logo-bold-tal-revivo.png" alt="docker_logo"/>

  <h1>Dockerffy</h1>
  <h4><strong>Docker configuration I use for managing services on my server.</strong></h4>
</div>

<hr />

<div align="center">
  <h3>System Overview</h3>

  <table>
    <thead>
      <tr>
        <th>Location</th>
        <th>Hostname</th>
        <th>CPU</th>
        <th>RAM</th>
        <th>Disk</th>
        <th>OS</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>Homelab</td>
        <td>fedora</td>
        <td>Intel N100</td>
        <td>8GB</td>
        <td>256GB</td>
        <td>Fedora 42 Cloud</td>
      </tr>
    </tbody>
  </table>
</div>

<hr />

<div align="center" style="max-width: 600px; margin: auto;">
  <div style="display: inline-flex; align-items: center; gap: 8px;">
    <img src="https://img.icons8.com/windows/32/228BE6/down--v1.png" alt="down" width="24" height="24" style="margin-top: 2px;" />
    <h3 style="margin: 0;">Installation</h3>
  </div>

  <pre style="text-align: left; margin-top: 16px; padding: 12px; border-radius: 6px; overflow-x: auto;">
# 1. Clone the repository
git clone https://github.com/erffy/dockerffy.git
cd dockerffy

# 2. Run the install script
sudo ./install.sh

# 3. Access Dockge at:
http://localhost:1000</pre>

  <div style="display: inline-flex; align-items: center; gap: 6px; font-size: 0.9em; margin-top: 12px; justify-content: center;">
    <img src="https://img.icons8.com/fluency/24/error.png" alt="error" width="24" height="24" />
    <strong>Warning:</strong> This script may behave unexpectedly. Test before use.
  </div>
</div>


<hr />

<div align="center">
  <div style="display: inline-flex; align-items: center; gap: 8px;">
    <img width="24" height="24" src="https://img.icons8.com/fluency/24/tree-structure.png" alt="tree-structure" style="margin-top: 2px;"/>
    <h3 style="margin: 0;">File Structure</h3>
  </div>

  <pre style="text-align: left; display: inline-block; margin-top: 8px;">
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
└── README.md</pre>

  <br/>

  <p>Made with ❤️ by <a href="https://github.com/erffy" target="_blank">erffy</a></p>
</div>