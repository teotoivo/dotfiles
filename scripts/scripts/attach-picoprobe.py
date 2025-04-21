import subprocess
import re
from datetime import datetime

# --- Config ---
VID_PID = "2e8a:000c"

def log(msg):
    timestamp = datetime.now().strftime('%H:%M:%S')
    print(f"[{timestamp}] {msg}")

def run_cmd(cmd):
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    return result.stdout.strip(), result.stderr.strip()

# --- Step 1: Find the device ---
log("Starting PicoProbe attach script")
log(f"Looking for device with VID:PID {VID_PID}...")

stdout, stderr = run_cmd("usbipd list")
if stderr and not stdout:
    log(f"❌ Error running 'usbipd list': {stderr}")
    input("Press Enter to exit...")
    exit(1)

busid = None
for line in stdout.splitlines():
    if VID_PID in line:
        match = re.match(r"^(\S+)", line.strip())
        if match:
            busid = match.group(1)
            log(f"✅ Found PicoProbe at BusID {busid}")
        break

if not busid:
    log("❌ PicoProbe not found. Is it plugged in?")
    input("Press Enter to exit...")
    exit(1)

# --- Step 2: Bind the device ---
log("Binding device...")
stdout, stderr = run_cmd(f"usbipd bind --busid {busid}")
bind_output = (stdout + stderr).lower()
if "already shared" in bind_output:
    log("ℹ️  Device already shared.")
elif "error" in bind_output:
    log(f"❌ Error while binding: {bind_output}")
    input("Press Enter to exit...")
    exit(1)
else:
    log("✅ Successfully bound.")

# --- Step 3: Attach the device ---
log("Attaching device to WSL...")
stdout, stderr = run_cmd(f"usbipd attach --wsl --busid {busid}")
attach_output = (stdout + stderr).lower()
if "already attached" in attach_output:
    log("ℹ️  Device already attached.")
elif "error" in attach_output and "info:" not in attach_output:
    log(f"❌ Error while attaching: {attach_output}")
    input("Press Enter to exit...")
    exit(1)
else:
    log("✅ Successfully attached to WSL.")

log("🎉 Done. PicoProbe is ready in WSL.")
input("Press Enter to close...")
