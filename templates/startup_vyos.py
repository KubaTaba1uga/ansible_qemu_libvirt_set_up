import os
from pathlib import Path

USER_CONFIG = Path("/dev/vdb")

if not USER_CONFIG.exists():
    exit(0)

os.system(f"vbash {USER_CONFIG}")
