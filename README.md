# Steam Deck Windows Setup Suite

A set of scripts to streamline and optimize a (mostly) automated setup of a Windows 11 installation on Steam Deck.

### Usage
[Download the repository content](https://github.com/leoncvlt/steamdeck-windows-setup-suite/archive/refs/heads/main.zip), unpack it and run the `steamdeck-windows-setup.bat` file - it will automatically start an elevated powershell window and run through the main script. The file might trigger Defender SmartScreen - in that case, just click "More info" and then "Run anyway".

### What it does

![image](https://github.com/leoncvlt/steamdeck-windows-setup-suite/assets/4929974/147841d4-54b7-4e09-88aa-ca8fd1c78dbe)

The script will start by showing a selection menu that can be navigated with the Steam Deck controller, and where each of the following operations can be toggled and selectively performed:

- Activate Windows, using the activation scripts at [https://massgrave.dev/](https://massgrave.dev/)
- Install any pending Windows updates
- Install the official [Valve Drivers for the Steam Deck](https://help.steampowered.com/en/faqs/view/6121-ECCD-D643-BAA8)
  - The APU driver being installed is the `2209130944` version, as the most recent one caused issues (error 1603) when installing on Windows 11 22H2.
  - Rather than the official Wireless driver, the unlocked version from [https://github.com/ryanrudolfoba/SteamDeck-Windows-WiFi-Fix/](https://github.com/ryanrudolfoba/SteamDeck-Windows-WiFi-Fix/) is installed for better performance
- Install all Visual C++ Redistributables Runtimes, DirectX & .NET runtimes
- Install ayufan's [Steam Deck Tools](https://github.com/ayufan/steam-deck-tools) or Valkirie's [Handheld Companion](https://github.com/Valkirie/HandheldCompanion/releases) to enable performance overlays, native controller input, TDP & fan settings, and more
  - You should only install one of them, not both - the script will warn and stop you if you try to do so.
- Remove bloatware UWP Apps, see the [source list](data/bloat.json) for details
- Remove OneDrive
- Applies various QoL tweaks, see the [source file](libs/apply-tweaks.ps1) for details. Feel free to uncomment as you see fit.

 If you're running the script of a fresh Windows installation, I reccomend to run through all of them.

### Disclaimer
The script has been tested, but obviously I am not responsible if your Steam Deck explodes. As a general reccomendation, do not trust "Windows debloating" scripts from random internet people (like me!), but everything the script does should be pretty clear from reading the [source files](steamdeck-windows-setup.ps1).

### Credits & Sources
- https://github.com/CelesteHeartsong/SteamDeckAutomatedInstall
- https://baldsealion.com/Steam-Deck-Ultimate-Windows-Guide
- https://git.ameliorated.info/Styris/AME-11/
- https://gist.github.com/DanielLarsenNZ/edc6dd611418581ef90b02ad8e23b363
- https://github.com/LeDragoX/Win-Debloat-Tools
- https://github.com/chrisseroka/ps-menu
- Countless StackOverflow threads & blog posts 🫡

## Support [![Buy me a coffee](https://img.shields.io/badge/-buy%20me%20a%20coffee-lightgrey?style=flat&logo=buy-me-a-coffee&color=FF813F&logoColor=white "Buy me a coffee")](https://www.buymeacoffee.com/leoncvlt)
If this tool has proven useful to you, consider [buying me a coffee](https://www.buymeacoffee.com/leoncvlt) to support development of this and [many other projects](https://github.com/leoncvlt?tab=repositories).
