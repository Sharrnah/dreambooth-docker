## Install WSL2
- Enable Virtual Machine Platform
  - Search for **PowerShell**, right-click the top result, and select the **Run as administrator** option.
  - Enter `Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform` and press Enter.
- To install WSL2 on Windows 10, open Command Prompt as admin and run `wsl --install`
- The command will install all the WSL2 components and the Ubuntu Linux distro.

## Setup for Windows

- For Windows using WSL2, write a .wslconfig File in your user path with following content:

  ```ini
  [wsl2]
  memory=12GB # Limits VM memory in WSL 2 to X GB
  processors=3 # Makes the WSL 2 VM use X virtual processors
  localhostForwarding=true
  ```
- You can play with the values if your PC can't handle it.

- Install Docker Desktop for Windows: https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe

- Make sure you are running the newest NVIDIA Drivers and newest Docker Desktop Version.
  - See https://docs.microsoft.com/en-us/windows/ai/directml/gpu-cuda-in-wsl for more information about WSL support.
    
    (all newer Driver and Docker versions should support it out of the box.)

    Test with:
    > `wsl cat /proc/version`
    
    Needs kernel version of 5.10.43.3 or higher.

    Run
    > `wsl --update`
    
    to update the kernel.
