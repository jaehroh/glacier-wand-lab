# Jupyter Lab Configuration

c = get_config()  # noqa: F821

# Security settings
c.ServerApp.token = ''  # We use env var JUPYTER_TOKEN instead
c.ServerApp.password = ''
c.ServerApp.allow_origin = '*'
c.ServerApp.allow_remote_access = True

# Disable potentially dangerous features in untrusted environment
c.ServerApp.allow_root = False
c.ServerApp.open_browser = False

# Working directory
c.ServerApp.root_dir = '/home/developer/projects'

# Autosave
c.ContentsManager.autosave_interval = 120
