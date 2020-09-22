![Logo](https://raw.githubusercontent.com/GarretSidzaka/Torch_Watchdog/master/torch_watchdog.png)

# TorchWatchdog

![Example of program](https://raw.githubusercontent.com/GarretSidzaka/Torch_Watchdog/master/torch_watchdog3_ex.png)

## Table of contents
* [General info](#general-info)
* [Installation](#installation)
* [Contribute](#contribue)


## General info
Powershell script to keep your servers alive.
	
## Installation
1. Copy TorchWatchdog.ps1 to your `C:/` directory.

2. Create another folder at `C:/Torches`.  Copy all your server folders into this directory. 

3. Press `WindowsKey + R` and bring up the run menu.  

4. Next type `shell:startup` and hit enter.

5. Create a shortcut to `C:/TorchWatchdog.ps1` in this folder.  Right click drag does this fast.

6. Edit the shortcut target to C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -File C:\TorchWatchdog.ps1

(ya all that stuff)

7. Uncheck/Disable these settings in the shortcut as well

![fix](https://i.stack.imgur.com/k8EVM.jpg)

8. Double click on the shortcut when you want to manually start the watchdog.
* Only works on Windows based servers




## Contribue

If you see an error or needed changes, please make a push request :)
