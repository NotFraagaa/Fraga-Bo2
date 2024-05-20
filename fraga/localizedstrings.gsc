#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;

setFragaLanguage()
{
    switch(getDvar("language"))
    {
        case "spanish":
            self thread spanishWellcome();
            if(isdefined(level.boxhits))
            level.boxhits.label = &"^3Tiradas de caja: ^4";
            level.cheats.label = &"^1^FCheats activados";
            level.firstbox_active.label = &"^2^FFirstbox activado";
            if(isorigins() || isburied() || isnuketown())
            level.perkrng_desabled.label = &"^4^FPerk RNG manipulada";
            if(isorigins())
            level.templar_modiffied.label = &"^6^FTemplarios manipulados";
            if(isdefined(self.lastBrutusRound))
		    self.lastBrutusRound.label = &"^3URB: ^4";
            if(isdefined(self.lastTemplarRound))
		    self.lastTemplarRound.label = &"^3URT: ^4";
            if(isdefined(self.lastPanzerRound))
		    self.lastPanzerRound.label = &"^3URP: ^4";
            if(isdefined(self.lastleaperround))
            self.lastleaperround.label = &"^3URL: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(self.springpad_hud))
            self.springpad_hud.label = &"^3TRAMPOLINES: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3TRAMPOLINES: ^4";
                level.subwoofer_hud.label = &"^3RESONADORES: ^4";
                level.turbine_hud.label = &"^3TURBINAS: ^4";
            }
            break;



        case "french":
            self thread frenchWellcome();
            if(isdefined(level.boxhits))
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats actif";
            level.firstbox_active.label = &"^2^FFirstbox actif";
            if(isorigins() || isburied() || isnuketown())
            level.perkrng_desabled.label = &"^4^FLa RNG des atouts est manipulé";
            if(isorigins())
            level.templar_modiffied.label = &"^6^FTemplier est manipulé";
            if(isdefined(self.lastBrutusRound))
		    self.lastBrutusRound.label = &"^3DMR: ^4";
            if(isdefined(self.lastTemplarRound))
		    self.lastTemplarRound.label = &"^3DMT: ^4";
            if(isdefined(self.lastPanzerRound))
		    self.lastPanzerRound.label = &"^3DMP: ^4";
            if(isdefined(self.lastleaperround))
            self.lastleaperround.label = &"^3DML: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(self.springpad_hud))
            self.springpad_hud.label = &"^3PROPULSEURS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3PROPULSEURS: ^4";
                level.subwoofer_hud.label = &"^3RÉSONATEUR: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;



        default:
            self thread englishWellcome();
            if(isdefined(level.boxhits))
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats active";
            level.firstbox_active.label = &"^2^FFirstbox active";
            if(isorigins() || isburied() || isnuketown())
            level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
            if(isorigins())
            level.templar_modiffied.label = &"^6^FTemplars manipulated";
            if(isdefined(self.lastBrutusRound))
		    self.lastBrutusRound.label = &"^3LBR: ^4";
            if(isdefined(self.lastTemplarRound))
		    self.lastTemplarRound.label = &"^3LTR: ^4";
            if(isdefined(self.lastPanzerRound))
		    self.lastPanzerRound.label = &"^3LPR: ^4";
            if(isdefined(self.lastleaperround))
            self.lastleaperround.label = &"^3LLR: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(self.springpad_hud))
            self.springpad_hud.label = &"^3SPRINGPADS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3SPRINGPADS: ^4";
                level.subwoofer_hud.label = &"^3RESONATORS: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;
    }
}

spanishWellcome()
{
    
    flag_wait("initial_blackscreen_passed");
                                                                            self iprintln("^6Fraga^5V13  ^3Acticado");
    if( isburied() || isdierise() || istranzit() ) {            wait 3;     self iprintln("Todas las perma perks otorgadas");}
    if( isburied() || isdierise() || istranzit() ) {            wait 0.5;   self iprintln("Banco lleno");}
    if(getDvar("scr_kill_infinite_loops") != "")
    {
                                                                wait 3;     self iprintln("Usa el comando ^6/sr^7 si vas a hacer un speedrun y pon la ronda correspondiente");
                                                                wait 1;     self iprintln("Acepta 5, 30, 50, 70, 100, 150 y 200");
    }
                                                                wait 5;     self iprintln("Usa ^6/firstbox 1^7 para quitar el RNG de la caja");
    if(ismob() || isorigins() || isdierise() ) {                wait 5;     self iprintln("Usa ^6/tracker 0^7 para quitar los trackers de rondas especiales");}
    if( ismob() || istown() || isnuketown() || isorigins() ) {  wait 5;     self iprintln("Usa ^6/box [1, 2]^7 para seleccionar el spawn de la caja");}
    if( ismob() ) {                                             wait 5;     self iprintln("Usa ^6/traptimer 1^7 para activar el timer de la trampa");}
    if( isburied()) {                                           wait 5;     self iprintln("Usa ^6/perkRNG 0^7 si quieres que la ultima ventaja otorgada por las brujas sea vulture");}
    if( isorigins()) {                                          wait 5;     self iprintln("Usa ^6/perkRNG 0^7 si quieres quitar el rng del wunderfizz");}
    if( isnuketown()) {                                         wait 5;     self iprintln("Usa ^6/perkRNG 0^7 para reiniciar automáticamente hasta que el pap y titán estén en la casa azul");}
    if( isorigins()) {                                          wait 1;     self iprintln("Usa ^6/templars 0^7 para que los templarios ataquen siempre al generador 4");}

    wait 5;                                                                 self iprintln("Usa ^6/nightmode 1^7 para cambiar al modo noche");
    wait 5;                                                                 self iprintln("Usa ^6/timer [0, 4]^7 para cambiar la posición del timer");
    wait 5;                                                                 self iprintln("^3¡Buena suerte!");
}

englishWellcome()
{
    
    flag_wait("initial_blackscreen_passed");
                                                                            self iprintln("^6Fraga^5V13  ^3Active");
    if( isburied() || isdierise() || istranzit() ) {            wait 3;     self iprintln("All perma perks awarded");}
    if( isburied() || isdierise() || istranzit() ) {            wait 0.5;   self iprintln("Bank filled");}
    if(getDvar("scr_kill_infinite_loops") != "")
    {
                                                                wait 3;     self iprintln("Use ^6/sr^7 if you're going do a round sr and add the round");
                                                                wait 1;     self iprintln("Accepts 5, 30, 50, 70, 100, 150 and 200");
    }
                                                                wait 5;     self iprintln("Use ^6/firstbox 1^7 to remove RNG from the box");
    if(ismob() || isorigins() || isdierise() ) {                wait 5;     self iprintln("Use ^6/tracker 0^7 to remove special round trackers");}
    if( ismob() || istown() || isnuketown() || isorigins() ) {  wait 5;     self iprintln("Use ^6/box [1, 2]^7 to select box's spawn");}
    if( ismob() ) {                                             wait 5;     self iprintln("Use ^6/traptimer 1^7 to activate traptimer");}
    if( isburied()) {                                           wait 5;     self iprintln("Use ^6/perkRNG 0^7 if you want vulture to be the last perk awarded by witches");}
    if( isorigins()) {                                          wait 5;     self iprintln("Use ^6/perkRNG 0^7 if you want to remove RNG from wunderfizz");}
    if( isnuketown()) {                                         wait 5;     self iprintln("Use ^6/perkRNG 0^7 to auto restart untill pap and jug are on green house");}
    if( isorigins()) {                                          wait 1;     self iprintln("Use ^6/templars 0^7 to make templars go gen4 always");}

    wait 5;                                                                 self iprintln("Use ^6/nightmode 1^7 in order to enter nightmode");
    wait 5;                                                                 self iprintln("Use ^6/timer [0, 4]^7 to change timer's position");
    wait 5;                                                                 self iprintln("^3Good luck!");
}
frenchWellcome()
{
    // Credit to QeZiaa & Astrox
    flag_wait("initial_blackscreen_passed");
                                                                            self iprintln("^6Fraga^5V12  ^3Active");
    if( isburied() || isdierise() || istranzit() ) {            wait 3;     self iprintln("Tous les atouts permanents sont attribués");}
    if( isburied() || isdierise() || istranzit() ) {            wait 0.5;   self iprintln("La banque est remplie");}
    if(getDvar("scr_kill_infinite_loops") != "")
    {
                                                                wait 3;     self iprintln("Marque ^6/sr^7 si tu vas faire une manche sr et ajoute la manche");
                                                                wait 1;     self iprintln("Acceptes 5, 30, 50, 70, 100, 150 et 200");
    }
                                                                wait 5;     self iprintln("Utilise ^6/firstbox 1^7 pour supprimer la RNG de la boite");
    if(ismob() || isorigins() || isdierise() ) {                wait 5;     self iprintln("Utilise ^6/tracker 0^7 pour supprimer le tracker de la manche spéciale");}
    if( ismob() || istown() || isnuketown() || isorigins() ) {  wait 5;     self iprintln("Utilise ^6/box [1, 2]^7 pour séléctionner l'emplacement de la boite magique");}
    if( ismob() ) {                                             wait 5;     self iprintln("Utilise ^6/traptimer 1^7 pour activer le traptimer");}
    if( isburied()) {                                           wait 5;     self iprintln("Utilise ^6/perkRNG 0^7 Si tu veux que le dernier atout de la sorcière soit vulture");}
    if( isorigins()) {                                          wait 5;     self iprintln("Utilise ^6/perkRNG 0^7 si tu veux supprimer la RNG de la wunderfizz");}
    if( isnuketown()) {                                         wait 5;     self iprintln("Utilise ^6/perkRNG 0^7 pour restart automatiquement jusqu'à ce que le pack à punch et Jug soient dans la maison verte");}
    if( isorigins()) {                                          wait 1;     self iprintln("Utilise ^6/templars 0^7 pour que les templiers aillent toujours au générateur 4");}

    wait 5;                                                                 self iprintln("Utilise ^6/nightmode 1^7 dans le but d'entrer dans le mode nuit");
    wait 5;                                                                 self iprintln("Utilise ^6/timer [0, 4]^7 pour changer la position du timer");
    wait 5;                                                                 self iprintln("^3Bonne chance!");
}

printTankLine(tank_moves)
{
    if(tank_moves == 1)
        switch(getDvar("language"))
        {
            case "spanish":
                self iprintln("El tanque se ha movido " + tank_moves + " vez.");
                break;
            case "french":
                self iprintln("Le tank a été deplacé" + tank_moves + " fois.");
                break;
            default:
                self iprintln("The tank has been moved " + tank_moves + " time.");
                break;
        }
    else
        switch(getDvar("language"))
        {
            case "spanish":
                self iprintln("El tanque se ha movido " + tank_moves + " veces.");
                break;
            case "french":
                self iprintln("Le tank a été deplacé" + tank_moves + " fois.");
                break;
            default:
                self iprintln("The tank has been moved " + tank_moves + " times.");
                break;
        }
}

printRoundTime()
{
    switch(getDvar("language"))
    {
        case "spanish":
	        self.roundtimer_fraga.label = &"Tiempo de la ronda: ";
            break;
        case "french":
	        self.roundtimer_fraga.label = &"Round time: ";
            break;
        default:
	        self.roundtimer_fraga.label = &"Round time: ";
            break;
    }
}

printplayerkills()
{
    
    switch(getDvar("language"))
    {
        case "spanish":
            if(isdefined(level.playerkills1))
            level.playerkills1.label = &"^3Bajas jugador 1: ^4";
            if(isdefined(level.playerkills2))
            level.playerkills1.label = &"^3Bajas jugador 2: ^4";
            if(isdefined(level.playerkills3))
            level.playerkills1.label = &"^3Bajas jugador 3: ^4";
            if(isdefined(level.playerkills4))
            level.playerkills1.label = &"^3Bajas jugador 4: ^4";
            break;
        case "french":
            if(isdefined(level.playerkills1))
            level.playerkills1.label = &"^3Tuer le joueur 1: ^4";
            if(isdefined(level.playerkills2))
            level.playerkills1.label = &"^3Tuer le joueur 2: ^4";
            if(isdefined(level.playerkills3))
            level.playerkills1.label = &"^3Tuer le joueur 3: ^4";
            if(isdefined(level.playerkills4))
            level.playerkills1.label = &"^3Tuer le joueur 4: ^4";
            break;
        default:
            if(isdefined(level.playerkills1))
            level.playerkills1.label = &"^3Kills player 1: ^4";
            if(isdefined(level.playerkills2))
            level.playerkills1.label = &"^3Kills player 2: ^4";
            if(isdefined(level.playerkills3))
            level.playerkills1.label = &"^3Kills player 3: ^4";
            if(isdefined(level.playerkills4))
            level.playerkills1.label = &"^3Kills player 4: ^4";
            break;
    }
}

printbuslocation()
{
    
    switch(getDvar("language"))
    {
        case "spanish":
			if(level.the_bus.origin[0] > -6530 && level.the_bus.origin[0] < -6520 && level.the_bus.origin[1] < 4800 && level.the_bus.origin[1] > 4600)	// Depot
				self.buslocation.label = &"^3Bus: ^4Estación";
			if(level.the_bus.origin[0] > -5560 && level.the_bus.origin[0] < -5550  && level.the_bus.origin[1] > -6870 && level.the_bus.origin[1] < -6800)	// Dinner
				self.buslocation.label = &"^3Bus: ^4Restaurante";
			if(level.the_bus.origin[0] > 6400 && level.the_bus.origin[1] < 6440 && level.the_bus.origin[1] > -5850 && level.the_bus.origin[1] < -5820)	// Farm
				self.buslocation.label = &"^3Bus: ^4Granja";
			if(level.the_bus.origin[0] > 10280 && level.the_bus.origin[0] < 10320 && level.the_bus.origin[1] < 7500 && level.the_bus.origin[1] > 7400)	// Power
				self.buslocation.label = &"^3Bus: ^4Electicidad";
			if(level.the_bus.origin[0] > 1460 && level.the_bus.origin[0] < 1490 && level.the_bus.origin[1] < 900 && level.the_bus.origin[1] > 800) 	// Town
				self.buslocation.label = &"^3Bus: ^4Ciudad";
            break;
        case "french":
			if(level.the_bus.origin[0] > -6530 && level.the_bus.origin[0] < -6520 && level.the_bus.origin[1] < 4800 && level.the_bus.origin[1] > 4600)	// Depot
				self.buslocation.label = &"^3Bus: ^4Depot";
			if(level.the_bus.origin[0] > -5560 && level.the_bus.origin[0] < -5550  && level.the_bus.origin[1] > -6870 && level.the_bus.origin[1] < -6800)	// Dinner
				self.buslocation.label = &"^3Bus: ^4Dinner";
			if(level.the_bus.origin[0] > 6400 && level.the_bus.origin[1] < 6440 && level.the_bus.origin[1] > -5850 && level.the_bus.origin[1] < -5820)	// Farm
				self.buslocation.label = &"^3Bus: ^4Farm";
			if(level.the_bus.origin[0] > 10280 && level.the_bus.origin[0] < 10320 && level.the_bus.origin[1] < 7500 && level.the_bus.origin[1] > 7400)	// Power
				self.buslocation.label = &"^3Bus: ^4Power";
			if(level.the_bus.origin[0] > 1460 && level.the_bus.origin[0] < 1490 && level.the_bus.origin[1] < 900 && level.the_bus.origin[1] > 800) 	// Town
				self.buslocation.label = &"^3Bus: ^4Town";
            break;
        default:
			if(level.the_bus.origin[0] > -6530 && level.the_bus.origin[0] < -6520 && level.the_bus.origin[1] < 4800 && level.the_bus.origin[1] > 4600)	// Depot
				self.buslocation.label = &"^3Bus: ^4Depot";
			if(level.the_bus.origin[0] > -5560 && level.the_bus.origin[0] < -5550  && level.the_bus.origin[1] > -6870 && level.the_bus.origin[1] < -6800)	// Dinner
				self.buslocation.label = &"^3Bus: ^4Dinner";
			if(level.the_bus.origin[0] > 6400 && level.the_bus.origin[1] < 6440 && level.the_bus.origin[1] > -5850 && level.the_bus.origin[1] < -5820)	// Farm
				self.buslocation.label = &"^3Bus: ^4Farm";
			if(level.the_bus.origin[0] > 10280 && level.the_bus.origin[0] < 10320 && level.the_bus.origin[1] < 7500 && level.the_bus.origin[1] > 7400)	// Power
				self.buslocation.label = &"^3Bus: ^4Power";
			if(level.the_bus.origin[0] > 1460 && level.the_bus.origin[0] < 1490 && level.the_bus.origin[1] < 900 && level.the_bus.origin[1] > 800) 	// Town
				self.buslocation.label = &"^3Bus: ^4Town";
            break;
    }
}

printbusstatus(buslastpos)
{
    switch(getDvar("language"))
    {
        case "spanish":
            if(buslastpos != level.the_bus.origin)
                self.busmoving.label = &"^3Bus en movimiento";
            else
                self.busmoving.label = &"^1Bus parado";
            buslastpos = level.the_bus.origin;
            break;
        case "french":
            if(buslastpos != level.the_bus.origin)
                self.busmoving.label = &"^3Bus est en mouvement";
            else
                self.busmoving.label = &"^1Bus est à l'arrêt ";
            buslastpos = level.the_bus.origin;
            break;
        default:
            if(buslastpos != level.the_bus.origin)
                self.busmoving.label = &"^3Bus mooving";
            else
                self.busmoving.label = &"^1Bus stopped";
            buslastpos = level.the_bus.origin;
            break;
    }
}