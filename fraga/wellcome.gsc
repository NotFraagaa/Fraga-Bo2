#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;


#include scripts\zm\fraga\ismap;

wellcome(language)
{
    switch(language)
    {
        case "spanish":
        flag_wait("initial_blackscreen_passed");
		                                                                self iprintln("^6Fraga^5V12  ^3Acticado");
        if( isburied() || isdierise() || istranzit() ) {    wait 3;     self iprintln("Todas las perma perks otorgadas");}
        if( isburied() || isdierise() || istranzit() ) {    wait 0.5;   self iprintln("Banco lleno");}
                                                            wait 3;     self iprintln("Usa el comando ^6/sr^7 si vas a hacer un speedrun y pon la ronda correspondiente");
                                                            wait 0.5;   self iprintln("Acepta 5, 30, 50, 70, 100, 150 y 200");
                                                            wait 5;     self iprintln("Usa ^6/firstbox 1^7 para quitar el RNG de la caja");
        if(ismob() || isorigins() || isdierise() ) {        wait 5;     self iprintln("Usa ^6/tracker 0^7 para quitar los trackers de rondas especiales");}
        if( ismob() ) {                                     wait 5;     self iprintln("Usa ^6/firstbox ^51 ^7/ ^42^7 para seleccionar el spawn de la caja");}
        if( istown() ) {                                    wait 5;     self iprintln("Usa ^6/firstbox ^51 ^7/ ^42^7 para seleccionar el spawn de la caja");}
        if( ismob() ) {                                     wait 5;     self iprintln("Usa ^6/traptimer 1^7 para activar el timer de la trampa");}
        if( isburied() || isdierise() ) {                   wait 5;     self iprintln("Usa ^6/buildables 0^7 para ocultar el"); self iprintln("contador y ^6/buildables 1^7 para activarlo");}
        if( isburied()) {                                   wait 5;     self iprintln("Usa ^6/perkRNG 0^7 si quieres que la ultima ventaja otorgada por las brujas sea vulture");}
        if( isburied() || isdierise() || istranzit() )
        {
            wait 5;                                                     self iprintln("Usa ^6/character x^7 para cambiar de personaje");
            wait 4;                                                     self iprintln("^1 1^7 = Misty");
            wait 0.1;                                                   self iprintln("^1 2^7 = Russman");
            wait 0.1;                                                   self iprintln("^1 3^7 = Stulingher");
            wait 0.1;                                                   self iprintln("^1 4^7 = Marlton");
        }
        if(level.script == "zm_tomb")
        {
            wait 5;                                                     self iprintln("Usa ^6/character x^7 para cambiar de personaje");
            wait 4;                                                     self iprintln("^1 1^7 = Richtofen");
            wait 0.1;                                                   self iprintln("^1 2^7 = Dempsey");
            wait 0.1;                                                   self iprintln("^1 3^7 = Nikolai");
            wait 0.1;                                                   self iprintln("^1 4^7 = Takeo");
        }
        if(level.script == "zm_prison")
        {
            wait 5;                                                     self iprintln("Usa ^6/character x^7 para cambiar de personaje");
            wait 4;                                                     self iprintln("^1 1^7 = Weasel");
            wait 0.1;                                                   self iprintln("^1 2^7 = Finn");
            wait 0.1;                                                   self iprintln("^1 3^7 = Sal");
            wait 0.1;                                                   self iprintln("^1 4^7 = Billy");
            wait 2;                                                     self iprintln("^1 5^7 = Afterlife");
        }
        wait 5;                                                         self iprintln("Usa ^6/nightmode 1^7 para cambiar al modo noche");
        wait 5;                                                         self iprintln("Usa ^6/timerx x^7 y ^6timery x^7 para mover el timer horizontal y verticalmente respectivamente");
        wait 5;                                                         self iprintln("^3¡Buena suerte!");
        break;
        
        case "english":
        flag_wait("initial_blackscreen_passed");
		                                                                self iprintln("^6Fraga^5V12  ^Loaded");
        if( isburied() || isdierise() || istranzit() ) {    wait 3;     self iprintln("Perma perks awarded");}
        if( isburied() || isdierise() || istranzit() ) {    wait 0.5;   self iprintln("Bank filled");}
                                                            wait 3;     self iprintln("Use ^6/sr^7 if you're going to speedrun a round and add the round you're speedrunning");
                                                            wait 0.5;   self iprintln("Accepts: 5, 30, 50, 70, 100, 150 y 200");
                                                            wait 5;     self iprintln("Use ^6/firstbox 1^7 to remove RNG from the box");
        if(ismob() || isorigins() || isdierise() ) {        wait 5;     self iprintln("Use ^6/tracker 0^7 to hide the special round trackers");}
        if( ismob() ) {                                     wait 5;     self iprintln("Use ^6/firstbox ^5office ^7/ ^4cafe^7 to select box location");}
        if( istown() ) {                                    wait 5;     self iprintln("Use ^6/firstbox ^51 ^7/ ^42^7 to select box location");}
        if( ismob() ) {                                     wait 5;     self iprintln("Use ^6/traptimer 1^7 to activate traptimer");}
        if( isburied() || isdierise() ) {                   wait 5;     self iprintln("Use ^6/buildables 0^7 to hide the"); self iprintln("counter and ^6/buildables 1^7 to unhide it");}
        if( isburied()) {                                   wait 5;     self iprintln("Use ^6/perkRNG 0^7 if you want vulture to be the last perk awarded by witches");}
        if( isburied() || isdierise() || istranzit() )
        {
            wait 5;                                                     self iprintln("Use ^6/character x^7 to select character");
            wait 4;                                                     self iprintln("^1 1^7 = Misty");
            wait 0.1;                                                   self iprintln("^1 2^7 = Russman");
            wait 0.1;                                                   self iprintln("^1 3^7 = Stulingher");
            wait 0.1;                                                   self iprintln("^1 4^7 = Marlton");
        }
        if(level.script == "zm_tomb")
        {
            wait 5;                                                     self iprintln("Use ^6/character x^7 to select character");
            wait 4;                                                     self iprintln("^1 1^7 = Richtofen");
            wait 0.1;                                                   self iprintln("^1 2^7 = Dempsey");
            wait 0.1;                                                   self iprintln("^1 3^7 = Nikolai");
            wait 0.1;                                                   self iprintln("^1 4^7 = Takeo");
        }
        if(level.script == "zm_prison")
        {
            wait 5;                                                     self iprintln("Use ^6/character x^7 to select character");
            wait 4;                                                     self iprintln("^1 1^7 = Weasel");
            wait 0.1;                                                   self iprintln("^1 2^7 = Finn");
            wait 0.1;                                                   self iprintln("^1 3^7 = Sal");
            wait 0.1;                                                   self iprintln("^1 4^7 = Billy");
            wait 2;                                                     self iprintln("^1 5^7 = Afterlife");
        }
        wait 5;                                                         self iprintln("Use ^6/nightmode 1^7 to change to night mode");
        wait 5;                                                         self iprintln("Use ^6/timerx x^7 y ^6timery x^7 to move the timer horizontaly and vertically respectively");
        wait 5;                                                         self iprintln("^3Good Luck!");
        break;
        default: break;
        
        case "galego":
        flag_wait("initial_blackscreen_passed");
		                                                                self iprintln("^6Fraga^5V12  ^3Acticado");
        if( isburied() || isdierise() || istranzit() ) {    wait 3;     self iprintln("Todas as perma perks otorgadas");}
        if( isburied() || isdierise() || istranzit() ) {    wait 0.5;   self iprintln("Banco cheo");}
                                                            wait 3;     self iprintln("Usa o comando ^6/sr^7 se estas a facer un speedrun e pon a ronda correspondente");
                                                            wait 0.5;   self iprintln("Acepta 5, 30, 50, 70, 100, 150 e 200");
                                                            wait 5;     self iprintln("Usa ^6/firstbox 1^7 para quitar o RNG da caixa");
        if(ismob() || isorigins() || isdierise() ) {        wait 5;     self iprintln("Usa ^6/tracker 0^7 para agochar trackers das rondas especiais");}
        if( ismob() ) {                                     wait 5;     self iprintln("Usa ^6/firstbox ^51 ^7/ ^42^7 para seleccionar o spawn da caixa");}
        if( istown() ) {                                    wait 5;     self iprintln("Usa ^6/firstbox ^51 ^7/ ^42^7 para seleccionar o spawn de a caixa");}
        if( ismob() ) {                                     wait 5;     self iprintln("Usa ^6/traptimer 1^7 para activar o timer da trampa");}
        if( isburied() || isdierise() ) {                   wait 5;     self iprintln("Usa ^6/buildables 0^7 para agochar o"); self iprintln("contador e ^6/buildables 1^7 para amosalo");}
        if( isburied()) {                                   wait 5;     self iprintln("Usa ^6/perkRNG 0^7 se queeres que a última ventaxa otorgada polas bruxas sexa o vulture");}
        if( isburied() || isdierise() || istranzit() )
        {
            wait 5;                                                     self iprintln("Usa ^6/character x^7 para cambiar de personaxe");
            wait 4;                                                     self iprintln("^1 1^7 = Misty");
            wait 0.1;                                                   self iprintln("^1 2^7 = Russman");
            wait 0.1;                                                   self iprintln("^1 3^7 = Stulingher");
            wait 0.1;                                                   self iprintln("^1 4^7 = Marlton");
        }
        if(level.script == "zm_tomb")
        {
            wait 5;                                                     self iprintln("Usa ^6/character x^7 para cambiar de personaxe");
            wait 4;                                                     self iprintln("^1 1^7 = Richtofen");
            wait 0.1;                                                   self iprintln("^1 2^7 = Dempsey");
            wait 0.1;                                                   self iprintln("^1 3^7 = Nikolai");
            wait 0.1;                                                   self iprintln("^1 4^7 = Takeo");
        }
        if(level.script == "zm_prison")
        {
            wait 5;                                                     self iprintln("Usa ^6/character x^7 para cambiar de personaxe");
            wait 4;                                                     self iprintln("^1 1^7 = Weasel");
            wait 0.1;                                                   self iprintln("^1 2^7 = Finn");
            wait 0.1;                                                   self iprintln("^1 3^7 = Sal");
            wait 0.1;                                                   self iprintln("^1 4^7 = Billy");
            wait 2;                                                     self iprintln("^1 5^7 = Afterlife");
        }
        wait 5;                                                         self iprintln("Usa ^6/nightmode 1^7 para cambiar ao modo noite");
        wait 5;                                                         self iprintln("Usa ^6/timerx x^7 y ^6timery x^7 para mover o timer horizontal e verticalmente respectivamente");
        wait 5;                                                         self iprintln("^3Boa sorte!");
        break;
    }
}