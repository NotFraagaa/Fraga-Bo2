# Fraga-Bo2

HUD CHANGES

    Game timer
    Round timer
    Trap timer
    SPH meter (default start at 30)
    HUD color and position can be changed
    Splits

# MAP CHANGES

Tranzit

    Bank full for all players
    All perman perks are given on spawn to all players
    MP5 upgraded on weapon locker for all players
    
Survival Maps:

    CIA always all players
    
Town

    Box is set to double tap
    
Die Rise

    Misty always all players
    Bank full for all players
    All perman perks are given on spawn to all players
    AN94 upgraded on the weapon locker for all players
    Trample steam counter
    
Mob of the Dead

    Weasel always all players
    Trap timer
    Box set to cafeteria always
    Key always spawns at cafeteria
    
Buried

    Misty always all players
    Bank full for all players
    All perman perks are given on spawn to all players
    AN94 upgraded on the weapon locker for all players
    Animated pap camo
    Tramplesteam, turbine and resonator counters

Origins

    Richtofen always all players
    Box set to gen 2
    Wunderfizz set to gen 4
    Animated pap camo

# Splits

Round 5: Rounds 1,2,3,4,5

Round 30: Rounds 5, 10, 15, 20, 25, 30

Round 50: Rounds 10, 20, 30, 40, 50

Round 70: Rounds 10, 20, 30, 40, 50, 60, 70

Round 100: Rounds 30, 50, 70, 80, 90, 100

Round 150: Rounds 50, 70, 100, 125, 130, 140, 150

Round 200: Rounds 50, 70, 100, 150, 175, 200

To change the SR use the following DVars:

    there can only be one at the same time, for changing them you need to do a fast_restart

5SR 1

30SR 1

50SR 1

70SR 1

100SR 1

150SR 1

200SR 1

# DVars

sph_start

     What round sph starts showing, default is 30
    
timer 1 0

     Enables timer, default is enabled

round_timer 1 0

    Enables round timer, default is enabled

traptimer 1 0

    Enables trap timer, default is disabled
    
timer_yposition and timer_xposition

    Changes timer position
    
timer_color "x x x"

    Changes timer color (x can be any number from 0 to 1; example: 0.5245)
    
buildablesmenu 0 1

    Shows/Hides the buildables menu on Die Rise / Buried

# Useful binds

bind o "toggle buildablesmenu 0 1"
bind 7 "toggle traptimer 0 1"