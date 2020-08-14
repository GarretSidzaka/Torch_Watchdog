# Torch_Watchdog

##Installation Instructions:


##Configuration:


##Usage:


##Start on boot:


##Contribute


## Table of contents
* [General info](#general-info)
* [Installation](#installation)
* [Configuration](#configuration)
* [Contribute](#contribue)


## General info
Modified torch watchdog to keep your Space engineer servers alive.
	
## Installation
Copy Torch_Watchdog.bat to your `C:/` directory.
Create another folder at `C:/Torches`.  Copy all your server folders into this directory.   You cannot have any other directories in here besides Torch server folders.
Press `WindowsKey + R` and bring up the run menu.  
Next type `shell:startup` and hit enter.
Create a shortcut to `C:/Torch_Watchdog.bat` in this folder.  Right click drag does this fast.
Double click on the shortcut when you want to manually start the watchdog.
* Only works on Windows based servers

## Configuration
If you want to have a different directory for your Torch servers, you can change it by editing this value:

```
:: set this to match the path that contains all of your torch folders

set "mypath=C:\Torches"
```



## Contribue

If you see an error or needed changes, please make a push request :)
