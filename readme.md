# Fallout 4 Next-gen downgrader for linux/proton

A simple script that utilizes [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) to reverse all modified depots in the next-gen update
based on [this Steam guide](https://steamcommunity.com/sharedfiles/filedetails/?id=3232095313)

## Requirements

- [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD#Linux)
- Native steam client for linux with Fallout 4 installed

## Usage

1. Download the script or clone this repository
2. Make the script executable with `chmod +x downgrade.sh`
3. Run the script with `./downgrade.sh`
   This step will prompt for your steam name, at this point the authentication is done through steamcmd, the command line utility provided by steam itself

   You might be prompted to provide a steam guard code, if you have steam guard enabled

4. Wait for the script to finish downloading all depots, this will take a long time.
5. Now it will prompt you if you want to copy the files to the game directory, you can do this manually if you want.
6. Done! You can now launch the game and use all your mods again. (Make sure to reinstall F4SE)
