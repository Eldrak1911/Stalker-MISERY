#!/bin/env bash

##### Auth as sudo required #####
[ "$EUID" -eq 0 ] || exec sudo bash "$0" "$@"

##### Verification of files presence #####
Verif()
{
clear
find -type f > Files_List_B.txt
comm -3 <(sort Files_List_A.txt) <(sort Files_List_B.txt) > List_Comparison.txt
if [ -s List_Comparison.txt ]; then
    echo "Files are missing. Check List_Comparison.txt"
else
    rm List_Comparison.txt
    Screen1
fi
}

COP_PATH=0
COP_PATH_USE=0
ABSOLUTE=0
DIRECTORY=0
WRITABLE=0
CUSS_SPE=0
CTLANG=0
CVLANG=0
CFOV=0
CSWITCH=0
CDIFF=0
CDM=0

##### Reminder, to show chosen settings. #####
Reminder()
{
echo "----------Reminder----------"
if [ "$COP_PATH_USE" != "0" ]; then
    echo "CoP Path -> " $COP_PATH_USE
fi
case $CUSS_SPE in
    1 ) echo "Specialization -> Assaulter"
    ;;
    2 ) echo "Specialization -> Recon"
    ;;
    3 ) echo "Specialization -> Sniper"
    ;;
esac
case $CTLANG in
    1 ) echo "Text Language -> English"
    ;;
    2 ) echo "Text Language -> Polish"
    ;;
    3 ) echo "Text Language -> Russian"
    ;;
    4 ) echo "Text Language -> French"
    ;;
    5 ) echo "Text Language -> German"
    ;;
    6 ) echo "Text Language -> Italian"
    ;;
    7 ) echo "Text Language -> Japanese"
    ;;
esac
case $CVLANG in
    1 ) echo "Spoken Language -> Russian"
    ;;
    2 ) echo "Spoken Language -> English"
    ;;
esac
if [ $CFOV != "0" ]; then
    echo "Field Of View -> " $CFOV
fi
if [ $CSWITCH != "0" ]; then
    echo "A-LIFE switch_distance -> " $CSWITCH
fi
case $CDIFF in
    1 ) echo "Difficulty -> Rookie"
    ;;
    2 ) echo "Difficulty -> MISERY"
esac
case $CDM in
    1 ) echo "Normal mode"
    ;;
    2 ) echo "Dark mode"
    ;;
esac
}

##### Screen 1, Welcoming and test of the superuser. #####
Screen1()
{
clear
cat << _EOF_
----------Welcome to the MISERY 2.2 Setup Wizard----------
----------Scripted by Eldrak1911----------

This will install MISERY version 2.2.1 for S.T.A.L.K.E.R. - Call of Pripyat on your computer.

It is recommended that you close all other applications before continuing.

IMPORTANT : Version 2.2.X is NOT savegame compatible and requires a new game start.
_EOF_

if [ "$(id -u)" != "0" ]; then
    echo ""
    echo "You must be logged as superuser to continue."
    echo "Please start this file with the sudo command."
    exit 1
fi

read -p "Enter (N)ext to continue, or (C)ancel to exit Setup
-> " CHOICE1
case $CHOICE1 in
    "C" ) exit
    ;;
    "N" ) Screen2
    ;;
    * ) exit
    ;;
esac
}

##### Screen 2, Entering the CoP directory Path. #####
Screen2()
{
clear
cat << _EOF_
----------Select Destination Location----------
    Where should MISERY be installed ?

    Note : At least 5353.5 MB of free disk space is required.

_EOF_

#Test if the Path is absolute, the directory existent and writable, or not.

echo "Indicate your main S.T.A.L.K.E.R. - Call of Pripyat directory path.
It must be absolute, the directory must be writable.
Example (Debian steam install) : /home/user/.steam/steam/steamapps/common/Stalker Call of Pripyat"
    read -p "-> " COP_PATH
COP_PATH_USE="$COP_PATH"
if [[ "$COP_PATH_USE" == /* ]]; then
ABSOLUTE=1
else
Screen2
fi
if [[ -d "$COP_PATH_USE" ]]; then
DIRECTORY=1
else
Screen2
fi
if [[ -w "$COP_PATH_USE" ]]; then
WRITABLE=1
else
Screen2
fi
if [[ $WRITABLE==1 && $ABSOLUTE==1 && $DIRECTORY==1 ]]; then
echo ""
echo "Your path to CoP folder is : "$COP_PATH_USE
echo ""

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE2
case $CHOICE2 in
    "C" ) exit
    ;;
    "N" ) Screen3
    ;;
    "B" ) Screen1
    ;;
    * ) exit
    ;;
esac
fi
}

##### Screen 3, Specialization selection. #####
Screen3()
{
clear
Reminder

cat << _EOF_
----------Select your current USS specialization----------
    NOTE : After the installation is performed,
    you can change the specialization from the main menu.
_EOF_

#[[ ]] pour encadrer de multipes tests, || == ou, && == et
USS_SPE=0
while [[ $USS_SPE != 1 && $USS_SPE != 2 && $USS_SPE != 3 ]]; do
read -p "Enter '1' for USS Assaulter, '2' for USS Recon, '3' for USS Sniper
-> " USS_SPE
case $USS_SPE in
    1 ) echo "You chose Assaulter" && export CUSS_SPE=1
    ;;
    2 ) echo "You chose Recon" && export CUSS_SPE=2
    ;;
    3 ) echo "You chose Sniper" && export CUSS_SPE=3
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE3
case $CHOICE3 in
    "C" ) exit
    ;;
    "N" ) Screen4
    ;;
    "B" ) Screen2
    ;;
    * ) exit
    ;;
esac
}

##### Screen 4, Text language selection. #####
Screen4()
{
clear
Reminder

cat << _EOF_
----------Select text language ingame----------
_EOF_
TLANG=0
while [[ $TLANG != 1 && $TLANG != 2 && $TLANG != 3 && $TLANG != 4 && $TLANG != 5 && $TLANG != 6 && $TLANG != 7 ]]; do
read -p "Enter '1' for English, '2' for Polish, '3' for Russian, '4' for French, '5' for German, '6' for Italian, '7' for Japanese
-> " TLANG
case $TLANG in
    1 ) echo "You chose English" && export CTLANG=1
    ;;
    2 ) echo "You chose Polish" && export CTLANG=2
    ;;
    3 ) echo "You chose Russian" && export CTLANG=3
    ;;
    4 ) echo "You chose French" && export CTLANG=4
    ;;
    5 ) echo "You chose German" && export CTLANG=5
    ;;
    6 ) echo "You chose Italian" && export CTLANG=6
    ;;
    7 ) echo "You chose Japanese" && export CTLANG=7
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE4
case $CHOICE4 in
    "C" ) exit
    ;;
    "N" ) Screen5
    ;;
    "B" ) Screen3
    ;;
    * ) exit
    ;;
esac
}

##### Screen 5, Voice language selection. #####
Screen5()
{
clear
Reminder

cat << _EOF_
----------Select spoken language ingame----------
_EOF_
VLANG=0
while [[ $VLANG != 1 && $VLANG != 2 ]]; do
read -p "Enter '1' for Russian, '2' for English
-> " VLANG
case $VLANG in
    1 ) echo "You chose Russian" && export CVLANG=1
    ;;
    2 ) echo "You chose English" && export CVLANG=2
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE5
case $CHOICE5 in
    "C" ) exit
    ;;
    "N" ) Screen6
    ;;
    "B" ) Screen4
    ;;
    * ) exit
    ;;
esac
}

##### Screen 6, FoV selection. #####
Screen6()
{
clear
Reminder

cat << _EOF_
----------Select the fov----------
Choose the field of view range.
_EOF_
FOV=0
while [[ $FOV != "55" && $FOV != "67.5" && $FOV != "75" && $FOV != "83" && $FOV != "85" && $FOV != "90" ]]; do
read -p "Choose between '55', '67.5', '75', '83', '85', and '90'
-> " FOV
case $FOV in
    "55" ) echo "You chose 55" && export CFOV="55"
    ;;
    "67.5" ) echo "You chose 67.5" && export CFOV="67.5"
    ;;
    "75" ) echo "You chose 75" && export CFOV="75"
    ;;
    "83" ) echo "You chose 83" && export CFOV="83"
    ;;
    "85" ) echo "You chose 85" && export CFOV="85"
    ;;
    "90" ) echo "You chose 90" && export CFOV="90"
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE6
case $CHOICE6 in
    "C" ) exit
    ;;
    "N" ) Screen7
    ;;
    "B" ) Screen5
    ;;
    * ) exit
    ;;
esac
}

##### Screen 7, A-LIFE switch distance selection. #####
Screen7()
{
clear
Reminder

cat << _EOF_
----------Select the switch distance----------
This crucial setting controls the distance in wich a-life enters its 'online mode'.

Beyond it, NPCs are 'Offline', wich means they are only simulated in memory and thus
will not be visible and combat with them will be impossible. You can increase the
number as much as you like, but bear in mind that this will require a high-end rig, or
lower it to ensure a better performance of the mod at the cost of immersion.

200 - 'Extended Vanilla' (Low-End rigs / Not Recommended)
250 - 'Lowered default'
300 - 'Default' (Recommended)
350 - 'Extended default'
400 - 'Enhanced'
550 - 'Extreme high-end rigs only'
900 - Maps in 'full-online mode' TESTING / A-LIFE video capture purpose ONLY
20 - 'For Fixing CTD' on loading saved game or similar.
      Reload, allow the game to run for a while, save, restore the switch_distance to its original value.
_EOF_

SWITCH=0
while [[ $SWITCH != "200" && $SWITCH != "250" && $SWITCH != "300" && $SWITCH != "350" && $SWITCH != "400" && $SWITCH != "550" && $SWITCH != "900" && $SWITCH != "20" ]]; do
read -p "Choose between any of the above
-> " SWITCH
case $SWITCH in
    "200" ) echo "You chose 200" && export CSWITCH="200"
    ;;
    "250" ) echo "You chose 250" && export CSWITCH="250"
    ;;
    "300" ) echo "You chose 300" && export CSWITCH="300"
    ;;
    "350" ) echo "You chose 350" && export CSWITCH="350"
    ;;
    "400" ) echo "You chose 400" && export CSWITCH="400"
    ;;
    "550" ) echo "You chose 550" && export CSWITCH="550"
    ;;
    "900" ) echo "You chose 900" && export CSWITCH="900"
    ;;
    "20" ) echo "You chose 20" && export CSWITCH="20"
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE7
case $CHOICE7 in
    "C" ) exit
    ;;
    "N" ) Screen8
    ;;
    "B" ) Screen6
    ;;
    * ) exit
    ;;
esac
}

##### Screen 8, Difficulty selection. #####
Screen8()
{
clear
Reminder

cat << _EOF_
----------Select the difficulty----------
NOTE : The rookie game mode makes MISERY significantly easier and more accessible to newcomers.
If Features, among other things, actor's increased resistance to damage, reduced accuracy of the AI,
higher artifact spawn rates, lower prices of equipment.

In short : The mode retains core aspects that define MISERY while making the gameplay more forgiving.
_EOF_
DIFF=0
while [[ $DIFF != "1" && $DIFF != "2" ]]; do
read -p "Choose between 1 : Rookie or 2 : MISERY
-> " DIFF
case $DIFF in
    "1" ) echo "You chose Rookie" && export CDIFF="1"
    ;;
    "2" ) echo "You chose MISERY" && export CDIFF="2"
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE8
case $CHOICE8 in
    "C" ) exit
    ;;
    "N" ) Screen9
    ;;
    "B" ) Screen7
    ;;
    * ) exit
    ;;
esac
}

##### Screen 9, Dark mode or Not Dark Mode, that is the question. #####
Screen9()
{
clear
Reminder

cat << _EOF_
----------Activate Dark Mode ?----------
The Dark Mode introduces another factor you have to take into account when
venturing into the zone : constant radiation when the sun is above the horizon.

Now, you're choosing between being killed by radiation during the day or
by the mutants during the night. Only for stoics.
_EOF_

DM=0
while [[ $DM != "1" && $DM != "2" ]]; do
read -p "Choose between 1 : Normal or 2 : Dark mode
-> " DM
case $DM in
    "1" ) echo "You chose Normal mode" && export CDM="1"
    ;;
    "2" ) echo "You chose Dark mode" && export CDM="2"
    ;;
esac
done

read -p "Enter (N)ext to continue, (C)ancel to exit Setup, or (B)ack to return to the previous screen
-> " CHOICE9
case $CHOICE9 in
    "C" ) exit
    ;;
    "N" ) Screen10
    ;;
    "B" ) Screen8
    ;;
    * ) exit
    ;;
esac
}

##### Screen 10, Ready to Install. #####
Screen10()
{
clear
Reminder

cat << _EOF_
----------Ready to Install----------
Setup is now ready to begin installing MISERY on your computer.

Write 'INSTALL' to continue with the installation, (B)ack if you want to review or change settings,
(C)ancel to abort the installation.
_EOF_
read -p "-> " CHOICE10
case $CHOICE10 in
    "C" ) exit
    ;;
    "INSTALL" ) Screen11
    ;;
    "B" ) Screen9
    ;;
    * ) exit
    ;;
esac
}

##### Screen 11, Install Process. #####
Screen11()
{
clear


#Copy of Stalker-COP.exe
echo "Copy of Stalker-COP.exe in progress"
cp -p ./data/Stalker-COP.exe "$COP_PATH_USE"
echo "Done."

#Modification of fsgame.ltx
echo "Modification of fsgame.ltx"
echo '$game_class_assaulter$  = true|  false| $game_data$|          class_diversity\assaulter\' >> "$COP_PATH_USE"/fsgame.ltx
echo '$game_class_recon$  = true|  false| $game_data$|          class_diversity\recon\' >> "$COP_PATH_USE"/fsgame.ltx
echo '$game_class_sniper$  = true|  false| $game_data$|          class_diversity\sniper\' >> "$COP_PATH_USE"/fsgame.ltx
echo "Done."

#Copy of bin folder minus FoV Dll.
echo "Copy of files in the bin folder in progress"
cp -p ./data/bin/"BugTrap.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"dbghelp.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"eax.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"lua.JIT.1.1.4.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"msvcr80.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"wrap_oal.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"xrAPI.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"xrCDB.dll" "$COP_PATH_USE"/bin
cp -p ./data/bin/"xrRender_R1.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"xrRender_R2.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"xrRender_R3.dll" "$COP_PATH_USE"/bin/
cp -p ./data/bin/"xrRender_R4.dll" "$COP_PATH_USE"/bin/
echo "Done."

#Copy of Basic Gamedata Folder (english Text Language).
echo "Copy of gamedata folder in progress"
cp -pR ./data/gamedata* "$COP_PATH_USE"
echo "Done."

#Copy of Gamedata Folder for Rookie Mode (english Text Language).
if [ $CDIFF == "1" ]; then
echo "Copy of gamedata folder in progress"
cp -pR ./data/ROOKIE_MODE/* "$COP_PATH_USE"
echo "Done."
fi

#Copy of Gamedata Folder for Dark Mode (english Text Language).
if [ $CDM == "2" ]; then
echo "Copy of Dark mode gamedata in progress"
cp -pR ./data/DARK_MODE/* "$COP_PATH_USE"
echo "Done."
fi

#Copy of Text Language folder.
case $CTLANG in
    2 ) echo "Copy of Polish text language in progress" && cp -pR ./data/translation/Polish/* "$COP_PATH_USE" && echo "Done."
    ;;
    3 ) echo "Copy of Russian text language in progress" && cp -pR ./data/translation/Russian/* "$COP_PATH_USE" && echo "Done."
    ;;
    4 ) echo "Copy of French text language in progress" && cp -pR ./data/translation/French/* "$COP_PATH_USE" && echo "Done."
    ;;
    5 ) echo "Copy of German text language in progress" && cp -pR ./data/translation/German/* "$COP_PATH_USE" && echo "Done."
    ;;
    6 ) echo "Copy of Italian text language in progress" && cp -pR ./data/translation/Italian/* "$COP_PATH_USE" && echo "Done."
    ;;
    7 ) echo "Copy of Japanese text language in progress" && cp -pR ./data/translation/Japanese/* "$COP_PATH_USE" && echo "Done."
    ;;
esac

#Copy of Voices folder.
case $CVLANG in
    1 ) echo "Copy of Russian spoken language in progress" && cp -pR ./data/spoken_language/Russian/* "$COP_PATH_USE" && echo "Done."
    ;;
    2 ) echo "Copy of English text language in progress" && cp -pR ./data/spoken_language/English/* "$COP_PATH_USE" && echo "Done."
    ;;
esac

#Copy of Scope Tweaks Folder & fov dll from /bin.
case $CFOV in
    "55" ) echo "Copy of 55 FoV dll & scope tweaks folder in progress" && cp -pR ./data/scope_tweaks/55FOV/* "$COP_PATH_USE" && cp -p ./data/bin/1602_fov55.dll "$COP_PATH_USE"/bin/ && echo "Done."
    ;;
    "67.5" ) echo "Copy of 67.5 FoV dll" && cp ./data/bin/1602_fov6750.dll "$COP_PATH_USE"/bin && echo "Done."
    ;;
    "75" ) echo "Copy of 75 FoV dll & scope tweaks folder in progress" && cp -pR ./data/scope_tweaks/75FOV/* "$COP_PATH_USE" && cp -p ./data/bin/1602_fov75.dll "$COP_PATH_USE"/bin/ && echo "Done."
    ;;
    "83" ) echo "Copy of 83 FoV dll & scope tweaks folder in progress" && cp -pR ./data/scope_tweaks/83FOV/* "$COP_PATH_USE" && cp -p ./data/bin/1602_fov83.dll "$COP_PATH_USE"/bin/ && echo "Done."
    ;;
    "85" ) echo "Copy of 85 FoV dll & scope tweaks folder in progress" && cp -pR ./data/scope_tweaks/83FOV/* "$COP_PATH_USE" && cp -p ./data/bin/1602_fov85.dll "$COP_PATH_USE"/bin/ && echo "Done."
    ;;
    "90" ) echo "Copy of 90 FoV dll & scope tweaks folder in progress" && cp -pR ./data/scope_tweaks/90FOV/* "$COP_PATH_USE" && cp -p ./data/bin/1602_fov90.dll "$COP_PATH_USE"/bin/ && echo "Done."
    ;;
esac

#Copy of the switch_distance preference
case $CSWITCH in
    "200" ) echo "Copy of switch_distance preference (200) in progress" && cp -pR ./data/SD_presets/200/* "$COP_PATH_USE" && echo "Done."
    ;;
    "250" ) echo "Copy of switch_distance preference (250) in progress" && cp -pR ./data/SD_presets/250/* "$COP_PATH_USE" && echo "Done."
    ;;
    "300" ) echo "Copy of switch_distance preference (300) in progress" && cp -pR ./data/SD_presets/300/* "$COP_PATH_USE" && echo "Done."
    ;;
    "350" ) echo "Copy of switch_distance preference (350) in progress" && cp -pR ./data/SD_presets/350/* "$COP_PATH_USE" && echo "Done."
    ;;
    "400" ) echo "Copy of switch_distance preference (400) in progress" && cp -pR ./data/SD_presets/400/* "$COP_PATH_USE" && echo "Done."
    ;;
    "550" ) echo "Copy of switch_distance preference (550) in progress" && cp -pR ./data/SD_presets/550/* "$COP_PATH_USE" && echo "Done."
    ;;
    "900" ) echo "Copy of switch_distance preference (900) in progress" && cp -pR ./data/SD_presets/900/* "$COP_PATH_USE" && echo "Done."
    ;;
    "20" ) echo "Copy of switch_distance preference (20) in progress" && cp -pR ./data/SD_presets/20/* "$COP_PATH_USE" && echo "Done."
    ;;
esac

#Dealing with USS Specialization.
case $USS_SPE in
    "1" ) echo "Copy of Assaulter data" && cp -pR ./data/gamedata/class_diversity/assaulter/* "$COP_PATH_USE" && echo "Done."
    ;;
    "2" ) echo "Copy of Recon data" && cp -pR ./data/gamedata/class_diversity/recon/* "$COP_PATH_USE" && echo "Done."
    ;;
    "3" ) echo "Copy of Sniper data" && cp -pR ./data/gamedata/class_diversity/sniper/* "$COP_PATH_USE" && echo "Done."
    ;;
esac
echo "Mod Installed, have a gruesome death ;)"
}
Verif
