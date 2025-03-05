# Fallout 4 scripts for linux

A collection of scripts to enable modding fallout 4 on linux

## Dependencies

Make sure you have the following before you proceed

- [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD#Linux) installed and in your `PATH`
- Steam client for linux with Fallout 4 installed
- [p7zip](https://p7zip.sourceforge.net/) to extract F4SE archive

## Usage

Make sure you have the `GAME_DIR` environment variable set for these scripts to use, for example:

```sh
export GAME_DIR="$HOME/.steam/steam/steamapps/common/Fallout 4/"
```

### Downgrading

To downgrade fallout run the `./downgrade` script, this will attempt to download the required game files and modify your installation.
This is done using the [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD#Linux) cli which will prompt you to log in to steam

Downloading these files may take a long time depending on your internet connection.
On subsequent runs pass `SKIP_DOWNLOAD=1` to skip ahead to the installation step

### Install Fallout 4 Script Extender

To be able to launch Fallout 4 after downgrading you need [Fallout 4 Script Extender](https://f4se.silverlock.org/) 
To fetch the latest compatible version run `./install-f4se`

## Troubleshooting

- Add a Non-Steam game and select `f4se_loader.exe` in your game directory
-Force the use of proton `^9.0-3` compatibility layer
