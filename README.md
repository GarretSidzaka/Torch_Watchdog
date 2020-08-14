![Logo](https://raw.githubusercontent.com/GarretSidzaka/Torch_Watchdog/master/torch_watchdog.png)

# Torch_Watchdog

https://raw.githubusercontent.com/GarretSidzaka/Torch_Watchdog/master/torch_watchdog_ex.png

## Table of contents
* [General info](#general-info)
* [Installation](#installation)
* [Configuration](#configuration)
* [Contribute](#contribue)


## General info
Modified torch watchdog to keep your Space engineer servers alive.
	
## Installation
1. Copy Torch_Watchdog.bat to your `C:/` directory.

2. Create another folder at `C:/Torches`.  Copy all your server folders into this directory.   You cannot have any other directories in here besides Torch server folders.

3. Press `WindowsKey + R` and bring up the run menu.  

4. Next type `shell:startup` and hit enter.

5. Create a shortcut to `C:/TorchWatchdog.bat` in this folder.  Right click drag does this fast.

6. Double click on the shortcut when you want to manually start the watchdog.
* Only works on Windows based servers

## Configuration
If you want to have a different directory for your Torch servers, you can change it by editing this value:

```
:: set this to match the path that contains all of your torch folders

set "mypath=C:\Torches"
```



## Contribue

If you see an error or needed changes, please make a push request :)
