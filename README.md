# Fraga-Bo2
<details>
  <summary>English description:</summary>

## Downloads
### New pluto (Recomended version)
- [Plutonium r2905+](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Plutonium.r2905+.zip)
  - Round splits only work on the newest version on pluto
### Alternative versions
- [Ancient (Without special round trackers)](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Ancient.rar)
- [Ancient (With special round trackers)](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Ancient.+.trackers.rar)
- These versions have some limitations such as 
  - Doesnt have graphic changes nor night mode
  - Wunderfizz is not fixed to gen 4
  - Perk rng can not be manipulated (except pap and jug location on nuketown)
  - Templars can not be manipulated
- Redacted comming soon, im having issues with the compiler
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

    You can chose box location with /box
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
    Box can be set with /box (1 for cafeteria / 2 for office)
    Key always spawns with the box
    Last Brutus Round counter
    
Buried

    Bank full for all players
    All perman perks are given on spawn to all players
    AN94 upgraded on the weapon locker for all players
    Animated pap camo
    Tramplesteam, turbine and resonator counters

Origins

    Box can be set with /box (1 for gen2 / 2 for gen3)
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
    1 = Top right of the screen
    2 = Top left of the screen
    3 = Left side of the screen
    4 = Next to ammo counter

traptimer [0, 1]

    Enables trap timer, default is disabled

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

</details>

<details>
  <summary>Descripción en español:</summary>

## Descargas
### New pluto (Versión recomendada)
- [Plutonium r2905+](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Plutonium.r2905+.zip)
  - Los timer de ronda solo funcionan en new pluto.
### Versiones alternativas
- [Ancient (Con tracker de rondas escpeciales)](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Ancient.rar)
- [Ancient (Sin trackers)](https://github.com/Fraagaa/Fraga-Bo2/releases/download/FragaV13/FragaV13.Ancient.+.trackers.rar)
- Estas versiones tienen limitaciones como: 
  - No tiene graficos mejorados ni modo noche
  - El wunderfizz no está fijo en el generador 4
  - No se puede manipular el rng de las ventajas (menos el pap y jug en nuketown)
  - Los templarios no se pueden manipular
- Redacted pronto, tengo problemas con el compilador
## Cambios del juego

- Velocidad arreglada
- Vida de los zombies arreglada
- Skybox animada
- Modo noche
- Sombras de jugadores

## Cambios en el HUD

    Timer de lobby
    Timer de ronda
    Timer de trampa
    Contador de tiradas de caja
    Contador SPH (apartir de la ronda 30 por defecto)
    Puedes cambiar el color del HUD
    Splits de rondas
    Se muestran las kills de cada jugadar en fr a partir de la ronda 6
    Se muestra la velocidad del jugador en fr a partir de la ronda 5

## Cambios en los mapas

Tranzit

    Banco lleno para todos los jugadores
    Todas las perman perks otrogadas a todos los jugadores hasta la ronda 15
    MP5 / M16 en la nevera
    Bus tracker con /bus 1 (r3755+)
    
Survival Maps

    Raygun & Raygun MK2 average trackers

Town

    Puedes elegir la posición del caja con /box
    1 = doubletap
    2 = quick revive

Nuketown

    Con /perkrng 0 puedes reiniciar hasta que 
    el PAP y jug estén en la casa azul
    y el ordend e las perks va a ser QR -> JUG -> PAP -> SPEED -> DT
    en solo, y JUG -> PAP -> SPEED -> DT -> QR en coop
    
Die Rise

    Banco lleno para todos los jugadores
    Todas las perman perks otrogadas a todos los jugadores hasta la ronda 15
    AN94 mejorada en la nevera para todos los jugadores
    Tracker de novas
    Contador de trampolines
    
Mob of the Dead

    Tiemr de trampa
    Puedes elegir la posición de la caja /box (1 para cafeteria / 2 para la oficina)
    La llave siempre spawnea donde la caja
    Tracker de brutus
    
Buried

    Banco lleno para todos los jugadores
    Todas las perman perks otrogadas a todos los jugadores hasta la ronda 15
    AN94 mejorada en la nevera para todos los jugadores
    Camuflaje animado de pap
    Contador de turbinas, resonadores y trampolines

Origins

    Puedes fijar la caja con /box (1 para gen2 / 2 para gen3)
    Wunderfizz en el generador 4
    Camuflaje aniamdo
    Tracker de panzers
    Tracker de templarios
    Tracker de tanque

## Splits **(r3705+)**

Ronda 5: Rondas 1,2,3,4,5

Ronda 30: Rondas 5, 10, 15, 20, 25, 30

Ronda 50: Rondas 10, 20, 30, 40, 50

Ronda 70: Rondas 10, 20, 30, 40, 50, 60, 70

Ronda 100: Rondas 30, 50, 70, 80, 90, 100

Ronda 150: Rondas 50, 70, 100, 125, 130, 140, 150

Ronda 200: Rondas 50, 70, 100, 150, 175, 200

SR **RoundNumeber** (necesita un fast_restart):
Example: SR 30

## DVars

character [0, 5]

    0 = Aleatorio
    1 = Misty, Richtophen, Arlington
    2 = Russman, Dempsei, Finn
    3 = Marlton, Nikolai, Sal
    4 = Stuthlinger, Takeo, Billy
    5 = Ghost (only on mob)

firstbox [0, 1]

    Quita RNG de la caja

sph [0, 255]

    Selecciona en que ronda empieza a mostrar el sph
    
timer [0, 4]

    0 = Off
    1 = Arriba a la derecha
    2 = Arriba a la izquierda
    3 = En el medio a la izquierda
    4 = Al lado del contador de munición

traptimer [0, 1]

    Activa el timer de trampa, por defecto está desactivado

SR

    5 30 50 70 100 150 200

FragaDebug

    Da a cada jugador 69420 puntos y permite los chetos

score

    Cambia la cantidad de puntos que da el modo debug

perkRNG [0, 1]

    Vulture será la ultima perk que te dan las brujas
    El orden de ventajas en nuketown será QR -> JUG -> PAP -> SPEED -> DT
    El orden de ventajas de la wunderfizz será JUG -> DT -> SPEED -> MULE -> STAM -> QR -> PHD -> CHERRY
    Auto reinicia partida en nuketown hasta que el pap y el jug está en la casa azul

Templars [0, 1]

    Los templarios solo atacan el generador 4
    Puede causar errores si el generador 4 no está activado
</details>
