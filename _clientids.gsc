#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_prison_sq_bg;
#include maps\mp\zm_alcatraz_craftables;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_perk_random;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_pers_upgrades;

init()
{
    self endon( "disconnect" );


    level.debug = getDvarInt("FragaDebug");
	
	if(level.debug) level thread debug();


	thread setdvars();
	thread fix_highround();
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;
    if(issurvivalmap() && !isdefined(level.chest_accessed_since_ray))
        level.chest_accessed_since_ray = 0;

    level thread firstbox();
	level thread boxhits();
    level thread roundcounter();
	level thread buried_init();
	level thread dierise_init();
	level thread origins_init();
	level thread mob_init();
	level thread tranzit_init();
    level thread nuketown_init();
    
    level thread firstboxActivated();
    level thread perkrng();
    level thread cheatsActivated();
    while(true)
    {
        level waittill("connecting", player);
        player thread fraga_connected();
        if(!level.onlinegame) player thread enablepersperks();
    }
}

debug()
{
    if(GetDvar("score") == "")
        setdvar( "score", "69420" );
    level.player_out_of_playable_area_monitor = 0;
    level thread debugmode();
    setdvar("sv_cheats", level.debug);
    setdvar("cg_ufo_scaler", 1);
    while(true)
    {
        level waittill("connected", player );
        player thread connectedDebug();
    }
}

connectedDebug()
{
    level endon( "game_ended" );
    self endon( "disconnect" );
    flag_wait( "start_zombie_round_logic" );
	if(level.script == "zm_prison")
		flag_wait( "afterlife_start_over" );
	self.score = GetDvarInt("score");
}

debugmode()
{
	level.debugmode.hidewheninmenu = 1;
    level.debugmode = createserverfontstring( "objective", 1.3 );
    level.debugmode.y = 20;
    level.debugmode.x = 0;
    level.debugmode.fontscale = 1;
    level.debugmode.alignx = "center";
    level.debugmode.horzalign = "user_center";
    level.debugmode.vertalign = "user_top";
    level.debugmode.aligny = "top";
    level.debugmode.alpha = 1;
    level.debugmode.label = &"DEBUG MODE";
}

fraga_connected()
{
	self endon("disconnect");
	self waittill("spawned_player");
	self thread timer();
	self thread timerlocation();
    self thread setFragaLanguage();
    if(getDvarInt("character") != 0) level.givecustomcharacters = ::set_character_option;
    if(self == level.players[0]) self thread fixrotationangle();
    if(isancient())
    {
        if(!level.onlinegame) self iprintln("^6Fraga^5V15  ^3Active ^4[Ancient, Local mode]");
        else self iprintln("^6Fraga^5V15  ^3Active ^4[Ancient]");
    }
    else
    {
        if(!level.onlinegame) self iprintln("^6Fraga^5V15  ^3Active ^4[Redacted, Local mode]");
        else self iprintln("^6Fraga^5V15  ^3Active ^4[Redacted]");
    }
    if(getDvar("language") == "french") self iprintln("^1Spanish ^3Ruleset  ^1Active");
}

origins_init()
{
	if(!isorigins()) return;
	level thread origins_connected();	
	level thread boxlocation();
}

origins_connected()
{
	while(true)
	{
		level waittill("connecting", player);
        // player thread PanzerTracker();
        // player thread TemplarTracker();
	}
}

// Buried

buried_init()
{
	if(isburied()) return;
    level thread connected_buried();
	level thread buildable_controller();
}

connected_buried()
{
	while(true)
	{
		level waittill("connecting", player);
		player thread onconnect_buried();
		player thread bank();
		player thread award_permaperks_safe();
        player waittill("spawned_player");
		player thread fridge();
	}
}

// Die Rise
onconnect_buried()
{
	self.initial_stats = array();
	self thread watch_stat( "springpad_zm", array( "zm_highrise", "zm_buried" ) );
	self thread watch_stat( "turbine" );
	self thread watch_stat( "subwoofer_zm" );
}


dierise_init()
{
	if(!isdierise()) return;
    level thread dierise_connected();
	level thread buildable_controller();
}

dierise_connected()
{
	while(true)
	{
		level waittill("connecting", player);
		player thread dierise_onconnect();
    	player thread bank();
    	player thread award_permaperks_safe();
        // player thread leapertracker();
		self.initial_stats = array();
		self thread watch_stat("springpad_zm");
        player waittill("spawned_player");
		player thread fridge();
	}
}

dierise_onconnect()
{
	self.initial_stats = array();
	self thread watch_stat( "springpad_zm", array( "zm_highrise", "zm_buried" ) );
}

//MOB
mob_init()
{
	if(!ismob()) return;
	level thread setup_master_key_override();
    level thread mob_connected();
	level thread boxlocation();
}

mob_connected()
{
	while(true)
	{
		level waittill("connecting", player);
        //player thread BrutusTracker();
		player thread trap_timer();
		player thread givetomahawk();
	}
}

//Tranzit
tranzit_init()
{
	if(!istranzit() || istown() || isfarm() || isdepot()) return;
    if (istranzit()) level thread tranzit_connected();
	if(!istranzit()) level thread raygun_counter();
	if(istown()) level thread boxlocation();
}

tranzit_connected()
{
	while(true)
	{
		level waittill("connecting", player);
    	player thread bank();
    	player thread award_permaperks_safe();
        player waittill("spawned_player");
		player thread fridge();
	}
}

// Nuketown
nuketown_init()
{
    if(!isnuketown())
        return;
    level thread nuketown_connected();
	level thread boxlocation();
	level thread raygun_counter();
}

nuketown_connected()
{
    while(true)
    {
	    level waittill("connecting", player);
        if(!isancient())
            player thread checkpap();
        else
	        player thread checkpaplocation();
    }
}

// General use
timer()
{
	self endon("disconnect");

	self thread round_timer();
	self.timer = newclienthudelem(self);
	self.timer.alpha = !getDvarInt("st") * 0;
	self.timer.color = (1, 1, 1);
	self.timer.hidewheninmenu = 1;
	self.timer.fontscale = 1.7;
	flag_wait("initial_blackscreen_passed");
	while(true)
	{
		self.timer settimer( int(gettime() / 1000) - level.start_time);
		wait 0.05;
	}
}

round_timer()
{
	self endon("disconnect");

	self.round_timer = newclienthudelem(self);
	self.round_timer.alpha = 0;
	self.round_timer.fontscale = 1.7;
	self.round_timer.color = (0.8, 0.8, 0.8);
	self.round_timer.hidewheninmenu = 1;
	self.round_timer.x = self.timer.x;
	self.round_timer.y = self.timer.y + 15;
	flag_wait("initial_blackscreen_passed");
	level.fade_time = 0.2;

	while(true)
	{
		zombies_this_round = level.zombie_total + get_round_enemy_array().size;
		hordes = zombies_this_round / 24;
		dog_round = flag("dog_round");
		leaper_round = flag("leaper_round");
		self.round_timer settimerup(0);
		start_time = int(GetTime() / 1000);
		level waittill("end_of_round");
		end_time = int(GetTime() / 1000);
		time = end_time - start_time;
		self display_round_time(time, hordes, dog_round, leaper_round);
		level waittill("start_of_round");
		self.round_timer.label = &"";
	}
}

display_round_time(time, hordes, dog_round, leaper_round)
{
	timer_for_hud = time - 0.1;
	sph_off = true;

	if(level.round_number > GetDvarInt("sph") && !dog_round && !leaper_round)
		sph_off = false;

	self.round_timer fadeovertime(level.fade_time);
	if(sph_off)
	{
		for(i = 0; i < 238; i++)
		{
			self.round_timer settimer(timer_for_hud);
			wait(0.05);
		}
	}
	else
	{
		for(i = 0; i < 100; i++)
		{
			self.round_timer settimer(timer_for_hud);
			wait(0.05);
		}
		self.round_timer fadeovertime(level.fade_time);
		self.round_timer.alpha = 0;
		wait(level.fade_time * 2);
		self display_sph(time, hordes);
	}
}

display_sph(time, hordes)
{
	sph = time / hordes;
	self.round_timer fadeovertime(level.fade_time);
	self.round_timer.alpha = 1;
	self.round_timer.label = &"SPH: ";
	self.round_timer setvalue(sph);

	for(i = 0; i < 5; i++)
		wait(1);

	self.round_timer fadeovertime(level.fade_time);
	self.round_timer.alpha = 0;
	wait(level.fade_time);
}

timerlocation()
{
	self endon("disconnect");

	while(true)
	{
		switch(getDvarInt("timer"))
		{
			case 0:
				self.timer.alpha = !getDvarInt("st") * 0;
				self.round_timer.alpha = 0;
				break;
			case 1:
				self.round_timer.alignx = "right";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_right";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -1;
				self.timer.y = 13;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				if(getDvar("cg_drawFPS") != "Off") self.timer.y += 4;
				if(getDvar("cg_drawFPS") != "Off" && GetDvar("language") == "japanese") self.timer.y += 10;
				if(ismob())
				{
					self.timer.y = 40;
					self.trap_timer.y = 19;
				}
				if(isdierise())
					self.timer.y = 30;
				break;
			case 2:
				self.round_timer.alignx = "left";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_left";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 0;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				if(isorigins())
					self.timer.y = 45;
				if(issurvivalmap())
					self.timer.y = 40;
				if(isdierise() && level.springpad_hud.alpha != 0)
					self.timer.y = 10;
				if(isburied() && level.springpad_hud.alpha != 0)
					self.timer.y = 35;
				break;
			case 3:
				self.timer.alignx = "left";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_left";
				self.timer.vertalign = "user_top";
				self.round_timer.alignx = "left";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_left";
				self.round_timer.vertalign = "user_top";
				self.timer.x = 1;
				self.timer.y = 250;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				break;
			case 4:
				self.round_timer.alignx = "right";
				self.round_timer.aligny = "top";
				self.round_timer.horzalign = "user_right";
				self.round_timer.vertalign = "user_top";
				self.timer.alignx = "right";
				self.timer.aligny = "top";
				self.timer.horzalign = "user_right";
				self.timer.vertalign = "user_top";
				self.timer.x = -170;
				self.timer.y = 415;
				self.timer.alpha = !getDvarInt("st") * 1;
				self.round_timer.alpha = 1;
				break;

			default: break;
		}
		self.round_timer.x = self.timer.x;
		self.round_timer.y = self.timer.y + 15;
		
		wait 0.1;
		if(GetDvar("language") == "japanese")
		{
			self.timer.fontscale = 1.5;
			self.round_timer.fontscale = self.timer.fontscale;
		}
	}
}


istown()
{
    if(level.script == "zm_transit")
        if(level.scr_zm_map_start_location == "town")
            if(level.scr_zm_ui_gametype_group == "zsurvival")
                return true;
                
    return false;
}

isfarm()
{
    if(level.script == "zm_transit")
        if(level.scr_zm_map_start_location == "farm")
            if(level.scr_zm_ui_gametype_group == "zsurvival")
                return true;

    return false;
}

isdepot()
{
    if(level.script == "zm_transit")
        if(level.scr_zm_map_start_location == "transit")
            if(level.scr_zm_ui_gametype_group == "zsurvival")
                return true;
    return false;
}

istranzit()
{
    if(level.script == "zm_transit")
        if(level.scr_zm_map_start_location == "transit")
            if(level.scr_zm_ui_gametype_group == "zclassic")
                return true;

    return false;
}

isnuketown()
{
	return (level.script == "zm_nuked");
}

isdierise()
{
	return (level.script == "zm_highrise");
}

ismob()
{
	return (level.script == "zm_prison");
}

isburied()
{
	return (level.script == "zm_buried");
}

isorigins()
{
	return (level.script == "zm_tomb");
}

is_round(round)
{
	return round <= level.round_number;
}

issurvivalmap()
{
    if(isnuketown()) return true;
    if(istown()) return true;
    if(isfarm()) return true;
    if(isdepot()) return true;
    return false;
}

isvictismap()
{
    if(isdierise()) return true;
    if(isburied()) return true;
    if(istranzit()) return true;

    return false;
}

setDvars()
{
    setdvar("sv_cheats", 0);
    setdvar("player_strafeSpeedScale", 1);
    setdvar("player_backSpeedScale", 1);
    setdvar("r_dof_enable", 0);
    
    createDvar("box", 1);
    createDvar("character", 0);
    createDvar("FragaDebug", 0);
    createDvar("sph", 50);
    createDvar("timer", 1);
    createDvar("firstbox", 0);
    createDvar("stop_warning", 0);

    if (ismob())
    {
        createDvar("tracker", 0);
        createDvar("traptimer", 0);
    }
    if (isorigins())
    {
        createDvar("tracker", 0);
        createDvar("perkRNG", 1);
    }

    if (isvictismap()) createDvar("fridge", "m16");
    if (isburied()) createDvar("perkRNG", 1);
    if (isdierise()) createDvar("tracker", 0);
    if (isnuketown() && isancient()) createDvar("perkRNG", 1);
    if (issurvivalmap()) createDvar("avg", 1);
    
    level waittill("initial_blackscreen_passed");
    level.start_time = int(gettime() / 1000) + 0.5;
}

createDvar(dvar, set)
{
    if(getDvar(dvar) == "")
        setDvar(dvar, set);
}


fix_highround()
{
	if(isorigins())
		return;
	while(level.round_number > 155)
	{
		zombies = getaiarray("axis");
        foreach(zombie in zombies)
            if(zombie.targetname == "zombie" && !isdefined(zombie.health_override))
            {
					zombie.health_override = true;
					zombie.health = 1044606723;
            }
		wait 0.1;
	}
}

fixrotationangle()
{
    // Aviso de ovweflow en el giro de la cámara
    // Estaría bien encontrar la dirección de memoria de la camara y hacerle el módulo 360 :|
	angulo1 = 0;
	angulo2 = 0;
	level.vueltass = 0;
    level.vueltas = createserverfontstring( "objective", 1.3 );
	level.vueltas.hidewheninmenu = 1;
    level.vueltas.y = -40;
    level.vueltas.x = 0;
    level.vueltas.fontscale = 1.4;
    level.vueltas.alignx = "center";
    level.vueltas.horzalign = "user_center";
    level.vueltas.vertalign = "user_bottom";
    level.vueltas.aligny = "bottom";
    level.vueltas.alpha = 1;
    level.vueltas.label = &"^F^1Warning: you're close to the max rotation angle";
	thread showWarning();
    while(true)
    {
		angulo1 = self.angles[1];
		diferencia = angulo1 - angulo2;
		if(diferencia  < -180)
			level.vueltass++;
		if(diferencia  > 180)
			level.vueltass--;
		
		angulo2 = angulo1;
		wait 0.001;
    }
}

showWarning()
{
	while(!getDvarInt("stop_warning"))
	{
		if(abs(level.vueltass) > 5000000) level.vueltas.alpha = 1;
		else level.vueltas.alpha = 0;
		wait 0.5;
	}
	level.vueltas destroy();
}

// Tiradas de caja
boxhits()
{
    level thread displayBoxHits();
    while(true)
    {
        level waittill("connecting", player);
        player thread track_rays();
    }
}

track_rays()
{
    while(true)
    {
        while(self.sessionstate != "playing")
            wait 0.1;
        if(self hasweapon("ray_gun_zm"))
            level.total_ray++;
        if(self hasweapon("raygun_mark2_zm"))
            level.total_mk2++;

        while(self has_weapon_or_upgrade("ray_gun_zm") || self has_weapon_or_upgrade("raygun_mark2_zm")) 
            wait 0.1;
        wait 0.1;
    }
}

displayBoxHits()
{
	level.boxhits.hidewheninmenu = 1;
    level.boxhits = createserverfontstring( "objective", 1.3 );
    level.boxhits.y = 0;
    level.boxhits.x = 0;
    level.boxhits.fontscale = 1.4;
    level.boxhits.alignx = "center";
    level.boxhits.horzalign = "user_center";
    level.boxhits.vertalign = "user_top";
    level.boxhits.aligny = "top";
    level.boxhits.alpha = 0;
    level.boxhits setvalue(0);
    if(issurvivalmap())
    {
        level.mk2_obtained = 0;
        level.ray_gun_obtained = 0;
        level.boxhits.alignx = "left";
        level.boxhits.horzalign = "user_left";
        level.boxhits.x = 2;
        level.boxhits.alpha = 1;
    }
    while(!isdefined(level.total_chest_accessed) || !isdefined(level.chest_accessed))
        wait 0.1;
    counter = 0;
    
    if(issurvivalmap())
        while(true)
        {
            if(counter != level.chest_accessed)
            {
                counter = level.chest_accessed;
                if(counter == 0) continue;

                level.total_chest_accessed++;

                if(count_for_raygun()) level.total_chest_accessed_ray++;
                if(count_for_mk2()) level.total_chest_accessed_mk2++;
                
                level.boxhits setvalue(level.total_chest_accessed);
            }
            wait 0.1;
        }
    else
        while(true)
        {
            if(counter != level.chest_accessed)
            {
                counter = level.chest_accessed;
                if(counter == 0) continue;

                level.total_chest_accessed++;
                level.boxhits setvalue(level.total_chest_accessed);
                for(i = 1; i > 0.1; i -= 0.02)
                {
                    level.boxhits.alpha = i;
                    wait 0.1;
                }
                level.boxhits.alpha = 0;
            }
            wait 0.1;
        }
}

count_for_raygun()
{
    // Si todos los jugadores tienen arma de rayos no cuenta
    // El problema es que puede tirar de caja un jugador con arma de rayos y cambiaria la media si hay otro sin arma de rayos
    foreach(player in level.players)
        if (!player has_weapon_or_upgrade("ray_gun_zm"))
            return true;
    return false;
}
count_for_mk2()
{
    if(isburied())
    {
        // En buried todos los jugadores pueden tener arma de rayos
        foreach(player in level.players)
            if (!player has_weapon_or_upgrade("raygun_mark2_zm"))
                return true;
        return false;
    }

    // Si un jugador tiene la mk2 ya no cuenta
    foreach(player in level.players)
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            return false;
    return true;
}

fade()
{
    for(i = 1; i < 0.1; i -= 0.02)
    {
        level.boxhits.alpha = i;
        wait 0.1;
    }
    level.boxhits.alpha = 0;
}

raygun_counter()
{
    self endon("disconnect");

    if(!isDefined(level.total_mk2)) level.total_mk2 = 0;
    if(!isDefined(level.total_ray)) level.total_ray = 0;

	level.total_ray_display.hidewheninmenu = 1;
    level.total_ray_display = createserverfontstring( "objective", 1.3 );
    level.total_ray_display.y = 26;
    level.total_ray_display.x = 2;
    level.total_ray_display.fontscale = 1.3;
    level.total_ray_display.alignx = "left";
    level.total_ray_display.horzalign = "user_left";
    level.total_ray_display.vertalign = "user_top";
    level.total_ray_display.aligny = "top";
    level.total_ray_display.alpha = 1;
	level.total_mk2_display.hidewheninmenu = 1;
    level.total_mk2_display = createserverfontstring( "objective", 1.3 );
    level.total_mk2_display.y = 14;
    level.total_mk2_display.x = 2;
    level.total_mk2_display.fontscale = 1.3;
    level.total_mk2_display.alignx = "left";
    level.total_mk2_display.horzalign = "user_left";
    level.total_mk2_display.vertalign = "user_top";
    level.total_mk2_display.aligny = "top";
    level.total_mk2_display.alpha = 1;
    
    level.total_ray_display setvalue(0);
    level.total_mk2_display setvalue(0);

    while(true)
    {
        if(getDvarInt("avg"))
        {
            level.total_mk2_display.label = &"^3Raygun MK2 AVG: ^4";
            level.total_ray_display.label = &"^3Raygun AVG: ^4";
            level.total_ray_display setvalue(level.ray_gun_obtained / level.total_ray);
            level.total_mk2_display setvalue(level.mk2_obtained / level.total_mk2);
        }
        else
        {
            level.total_mk2_display.label = &"^3Total Raygun MK2: ^4";
            level.total_ray_display.label = &"^3Total Raygun: ^4";
            level.total_ray_display setvalue(level.total_ray);
            level.total_mk2_display setvalue(level.total_mk2);
        }
        wait 0.1;
    }
}

boxlocation()
{
    flag_wait("initial_blackscreen_passed");
    while(!isdefined(level.chests))
        wait 0.1;
    switch(getDvarInt("box"))
    {
        case 1: 
            if(isorigins()) level thread startbox("bunker_tank_chest");
            if(isnuketown()) level thread startbox("start_chest1");
            if(ismob()) level thread startbox("cafe_chest");
            if(istown()) level thread startbox("town_chest_2");
        break;

        case 2:
            if(isorigins()) level thread startbox("bunker_cp_chest");
            if(isnuketown()) level thread startbox("start_chest2");
            if(ismob()) level thread startbox("start_chest");
            if(istown()) level thread startbox("town_chest");
        break;

        default: break;
    }
}

startBox(box)
{
    if(isDefined(level._zombiemode_custom_box_move_logic))
        kept_move_logic = level._zombiemode_custom_box_move_logic;

    level._zombiemode_custom_box_move_logic = ::force_next_location;

    foreach (chest in level.chests)
    {
        if (!chest.hidden && chest.script_noteworthy == box)
        {
            if (isDefined(kept_move_logic))
                level._zombiemode_custom_box_move_logic = kept_move_logic;
            return;
        }
        if (!chest.hidden)
        {
            level.chest_min_move_usage = 8;
            level.chest_name = box;

            flag_set("moving_chest_now");
            chest thread maps\mp\zombies\_zm_magicbox::treasure_chest_move();

            wait 0.05;
            level notify("weapon_fly_away_start");
            wait 0.05;
            level notify("weapon_fly_away_end");

            break;
        }
    }

    while (flag("moving_chest_now"))
        wait 0.05;

    if (isDefined(kept_move_logic))
        level._zombiemode_custom_box_move_logic = kept_move_logic;

    if (isDefined(level.chest_name) && isDefined(level.dig_magic_box_moved))
        level.dig_magic_box_moved = 0;

    level.chest_min_move_usage = 4;
}

force_next_location()
{
    for (i = 0; i < level.chests.size; i++)
        if (level.chests[i].script_noteworthy == level.chest_name)
            level.chest_index = i;
}

firstbox()
{
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");
    
    while(level.round_number <= 1)
    {
        if(getDvarInt("firstbox"))
        {
            level thread setUpWeapons();
            special_weapon_magicbox_check = level.special_weapon_magicbox_check;
            level.special_weapon_magicbox_check = undefined;

            foreach(weapon in getarraykeys(level.zombie_weapons))
            {
                level.zombie_weapons[weapon].is_in_box = 0;
                wait 0.1;
            }
            
            while(!isdefined(level.forced_box_guns))
                wait 0.1;

            foreach(weapon in level.forced_box_guns)
            {
                level.zombie_weapons[weapon].is_in_box = 1;
                wait 0.1;
            }

            while( (level.total_chest_accessed - level.chest_moves) != level.forced_box_guns.size && level.round_number < 10)
                wait 1;

            level.special_weapon_magicbox_check = special_weapon_magicbox_check;
            foreach(weapon in getarraykeys(level.zombie_include_weapons))
            {
                if(level.zombie_include_weapons[weapon] == 1)
                    level.zombie_weapons[weapon].is_in_box = 1;
            }
        }
        if(isancient())
            return;
        else
            wait 0.1;
    }
}

setUpWeapons()
{
    if(isdefined(level.forced_box_guns))
        return;
    if(istranzit())
    switch(level.players.size)
    {
        case 1: 
        level.forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "emp_grenade_zm");
        break;
        case 2:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm");
        break;
        case 3:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm", "cymbal_monkey_zm");
        break;
        case 4:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
    }
    if(isnuketown())
    switch(level.players.size)
    {
        case 1: 
        level.forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm");
        break;
        case 2:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
        case 3:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
        case 4:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
    }
    if(isdierise())
    switch(level.players.size)
    {
        case 1: 
        level.forced_box_guns = array("cymbal_monkey_zm");
        break;
        case 2:
        level.forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
        case 3:
        level.forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
        case 4:
        level.forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
    }
    if(ismob())
    switch(level.players.size)
    {
        case 1: 
        level.forced_box_guns = array("raygun_mark2_zm", "blundergat_zm");
        break;
        case 2:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "blundergat_zm");
        break;
        case 3:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "blundergat_zm");
        break;
        case 4:
        level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "blundergat_zm");
        break;
    }
    if(isburied())
    switch(level.players.size)
    {
        case 1: 
        level.forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "slowgun_zm");
        break;
        case 2:
        level.forced_box_guns = array("raygun_mark2_zm", "raygun_mark2_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
        break;
        case 3:
        level.forced_box_guns = array("raygun_mark2_zm", "raygun_mark2_zm", "raygun_mark2_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
        break;
        case 4:
        level.forced_box_guns = array("raygun_mark2_zm", "raygun_mark2_zm", "raygun_mark2_zm", "raygun_mark2_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
        break;
    }
    if(isorigins())
    switch(level.players.size)
    {
        case 1: 
        level.forced_box_guns = array("scar_zm", "raygun_mark2_zm", "m32_zm", "cymbal_monkey_zm");
        break;
        case 2:
        level.forced_box_guns = array("scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
        case 3:
        level.forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
        case 4:
        level.forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
        break;
    }
}

// Victis
fridge()
{
	if(level.round_number >= 15)
		return;
	
	if(isdierise() || isburied())
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
	}
	if(istranzit())
	{
		if(getDvar("fridge") == "m16")
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "m16_gl_upgraded_zm");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 270);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 30);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_clip", 1);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_stock", 8);
		}
		else
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "mp5k_upgraded_zm");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 200);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 40);
		}
	}
}


award_permaperks_safe()
{
    if(!level.onlinegame) return;
	if(level.round_number >= 15) return;

	level endon("end_game");
	self endon("disconnect");

	while (!isalive(self))
		wait 0.05;

	wait 0.5;

    perks_to_process = [];
    perks_to_process[perks_to_process.size] = permaperk_array("revive");
    perks_to_process[perks_to_process.size] = permaperk_array("multikill_headshots");
    perks_to_process[perks_to_process.size] = permaperk_array("perk_lose");
    perks_to_process[perks_to_process.size] = permaperk_array("jugg", undefined, undefined, 15);
    perks_to_process[perks_to_process.size] = permaperk_array("flopper", array("zm_buried"));
    perks_to_process[perks_to_process.size] = permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"));
    perks_to_process[perks_to_process.size] = permaperk_array("cash_back");
    perks_to_process[perks_to_process.size] = permaperk_array("sniper");
    perks_to_process[perks_to_process.size] = permaperk_array("insta_kill");
    perks_to_process[perks_to_process.size] = permaperk_array("pistol_points");
    perks_to_process[perks_to_process.size] = permaperk_array("double_points");

	foreach (perk in perks_to_process)
	{
		if( !(istranzit() && perk == permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"))))
		self resolve_permaperk(perk);
		wait 0.05;
	}

	if(istranzit()) remove_permaperk("box_weapon");
    // Raygun Mark 2 is not included on the permanperk on tranzit

	wait 0.5;
	self maps\mp\zombies\_zm_stats::uploadstatssoon();
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	// Damos todas las ventajas en los mapas correspondientes
	// Estoy bastante seguro de que no hace falta porque no se cargan en el resto de mapas
	if (!isDefined(maps_award))
		maps_award = array("zm_transit", "zm_highrise", "zm_buried");
	if (!isDefined(maps_take))
		maps_take = [];
	if (!isDefined(to_round))
		to_round = 255;

	permaperk = [];
	permaperk["code"] = code;
	permaperk["maps_award"] = maps_award;
	permaperk["maps_take"] = maps_take;
	permaperk["to_round"] = to_round;

	return permaperk;
}

resolve_permaperk(perk)
{
	wait 0.05;

	perk_code = perk["code"];

	if (is_round(perk["to_round"])) return;

	if (isinarray(perk["maps_award"], level.script) && !self.pers_upgrades_awarded[perk_code])
	{
		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			self award_permaperk(stat_name, perk_code, stat_value);
		}
	}

	if (isinarray(perk["maps_take"], level.script) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}

award_permaperk(stat_name, perk_code, stat_value)
{
	flag_set("permaperks_were_set");
	self.stats_this_frame[stat_name] = 1;
	self maps\mp\zombies\_zm_stats::set_global_stat(stat_name, stat_value);
	self playsoundtoplayer("evt_player_upgrade", self);
}

remove_permaperk(perk_code)
{
	self.pers_upgrades_awarded[perk_code] = 0;
	self playsoundtoplayer("evt_player_downgrade", self);
}

bank()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	if(level.round_number != 1) return;
	self.account_value = level.bank_account_max;
}

// Buildables
watch_stat( stat, map_array )
{
    if ( !isdefined( map_array ) )
        map_array = array( "zm_buried" );

    if ( !isinarray( map_array, level.script ) )
        return;

    level endon( "end_game" );
    self endon( "disconnect" );

    if ( !isdefined( self.initial_stats[stat] ) )
        self.initial_stats[stat] = self getdstat( "buildables", stat, "buildable_pickedup" );

    while ( true )
    {
        stat_number = self getdstat( "buildables", stat, "buildable_pickedup" );
        delta = stat_number - self.initial_stats[stat];

        if (delta > 0 && stat_number > 0)
        {
            self.initial_stats[stat] = stat_number;
            level.buildable_stats[stat] = level.buildable_stats[stat] + delta;
            
            for(i = 1; i > 0.25; i -= 0.02)
            {
                level.turbine_hud.alpha = i;
                level.subwoofer_hud.alpha = i;
                level.springpad_hud.alpha = i;
                wait 0.1;
            }
            level.turbine_hud.alpha = 0;
            level.subwoofer_hud.alpha = 0;
            level.springpad_hud.alpha = 0;
        }
        wait 0.1;
    }
}

buildable_hud()
{
	level.springpad_hud.hidewheninmenu = 1;
    level.springpad_hud = createserverfontstring( "objective", 1.3 );
    if (isburied()) level.springpad_hud.y = 0;
    else level.springpad_hud.y = 15;
    level.springpad_hud.x = 2;
    level.springpad_hud.fontscale = 1.1;
    level.springpad_hud.alignx = "left";
    level.springpad_hud.horzalign = "user_left";
    level.springpad_hud.vertalign = "user_top";
    level.springpad_hud.aligny = "top";
    level.springpad_hud setvalue( 0 );
	level.subwoofer_hud.hidewheninmenu = 1;
    level.subwoofer_hud = createserverfontstring( "objective", 1.3 );
    level.subwoofer_hud.y = 10;
    level.subwoofer_hud.x = 2;
    level.subwoofer_hud.fontscale = 1.1;
    level.subwoofer_hud.alignx = "left";
    level.subwoofer_hud.horzalign = "user_left";
    level.subwoofer_hud.vertalign = "user_top";
    level.subwoofer_hud.aligny = "top";
    level.subwoofer_hud setvalue( 0 );
	level.turbine_hud.hidewheninmenu = 1;
    level.turbine_hud = createserverfontstring( "objective", 1.3 );
    level.turbine_hud.y = 20;
    level.turbine_hud.x = 2;
    level.turbine_hud.fontscale = 1.1;
    level.turbine_hud.alignx = "left";
    level.turbine_hud.horzalign = "user_left";
    level.turbine_hud.vertalign = "user_top";
    level.turbine_hud.aligny = "top";
    level.turbine_hud setvalue( 0 );
    level.turbine_hud.alpha = 0;
    level.subwoofer_hud.alpha = 0;
    level.springpad_hud.alpha = 0;
	level.springpad_hud.label = &"^3SPRINGPADS: ^4";
	level.subwoofer_hud.label = &"^3RESONATORS: ^4";
	level.turbine_hud.label = &"^3TURBINES: ^4";

    if (isdierise())
    {
        level.subwoofer_hud destroy();
        level.turbine_hud destroy();
    }
}

buildable_controller()
{
    level endon("end_game");

    buildable_hud();
    level.buildable_stats = array();
    level.buildable_stats["springpad_zm"] = 0;
    level.buildable_stats["turbine"] = 0;
    level.buildable_stats["subwoofer_zm"] = 0;
	wait 1;

    // Por alguna razón se vuelven a asignar incorrectamente
	if(level.buildable_stats["springpad_zm"] > 0)
		level.buildable_stats["springpad_zm"] = 0;
	if(level.buildable_stats["turbine"] > 0)
		level.buildable_stats["turbine"] = 0;
	if(level.buildable_stats["subwoofer_zm"] > 0)
		level.buildable_stats["subwoofer_zm"] = 0;


    if(isburied())
        while (true)
        {
            level.subwoofer_hud setvalue( level.buildable_stats["subwoofer_zm"] );
            level.turbine_hud setvalue( level.buildable_stats["turbine"] );
            level.springpad_hud setvalue( level.buildable_stats["springpad_zm"] );
            wait 0.1;
        }
    else
        while (true)
        {
            level.springpad_hud setvalue( level.buildable_stats["springpad_zm"] );
            wait 0.1;
        }
}

// Personajes
set_character_option()
{
    if(istranzit())
    {
        self.favorite_wall_weapons_list = [];
        self.talks_in_danger = 0;
        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_player_farmgirl_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_farmgirl_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
                self set_player_is_female( 1 );
            break;
            case 2:
                self setmodel( "c_zom_player_oldman_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_oldman_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "frag_grenade_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "claymore_zm";
                self set_player_is_female( 0 );
            break;
            case 3:
                self setmodel( "c_zom_player_reporter_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_reporter_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.talks_in_danger = 1;
                level.rich_sq_player = self;
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "beretta93r_zm";
                self set_player_is_female( 0 );
            break;
            case 4:
                self setmodel( "c_zom_player_engineer_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_engineer_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m14_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m16_zm";
                self set_player_is_female( 0 );
            break;
        }
    }
    if(isnuketown())
    {
        self detachall();
        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel("c_zom_player_cdc_fb");
                self setviewmodel("c_zom_suit_viewhands");
                self.voice = "american";
                self.skeleton = "base";
                self set_player_is_female( 0 );
            break;
            case 2:
                self setmodel("c_zom_player_cdc_fb");
                self setviewmodel("c_zom_suit_viewhands");
                self.voice = "american";
                self.skeleton = "base";
                self set_player_is_female( 0 );
            break;
        }
    }
    if(isdierise())
    {
        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_player_farmgirl_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_farmgirl_dlc1_fb";
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_farmgirl_viewhands" );
                level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
                self set_player_is_female( 1 );
                self.characterindex = 2;
            break;
            case 2:
                self setmodel( "c_zom_player_oldman_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_oldman_dlc1_fb";
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_oldman_viewhands" );
                level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "frag_grenade_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "claymore_zm";
                self set_player_is_female( 0 );
                self.characterindex = 0;
            break;
            case 3:
                self setmodel( "c_zom_player_reporter_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_reporter_dlc1_fb";
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_reporter_viewhands" );
                level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "beretta93r_zm";
                self.talks_in_danger = 1;
                level.rich_sq_player = self;
                self set_player_is_female( 0 );
                self.characterindex = 1;
            break;
            case 4:
                self setmodel( "c_zom_player_engineer_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_engineer_dlc1_fb";
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_engineer_viewhands" );
                level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m14_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m16_zm";
                self set_player_is_female( 0 );
                self.characterindex = 3;
            break;
        }
    }
    if(ismob())
    {
        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_player_arlington_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_arlington_coat_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "ray_gun_zm";
                self set_player_is_female( 0 );
                self.character_name = "Arlington";
            break;
            case 2:
                self setmodel( "c_zom_player_oleary_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_oleary_shortsleeve_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "judge_zm";
                self set_player_is_female( 0 );
                self.character_name = "Finn";
            break;
            case 3:
                self setmodel( "c_zom_player_deluca_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_deluca_longsleeve_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "thompson_zm";
                self set_player_is_female( 0 );
                self.character_name = "Sal";
            break;
            case 4:
                self setmodel( "c_zom_player_handsome_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_handsome_sleeveless_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
                self set_player_is_female( 0 );
                self.character_name = "Billy";
            break;
            case 5:
                self setmodel( "c_zom_player_handsome_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_ghost_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
                self set_player_is_female( 0 );
                self.character_name = "Billy";
            break;
        }
    }
    if(isburied())
    {
        switch( getDvarInt("character") )
        {
        case 1:
            self setmodel( "c_zom_player_farmgirl_fb" );
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
            self set_player_is_female( 1 );
            self.characterindex = 2;
            break;
        case 2:
            self setmodel( "c_zom_player_oldman_fb" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_oldman_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "frag_grenade_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "claymore_zm";
            self set_player_is_female( 0 );
            self.characterindex = 0;
            break;
        case 3:
            self setmodel( "c_zom_player_reporter_fb" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_reporter_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "beretta93r_zm";
            self.talks_in_danger = 1;
            level.rich_sq_player = self;
            self set_player_is_female( 0 );
            self.characterindex = 1;
            break;
        case 4:
            self setmodel( "c_zom_player_engineer_fb" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_engineer_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m14_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m16_zm";
            self set_player_is_female( 0 );
            self.characterindex = 3;
            break;
        }
    }
    if(isorigins())
    {
        self detachall();

        if ( !isdefined( self.characterindex ) )
            self.characterindex = assign_lowest_unused_character_index();

        self.favorite_wall_weapons_list = [];
        self.talks_in_danger = 0;

        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_tomb_richtofen_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_richtofen_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Richtofen";
            break;
            case 2:
                self setmodel( "c_zom_tomb_dempsey_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_dempsey_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Dempsey";
            break;
            case 3:
                self setmodel( "c_zom_tomb_nikolai_fb" );
                self.voice = "russian";
                self.skeleton = "base";
                self setviewmodel( "c_zom_nikolai_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Nikolai";
            break;
            case 4:
                self setmodel( "c_zom_tomb_takeo_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_takeo_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Takeo";
            break;
        }
    }

    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

set_exert_id()
{
	self endon("disconnect");
	wait_network_frame();
	self maps\mp\zombies\_zm_audio::setexertvoice(self.characterindex);
}

zmbvoxinitspeaker( speaker, prefix, ent )
{
    ent.zmbvoxid = speaker;

    if ( !isdefined( self.speaker[speaker] ) )
    {
        self.speaker[speaker] = spawnstruct();
        self.speaker[speaker].alias = [];
    }

    self.speaker[speaker].prefix = prefix;
    self.speaker[speaker].ent = ent;
}

assign_lowest_unused_character_index()
{
    charindexarray = [];
    charindexarray[0] = 0;
    charindexarray[1] = 1;
    charindexarray[2] = 2;
    charindexarray[3] = 3;
    players = get_players();

    if ( players.size == 1 )
    {
        charindexarray = array_randomize( charindexarray );

        if (charindexarray[0] == 2)
            level.has_richtofen = 1;

        return charindexarray[0];
    }
    else
    {
        n_characters_defined = 0;

        foreach (player in players)
        {
            if ( isdefined( player.characterindex ) )
            {
                arrayremovevalue( charindexarray, player.characterindex, 0 );
                n_characters_defined++;
            }
        }

        if (charindexarray.size > 0)
        {
            if ( n_characters_defined == players.size - 1 )
                if ( !( isdefined( level.has_richtofen ) && level.has_richtofen ) )
                {
                    level.has_richtofen = 1;
                    return 2;
                }

            charindexarray = array_randomize( charindexarray );

            if ( charindexarray[0] == 2 )
                level.has_richtofen = 1;

            return charindexarray[0];
        }
    }
    return 0;
}

//Trackers

/*
leapertracker()
{
	self endon("disconnect");
    self thread trackerswatcher();

	self.lastleaperround = newclienthudelem(self);
	self.lastleaperround.alignx = "left";
	self.lastleaperround.horzalign = "user_left";
	self.lastleaperround.vertalign = "user_top";
	self.lastleaperround.aligny = "top";
	self.lastleaperround.x = 7;
	self.lastleaperround.y = 370;
	self.lastleaperround.fontscale = 1.1;
	self.lastleaperround.sort = 1;
	self.lastleaperround.color = (1, 1 ,1);
	self.lastleaperround.hidewheninmenu = 1;
	self.lastleaperround.label = &"^3Last leaper round: ^4";
	self.lastleaperround setValue(0);
	while(true)
	{
		level waittill("start_of_round");
		if(flag("leaper_round"))
		self.lastleaperround setvalue(level.round_number);
	}
}

PanzerTracker()
{
	self endon("disconnect");

    self thread trackerswatcher();
	self.lastPanzerRound = newclienthudelem(self);
	self.lastPanzerRound.alignx = "left";
	self.lastPanzerRound.horzalign = "user_left";
	self.lastPanzerRound.vertalign = "user_top";
	self.lastPanzerRound.aligny = "top";
	self.lastPanzerRound.x = 7;
	self.lastPanzerRound.y = 310;
	self.lastPanzerRound.fontscale = 1.1;
	self.lastPanzerRound.sort = 1;
	self.lastPanzerRound.color = (1, 1 ,1);
	self.lastPanzerRound.hidewheninmenu = 1;
	self.lastPanzerRound.label = &"^3Last panzer round: ^4";
	self.lastPanzerRound setValue(0);
	while(true)
	{
		level waittill( "spawn_mechz" );
		self.lastPanzerRound setvalue(level.round_number);
	}
}

TemplarTracker()
{
	self endon("disconnect");

    self thread trackerswatcher();
	self.lastTemplarRound = newclienthudelem(self);
	self.lastTemplarRound.alignx = "left";
	self.lastTemplarRound.horzalign = "user_left";
	self.lastTemplarRound.vertalign = "user_top";
	self.lastTemplarRound.aligny = "top";
	self.lastTemplarRound.x = 7;
	self.lastTemplarRound.y = 300;
	self.lastTemplarRound.fontscale = 1.1;
	self.lastTemplarRound.sort = 1;
	self.lastTemplarRound.color = (1, 1 ,1);
	self.lastTemplarRound.hidewheninmenu = 1;
	self.lastTemplarRound.label = &"^3Last templar round: ^4";
	self.lastTemplarRound setValue(0);
	while(true)
	{
		level waittill( "generator_under_attack" );
		self.lastTemplarRound setvalue(level.round_number);
	}
}

trackerswatcher()
{
    while(true)
    {
        if(getDvarInt("tracker"))
        {
            //self.lastBrutusRound.alpha = 1;
	        self.lastTemplarRound.alpha = 1;
	        self.lastPanzerRound.alpha = 1;
	        self.lastleaperround.alpha = 1;
        }
        else
        {
            //self.lastBrutusRound.alpha = 0;
	        self.lastTemplarRound.alpha = 0;
	        self.lastPanzerRound.alpha = 0;
	        self.lastleaperround.alpha = 0;
        }
        wait 0.1;
    }
}

*/
/*
BrutusTracker()
{
	self endon("disconnect");
    self thread trackerswatcher();

	self.lastBrutusRound = newclienthudelem(self);
	self.lastBrutusRound.alignx = "left";
	self.lastBrutusRound.horzalign = "user_left";
	self.lastBrutusRound.vertalign = "user_top";
	self.lastBrutusRound.aligny = "top";
	self.lastBrutusRound.x = 7;
	self.lastBrutusRound.y = 365;
	self.lastBrutusRound.fontscale = 1.1;
	self.lastBrutusRound.sort = 1;
	self.lastBrutusRound.color = (1, 1 ,1);
	self.lastBrutusRound.hidewheninmenu = 1;
	self.lastBrutusRound.label = &"^3Last brutus round: ^4";
	self.lastBrutusRound setValue(0);
	while(true)
	{
		level waittill( "brutus_spawned");
		self.lastBrutusRound setvalue(level.round_number);
        wait 1;
	}
}
*/

//MOB
setup_master_key_override()
{
	wait 1;
    switch(getDvarInt("box"))
    {
        case 1:
            level.is_master_key_west = 0;
            setclientfield( "fake_master_key", level.is_master_key_west + 1 );
            exploder( 100 );
            level thread key_pulley( "east" );
            array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
            break;
        case 2:
            level.is_master_key_west = 1;
            setclientfield( "fake_master_key", level.is_master_key_west + 1 );
            level thread key_pulley( "west" );
            exploder( 101 );
            array_delete( getentarray( "wires_pulley_east", "script_noteworthy" ) );
            break;
        default:
            level.is_master_key_west = 0;
            setclientfield( "fake_master_key", level.is_master_key_west + 1 );
            exploder( 100 );
            level thread key_pulley( "east" );
            array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
            break;
    }
}

givetomahawk()
{
	while(true)
	{
		while(level.round_number <= 50)
			wait 10;
		if(self.origin[0] < 400 && self.origin[0] > 350 && self.origin[1] > 10200 && self.origin[1] < 10292 && self.origin[2] > 1370)
            self thread give_tomahawk();

		wait 0.1;
	}
}

give_tomahawk()
{
    self play_sound_on_ent( "purchase" );
    self notify( "tomahawk_picked_up" );
    level notify( "bouncing_tomahawk_zm_aquired" );
    self notify( "player_obtained_tomahawk" );
    self.tomahawk_upgrade_kills = 99;
    self.killed_with_only_tomahawk = 1;
    self.killed_something_thq = 1;
    self notify( "tomahawk_upgraded_swap" );
    self set_player_tactical_grenade( "upgraded_tomahawk_zm" );
    self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
    gun = self getcurrentweapon();
    self disable_player_move_states( 1 );
    self giveweapon( "zombie_tomahawk_flourish" );
    self switchtoweapon( "zombie_tomahawk_flourish" );
    self waittill_any( "player_downed", "weapon_change_complete" );
    self switchtoweapon( gun );
    self enable_player_move_states();
    self takeweapon( "zombie_tomahawk_flourish" );
    self giveweapon( "upgraded_tomahawk_zm" );
    self givemaxammo( "upgraded_tomahawk_zm" );
    primaryweapons = self getweaponslistprimaries();
    if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
    {
        self switchtoweapon( primaryweapons[ 0] );
        self waittill( "weapon_change_complete" );
    }
}

key_pulley( str_master_key_location )
{
    if ( level.is_master_key_west )
    {
        t_other_hurt_trigger = getent( "pulley_hurt_trigger_east", "targetname" );
        t_other_panel = getent( "master_key_pulley_east", "targetname" );
    }
    else
    {
        t_other_hurt_trigger = getent( "pulley_hurt_trigger_west", "targetname" );
        t_other_panel = getent( "master_key_pulley_west", "targetname" );
    }

    t_other_hurt_trigger delete();
    t_other_panel setmodel( "p6_zm_al_power_station_panels_03" );
    t_pulley_hurt_trigger = getent( "pulley_hurt_trigger_" + str_master_key_location, "targetname" );
    //t_pulley_hurt_trigger = ::sndhitelectrifiedpulley( str_master_key_location );
    m_master_key_pulley = getent( "master_key_pulley_" + str_master_key_location, "targetname" );
    m_master_key_pulley play_fx( "fx_alcatraz_panel_on_2", m_master_key_pulley.origin, m_master_key_pulley.angles, "power_down", 1, undefined, undefined );
    m_master_key_pulley thread afterlife_interact_object_think();

    level waittill( "master_key_pulley_" + str_master_key_location );

    m_master_key_pulley playsound( "zmb_quest_generator_panel_spark" );
    m_master_key_pulley notify( "power_down" );
    m_master_key_pulley setmodel( "p6_zm_al_power_station_panels_03" );
    playfxontag( level._effect["fx_alcatraz_panel_ol"], m_master_key_pulley, "tag_origin" );
    m_master_key_pulley play_fx( "fx_alcatraz_panel_off_2", m_master_key_pulley.origin, m_master_key_pulley.angles, "power_down", 1, undefined, undefined );

    if ( level.is_master_key_west )
    {
        stop_exploder( 101 );
        array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
    }
    else
    {
        stop_exploder( 100 );
        array_delete( getentarray( "wires_pulley_east", "script_noteworthy" ) );
    }

    t_hurt_trigger = getent( "pulley_hurt_trigger_" + str_master_key_location, "targetname" );
    t_hurt_trigger delete();

    if ( str_master_key_location == "west" )
        level setclientfield( "fxanim_pulley_down_start", 1 );
    else if ( str_master_key_location == "east" )
        level setclientfield( "fxanim_pulley_down_start", 2 );

    wait 3;
    level setclientfield( "master_key_is_lowered", 1 );
    m_master_key = get_craftable_piece_model( "quest_key1", "p6_zm_al_key" );

    if ( isdefined( m_master_key ) )
    {
        e_master_key_target = getstruct( "master_key_" + str_master_key_location + "_origin", "targetname" );
        m_master_key.origin = e_master_key_target.origin;
        m_master_key setvisibletoall();
    }
}

trap_timer()
{
	self endon( "disconnect" );

	self.trap_timer = newclienthudelem( self );
	self.trap_timer.alignx = "right";
	self.trap_timer.aligny = "top";
	self.trap_timer.horzalign = "user_right";
	self.trap_timer.vertalign = "user_top";
	self.trap_timer.x = -2;
	self.trap_timer.y = 14;
	self.trap_timer.fontscale = 1.4;
	self.trap_timer.hidewheninmenu = 1;
	self.trap_timer.hidden = 0;
	self.trap_timer.label = &"";
	self.trap_timerx.alpha = 1;

	while(true)
	{
		if(getDvarInt("traptimer"))
		{
			level waittill( "trap_activated" );
			if( level.trap_activated )
			{
				wait 0.1;
				self.trap_timer.color = ( 0, 1, 0 );
				self.trap_timer.alpha = 1;
				self.trap_timer settimer( 25 );
				wait 25;
				self.trap_timer settimer( 25 );
				self.trap_timer.color = ( 1, 0, 0 );
				wait 25;
				self.trap_timer.alpha = 0;
			}
		}
		wait 0.1;	
	}
}

//Nuketown
checkpaplocation()
{
	if(getDvarInt("perkrng") == 1)
		return;
	wait 1;
	if(level.players.size > 1)
	wait 4;
	pap = getent( "specialty_weapupgrade", "script_noteworthy" );
	jug = getent( "vending_jugg", "targetname" );
	if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
		level.players[0] notify ("menuresponse", "", "restart_level_zm");
}

checkpap()
{
    if(getDvarInt("perkrng") != 0)
        return;
    wait 3;
	pap = getent( "specialty_weapupgrade", "script_noteworthy" );
	switch(getDvar("language"))
	{
		case "spanish":
			if(pap.origin[0] < -2000) self iprintln("El PAP está al fondo de las casa azul");
			else if(pap.origin[0] < -1600) self iprintln("El PAP está al lado del bunker");
			else if(pap.origin[0] > 2030) self iprintln("El PAP está al fondo de las casa amarilla");
			else if(pap.origin[0] > 1600) self iprintln("El PAP está en la caja de arena");
			else if(pap.origin[0] > 1300) self iprintln("El PAP está en la barbacoa");
			else if(pap.origin[0] > 700) self iprintln("El PAP está en el 2º piso de la casa amarilla");
			else self iprintln("El PAP está en el medio");
		break;
		default:
			if(pap.origin[0] < -2000) self iprintln("PAP is at the end of green house's garden");
			else if(pap.origin[0] < -1600) self iprintln("PAP is next to the bunker");
			else if(pap.origin[0] > 2030) self iprintln("PAP is at the end of yellow house's garden");
			else if(pap.origin[0] > 1600) self iprintln("PAP is at sandbox");
			else if(pap.origin[0] > 1300) self iprintln("PAP is at barbecue");
			else if(pap.origin[0] > 700) self iprintln("PAP is at yellow house's seconde floor");
			else self iprintln("PAP is at middle of the map");
		break;
	}
}

sndhitelectrifiedpulley( str_master_key_location )
{
    self endon( "master_key_pulley_" + str_master_key_location );

    while ( true )
    {
        self waittill( "trigger", e_triggerer );

        self playsound( "fly_elec_sparks_key" );
        wait 1;
    }
}

afterlife_interact_object_think()
{
    self endon( "afterlife_interact_complete" );

    if ( isdefined( self.script_int ) && self.script_int > 0 )
        n_total_interact_count = self.script_int;
    else if ( !isdefined( self.script_int ) || isdefined( self.script_int ) && self.script_int <= 0 )
        n_total_interact_count = 0;

    n_count = 0;
    self.health = 5000;
    self setcandamage( 1 );
    self useanimtree( "animtree" );
    self playloopsound( "zmb_afterlife_shockbox_off", 1 );
    trig_spawn_offset = ( 0, 0, 0 );

    if ( self.model != "p6_anim_zm_al_nixie_tubes" )
    {
        if ( isdefined( self.script_string ) && self.script_string == "intro_powerup_activate" )
            self.t_bump = spawn( "trigger_radius", self.origin + vectorscale( ( 0, 1, 0 ), 28.0 ), 0, 28, 64 );
        else
        {
            if ( issubstr( self.model, "p6_zm_al_shock_box" ) )
            {
                trig_spawn_offset = ( 0, 11, 46 );
                str_hint = &"ZM_PRISON_AFTERLIFE_INTERACT";
            }
            else if ( issubstr( self.model, "p6_zm_al_power_station_panels" ) )
            {
                trig_spawn_offset = ( 32, 35, 58 );
                str_hint = &"ZM_PRISON_AFTERLIFE_OVERLOAD";
            }

            afterlife_interact_hint_trigger_create( self, trig_spawn_offset, str_hint );
        }
    }

    while ( true )
    {
        if ( isdefined( self.unitrigger_stub ) )
            self.unitrigger_stub.is_activated_in_afterlife = 0;
        else if ( isdefined( self.t_bump ) )
        {
            self.t_bump setcursorhint( "HINT_NOICON" );
            self.t_bump sethintstring( &"ZM_PRISON_AFTERLIFE_INTERACT" );
        }

        self waittill( "damage", amount, attacker );

        if ( attacker == level || isplayer( attacker ) && attacker getcurrentweapon() == "lightning_hands_zm" )
        {
            if ( isdefined( self.script_string ) )
            {
                if ( isdefined( level.afterlife_interact_dist ) )
                {
                    if ( attacker == level || distancesquared( attacker.origin, self.origin ) < level.afterlife_interact_dist * level.afterlife_interact_dist )
                    {
                        level notify( self.script_string );

                        if ( isdefined( self.unitrigger_stub ) )
                        {
                            self.unitrigger_stub.is_activated_in_afterlife = 1;
                            self.unitrigger_stub maps\mp\zombies\_zm_unitrigger::run_visibility_function_for_all_triggers();
                        }
                        else if ( isdefined( self.t_bump ) )
                            self.t_bump sethintstring( "" );

                        self playloopsound( "zmb_afterlife_shockbox_on", 1 );

                        if ( self.model == "p6_zm_al_shock_box_off" )
                        {
                            if ( !isdefined( self.playing_fx ) )
                            {
                                playfxontag( level._effect["box_activated"], self, "tag_origin" );
                                self.playing_fx = 1;
                                self thread afterlife_interact_object_fx_cooldown();
                                self playsound( "zmb_powerpanel_activate" );
                            }

                            self setmodel( "p6_zm_al_shock_box_on" );
                            self setanim( level.shockbox_anim["on"] );
                        }

                        n_count++;

                        if ( n_total_interact_count <= 0 || n_count < n_total_interact_count )
                        {
                            self waittill( "afterlife_interact_reset" );

                            self playloopsound( "zmb_afterlife_shockbox_off", 1 );

                            if ( self.model == "p6_zm_al_shock_box_on" )
                            {
                                self setmodel( "p6_zm_al_shock_box_off" );
                                self setanim( level.shockbox_anim["off"] );
                            }

                            if ( isdefined( self.unitrigger_stub ) )
                            {
                                self.unitrigger_stub.is_activated_in_afterlife = 0;
                                self.unitrigger_stub maps\mp\zombies\_zm_unitrigger::run_visibility_function_for_all_triggers();
                            }
                        }
                        else
                        {
                            if ( isdefined( self.t_bump ) )
                                self.t_bump delete();

                            break;
                        }
                    }
                }
            }
        }
    }
}

play_fx( str_fx, v_origin, v_angles, time_to_delete_or_notify, b_link_to_self, str_tag, b_no_cull )
{
    if(isdefined(time_to_delete_or_notify))
    {
        if(time_to_delete_or_notify == -1)
        {
            if(isdefined(b_link_to_self))
            {
                if(b_link_to_self)
                {
                    if(isdefined(str_tag))
                    {
                        playfxontag( getfx( str_fx ), self, str_tag );
                        return self;
                    }
                }
            }
        }
    }
    else if(!isstring( time_to_delete_or_notify ))
    {
        if(time_to_delete_or_notify == -1)
        {
            if(isdefined(b_link_to_self))
            {
                if(b_link_to_self)
                {
                    if(isdefined(str_tag))
                    {
                        playfxontag( getfx( str_fx ), self, str_tag );
                        return self;
                    }
                }
            }
        }
    }
    else
    {
        m_fx = spawn_model( "tag_origin", v_origin, v_angles );

        if ( isdefined( b_link_to_self ) && b_link_to_self )
        {
            if ( isdefined( str_tag ) )
                m_fx linkto( self, str_tag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
            else
                m_fx linkto( self );
        }

        if ( isdefined( b_no_cull ) && b_no_cull )
            m_fx setforcenocull();

        playfxontag( getfx( str_fx ), m_fx, "tag_origin" );
        m_fx thread _play_fx_delete( self, time_to_delete_or_notify );
        return m_fx;
    }
}

afterlife_interact_hint_trigger_create( m_interact, v_trig_offset, str_hint )
{
    m_interact.unitrigger_stub = spawnstruct();
    m_interact.unitrigger_stub.origin = m_interact.origin + anglestoforward( m_interact.angles ) * v_trig_offset[0] + anglestoright( m_interact.angles ) * v_trig_offset[1] + anglestoup( m_interact.angles ) * v_trig_offset[2];
    m_interact.unitrigger_stub.radius = 40;
    m_interact.unitrigger_stub.height = 64;
    m_interact.unitrigger_stub.script_unitrigger_type = "unitrigger_radius_use";
    m_interact.unitrigger_stub.hint_string = str_hint;
    m_interact.unitrigger_stub.cursor_hint = "HINT_NOICON";
    m_interact.unitrigger_stub.require_look_at = 1;
    m_interact.unitrigger_stub.ignore_player_valid = 1;
    m_interact.unitrigger_stub.prompt_and_visibility_func = ::afterlife_trigger_visible_in_afterlife;
    maps\mp\zombies\_zm_unitrigger::register_static_unitrigger( m_interact.unitrigger_stub, ::afterlife_interact_hint_trigger_think );
}
afterlife_interact_hint_trigger_think()
{
    self endon( "kill_trigger" );

    while ( true )
    {
        self waittill( "trigger" );

        wait 1000;
    }
}

afterlife_trigger_visible_in_afterlife( player )
{
    b_is_invis = false;
    if(isdefined(self.stub.is_activated_in_afterlife))
    {
        if(self.stub.is_activated_in_afterlife)
        {
            b_is_invis = true;
        }
    }
    self setinvisibletoplayer( player, b_is_invis );
    self sethintstring( self.stub.hint_string );

    if ( !b_is_invis )
    {
        if ( player is_player_looking_at( self.origin, 0.25 ) )
        {
            if ( cointoss() )
                player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "need_electricity" );
            else
                player thread maps\mp\zombies\_zm_audio::create_and_play_dialog( "general", "electric_zap" );
        }
    }

    return !b_is_invis;
}

get_craftable_piece_model( str_craftable, str_piece )
{
    foreach ( uts_craftable in level.a_uts_craftables )
    {
        if ( uts_craftable.craftablestub.name == str_craftable )
        {
            foreach ( piecespawn in uts_craftable.craftablespawn.a_piecespawns )
            {
                if ( piecespawn.piecename == str_piece && isdefined( piecespawn.model ) )
                    return piecespawn.model;
            }

            break;
        }
    }

    return undefined;
}

afterlife_interact_object_fx_cooldown()
{
    wait 2;
    self.playing_fx = undefined;
}

_play_fx_delete( ent, time_to_delete_or_notify)
{
    if(!isdefined(time_to_delete_or_notify))
        time_to_delete_or_notify = -1;

    if ( isstring( time_to_delete_or_notify ) )
        ent waittill_either( "death", time_to_delete_or_notify );
    else if ( time_to_delete_or_notify > 0 )
        ent waittill_notify_or_timeout( "death", time_to_delete_or_notify );
    else
        ent waittill( "death" );

    if ( isdefined( self ) )
        self delete();
}

spawn_model( model_name, origin, angles,n_spawnflags)
{
    n_spawnflags = 0;
    origin = ( 0, 0, 0 );
    model = spawn( "script_model", origin, n_spawnflags );
    model setmodel( model_name );

    if ( isdefined( angles ) )
        model.angles = angles;

    return model;
}

setFragaLanguage()
{
    switch(getDvar("language"))
    {
        case "spanish":
            level.boxhits.label = &"^3Tiradas de caja: ^4";
            level.cheats.label = &"^1^FCheats activados";
            level.firstbox_active.label = &"^2^FFirstbox activado";
            if(isorigins() || isburied() || isnuketown() && !level.debug) level.perkrng_desabled.label = &"^4^FPerk RNG manipulada";
            if(isorigins() && !level.debug) level.templar_modiffied.label = &"^6^FTemplarios manipulados";
            if(isdefined(self.lastBrutusRound)) self.lastBrutusRound.label = &"^3Última ronda de brutus: ^4";
            if(isdefined(self.lastTemplarRound)) self.lastTemplarRound.label = &"^3Última ronda de templarios: ^4";
            if(isdefined(self.lastPanzerRound)) self.lastPanzerRound.label = &"^3Última ronda de panzer: ^4";
            if(isdefined(self.lastleaperround)) self.lastleaperround.label = &"^3Última ronda de novas: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud)) level.springpad_hud.label = &"^3TRAMPOLINES: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3TRAMPOLINES: ^4";
                level.subwoofer_hud.label = &"^3RESONADORES: ^4";
                level.turbine_hud.label = &"^3TURBINAS: ^4";
            }
            break;
        case "french":
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats actif";
            level.firstbox_active.label = &"^2^FFirstbox actif";
            if(isorigins() || isburied() || isnuketown()) level.perkrng_desabled.label = &"^4^FLa RNG des atouts est manipulé";
            if(isorigins()) level.templar_modiffied.label = &"^6^FTemplier est manipulé";
            if(isdefined(self.lastBrutusRound)) self.lastBrutusRound.label = &"^3Dernière manche de brutus: ^4";
            if(isdefined(self.lastTemplarRound)) self.lastTemplarRound.label = &"^3Dernière manche des templiers: ^4";
            if(isdefined(self.lastPanzerRound)) self.lastPanzerRound.label = &"^3Dernière manche de panzer: ^4";
            if(isdefined(self.lastleaperround)) self.lastleaperround.label = &"^3Dernière manche de leapers: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud)) level.springpad_hud.label = &"^3PROPULSEURS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3PROPULSEURS: ^4";
                level.subwoofer_hud.label = &"^3RÉSONATEUR: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;
        case "japanese":
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats アクティブ";
            level.firstbox_active.label = &"^2^FFirstbox アクティブ";
            if(isorigins() || isburied() || isnuketown() && !level.debug) level.perkrng_desabled.label = &"^4^F特典 RNG 操作された";
            if(isorigins() && !level.debug) level.templar_modiffied.label = &"^6^Fテンプラー 操作された";
            if(isdefined(self.lastBrutusRound)) self.lastBrutusRound.label = &"^3ブルータス最後のラウンド: ^4";
            if(isdefined(self.lastTemplarRound)) self.lastTemplarRound.label = &"^3テンプル騎士団の最後のラウンド: ^4";
            if(isdefined(self.lastPanzerRound)) self.lastPanzerRound.label = &"^3最後の装甲ラウンド: ^4";
            if(isdefined(self.lastleaperround)) self.lastleaperround.label = &"^3最後のリーパーラウンド: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud)) level.springpad_hud.label = &"^3スプリングパッド: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3スプリングパッド: ^4";
                level.subwoofer_hud.label = &"^3レゾネーター: ^4";
                level.turbine_hud.label = &"^3タービン: ^4";
            }
            break;
        default:
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats active";
            level.firstbox_active.label = &"^2^FFirstbox active";
            if(isorigins() || isburied() || isnuketown() && !level.debug) level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
            if(isdefined(self.lastBrutusRound)) self.lastBrutusRound.label = &"^3Last brutus round: ^4";
            if(isdefined(self.lastTemplarRound)) self.lastTemplarRound.label = &"^3Last templar round: ^4";
            if(isdefined(self.lastPanzerRound)) self.lastPanzerRound.label = &"^3Last panzer round: ^4";
            if(isdefined(self.lastleaperround)) self.lastleaperround.label = &"^3Last leaper round: ^4";
            if(isdefined(level.springpad_hud)) level.springpad_hud.label = &"^3SPRINGPADS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3SPRINGPADS: ^4";
                level.subwoofer_hud.label = &"^3RESONATORS: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;
    }
    while(level.round_number < 2)
        wait 0.5;
    level.firstbox_active.label = &"";
    level.perkrng_desabled.label = &"";
}

enablepersperks()
{
    if(!isvictismap())
        return;
	if(level.round_number >= 15)
		return;
    self thread minijug();
    self thread tombstone();
    if(isburied())
    {
        wait 5;
        maps\mp\zombies\_zm::register_player_damage_callback( ::phd );
        self playsound( "evt_player_upgrade" ); wait 0.5;
        self playsound( "evt_player_upgrade" ); wait 0.5;
        self playsound( "evt_player_upgrade" );
    }
    else
    {
        self playsound( "evt_player_upgrade" ); wait 0.5;
        self playsound( "evt_player_upgrade" );
    }
}

minijug()
{
    player_downed = self.downs;
    while(!player_downed || level.round_number <= 15)
    {
        player_downed = self.downs;
        if(!self hasperk("specialty_armorvest"))
            self.maxhealth = 190;
        else
            self.maxhealth = 340;
        wait 0.5;
    }
    self playsoundtoplayer("evt_player_downgrade", self);
}

tombstone()
{
    wait 1;
    while(true)
    {
		self waittill_any("perk_acquired", "perk_lost");
        wait 0.1; // so we dont overwrite them while we're giving them to the player

        if(self.perks_active.size < 1 && isdefined(self.revivetrigger))
        {
            while(isdefined(self.revivetrigger))
                wait 0.1;
            self thread giveplayerdata();
            wait 5;
            continue;
        }
        else if(self.perks_active.size < 1 && self.a_saved_perks.size >= 1)
        {
            wait 2;
            self thread giveplayerdata();
            wait 5;
            continue;
        }
        self thread savePerks();
    }
}

saveperks()
{
    self.a_saved_perks = [];

    if(self hasperk("specialty_additionalprimaryweapon"))
    {
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_additionalprimaryweapon";
        if(!self.savingweapons)
            self thread scanweapons();
    }
    if(self hasperk("specialty_armorvest")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_armorvest";    // JUG
    if(self hasperk("specialty_fastreload")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_fastreload";   // SPEED
    if(self hasperk("specialty_rof")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_rof";          // DT
    if(self hasperk("specialty_finalstand")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_finalstand";   // Who's who
    if(self hasperk("specialty_scavenger")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_scavenger";    // Tomb stone
    if(self hasperk("specialty_nomotionsensor")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_nomotionsensor"; // Vulture
    if(self hasperk("specialty_longersprint")) self.a_saved_perks[self.a_saved_perks.size] = "specialty_longersprint"; // Stam
}

scanweapons()
{
    self.savingweapons = true;
    while(self.savingweapons)
    {
        wait 0.1;
        if(isdefined(self.revivetrigger))
        {
			wait 10;
            self.savingweapons = false;
            return;
        }
        if(self.origin[2] < 0)
        {
            wait 10;
            self.savingweapons = false;
            return;
        }
        self.a_saved_primaries = self getweaponslistprimaries();
        self.a_saved_primaries_weapons = [];
        index = 0;

        foreach ( weapon in self.a_saved_primaries )
        {
            self.a_saved_primaries_weapons[index] = maps\mp\zombies\_zm_weapons::get_player_weapondata( self, weapon );
            index++;
        }
        if(!self hasperk("specialty_additionalprimaryweapon"))
        {
            self.savingweapons = false;
            return;
        }
    }
}

giveplayerdata()
{
    player_has_mule_kick = false;

    foreach(perk in self.a_saved_perks)
    {
        if (perk == "specialty_additionalprimaryweapon")
            player_has_mule_kick = 1;

        self maps\mp\zombies\_zm_perks::give_perk(perk);
        wait 0.5;
    }

    if (player_has_mule_kick)
    {
        a_current_weapons = self getweaponslistprimaries();

        foreach(weapon in self.a_saved_primaries_weapons)
        {
            found = false;

            foreach(weapon2 in a_current_weapons)
            {
                if(weapon2 == weapon["name"])
                {
                    found = true;
                    break;
                }
            }

            if (!found)
            {
                self maps\mp\zombies\_zm_weapons::weapondata_give(weapon);
                self switchtoweapon( a_current_weapons[0] );
                break;
            }
        }
    }
    self.a_saved_perks = undefined;
    self.a_saved_primaries = undefined;
    self.a_saved_primaries_weapons = undefined;
}

phd( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psoffsettime, b_damage_from_underneath, n_model_index, str_part_name )
{
    if( str_means_of_death == "MOD_FALLING" )
    {
        if(self.haspersphd)
        {
            if(isdefined( self.divetoprone ) && self.divetoprone == 1)
            {
                self thread pers_flopper_damage_network_optimized( self.origin, 300, 5000, 1000, "MOD_GRENADE_SPLASH" );
                if( getdvar( "mapname" ) == "zm_buried" || getdvar( "mapname" ) == "zm_tomb" )
                    fx = level._effect[ "divetonuke_groundhit"];
                self playsound( "zmb_phdflop_explo" );
                playfx( fx, self.origin );
                return 0;
            }
            else
            {
                self.haspersphd = false;
                self playsound( "evt_player_downgrade" );
                return 0;
            }
        }
        else
        {
            if(!isdefined(self.damagebyfalling))
                self.damagebyfalling = 0;

            self.damagebyfalling += n_damage;
            if(self.damagebyfalling >= 1000)
            {
                self.damagebyfalling = 0;
                self playsound( "evt_player_upgrade" );
                self.haspersphd = true;
            }
        }
    }
    if ( str_means_of_death == "MOD_PROJECTILE" || str_means_of_death == "MOD_PROJECTILE_SPLASH" || str_means_of_death == "MOD_GRENADE" || str_means_of_death == "MOD_GRENADE_SPLASH" )
    {
        if (self.haspersphd)
            return 0;
    }

    if ( isdefined( self.is_in_fountain_transport_trigger ) && self.is_in_fountain_transport_trigger && str_means_of_death == "MOD_FALLING" )
        return 0;

    return n_damage;
}

pers_flopper_damage_network_optimized( origin, radius, max_damage, min_damage, damage_mod )
{
    self endon( "disconnect" );
    a_zombies = get_array_of_closest( origin, get_round_enemy_array(), undefined, undefined, radius );
    network_stall_counter = 0;

    if ( isdefined( a_zombies ) )
    {
        for ( i = 0; i < a_zombies.size; i++ )
        {
            e_zombie = a_zombies[i];

            if ( !isdefined( e_zombie ) || !isalive( e_zombie ) )
                continue;

            dist = distance( e_zombie.origin, origin );
            damage = min_damage + ( max_damage - min_damage ) * ( 1.0 - dist / radius );
            e_zombie dodamage( damage, e_zombie.origin, self, self, 0, damage_mod );
            network_stall_counter--;

            if ( network_stall_counter <= 0 )
            {
                wait_network_frame();
                network_stall_counter = randomintrange( 1, 3 );
            }
        }
    }
}

roundcounter()
{
	round = 0;
	level.roundcounter setvalue(round);
	level.roundcounter.hidewheninmenu = 1;
    level.roundcounter = createserverfontstring( "objective", 1.3 );
    level.roundcounter.y = -5;
    level.roundcounter.x = 70;
    level.roundcounter.fontscale = 10;
    level.roundcounter.alignx = "left";
    level.roundcounter.horzalign = "user_left";
    level.roundcounter.vertalign = "user_bottom";
    level.roundcounter.aligny = "bottom";
    level.roundcounter.alpha = 0;
    level.roundcounter.color = (0.27, 0, 0);
	while(true)
	{
		level waittill("start_of_round");
		round++;
    	level.roundcounter setvalue(round);
		if(round >= 255)
    	level.roundcounter.alpha = 1;
	}
}

isancient()
{
    if(getDvar("name") == "")
        return false;
    return true;
}


basegame_network_frame()
{
    if (level.players.size == 1)
        wait 0.1;
    else if (numremoteclients())
    {
        snapshot_ids = getsnapshotindexarray();

        for (acked = undefined; !isdefined(acked); acked = snapshotacknowledged(snapshot_ids))
            level waittill("snapacknowledged");
    }
    else
        wait 0.1;
}

//Cheating
firstboxActivated()
{
	level.firstbox_active.hidewheninmenu = 1;
    level.firstbox_active = createserverfontstring( "objective", 1.3 );
    level.firstbox_active.y = -20;
    level.firstbox_active.x = 0;
    level.firstbox_active.fontscale = 1;
    level.firstbox_active.alignx = "center";
    level.firstbox_active.horzalign = "user_center";
    level.firstbox_active.vertalign = "user_bottom";
    level.firstbox_active.aligny = "bottom";
    level.firstbox_active.label = &"^2^FFirstbox active";
    level.firstbox_active.alpha = 0;
    if(getDvarInt("firstbox"))
    while(level.round_number < 2)
    {
        level.firstbox_active.alpha = 1;
        wait 0.1;
    }
    level.firstbox_active destroy();
}

perkrng()
{
	level.perkrng_desabled.hidewheninmenu = 1;
    level.perkrng_desabled = createserverfontstring( "objective", 1.3 );
    level.perkrng_desabled.y = -30;
    level.perkrng_desabled.x = 0;
    level.perkrng_desabled.fontscale = 1;
    level.perkrng_desabled.alignx = "center";
    level.perkrng_desabled.horzalign = "user_center";
    level.perkrng_desabled.vertalign = "user_bottom";
    level.perkrng_desabled.aligny = "bottom";
    level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
    if(isburied() || isorigins())
    {
        if(!getDvarInt("perkRNG"))
        while(level.round_number < 2)
        {
            level.perkrng_desabled.alpha = 1;
            wait 0.1;
        }
    }
    level.perkrng_desabled destroy();
}

cheatsActivated()
{
	level.cheats.hidewheninmenu = 1;
    level.cheats = createserverfontstring( "objective", 1.3 );
    level.cheats.y = 20;
    level.cheats.x = 0;
    level.cheats.fontscale = 3;
    level.cheats.alignx = "center";
    level.cheats.horzalign = "user_center";
    level.cheats.vertalign = "user_top";
    level.cheats.aligny = "top";
    level.cheats.alpha = 0;

    while(true)
    {
        level.cheats.alpha = getDvarInt("sv_cheats");
        wait 0.1;
    }
}