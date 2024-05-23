# Fraga-Bo2

## Downloads
- [Plutonium r2905](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Plutonium.r2905.rar)
  - Round splits only work on the newest version on pluto
- Redacted soon
- Ancient soon

## Game Changes

- Backspeed fixed
- Zombie health fix
- Animated Skyboxes
- Night mode
- Player shadows

## HUD CHANGES

    Game timer
    Round timer
    Trap timer
    Box hits counter
    SPH meter (default start at 30)
    HUD color and position can be changed
    Round Splits
    Display kills at the end of the round if the player didnt leave the first room and its round 6+
    Displays velocity meter if the player didnt leave the first room and its round 6+

## MAP CHANGES

Tranzit

    Bank full for all players
    All perman perks are given on spawn to all players
    MP5 upgraded on weapon locker for all players
    Bus location with /bus 1 (r3705+)
    
Survival Maps

    Raygun & Raygun MK2 average trackers

Town

    You can chose box location with /fisrtbox
    1 for doubletap
    2 for quick revive

Nuketown

    With /perkrng 0 you can automatically restart untill
    PAP and jug are in the green house
    and the perk order will be QR -> JUG -> PAP -> SPEED -> DT
    on solo and JUG -> PAP -> SPEED -> DT -> QR on coop
    
Die Rise

    Bank full for all players
    All perman perks are given on spawn to all players
    AN94 upgraded on the weapon locker for all players
    Leapers tracker
    Springpads counter
    
Mob of the Dead

    Trap timer
    Box can be set with /firstbox (1 for cafeteria / 2 for office)
    Key always spawns with the box
    Last Brutus Round counter
    
Buried

    Bank full for all players
    All perman perks are given on spawn to all players
    AN94 upgraded on the weapon locker for all players
    Animated pap camo
    Tramplesteam, turbine and resonator counters

Origins

    Box can be set with /firstbox (1 for gen2 / 2 for gen3)
    Wunderfizz set to gen 4
    Animated pap camo
    Panzer tracker
    Templars tracker
    Tank tracker

## Splits **(r3705+)**

Round 5: Rounds 1,2,3,4,5

Round 30: Rounds 5, 10, 15, 20, 25, 30

Round 50: Rounds 10, 20, 30, 40, 50

Round 70: Rounds 10, 20, 30, 40, 50, 60, 70

Round 100: Rounds 30, 50, 70, 80, 90, 100

Round 150: Rounds 50, 70, 100, 125, 130, 140, 150

Round 200: Rounds 50, 70, 100, 150, 175, 200

SR **RoundNumeber** (you need to do a fast_restart):
Example: SR 30

## DVars

character [0, 5]

    0 = Random
    1 = Misty, Richtophen, Arlington
    2 = Russman, Dempsei, Finn
    3 = Marlton, Nikolai, Sal
    4 = Stuthlinger, Takeo, Billy
    5 = Ghost (only on mob)

firstbox [0, 1]

    Disables RNG from

sph [0, 255]

     What round sph starts showing, default is 30
    
timer [0, 4]

    0 = Off
    1 = Left side of the screen
    2 = Top left of the screen
    3 = Top right of the screen
    4 = Next to ammo counter

traptimer [0, 1]

    Enables trap timer, default is disabled
    
color ("x x x")

    Changes timer color (RGB format)

SR

    5 30 50 70 100 150 200

FragaDebug

    Gives every player 69420 points and allowes cheats

score

    Changes the amount of points given when debug mode is on

perkRNG [0, 1]

    Vulture will be the last perk awarded by the whitches
    Perk order will be QR -> JUG -> PAP -> SPEED -> DT on nuketown
    Perk order will be JUG -> DT -> SPEED -> MULE -> STAM -> QR -> PHD -> CHERRY
    Auto restarts on nuketown untill PAP and JUG are on the green house

Templars [0, 1]

    Templars will always attack gen4
    Might cause errors if gen4 is not active
