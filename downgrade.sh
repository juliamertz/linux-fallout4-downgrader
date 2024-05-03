#!/usr/bin/env bash

USERNAME_TMP_FILE="/tmp/steamcmd_username"
GAME_DIR=""

DEPOT_BASE_CONTENT_A="377160 377161 7497069378349273908"
DEPOT_BASE_EXECUTABLE="377160 377162 5847529232406005096"
DEPOT_BASE_CONTENT_B="377160 377163 5819088023757897745"
DEPOT_WASTELAND_WORKSHOP="377160 435880 1255562923187931216"
DEPOT_AUTOMATRON="377160 435870 1691678129192680960"

DEPOT_LOCALE_EN_BASE="377160 377164 2178106366609958945"
DEPOT_LOCALE_EN_AUTOMATRON="377160 435871 5106118861901111234"
DEPOT_LOCALE_ES_BASE="377160 377168 7717372852115364102"
DEPOT_LOCALE_ES_AUTOMATRON="377160 435875 2953236065717816833"
DEPOT_LOCALE_FR_BASE="377160 377165 7549549550652702123"
DEPOT_LOCALE_FR_AUTOMATRON="377160 435872 5590419866095647350"
DEPOT_LOCALE_DE_BASE="377160 377166 6854162778963425477"
DEPOT_LOCALE_DE_AUTOMATRON="377160 435873 2207548206398235202"
DEPOT_LOCALE_IT_BASE="377160 377167 783101348965844295"
DEPOT_LOCALE_IT_AUTOMATRON="377160 435874 9032251103390457158"
DEPOT_LOCALE_JA_BASE="377160 393884 3455288010746962666"
DEPOT_LOCALE_JA_AUTOMATRON="377160 404091 6756984187996423348"
DEPOT_LOCALE_PT_BASE="377160 393882 7540680803954664080"
DEPOT_LOCALE_PT_AUTOMATRON="377160 435878 8276750634369029613"
DEPOT_LOCALE_RU_BASE="377160 393881 4735225695214536532"
DEPOT_LOCALE_RU_AUTOMATRON="377160 435877 2675794883952625475"

function get_username() {
  if [[ -f $USERNAME_TMP_FILE ]]; then
    cat $USERNAME_TMP_FILE 
  else
    read -p "Enter your Steam username: " username 
    echo "$username" > $USERNAME_TMP_FILE
    echo $username
  fi
}

function authenticate() {
  steamcmd +login $1 +quit
}

function is_authenticated() {
  result=$(steamcmd +login $1 +info +quit | grep "Logged On")

  if [[ -z $result ]]; then
    echo false
  else
    echo true
  fi
}

function download_depots() {
  cmd="steamcmd +login $(get_username)"
  owns_automatron=0

  cmd="$cmd +download_depot $DEPOT_BASE_CONTENT_A"
  cmd="$cmd +download_depot $DEPOT_BASE_EXECUTABLE"
  cmd="$cmd +download_depot $DEPOT_BASE_CONTENT_B"
  cmd="$cmd +download_depot $DEPOT_WASTELAND_WORKSHOP"

  read -p "Do you own the automatron DLC? (y/n): " answer
  if [[ $answer == "y" ]]; then
    owns_automatron=1
    cmd="$cmd +download_depot $DEPOT_AUTOMATRON"
  fi

  echo "Available locales:"
  echo "en: English"
  echo "es: Spanish"
  echo "fr: French"
  echo "de: German"
  echo "it: Italian"
  echo "ja: Japanese"
  echo "pt: Portuguese"
  echo "ru: Russian"

  read -p "Which locale do you want to download?: " locale

  locale_code=$(echo $locale | tr '[:lower:]' '[:upper:]')
  depot=$(eval echo $(echo "\$DEPOT_LOCALE_${locale_code}_BASE"))


  case $locale in
    en)
      cmd="$cmd +download_depot $DEPOT_LOCALE_EN_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_EN_AUTOMATRON"
      fi
      ;;
    es)
      cmd="$cmd +download_depot $DEPOT_LOCALE_ES_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_ES_AUTOMATRON"
      fi
      ;;

    fr)
      cmd="$cmd +download_depot $DEPOT_LOCALE_FR_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_FR_AUTOMATRON"
      fi
      ;;

    de)
      cmd="$cmd +download_depot $DEPOT_LOCALE_DE_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_DE_AUTOMATRON"
      fi
      ;;
    it)
      cmd="$cmd +download_depot $DEPOT_LOCALE_IT_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_IT_AUTOMATRON"
      fi
      ;;
    ja)
      cmd="$cmd +download_depot $DEPOT_LOCALE_JA_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_JA_AUTOMATRON"
      fi
      ;;
    pt)
      cmd="$cmd +download_depot $DEPOT_LOCALE_PT_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_PT_AUTOMATRON"
      fi
      ;;
    ru)
      cmd="$cmd +download_depot $DEPOT_LOCALE_RU_BASE"
      if [[ $owns_automatron -eq 1 ]]; then
        cmd="$cmd +download_depot $DEPOT_LOCALE_RU_AUTOMATRON"
      fi
      ;;
    *)
      echo "Invalid locale. Please try again."
      exit 1
      ;;
  esac

  cmd="$cmd +quit"

  echo "Executing Steam command:"
  echo $cmd; eval $cmd
}

function apply_patches() {
  if [[ -z $GAME_DIR ]]; then
    echo "Game directory not found. Exiting."
    exit 1
  fi
  CONTENT_DIR="$HOME/.steam/steamcmd/linux32/steamapps/content"

  cd $CONTENT_DIR/app_377160

  # It is important that depot_377163 is copied last for the textures
  # luckily the files will be ordered by name so this is not a problem
  for dir in *; do
    cp -vrf $dir/* $GAME_DIR
  done
}

function reverse_next_gen_changes() {
  if [[ -z $GAME_DIR ]]; then
    echo "Game directory not found. Exiting."
    exit 1
  fi

  cd $GAME_DIR
  rm -vf Data/cc*
  rm -vf Fallout4IDs.ccc
}

function find_game_dir() {
  read -p "Do you want to find the game directory automatically? (y/n): " answer
  if [[ $answer == "y" ]]; then
    game_dir=$(find / -type f -name "Fallout4.exe" -exec dirname {} \; -quit)
    read -p "Game executable found at: $game_dir. Is this correct? (y/n): " answer
    if [[ $answer == "y" ]]; then
      GAME_DIR=$game_dir
    else
      find_game_dir
    fi
  else
    read -p "Enter the fallout 4 installtion path: " game_dir
    GAME_DIR=$game_dir
  fi
}

find_game_dir

if [[ $(type -P "steamcmd") ]]; then
  username=$(get_username)
  steamcmd +login $username +quit
  if [[ $(is_authenticated $username) ]]; then
    echo "You are authenticated."
    download_depots 
    apply_patches
    reverse_next_gen_changes
  else
    echo "Authentication failed. Please try again."
    exit 1
  fi
else 
  echo "SteamCMD is not found in your path. Please install it first. https://developer.valvesoftware.com/wiki/SteamCMD#Linux"
  exit 1
fi


