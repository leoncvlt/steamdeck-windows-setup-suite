# Steam Deck Windows Setup Suite

A set of scripts to streamline and optimize a (mostly) automated setup of a Windows 11 installation on Steam Deck.

### Usage
Download the source code and run the `steamdeck-windows-setup.bat` file - it will automatically start an elevated powershell window and run through the main script. The file might trigger Defender SmartScreen - in that case, just click "More info" and then "Run anyway".

### What it does
The script runs through the following operations:

- Activates Windows, using the activation scripts at [https://massgrave.dev/](https://massgrave.dev/)
- Install any pending Windows updates
- Install the official Valve Drivers for the Steam Deck
  - The APU driver being installed is the `2209130944` version, as the most recent one caused issues (error 1603) when installing on Windows 11 22H2. The installation is attended, so you'll have to click through the installer to continue. 
  - Rather than the official Wireless driver, the unlocked version from [https://github.com/ryanrudolfoba/SteamDeck-Windows-WiFi-Fix/](https://github.com/ryanrudolfoba/SteamDeck-Windows-WiFi-Fix/) is installed for better performance
- Install all Visual C++ Redistributables Runtimes, DirectX & .NET runtimes
- Install ayufan's [Steam Deck Tools](https://github.com/ayufan/steam-deck-tools) to enable virtual controller, performance overlays, power settings and more
  - The installation is attended, so you'll have to click through the installer to continue. I reccomend using the default install options, but you can uncheck "Visual Studio Runtime" and ".Net Runtime" if you selected the "Install Redistributables" option in this script.
- Remove bloatware UWP Apps
- Remove OneDrive
- Applies various QOL tweaks, see the [source file](libs/apply-tweaks.ps1) for details.

The script will start by showing a selection menu where operations can be toggled and selectively performed. If you're running the script of a fresh Windows installation, I reccomend to run through all options.

### Disclaimer
The script has been tested, but obviously I am not responsible if your Steam Deck explodes. As a general reccomendation, do not trust "Windows debloating" scripts from random internet people (like me!), but everything the script does should be pretty clear from reading the [source files](steamdeck-windows-setup.ps1).

### Credits
- https://github.com/CelesteHeartsong/SteamDeckAutomatedInstall
- https://git.ameliorated.info/Styris/AME-11/
- https://gist.github.com/DanielLarsenNZ/edc6dd611418581ef90b02ad8e23b363
- https://github.com/LeDragoX/Win-Debloat-Tools
- https://github.com/chrisseroka/ps-menu
- Countless StackOverflow posts

## Support [![Buy me a coffee](https://img.shields.io/badge/-buy%20me%20a%20coffee-lightgrey?style=flat&logo=buy-me-a-coffee&color=FF813F&logoColor=white "Buy me a coffee")](https://www.buymeacoffee.com/leoncvlt)
If this tool has proven useful to you, consider [buying me a coffee](https://www.buymeacoffee.com/leoncvlt) to support development of this and [many other projects](https://github.com/leoncvlt?tab=repositories).