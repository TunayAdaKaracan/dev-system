# Picotron Dev System
This is a modified system of Picotron. It is designed for [Arc System Loader](https://github.com/TunayAdaKaracan/arc-system-loader) but can be used as a standalone system.
This system is recommended to be base system for forks. 

## Arc System Loader Installation
1. If not installed, install arc system loader.
2. Download dev system as a zip file
3. Extract on /systems/dev
4. Go to /system/boot.lua and set `selected_system` to `dev`
5. Reboot

## Standalone Installation
1. Create a /system folder on host.
2. Put contents of dev system to /system.
3. Reboot

## Features
- require() -> Checks both current and system lib files. Returns what that file returns
- git.lua -> git cli tool. (On development)
- Userland processes can access to kernel functions
- startup.lua does not return an error on version mismatch. Just a small notify.

### TODO
- [ ] apt system for libraries and apps
- [ ] app explorer with GUI
- [ ] more cli tools
- [ ] complete apply_changes.lua to reflect any changes from /system to /system/dev
