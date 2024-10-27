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
	thread setdvars();
	thread fix_highround();
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;
    if(issurvivalmap() && !isdefined(level.chest_accessed_since_ray))
        level.chest_accessed_since_ray = 0;

    level thread firstbox();
	level thread boxhits();
    level thread roundcounter();
	thread buried_init();
	thread dierise_init();
	thread origins_init();
	thread mob_init();
	thread tranzit_init();
    thread nuketown_init();
    level.st = false;
    if(getDvarInt("st"))
        thread st_init();
    while(true)
    {
        level waittill("connecting", player);
        player thread fraga_connected();
        if(!level.onlinegame)
            player thread enablepersperks();
        player thread cheatDetectionRedacted();
    }
}

fraga_connected()
{
	self endon("disconnect");
	self waittill("spawned_player");
	self thread timer();
	self thread timerlocation();
    self thread setFragaLanguage();
    self thread fixrotationangle();
    if(isancient())
    {
        if(!level.onlinegame)
            self iprintln("^6Fraga^5V15  ^3Active ^4[Ancient, Local mode]");
        else
            self iprintln("^6Fraga^5V15  ^3Active ^4[Ancient]");
    }
    else
    {
        if(!level.onlinegame)
            self iprintln("^6Fraga^5V14  ^3Active ^4[Redacted, Local mode]");
        else
            self iprintln("^6Fraga^5V14  ^3Active ^4[Redacted]");
    }
    if(getDvar("language") == "french")
        self iprintln("^1Spanish ^3Ruleset  ^1Active");
}

origins_init()
{
	if(level.script != "zm_tomb")
		return;
	level thread origins_connected();	
	level thread boxlocation();
}

origins_connected()
{
	while(1)
	{
		level waittill("connecting", player);
        player thread PanzerTracker();
        player thread TemplarTracker();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_origins;
	}
}

/* Buried */

buried_init()
{
	if(level.script != "zm_buried")
		return;
    level thread connected_buried();
	level thread buildable_controller();
}

connected_buried()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread onconnect_buried();
		player thread bank();
		player thread award_permaperks_safe();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_buried;
        player waittill("spawned_player");
		player thread fridge();
	}
}

/* Die Rise */
onconnect_buried()
{
	self.initial_stats = array();
	self thread watch_stat( "springpad_zm", array( "zm_highrise", "zm_buried" ) );
	self thread watch_stat( "turbine" );
	self thread watch_stat( "subwoofer_zm" );
}


dierise_init()
{
	if(level.script != "zm_highrise")
		return;
    level thread dierise_connected();
	level thread buildable_controller();
}

dierise_connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread dierise_onconnect();
    	player thread bank();
    	player thread award_permaperks_safe();
        //player thread leapertracker();
		self.initial_stats = array();
		self thread watch_stat("springpad_zm");
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_dierise;
        player waittill("spawned_player");
		player thread fridge();
	}
}

dierise_onconnect()
{
	self.initial_stats = array();
	self thread watch_stat( "springpad_zm", array( "zm_highrise", "zm_buried" ) );
}

/* MOB */
mob_init()
{
	if(level.script != "zm_prison")
		return;
	level thread setup_master_key_override();
    level thread mob_connected();
	level thread boxlocation();
}

mob_connected()
{
	while(1)
	{
		level waittill("connecting", player);
        //player thread BrutusTracker();
		player thread trap_timer();
		player thread givetomahawk();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_mob;
	}
}

/* Tranzit */

tranzit_init()
{
	if(level.script != "zm_transit")
		return;
    if (istranzit())
		level thread tranzit_connected();
	if(!istranzit())
		level thread raygun_counter();
	if(istown())
		level thread boxlocation();
}

tranzit_connected()
{
	while(1)
	{
		level waittill("connecting", player);
    	player thread bank();
    	player thread award_permaperks_safe();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_transit;
        player waittill("spawned_player");
		player thread fridge();
	}
}


nuketown_init()
{
    if(level.script != "zm_nuked")
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
        if(getDvarInt("character") != 0)
            level.givecustomcharacters = ::set_character_option_nuketown;
    }
}

/* General use */
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

	while(1)
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
	sph_off = 1;

	if(level.round_number > GetDvarInt("sph") && !dog_round && !leaper_round)
		sph_off = 0;

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
	{
		wait(1);
	}

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
				if(getDvar("cg_drawFPS") != "Off")
					self.timer.y += 4;
				if(getDvar("cg_drawFPS") != "Off" && GetDvar("language") == "japanese")
					self.timer.y += 10;
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
    {
        if(level.scr_zm_map_start_location == "town")
        {
            if(level.scr_zm_ui_gametype_group == "zsurvival")
                return true;
            return false;
        }
        return false;
    }
    return false;
}

isfarm()
{
    if(level.script == "zm_transit")
    {
        if(level.scr_zm_map_start_location == "farm")
        {
            if(level.scr_zm_ui_gametype_group == "zsurvival")
                return true;
            return false;
        }
        return false;
    }
    return false;
}

isdepot()
{
    if(level.script == "zm_transit")
    {
        if(level.scr_zm_map_start_location == "transit")
        {
            if(level.scr_zm_ui_gametype_group == "zsurvival")
                return true;
            return false;
        }
        return false;
    }
    return false;
}

istranzit()
{
    if(level.script == "zm_transit")
    {
        if(level.scr_zm_map_start_location == "transit")
        {
            if(level.scr_zm_ui_gametype_group == "zclassic")
                return true;
            return false;
        }
        return false;
    }
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
    if(isnuketown())
        return true;
    if(istown())
        return true;
    if(isfarm())
        return true;
    if(isdepot())
        return true;
    return false;
}

isvictismap()
{
    if(isdierise())
        return true;
    if(isburied())
        return true;
    if(istranzit())
        return true;
    return false;
}


setDvars()
{
    setdvar("sv_cheats", 0 );
    setdvar("player_strafeSpeedScale", 1 );
    setdvar("player_backSpeedScale", 1 );
    setdvar("r_dof_enable", 0 );
	if(GetDvar("box") == "")
		setdvar("box", 1);
	if(GetDvar("character") == "")
		setdvar("character", 0);
	if(GetDvar("FragaDebug") == "")
		setdvar("FragaDebug", 0);
    if(getdvar("sph") == "")
        setdvar("sph", 50 );
    if(getdvar("timer") == "")
        setdvar("timer", 1 );
	if(GetDvar("firstbox") == "")
		setdvar("firstbox", 0);
    if(getDvar("st") == "")
        setDvar("st", 0);
    if(getDvar("stop_warning") == "")
        setDvar("stop_warning", 0);
    
    if(isvictismap())
    {
        if(getdvar("fridge") == "")
            setdvar("fridge", "m16");
    }
    if(ismob())
    {
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 0);
        if(getdvar("traptimer") == "")
            setdvar("traptimer", 0 );
    }
    if(isorigins())
    {
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 0);
        if(GetDvar("perkRNG") == "")
            setdvar("perkRNG", 1);
    }
    if(isburied())
    {
        if(GetDvar("perkRNG") == "")
            setdvar("perkRNG", 1);
    }
    if(isdierise())
    {
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 0);
    }
    if(isnuketown() && isancient())
    {
        if(getDvar("perkRNG") == "")
            setDvar("perkRNG", 1);
    }
    if(issurvivalmap())
    {
        if(getDvar("avg") == "")
            setDvar("avg", 1);
    }
    if(getDvarInt("st"))
    {
        if(getDvar("start_round") == "")
            setDvar("start_round", 100);
        if(getDvar("start_delay") == "")
            setDvar("start_delay", 60);
        if(getDvar("st_remove_boards") == "")
            setDvar("st_remove_boards", 1);
        if(getDvar("st_power_on") == "")
            setDvar("st_power_on", 1);
        if(getDvar("st_perks") == "")
            setDvar("st_perks", 1);
        if(getDvar("st_doors") == "")
            setDvar("st_doors", 0);
        if(getDvar("st_weapons") == "")
            setDvar("st_weapons", 1);
        if(getDvar("hud_remaining") == "")
            setDvar("hud_remaining", 1);
        if(getDvar("hud_zone") == "")
            setDvar("hud_zone", 1);
        if(getDvar("perkRNG") == "")
            setDvar("perkRNG", 1);
    }
    level waittill("initial_blackscreen_passed");
    level.start_time = int(gettime() / 1000) + 0.5;
}

fix_highround()
{
	if(level.script == "zm_tomb")
		return;
	while(level.round_number > 155)
	{
		zombies = getaiarray("axis");
		i = 0;
		while(i < zombies.size)
		{
			if(zombies[i].targetname != "zombie")
			{
				continue;
			}
			if(zombies[i].targetname == "zombie")
			{
				if(!isdefined(zombies[i].health_override))
				{
					zombies[i].health_override = 1;
					zombies[i].health = 1044606723;
				}
			}
			i++;
		}
		wait(0.1);
	}
}

fixrotationangle()
{
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
		if(abs(level.vueltass) > 5000000)
			level.vueltas.alpha = 1;
		else level.vueltas.alpha = 0;
		wait 0.5;
	}
	level.vueltas destroy();
}

/* Box stuff */

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
    if(isdierise())
        level.boxhits.y = 10;
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
        level.total_chest_accessed_mk2 = 0;
        level.total_chest_accessed_ray = 0;
        level.boxhits.alignx = "left";
        level.boxhits.horzalign = "user_left";
        level.boxhits.x = 2;
        level.boxhits.alpha = 1;
    }
    while(!isDefined(level.total_chest_accessed))
        wait 0.1;
    while(!isdefined(level.chest_accessed))
        wait 0.1;
    lol = 0;
    while(1)
    {
        if(lol != level.chest_accessed)
        {
            lol = level.chest_accessed;
            if(lol == 0)
                continue;

            level.total_chest_accessed++;

            if(count_for_raygun())
                level.total_chest_accessed_ray++;
            if(count_for_mk2())
                level.total_chest_accessed_mk2++;

            level.boxhits setvalue(level.total_chest_accessed);

            if(!issurvivalmap())
                thread fade();
        }
        wait 0.1;
    }
}

count_for_raygun()
{
    foreach(player in level.players)
        if (!player has_weapon_or_upgrade("ray_gun_zm"))
            return true;
    return false;
}
count_for_mk2()
{
    if(isburied())
    {
        foreach(player in level.players)
            if (!player has_weapon_or_upgrade("raygun_mark2_zm"))
                return true;
        return false;
    }

    foreach(player in level.players)
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            return false;
    return true;
}

fade()
{
    i = 1;
    while(i < 0.1)
    {
        i -= 0.02;
        level.boxhits.alpha = i;
        wait 0.1;
    }
    level.boxhits.alpha = 0;
}

raygun_counter()
{
    self endon("disconnect");

    if(!isDefined(level.total_mk2))
        level.total_mk2 = 0;
    if(!isDefined(level.total_ray))
        level.total_ray = 0;

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

    while(1)
    {
        if(getDvarInt("avg"))
        {
            level.total_mk2_display.label = &"^3Raygun MK2 AVG: ^4";
            level.total_ray_display.label = &"^3Raygun AVG: ^4";
            if(isDefined(level.total_ray_display))
                level.total_ray_display setvalue(level.total_chest_accessed_ray / level.total_ray);
            if(isDefined(level.total_mk2_display))
                level.total_mk2_display setvalue(level.total_chest_accessed_mk2 / level.total_mk2);
        }
        else
        {
            level.total_mk2_display.label = &"^3Total Raygun MK2: ^4";
            level.total_ray_display.label = &"^3Total Raygun: ^4";
            if(isDefined(level.total_ray_display))
                level.total_ray_display setvalue(level.total_ray);
            if(isDefined(level.total_mk2_display))
                level.total_mk2_display setvalue(level.total_mk2);
        }
        wait 0.1;
    }
}



boxlocation()
{
    while(!isdefined(level.chests))
        wait 0.1;
    switch(getDvarInt("box"))
    {
        case 1: 
            if(isorigins())
                level thread startbox("bunker_tank_chest");
            if(isnuketown())
                level thread startbox("start_chest1");
            if(ismob())
                level thread startbox("cafe_chest");
            if(istown())
                level thread startbox("town_chest_2");
            break;
        case 2:
            if(isorigins())
                level thread startbox("bunker_cp_chest");
            if(isnuketown())
                level thread startbox("start_chest2");
            if(ismob())
                level thread startbox("start_chest");
            if(istown())
                level thread startbox("town_chest");
            break;
        default: break;
    }
}

startBox(start_chest)
{
    self endon("disconnect");
    
	for(i = 0; i < level.chests.size; i++)
	{
        if(level.chests[i].script_noteworthy == start_chest)
    		desired_chest_index = i; 
        else if(level.chests[i].hidden == 0)
     		nondesired_chest_index = i;               	
	}

	if( isdefined(nondesired_chest_index) && (nondesired_chest_index < desired_chest_index))
	{
		level.chests[nondesired_chest_index] hide_chest();
		level.chests[nondesired_chest_index].hidden = 1;

		level.chests[desired_chest_index].hidden = 0;
		level.chests[desired_chest_index] show_chest();
		level.chest_index = desired_chest_index;
	}
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

/* Victis */


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
    if(!level.onlinegame)
        return;
	if(level.round_number >= 15)
		return;

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
	if(istranzit())
		remove_permaperk("box_weapon");
	wait 0.5;
	self maps\mp\zombies\_zm_stats::uploadstatssoon();
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	/* Damos todas las ventajas en los mapas correspondientes */
	/* Estoy bastante seguro de que no hace falta porque no se cargan en el resto de mapas */
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

	/* Too high of a round, return out */
	if (is_round(perk["to_round"]))
		return;

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

	if(level.round_number != 1)
		return;
	self.account_value = level.bank_account_max;
}

/* Buildables */


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

        if ( delta > 0 && stat_number > 0 )
        {
            self.initial_stats[stat] = stat_number;
            level.buildable_stats[stat] = level.buildable_stats[stat] + delta;
            i = 1;
            while(i != 0)
            {
    
                level.turbine_hud.alpha = i;
                level.subwoofer_hud.alpha = i;
                level.springpad_hud.alpha = i;
                i = i -0.02;
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
    if(level.script == "zm_buried")
        level.springpad_hud.y = 0;
    else
        level.springpad_hud.y = 15;
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

    if ( isdierise() )
    {
        level.subwoofer_hud destroy();
        level.turbine_hud destroy();
    }
}

buildable_controller()
{
    level endon( "end_game" );

    buildable_hud();
    level.buildable_stats = array();
    level.buildable_stats["springpad_zm"] = 0;
    level.buildable_stats["turbine"] = 0;
    level.buildable_stats["subwoofer_zm"] = 0;

	wait 1;
	if(level.buildable_stats["springpad_zm"] > 0)
		level.buildable_stats["springpad_zm"] = 0;
	if(level.buildable_stats["turbine"] > 0)
		level.buildable_stats["turbine"] = 0;
	if(level.buildable_stats["subwoofer_zm"] > 0)
		level.buildable_stats["subwoofer_zm"] = 0;
    while ( true )
    {
        if ( isburied() )
        {
            level.subwoofer_hud setvalue( level.buildable_stats["subwoofer_zm"] );
            level.turbine_hud setvalue( level.buildable_stats["turbine"] );
        }

        level.springpad_hud setvalue( level.buildable_stats["springpad_zm"] );
        wait 0.1;
    }
}

/* Characters */


set_character_option_buried()
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
    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

set_character_option_dierise()
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
    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

set_character_option_nuketown()
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
    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

set_character_option_mob()
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
    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

set_character_option_origins()
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
    self setmovespeedscale( 1 );
    self setsprintduration( 4 );
    self setsprintcooldown( 0 );
    self thread set_exert_id();
}

set_character_option_transit()
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

        if ( charindexarray[0] == 2 )
            level.has_richtofen = 1;

        return charindexarray[0];
    }
    else
    {
        n_characters_defined = 0;

        foreach ( player in players )
        {
            if ( isdefined( player.characterindex ) )
            {
                arrayremovevalue( charindexarray, player.characterindex, 0 );
                n_characters_defined++;
            }
        }

        if ( charindexarray.size > 0 )
        {
            if ( n_characters_defined == players.size - 1 )
            {
                if ( !( isdefined( level.has_richtofen ) && level.has_richtofen ) )
                {
                    level.has_richtofen = 1;
                    return 2;
                }
            }

            charindexarray = array_randomize( charindexarray );

            if ( charindexarray[0] == 2 )
                level.has_richtofen = 1;

            return charindexarray[0];
        }
    }
    return 0;
}

/* Trackers */

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
	while(1)
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
	while(1)
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
	while(1)
	{
		level waittill( "generator_under_attack" );
		self.lastTemplarRound setvalue(level.round_number);
	}
}

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
	while(1)
	{
		level waittill( "brutus_spawned");
		self.lastBrutusRound setvalue(level.round_number);
        wait 1;
	}
}
*/
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
/* MOB */

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

/* Nuketown */

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
			if(pap.origin[0] < -2000)
			{
				self iprintln("El PAP está al fondo de las casa azul");
				return;
			}
			if(pap.origin[0] < -1600)
			{
				self iprintln("El PAP está al lado del bunker");
				return;
			}
			if(pap.origin[0] > 2030)
			{
				self iprintln("El PAP está al fondo de las casa amarilla");
				return;
			}
			if(pap.origin[0] > 1600)
			{
				self iprintln("El PAP está en la caja de arena");
				return;
			}
			if(pap.origin[0] > 1300)
			{
				self iprintln("El PAP está en la barbacoa");
				return;
			}
			if(pap.origin[0] > 700)
			{
				self iprintln("El PAP está en el 2º piso de la casa amarilla");
				return;
			}
			self iprintln("El PAP está en el medio");
		break;
		default:
			if(pap.origin[0] < -2000)
			{
				self iprintln("PAP is at the end of green house's garden");
				return;
			}
			if(pap.origin[0] < -1600)
			{
				self iprintln("PAP is next to the bunker");
				return;
			}
			if(pap.origin[0] > 2030)
			{
				self iprintln("PAP is at the end of yellow house's garden");
				return;
			}
			if(pap.origin[0] > 1600)
			{
				self iprintln("PAP is at sandbox");
				return;
			}
			if(pap.origin[0] > 1300)
			{
				self iprintln("PAP is at barbecue");
				return;
			}
			if(pap.origin[0] > 700)
			{
				self iprintln("PAP is at yellow house's seconde floor");
				return;
			}
			self iprintln("PAP is at middle of the map");
		break;
	}
}

/* Mob */

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
            if(isorigins() || isburied() || isnuketown() && !level.debug)
                level.perkrng_desabled.label = &"^4^FPerk RNG manipulada";
            if(isorigins() && !level.debug)
                level.templar_modiffied.label = &"^6^FTemplarios manipulados";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3Última ronda de brutus: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3Última ronda de templarios: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3Última ronda de panzer: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3Última ronda de novas: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3TRAMPOLINES: ^4";
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
            if(isorigins() || isburied() || isnuketown())
                level.perkrng_desabled.label = &"^4^FLa RNG des atouts est manipulé";
            if(isorigins())
                level.templar_modiffied.label = &"^6^FTemplier est manipulé";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3Dernière manche de brutus: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3Dernière manche des templiers: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3Dernière manche de panzer: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3Dernière manche de leapers: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3PROPULSEURS: ^4";
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
            if(isorigins() || isburied() || isnuketown() && !level.debug)
                level.perkrng_desabled.label = &"^4^F特典 RNG 操作された";
            if(isorigins() && !level.debug)
                level.templar_modiffied.label = &"^6^Fテンプラー 操作された";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3ブルータス最後のラウンド: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3テンプル騎士団の最後のラウンド: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3最後の装甲ラウンド: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3最後のリーパーラウンド: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3スプリングパッド: ^4";
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
            if(isorigins() || isburied() || isnuketown() && !level.debug)
                level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3Last brutus round: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3Last templar round: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3Last panzer round: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3Last leaper round: ^4";
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3SPRINGPADS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3SPRINGPADS: ^4";
                level.subwoofer_hud.label = &"^3RESONATORS: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;
    }
    while(!isdefined(level.debug) || !isdefined(level.st))
        wait 0.5;
    if(level.debug || level.st)
    {
        level.cheats.label = &"";
        level.firstbox_active.label = &"";
        level.perkrng_desabled.label = &"";
    }
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
        self playsound( "evt_player_upgrade" );
        wait 0.5;
        self playsound( "evt_player_upgrade" );
        wait 0.5;
        self playsound( "evt_player_upgrade" );
    }
    else
    {
        self playsound( "evt_player_upgrade" );
        wait 0.5;
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
    if(self hasperk("specialty_armorvest"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_armorvest";    // JUG
    if(self hasperk("specialty_fastreload"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_fastreload";   // SPEED
    if(self hasperk("specialty_rof"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_rof";          // DT
    if(self hasperk("specialty_finalstand"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_finalstand";   // Who's who
    if(self hasperk("specialty_scavenger"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_scavenger";    // tumba
    if(self hasperk("specialty_nomotionsensor"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_nomotionsensor"; // Stam
    if(self hasperk("specialty_longersprint"))
        self.a_saved_perks[self.a_saved_perks.size] = "specialty_longersprint"; // Stam
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
    player_has_mule_kick = 0;
    discard_quickrevive = 0;

    for ( i = 0; i < self.a_saved_perks.size; i++ )
    {
        perk = self.a_saved_perks[i];

        if ( self.a_saved_perks[i] == "specialty_additionalprimaryweapon" )
            player_has_mule_kick = 1;

        self maps\mp\zombies\_zm_perks::give_perk( self.a_saved_perks[i] );
        wait 0.5;
    }

    if ( player_has_mule_kick )
    {
        a_current_weapons = self getweaponslistprimaries();

        for ( i = 0; i <= self.a_saved_primaries_weapons.size; i++ )
        {
            saved_weapon = self.a_saved_primaries_weapons[i];
            found = 0;

            for ( j = 0; j < a_current_weapons.size; j++ )
            {
                current_weapon = a_current_weapons[j];

                if ( current_weapon == saved_weapon["name"] )
                {
                    found = 1;
                    break;
                }
            }

            if ( found == 0 )
            {
                self maps\mp\zombies\_zm_weapons::weapondata_give( self.a_saved_primaries_weapons[i] );
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

cheatDetectionRedacted()
{
    if(level.st)
        return;
    if(level.debug) 
        return;
    while(level.round_number < 2)
    {
        if(getDvarInt("firstbox") == 1)
            self iprintln("^2Firstbox Active");
        if(getDvarInt("perkrng") == 0)
        {
            if(isorigins())
                self iprintln("^4Perk RNG moddified");
            if(isburied())
                self iprintln("^4Perk RNG moddified");
        }
        if(getDvarInt("sv_cheats"))
            self iprintln("^1Cheats active");
        wait 5;
    }
    while(true)
    {
        if(getDvarInt("sv_cheats") == 1)
            self iprintln("^1Cheats active");
        wait 0.1;
    }
}

st_init()
{
    level.st = true;
    thread wait_for_players();
    level thread turn_on_power();
    level thread set_starting_round();
    level thread remove_boards_from_windows();

    if(ismob())
        level thread mob_map_changes();
    
	flag_wait("initial_blackscreen_passed");
    level thread round_pause();
    if(isdierise() || istranzit() || isorigins() || ismob())
    {
        level thread buildbuildables();
        level thread buildcraftables();
    }
}

wait_for_players()
{
    while(true)
    {
        level waittill( "connected" , player);
        player thread connected_st();
    }
}
connected_st()
{
    self endon( "disconnect" );

    while(true)
    {
        self waittill( "spawned_player" );
		self thread health_bar_hud();
		self tomb_give_shovel();
        self.score = 500000;
		self iprintln("^6Strat Tester");

        self thread zone_hud();
        self thread zombie_remaining_hud();

        self thread give_weapons_on_spawn();
        self thread give_perks_on_spawn();
        self thread give_perks_on_revive();

        self thread infinite_afterlifes();

        enable_cheats();
        
        wait 0.05;
    }
}

enable_cheats()
{
    setDvar( "sv_cheats", 1 );
	setDvar( "cg_ufo_scaler", 0.7 );

    if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
		self notify( "stop_player_out_of_playable_area_monitor" );

	level.player_out_of_playable_area_monitor = 0;
}

set_starting_round()
{
    level.zombie_move_speed = 130;
	level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
	level.round_number = getDvarInt( "start_round" );
}

zombie_spawn_wait()
{
	level endon("end_game");
	level endon( "restart_round" );

	flag_clear("spawn_zombies");

	wait getDvarInt("start_delay");

	flag_set("spawn_zombies");
	level notify("start_delay_over");
}

round_pause()
{
	delay = getDvarInt("start_delay");
    
	if(ismob())
	flag_wait( "afterlife_start_over" );


	level.countdown_hud = create_simple_hud();
	level.countdown_hud.alignx = "center";
	level.countdown_hud.aligny = "top";
	level.countdown_hud.horzalign = "user_center";
	level.countdown_hud.vertalign = "user_top";
	level.countdown_hud.fontscale = 32;
	level.countdown_hud setshader( "hud_chalk_1", 64, 64 );
	level.countdown_hud SetValue( delay );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 0;
	level.countdown_hud FadeOverTime( 2.0 );
	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud.alpha = 1;
	wait 2;
	level thread zombie_spawn_wait();

	while (delay >= 1)
	{
		wait 1;
		delay--;
		level.countdown_hud SetValue( delay );
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );
	
	foreach(player in level.players)
		player.round_timer settimerup(0);
	level.countdown_hud destroy_hud();
}

remove_boards_from_windows()
{
	if(!getDvarInt("st_remove_boards"))
		return;

	flag_wait( "initial_blackscreen_passed" );

	maps\mp\zombies\_zm_blockers::open_all_zbarriers();
}

turn_on_power() //by xepixtvx
{
	if(!getDvarInt("st_power_on"))
		return;

	flag_wait( "initial_blackscreen_passed" );
	wait 5;
	trig = getEnt( "use_elec_switch", "targetname" );
	powerSwitch = getEnt( "elec_switch", "targetname" );
	powerSwitch notSolid();
	trig setHintString( &"ZOMBIE_ELECTRIC_SWITCH" );
	trig setVisibleToAll();
	trig notify( "trigger", self );
	trig setInvisibleToAll();
	powerSwitch rotateRoll( -90, 0, 3 );
	level thread maps\mp\zombies\_zm_perks::perk_unpause_all_perks();
	powerSwitch waittill( "rotatedone" );
	flag_set( "power_on" );
	level setClientField( "zombie_power_on", 1 ); 
}

/*
* *****************************************************
*	
* ****************** Weapons\Perks ********************
*
* *****************************************************
*/

give_perks_on_revive()
{
    if(!getDvarInt("st_perks"))
        return;

	level endon("end_game");
	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
        self give_perks_by_map();
	}
}

give_perks_on_spawn()
{
	if(!getDvarInt("st_perks"))
		return;

    level waittill("initial_blackscreen_passed");
    wait 0.5;
    self give_perks_by_map();
}

give_perks_by_map()
{
    if (isfarm())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(istown())
    {
        perks = array( "specialty_fastreload", "specialty_longersprint", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if (istranzit())
    {
        perks = array( "specialty_armorvest", "specialty_longersprint", "specialty_fastreload", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(isnuketown())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(isdierise())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(ismob())
    {
        flag_wait( "afterlife_start_over" );
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_grenadepulldeath" );
        self give_perks( perks );
    }
    if(isburied())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_rof", "specialty_longersprint", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(isorigins())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_rof", "specialty_longersprint", "specialty_quickrevive" );
        self give_perks( perks );
    }
}

give_perks( perk_array )
{
	foreach( perk in perk_array )
	{
		self give_perk( perk, 0 );
		wait 0.15;
	}
}

give_weapons_on_spawn()
{
	if(!getDvarInt("st_weapons"))
		return;
	
    level waittill("initial_blackscreen_passed");

    if(ismob())
        flag_wait( "afterlife_start_over" );
    if(!isorigins())
        self takeweapon( "m1911_zm" );
    if(isorigins())
        self takeweapon( "c96_zm" );
    wait 1;

    switch( level.script )
    {
        case "zm_transit":
        	location = level.scr_zm_map_start_location;
            if ( location == "farm" )
            {
				self giveweapon( "raygun_mark2_zm" );
                self giveweapon( "qcw05_zm" );
            }
            else if ( location == "town" )
            {
                self giveweapon( "raygun_mark2_upgraded_zm" );
                self giveweapon( "m1911_upgraded_zm" );
                self giveweapon( "tazer_knuckles_zm" );
                self switchToWeapon( "raygun_mark2_upgraded_zm" );
            }
            else if ( location == "transit" && !is_classic() ) //depot
            {
				self giveweapon( "raygun_mark2_zm" );
                self giveweapon( "qcw05_zm" );
                self giveweapon( "tazer_knuckles_zm" );
            }
            else if ( location == "transit" )
            {
                self giveweapon( "raygun_mark2_upgraded_zm" );
                self giveweapon( "m1911_upgraded_zm" );
                self giveweapon( "jetgun_zm" );
                self giveweapon( "tazer_knuckles_zm" );
                self switchToWeapon( "raygun_mark2_upgraded_zm" );
            }
            break;
        case "zm_nuked":
            self giveweapon( "raygun_mark2_upgraded_zm" );
            self giveweapon( "m1911_upgraded_zm" );
            self switchToWeapon( "raygun_mark2_upgraded_zm" );
            break;
        case "zm_highrise":
            self giveweapon( "slipgun_zm" );
            self giveweapon( "qcw05_zm" );
            self switchToWeapon( "slipgun_zm" );
            break;
        case "zm_prison":
            self giveweapon( "blundersplat_upgraded_zm" );
            self giveweapon( "raygun_mark2_upgraded_zm" );

            self weapon_give( "claymore_zm", undefined, undefined, 0 );
            self thread give_tomahawk();
            self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
            break;
        case "zm_buried":
            self giveweapon( "raygun_mark2_upgraded_zm" );
            self giveweapon( "m1911_upgraded_zm" );
            self giveweapon( "slowgun_upgraded_zm" );

            self weapon_give( "claymore_zm", undefined, undefined, 0 );
            self switchToWeapon( "slowgun_upgraded_zm" );
            break;
        case "zm_tomb":
            self giveweapon( "raygun_mark2_upgraded_zm" );
            self giveweapon( "mp40_upgraded_zm" );
            self equipment_take( "claymore_zm" );
            self weapon_give( "claymore_zm", undefined, undefined, 0 );
            self switchToWeapon( "mp40_upgraded_zm" );

            self setactionslot( 3, "weapon", "staff_revive_zm" );
            self giveweapon( "staff_revive_zm" );
            self givemaxammo( "staff_revive_zm" );
			if( cointoss() )
            {
            	self weapon_give( "staff_air_upgraded_zm", undefined, undefined, 0 );
                self switchToWeapon( "staff_air_upgraded_zm" );
            }
			else
            {
                self weapon_give( "staff_water_upgraded_zm", undefined, undefined, 0 );
			    self switchToWeapon( "staff_water_upgraded_zm" );
            }
            break;
    }
    self weapon_give( "knife_zm", undefined, undefined, 0 );
}

give_melee_weapon_instant( weapon_name )
{
	self giveweapon( weapon_name );

    gun = self getcurrentweapon();
	if ( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
		self switchtoweapon( gun );
}


/*
* *****************************************************
*	
* *********************** HUD *************************
*
* *****************************************************
*/

zombie_remaining_hud()
{
	self endon( "disconnect" );
	level endon( "end_game" );

	level waittill( "start_of_round" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.4 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", "CENTER", 190 );
    self.zombie_counter_hud.alpha = 0;
    self.zombie_counter_hud.label = &"Zombies: ^1";
	self thread zombie_remaining_hud_watcher();

    while(true)
    {
        self.zombie_counter_hud setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        wait 0.05; 
    }
}

zombie_remaining_hud_watcher()
{	
	self endon("disconnect");
	level endon( "end_game" );

	while(true)
	{
		self.zombie_counter_hud.alpha = getDvarInt("hud_remaining");
        wait 0.1;
	}
}

zone_hud()
{
	if(!getDvarInt("hud_zone"))
		return;

	self endon("disconnect");

	x = 8;
	y = -111;
	if (isburied())
		y -= 25;
	if (isorigins())
		y -= 30;

	self.zone_hud = newClientHudElem(self);
	self.zone_hud.alignx = "left";
	self.zone_hud.aligny = "bottom";
	self.zone_hud.horzalign = "user_left";
	self.zone_hud.vertalign = "user_bottom";
	self.zone_hud.x += x;
	self.zone_hud.y += y;
	self.zone_hud.fontscale = 1.3;
	self.zone_hud.alpha = 0;
	self.zone_hud.color = ( 1, 1, 1 );
	self.zone_hud.hidewheninmenu = 1;

	flag_wait( "initial_blackscreen_passed" );

	self thread zone_hud_watcher(x, y);
}

zone_hud_watcher( x, y )
{	
	self endon("disconnect");
	level endon( "end_game" );

	prev_zone = "";
	while(true)
	{
		while( !getDvarInt("hud_zone") )
			wait 0.1;

		self.zone_hud.alpha = 1;

		while( getDvarInt("hud_zone") )
		{
			self.zone_hud.y = (y + (self.zone_hud_offset * !level.hud_health_bar ) );

			zone = self get_zone_name();
			if(prev_zone != zone)
			{
				prev_zone = zone;

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 0;
				wait 0.2;

				self.zone_hud settext(zone);

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 1;
				wait 0.15;
			}

			wait 0.05;
		}
		self.zone_hud.alpha = 0;
	}
}

get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
		return "";

	name = "";

	if (istranzit())
	{
        switch(zone)
        {
            case "zone_pri": name = "Bus Depot"; break;
            case "zone_pri2": name = "Bus Depot Hallway"; break;
            case "zone_station_ext": name = "Outside Bus Depot"; break;
            case "zone_trans_2b": name = "Fog After Bus Depot"; break;
            case "zone_trans_2": name = "Tunnel Entrance"; break;
            case "zone_amb_tunnel": name = "Tunnel"; break;
            case "zone_trans_3": name = "Tunnel Exit"; break;
            case "zone_roadside_west": name = "Outside Diner"; break;
            case "zone_gas": name = "Gas Station"; break;
            case "zone_roadside_east": name = "Outside Garage"; break;
            case "zone_trans_diner": name = "Fog Outside Diner"; break;
            case "zone_trans_diner2": name = "Fog Outside Garage"; break;
            case "zone_gar": name = "Garage"; break;
            case "zone_din": name = "Diner"; break;
            case "zone_diner_roof": name = "Diner Roof"; break;
            case "zone_trans_4": name = "Fog After Diner"; break;
            case "zone_amb_forest": name = "Forest"; break;
            case "zone_trans_10": name = "Outside Church"; break;
            case "zone_town_church": name = "Church"; break;
            case "zone_trans_5": name = "Fog Before Farm"; break;
            case "zone_far": name = "Outside Farm"; break;
            case "zone_far_ext": name = "Farm"; break;
            case "zone_brn": name = "Barn"; break;
            case "zone_farm_house": name = "Farmhouse"; break;
            case "zone_trans_6": name = "Fog After Farm"; break;
            case "zone_amb_cornfield": name = "Cornfield"; break;
            case "zone_cornfield_prototype": name = "Nacht"; break;
            case "zone_trans_7": name = "Upper Fog Before Power"; break;
            case "zone_trans_pow_ext1": name = "Fog Before Power"; break;
            case "zone_pow": name = "Outside Power Station"; break;
            case "zone_prr": name = "Power Station"; break;
            case "zone_pcr": name = "Power Control Room"; break;
            case "zone_pow_warehouse": name = "Warehouse"; break;
            case "zone_trans_8": name = "Fog After Power"; break;
            case "zone_amb_power2town": name = "Cabin"; break;
            case "zone_trans_9": name = "Fog Before Town"; break;
            case "zone_town_north": name = "North Town"; break;
            case "zone_tow": name = "Center Town"; break;
            case "zone_town_east": name = "East Town"; break;
            case "zone_town_west": name = "West Town"; break;
            case "zone_town_south": name = "South Town"; break;
            case "zone_bar": name = "Bar"; break;
            case "zone_town_barber": name = "Bookstore"; break;
            case "zone_ban": name = "Bank"; break;
            case "zone_ban_vault": name = "Bank Vault"; break;
            case "zone_tbu": name = "Below Bank"; break;
            case "zone_trans_11": name = "Fog After Town"; break;
            case "zone_amb_bridge": name = "Bridge"; break;
            case "zone_trans_1": name = "Fog Before Bus Depot"; break;
        }
		return name;
	}
	if (isnuketown())
	{
        switch (zone)
        {
            case "culdesac_yellow_zone": name = "Yellow House Middle"; break;
            case "culdesac_green_zone": name = "Green House Middle"; break;
            case "truck_zone": name = "Truck"; break;
            case "openhouse1_f1_zone": name = "Green House Downstairs"; break;
            case "openhouse1_f2_zone": name = "Green House Upstairs"; break;
            case "openhouse1_backyard_zone": name = "Green House Backyard"; break;
            case "openhouse2_f1_zone": name = "Yellow House Downstairs"; break;
            case "openhouse2_f2_zone": name = "Yellow House Upstairs"; break;
            case "openhouse2_backyard_zone": name = "Yellow House Backyard"; break;
            case "ammo_door_zone": name = "Yellow House Backyard Door"; break;
        }
		return name;
	}
	if (isdierise())
	{
        switch (zone)
        {
            case "zone_green_start": name = "Green Highrise Level 3b"; break;
            case "zone_green_escape_pod": name = "Escape Pod"; break;
            case "zone_green_escape_pod_ground": name = "Escape Pod Shaft"; break;
            case "zone_green_level1": name = "Green Highrise Level 3a"; break;
            case "zone_green_level2a": name = "Green Highrise Level 2a"; break;
            case "zone_green_level2b": name = "Green Highrise Level 2b"; break;
            case "zone_green_level3a": name = "Green Highrise Restaurant"; break;
            case "zone_green_level3b": name = "Green Highrise Level 1a"; break;
            case "zone_green_level3c": name = "Green Highrise Level 1b"; break;
            case "zone_green_level3d": name = "Green Highrise Behind Restaurant"; break;
            case "zone_orange_level1": name = "Upper Orange Highrise Level 2"; break;
            case "zone_orange_level2": name = "Upper Orange Highrise Level 1"; break;
            case "zone_orange_elevator_shaft_top": name = "Elevator Shaft Level 3"; break;
            case "zone_orange_elevator_shaft_middle_1": name = "Elevator Shaft Level 2"; break;
            case "zone_orange_elevator_shaft_middle_2": name = "Elevator Shaft Level 1"; break;
            case "zone_orange_elevator_shaft_bottom": name = "Elevator Shaft Bottom"; break;
            case "zone_orange_level3a": name = "Lower Orange Highrise Level 1a"; break;
            case "zone_orange_level3b": name = "Lower Orange Highrise Level 1b"; break;
            case "zone_blue_level5": name = "Lower Blue Highrise Level 1"; break;
            case "zone_blue_level4a": name = "Lower Blue Highrise Level 2a"; break;
            case "zone_blue_level4b": name = "Lower Blue Highrise Level 2b"; break;
            case "zone_blue_level4c": name = "Lower Blue Highrise Level 2c"; break;
            case "zone_blue_level2a": name = "Upper Blue Highrise Level 1a"; break;
            case "zone_blue_level2b": name = "Upper Blue Highrise Level 1b"; break;
            case "zone_blue_level2c": name = "Upper Blue Highrise Level 1c"; break;
            case "zone_blue_level2d": name = "Upper Blue Highrise Level 1d"; break;
            case "zone_blue_level1a": name = "Upper Blue Highrise Level 2a"; break;
            case "zone_blue_level1b": name = "Upper Blue Highrise Level 2b"; break;
            case "zone_blue_level1c": name = "Upper Blue Highrise Level 2c"; break;
        }
	}
	if (ismob())
	{
        switch (zone)
        {
            case "zone_start": name = "D-Block"; break;
            case "zone_library": name = "Library"; break;
            case "zone_cellblock_west": name = "Cellblock 2nd Floor"; break;
            case "zone_cellblock_west_gondola": name = "Cellblock 3rd Floor"; break;
            case "zone_cellblock_west_gondola_dock": name = "Cellblock Gondola"; break;
            case "zone_cellblock_west_barber": name = "Michigan Avenue"; break;
            case "zone_cellblock_east": name = "Times Square"; break;
            case "zone_cafeteria": name = "Cafeteria"; break;
            case "zone_cafeteria_end": name = "Cafeteria End"; break;
            case "zone_infirmary": name = "Infirmary 1"; break;
            case "zone_infirmary_roof": name = "Infirmary 2"; break;
            case "zone_roof_infirmary": name = "Roof 1"; break;
            case "zone_roof": name = "Roof 2"; break;
            case "zone_cellblock_west_warden": name = "Sally Port"; break;
            case "zone_warden_office": name = "Warden's Office"; break;
            case "cellblock_shower": name = "Showers"; break;
            case "zone_citadel_shower": name = "Citadel To Showers"; break;
            case "zone_citadel": name = "Citadel"; break;
            case "zone_citadel_warden": name = "Citadel To Warden's Office"; break;
            case "zone_citadel_stairs": name = "Citadel Tunnels"; break;
            case "zone_citadel_basement": name = "Citadel Basement"; break;
            case "zone_citadel_basement_building": name = "China Alley"; break;
            case "zone_studio": name = "Building 64"; break;
            case "zone_dock": name = "Docks"; break;
            case "zone_dock_puzzle": name = "Docks Gates"; break;
            case "zone_dock_gondola": name = "Upper Docks"; break;
            case "zone_golden_gate_bridge": name = "Golden Gate Bridge"; break;
            case "zone_gondola_ride": name = "Gondola"; break;
        }
		return name;
	}
	if (isburied())
	{
        switch (zone)
        {
            case "zone_start": name = "Processing"; break;
            case "zone_start_lower": name = "Lower Processing"; break;
            case "zone_tunnels_center": name = "Center Tunnels"; break;
            case "zone_tunnels_north": name = "Courthouse Tunnels 2"; break;
            case "zone_tunnels_north2": name = "Courthouse Tunnels 1"; break;
            case "zone_tunnels_south": name = "Saloon Tunnels 3"; break;
            case "zone_tunnels_south2": name = "Saloon Tunnels 2"; break;
            case "zone_tunnels_south3": name = "Saloon Tunnels 1"; break;
            case "zone_street_lightwest": name = "Outside General Store & Bank"; break;
            case "zone_street_lightwest_alley": name = "Outside General Store & Bank Alley"; break;
            case "zone_morgue_upstairs": name = "Morgue"; break;
            case "zone_underground_jail": name = "Jail Downstairs"; break;
            case "zone_underground_jail2": name = "Jail Upstairs"; break;
            case "zone_general_store": name = "General Store"; break;
            case "zone_stables": name = "Stables"; break;
            case "zone_street_darkwest": name = "Outside Gunsmith"; break;
            case "zone_street_darkwest_nook": name = "Outside Gunsmith Nook"; break;
            case "zone_gun_store": name = "Gunsmith"; break;
            case "zone_bank": name = "Bank"; break;
            case "zone_tunnel_gun2stables": name = "Stables To Gunsmith Tunnel 2"; break;
            case "zone_tunnel_gun2stables2": name = "Stables To Gunsmith Tunnel"; break;
            case "zone_street_darkeast": name = "Outside Saloon & Toy Store"; break;
            case "zone_street_darkeast_nook": name = "Outside Saloon & Toy Store Nook"; break;
            case "zone_underground_bar": name = "Saloon"; break;
            case "zone_tunnel_gun2saloon": name = "Saloon To Gunsmith Tunnel"; break;
            case "zone_toy_store": name = "Toy Store Downstairs"; break;
            case "zone_toy_store_floor2": name = "Toy Store Upstairs"; break;
            case "zone_toy_store_tunnel": name = "Toy Store Tunnel"; break;
            case "zone_candy_store": name = "Candy Store Downstairs"; break;
            case "zone_candy_store_floor2": name = "Candy Store Upstairs"; break;
            case "zone_street_lighteast": name = "Outside Courthouse & Candy Store"; break;
            case "zone_underground_courthouse": name = "Courthouse Downstairs"; break;
            case "zone_underground_courthouse2": name = "Courthouse Upstairs"; break;
            case "zone_street_fountain": name = "Fountain"; break;
            case "zone_church_graveyard": name = "Graveyard"; break;
            case "zone_church_main": name = "Church Downstairs"; break;
            case "zone_church_upstairs": name = "Church Upstairs"; break;
            case "zone_mansion_lawn": name = "Mansion Lawn"; break;
            case "zone_mansion": name = "Mansion"; break;
            case "zone_mansion_backyard": name = "Mansion Backyard"; break;
            case "zone_maze": name = "Maze"; break;
            case "zone_maze_staircase": name = "Maze Staircase"; break;
        }
		return name;
	}
	else if (isorigins())
	{
        switch (zone)
        {
            case "zone_start": name = "Lower Laboratory"; break;
            case "zone_start_a": name = "Upper Laboratory"; break;
            case "zone_start_b": name = "Generator 1"; break;
            case "zone_bunker_1a": name = "Generator 3 Bunker 1"; break;
            case "zone_fire_stairs": name = "Fire Tunnel"; break;
            case "zone_bunker_1": name = "Generator 3 Bunker 2"; break;
            case "zone_bunker_3a": name = "Generator 3"; break;
            case "zone_bunker_3b": name = "Generator 3 Bunker 3"; break;
            case "zone_bunker_2a": name = "Generator 2 Bunker 1"; break;
            case "zone_bunker_2": name = "Generator 2 Bunker 2"; break;
            case "zone_bunker_4a": name = "Generator 2"; break;
            case "zone_bunker_4b": name = "Generator 2 Bunker 3"; break;
            case "zone_bunker_4c": name = "Tank Station"; break;
            case "zone_bunker_4d": name = "Above Tank Station"; break;
            case "zone_bunker_tank_c": name = "Generator 2 Tank Route 1"; break;
            case "zone_bunker_tank_c1": name = "Generator 2 Tank Route 2"; break;
            case "zone_bunker_4e": name = "Generator 2 Tank Route 3"; break;
            case "zone_bunker_tank_d": name = "Generator 2 Tank Route 4"; break;
            case "zone_bunker_tank_d1": name = "Generator 2 Tank Route 5"; break;
            case "zone_bunker_4f": name = "zone_bunker_4f"; break;
            case "zone_bunker_5a": name = "Workshop Downstairs"; break;
            case "zone_bunker_5b": name = "Workshop Upstairs"; break;
            case "zone_nml_2a": name = "No Man's Land Walkway"; break;
            case "zone_nml_2": name = "No Man's Land Entrance"; break;
            case "zone_bunker_tank_e": name = "Generator 5 Tank Route 1"; break;
            case "zone_bunker_tank_e1": name = "Generator 5 Tank Route 2"; break;
            case "zone_bunker_tank_e2": name = "zone_bunker_tank_e2"; break;
            case "zone_bunker_tank_f": name = "Generator 5 Tank Route 3"; break;
            case "zone_nml_1": name = "Generator 5 Tank Route 4"; break;
            case "zone_nml_4": name = "Generator 5 Tank Route 5"; break;
            case "zone_nml_0": name = "Generator 5 Left Footstep"; break;
            case "zone_nml_5": name = "Generator 5 Right Footstep Walkway"; break;
            case "zone_nml_farm": name = "Generator 5"; break;
            case "zone_nml_celllar": name = "Generator 5 Cellar"; break;
            case "zone_bolt_stairs": name = "Lightning Tunnel"; break;
            case "zone_nml_3": name = "No Man's Land 1st Right Footstep"; break;
            case "zone_nml_2b": name = "No Man's Land Stairs"; break;
            case "zone_nml_6": name = "No Man's Land Left Footstep"; break;
            case "zone_nml_8": name = "No Man's Land 2nd Right Footstep"; break;
            case "zone_nml_10a": name = "Generator 4 Tank Route 1"; break;
            case "zone_nml_10": name = "Generator 4 Tank Route 2"; break;
            case "zone_nml_7": name = "Generator 4 Tank Route 3"; break;
            case "zone_bunker_tank_a": name = "Generator 4 Tank Route 4"; break;
            case "zone_bunker_tank_a1": name = "Generator 4 Tank Route 5"; break;
            case "zone_bunker_tank_a2": name = "zone_bunker_tank_a2"; break;
            case "zone_bunker_tank_b": name = "Generator 4 Tank Route 6"; break;
            case "zone_nml_9": name = "Generator 4 Left Footstep"; break;
            case "zone_air_stairs": name = "Wind Tunnel"; break;
            case "zone_nml_11": name = "Generator 4"; break;
            case "zone_nml_12": name = "Generator 4 Right Footstep"; break;
            case "zone_nml_16": name = "Excavation Site Front Path"; break;
            case "zone_nml_17": name = "Excavation Site Back Path"; break;
            case "zone_nml_18": name = "Excavation Site Level 3"; break;
            case "zone_nml_19": name = "Excavation Site Level 2"; break;
            case "ug_bottom_zone": name = "Excavation Site Level 1"; break;
            case "zone_nml_13": name = "Generator 5 To Generator 6 Path"; break;
            case "zone_nml_14": name = "Generator 4 To Generator 6 Path"; break;
            case "zone_nml_15": name = "Generator 6 Entrance"; break;
            case "zone_village_0": name = "Generator 6 Left Footstep"; break;
            case "zone_village_5": name = "Generator 6 Tank Route 1"; break;
            case "zone_village_5a": name = "Generator 6 Tank Route 2"; break;
            case "zone_village_5b": name = "Generator 6 Tank Route 3"; break;
            case "zone_village_1": name = "Generator 6 Tank Route 4"; break;
            case "zone_village_4b": name = "Generator 6 Tank Route 5"; break;
            case "zone_village_4a": name = "Generator 6 Tank Route 6"; break;
            case "zone_village_4": name = "Generator 6 Tank Route 7"; break;
            case "zone_village_2": name = "Church"; break;
            case "zone_village_3": name = "Generator 6 Right Footstep"; break;
            case "zone_village_3a": name = "Generator 6"; break;
            case "zone_ice_stairs": name = "Ice Tunnel"; break;
            case "zone_bunker_6": name = "Above Generator 3 Bunker"; break;
            case "zone_nml_20": name = "Above No Man's Land"; break;
            case "zone_village_6": name = "Behind Church"; break;
            case "zone_chamber_0": name = "The Crazy Place Lightning Chamber"; break;
            case "zone_chamber_1": name = "The Crazy Place Lightning & Ice"; break;
            case "zone_chamber_2": name = "The Crazy Place Ice Chamber"; break;
            case "zone_chamber_3": name = "The Crazy Place Fire & Lightning"; break;
            case "zone_chamber_4": name = "The Crazy Place Center"; break;
            case "zone_chamber_5": name = "The Crazy Place Ice & Wind"; break;
            case "zone_chamber_6": name = "The Crazy Place Fire Chamber"; break;
            case "zone_chamber_7": name = "The Crazy Place Wind & Fire"; break;
            case "zone_chamber_8": name = "The Crazy Place Wind Chamber"; break;
            case "zone_robot_head": name = "Robot's Head"; break;
        }
		return name;
	}
		return name;
}


/*
* *****************************************************
*	
* ******************** Buildables *********************
*
* *****************************************************
*/

tomb_give_shovel()
{
	if( level.script != "zm_tomb" )
		return;

	self.dig_vars[ "has_shovel" ] = 1;
	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 1 );
}

buildbuildables()
{
	if(is_classic())
	{
		if(istranzit())
		{
			buildbuildable( "turbine" );
			buildbuildable( "electric_trap" );
			buildbuildable( "turret" );
			buildbuildable( "riotshield_zm" );
			buildbuildable( "jetgun_zm" );
			buildbuildable( "powerswitch", 1 );
			buildbuildable( "pap", 1 );
			buildbuildable( "sq_common", 1 );
			buildbuildable( "dinerhatch", 1 );
			buildbuildable( "bushatch", 1 );
			buildbuildable( "busladder", 1 );
			removebuildable( "dinerhatch" );
			removebuildable( "bushatch" );
			removebuildable( "busladder" );

			getent( "powerswitch_p6_zm_buildable_pswitch_hand", "targetname" ) show();
			getent( "powerswitch_p6_zm_buildable_pswitch_body", "targetname" ) show();
			getent( "powerswitch_p6_zm_buildable_pswitch_lever", "targetname" ) show();
		}
		if(isdierise())
		{
			buildbuildable( "slipgun_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "sq_common", 1 );
		}
	    if(isburied())
		{
			level waittill( "buildables_setup" );
			wait 0.05;

			level.buildables_available = array("subwoofer_zm", "springpad_zm", "headchopper_zm", "turbine");

			buildbuildable( "turbine" );
			buildbuildable( "subwoofer_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "headchopper_zm" );
			buildbuildable( "sq_common", 1 );
		}
	}
}

buildbuildable( buildable, craft )
{
	if (!isDefined(craft))
		craft = 0;

	player = get_players()[ 0 ];
	foreach (stub in level.buildable_stubs)
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable && (isDefined( buildable ) || stub.persistent != 3))
		{
            if (craft)
            {
                stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
                stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
                stub.model notsolid();
                stub.model show();
            }
            else
            {
                equipname = stub get_equipname();
                level.zombie_buildables[stub.equipname].hint = "Hold ^3[{+activate}]^7 to craft " + equipname;
                stub.prompt_and_visibility_func = ::buildabletrigger_update_prompt;
            }

            i = 0;
            foreach (piece in stub.buildablezone.pieces)
            {
                piece maps\mp\zombies\_zm_buildables::piece_unspawn();
                if (!craft && i > 0)
                    stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_set_piece_built(piece);
                i++;
            }

            return;
		}
	}
}

get_equipname()
{
    switch(self.equipname)
    {
	    case   "turbine": return "Turbine";
	    case   "electric_trap": return "Electric Trap";
	    case   "riotshield_zm": return "Zombie Shield";
	    case   "jetgun_zm": return "Jet Gun";
	    case   "slipgun_zm": return "Sliquifier";
	    case   "subwoofer_zm": return "Subsurface Resonator";
	    case   "springpad_zm": return "Trample Steam";
	    case   "headchopper_zm": return "Head Chopper";
    }
}
buildabletrigger_update_prompt( player )
{
	can_use = 0;
	if (isDefined(level.buildablepools))
		can_use = self.stub pooledbuildablestub_update_prompt( player, self );
	else
		can_use = self.stub buildablestub_update_prompt( player, self );
	
	self sethintstring( self.stub.hint_string );
	if ( isDefined( self.stub.cursor_hint ) )
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && isDefined( self.stub.cursor_hint_weapon ) )
			self setcursorhint( self.stub.cursor_hint, self.stub.cursor_hint_weapon );
		else
			self setcursorhint( self.stub.cursor_hint );
	}
	return can_use;
}

buildablestub_update_prompt( player, trigger )
{
	if ( !self maps\mp\zombies\_zm_buildables::anystub_update_prompt( player ) )
		return 0;

	if ( isDefined( self.buildablestub_reject_func ) )
	{
		rval = self [[ self.buildablestub_reject_func ]]( player );
		if ( rval )
			return 0;
	}

	if ( isDefined( self.custom_buildablestub_update_prompt ) && !( self [[ self.custom_buildablestub_update_prompt ]]( player ) ) )
		return 0;

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if ( isDefined( self.built ) && !self.built )
	{
		slot = self.buildablestruct.buildable_slot;
		piece = self.buildablezone.pieces[0];
		player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

		if ( !isDefined( player maps\mp\zombies\_zm_buildables::player_get_buildable_piece( slot ) ) )
		{
			if ( isDefined( level.zombie_buildables[ self.equipname ].hint_more ) )
				self.hint_string = level.zombie_buildables[ self.equipname ].hint_more;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			return 0;
		}
		else
		{
			if ( !self.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( player maps\mp\zombies\_zm_buildables::player_get_buildable_piece( slot ) ) )
			{
				if ( isDefined( level.zombie_buildables[ self.equipname ].hint_wrong ) )
					self.hint_string = level.zombie_buildables[ self.equipname ].hint_wrong;
				else
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";

				return 0;
			}
			else
			{
				if ( isDefined( level.zombie_buildables[ self.equipname ].hint ) )
					self.hint_string = level.zombie_buildables[ self.equipname ].hint;
				else
					self.hint_string = "Missing buildable hint";
			}
		}
	}
	else
	{
		if ( self.persistent == 1 )
		{
			if ( maps\mp\zombies\_zm_equipment::is_limited_equipment( self.weaponname ) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use( self.weaponname ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
				return 0;
			}

			if ( player has_player_equipment( self.weaponname ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
				return 0;
			}

			self.hint_string = self.trigger_hintstring;
		}
		else if ( self.persistent == 2 )
		{
			if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.weaponname, undefined ) )
			{
				self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				return 0;
			}
			else
				if ( isDefined( self.bought ) && self.bought )
				{
					self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
					return 0;
				}
			self.hint_string = self.trigger_hintstring;
		}
		else
		{
			self.hint_string = "";
			return 0;
		}
	}
	return 1;
}

pooledbuildablestub_update_prompt( player, trigger )
{
	if ( !self maps\mp\zombies\_zm_buildables::anystub_update_prompt( player ) )
		return 0;

	if ( isDefined( self.custom_buildablestub_update_prompt ) && !( self [[ self.custom_buildablestub_update_prompt ]]( player ) ) )
		return 0;

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if ( isDefined( self.built ) && !self.built )
	{
		trigger thread buildablestub_build_succeed();

		if (level.buildables_available.size > 1)
			self thread choose_open_buildable(player);

		slot = self.buildablestruct.buildable_slot;

		if (self.buildables_available_index >= level.buildables_available.size)
			self.buildables_available_index = 0;

		foreach (stub in level.buildable_stubs)
			if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
			{
				piece = stub.buildablezone.pieces[0];
				break;
			}

		player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

		piece = player maps\mp\zombies\_zm_buildables::player_get_buildable_piece(slot);

		if ( !isDefined( piece ) )
		{
			if ( isDefined( level.zombie_buildables[ self.equipname ].hint_more ) )
				self.hint_string = level.zombie_buildables[ self.equipname ].hint_more;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";

			if ( isDefined( level.custom_buildable_need_part_vo ) )
				player thread [[ level.custom_buildable_need_part_vo ]]();

			return 0;
		}
		else
		{
			if ( isDefined( self.bound_to_buildable ) && !self.bound_to_buildable.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( piece ) )
			{
				if ( isDefined( level.zombie_buildables[ self.bound_to_buildable.equipname ].hint_wrong ) )
					self.hint_string = level.zombie_buildables[ self.bound_to_buildable.equipname ].hint_wrong;
				else
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";

				if ( isDefined( level.custom_buildable_wrong_part_vo ) )
					player thread [[ level.custom_buildable_wrong_part_vo ]]();

				return 0;
			}
			else
			{
				if ( !isDefined( self.bound_to_buildable ) && !self.buildable_pool pooledbuildable_has_piece( piece ) )
				{
					if ( isDefined( level.zombie_buildables[ self.equipname ].hint_wrong ) )
						self.hint_string = level.zombie_buildables[ self.equipname ].hint_wrong;
					else
						self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";

					return 0;
				}
				else
				{
					if ( isDefined( self.bound_to_buildable ) )
					{
						if ( isDefined( level.zombie_buildables[ piece.buildablename ].hint ) )
							self.hint_string = level.zombie_buildables[ piece.buildablename ].hint;
						else
							self.hint_string = "Missing buildable hint";
					}
					
					if ( isDefined( level.zombie_buildables[ piece.buildablename ].hint ) )
						self.hint_string = level.zombie_buildables[ piece.buildablename ].hint;
					else
						self.hint_string = "Missing buildable hint";
				}
			}
		}
	}
	else
	{
		return trigger [[ self.original_prompt_and_visibility_func ]]( player );
	}
	return 1;
}

pooledbuildable_has_piece( piece )
{
	return isDefined( self pooledbuildable_stub_for_piece( piece ) );
}

pooledbuildable_stub_for_piece( piece )
{
	foreach (stub in self.stubs)
		if ( !isDefined( stub.bound_to_buildable ) && stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( piece ))
            return stub;

	return undefined;
}

choose_open_buildable( player )
{
	self endon( "kill_choose_open_buildable" );

	n_playernum = player getentitynumber();
	b_got_input = 1;
	hinttexthudelem = newclienthudelem( player );
	hinttexthudelem.alignx = "center";
	hinttexthudelem.aligny = "middle";
	hinttexthudelem.horzalign = "center";
	hinttexthudelem.vertalign = "bottom";
	hinttexthudelem.y = -100;
	hinttexthudelem.foreground = 1;
	hinttexthudelem.font = "default";
	hinttexthudelem.fontscale = 1;
	hinttexthudelem.alpha = 1;
	hinttexthudelem.color = ( 1, 1, 1 );
	hinttexthudelem settext( "Press [{+actionslot 1}] or [{+actionslot 2}] to change item" );

	if (!isDefined(self.buildables_available_index))
		self.buildables_available_index = 0;

	while ( isDefined( self.playertrigger[ n_playernum ] ) && !self.built )
	{
		if (!player isTouching(self.playertrigger[n_playernum]))
		{
			hinttexthudelem.alpha = 0;
			wait 0.05;
			continue;
		}

		hinttexthudelem.alpha = 1;

		if ( player actionslotonebuttonpressed() )
		{
			self.buildables_available_index++;
			b_got_input = 1;
		}
		else if ( player actionslottwobuttonpressed() )
            {
                self.buildables_available_index--;

                b_got_input = 1;
            }

		if ( self.buildables_available_index >= level.buildables_available.size )
			self.buildables_available_index = 0;

		else if ( self.buildables_available_index < 0 )
			self.buildables_available_index = level.buildables_available.size - 1;


		if ( b_got_input )
		{
			piece = undefined;
			foreach (stub in level.buildable_stubs)
				if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
				{
					piece = stub.buildablezone.pieces[0];
					break;
				}
			slot = self.buildablestruct.buildable_slot;
			player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

			self.equipname = level.buildables_available[self.buildables_available_index];
			self.hint_string = level.zombie_buildables[self.equipname].hint;
			self.playertrigger[n_playernum] sethintstring(self.hint_string);
			b_got_input = 0;
		}

		if ( player is_player_looking_at( self.playertrigger[n_playernum].origin, 0.76 ) )
			hinttexthudelem.alpha = 1;
		else
			hinttexthudelem.alpha = 0;

		wait 0.05;
	}

	hinttexthudelem destroy();
}

buildablestub_build_succeed()
{
	self notify("buildablestub_build_succeed");
	self endon("buildablestub_build_succeed");

	self waittill( "build_succeed" );

	self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
	arrayremovevalue(level.buildables_available, self.stub.buildablezone.buildable_name);
	if (level.buildables_available.size == 0)
		foreach (stub in level.buildable_stubs)
			switch(stub.equipname)
			{
				case "turbine":
				case "subwoofer_zm":
				case "springpad_zm":
				case "headchopper_zm":
					maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
					break;
			}
}

removebuildable( buildable, after_built )
{
	if (!isDefined(after_built))
		after_built = 0;

	if (after_built)
	{
		foreach (stub in level._unitriggers.trigger_stubs)
			if(IsDefined(stub.equipname) && stub.equipname == buildable)
			{
				stub.model hide();
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( stub );
				return;
			}
	}
	else
	{
        foreach (stub in level.buildable_stubs)
            if ( !isDefined( buildable ) || stub.equipname == buildable && (isDefined( buildable ) || stub.persistent != 3))
            {
                stub maps\mp\zombies\_zm_buildables::buildablestub_remove();

                foreach (piece in stub.buildablezone.pieces)
                    piece maps\mp\zombies\_zm_buildables::piece_unspawn();

                maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( stub );
                return;
            }
	}
}

buildable_piece_remove_on_last_stand()
{
	self endon( "disconnect" );

	self thread buildable_get_last_piece();

	while (true)
	{
		self waittill("entering_last_stand");

		if (isDefined(self.last_piece))
			self.last_piece maps\mp\zombies\_zm_buildables::piece_unspawn();
	}
}

buildable_get_last_piece()
{
	self endon( "disconnect" );

	while (true)
	{
		if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			self.last_piece = maps\mp\zombies\_zm_buildables::player_get_buildable_piece(0);
		wait 0.05;
	}
}


/*
* *****************************************************
*	
* ********** MOTD\Origins style buildables ************
*
* *****************************************************
*/

buildcraftables()
{
	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "prison")
		{
			buildcraftable( "alcatraz_shield_zm" );
			buildcraftable( "packasplat" );
			if(level.is_forever_solo_game)
				buildcraftable( "plane" );
			changecraftableoption( 0 );
		}
		else if(level.scr_zm_map_start_location == "tomb")
		{
			buildcraftable( "tomb_shield_zm" );
			buildcraftable( "equip_dieseldrone_zm" );
			takecraftableparts( "gramophone" );
		}
	}
}

changecraftableoption( index )
{
	foreach (craftable in level.a_uts_craftables)
		if (craftable.equipname == "open_table")
			craftable thread setcraftableoption( index );
}

setcraftableoption( index )
{
	self endon("death");

	while (self.a_uts_open_craftables_available.size <= 0)
		wait 0.05;

	if (self.a_uts_open_craftables_available.size > 1)
	{
		self.n_open_craftable_choice = index;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		foreach (trig in self.playertrigger)
			trig sethintstring( self.hint_string );
	}
}

takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
		if ( stub.name == buildable )
			foreach (piece in stub.a_piecestubs)
			{
				piecespawn = piece.piecespawn;
				if ( isDefined( piecespawn ) )
					player player_take_piece_gramophone( piecespawn );
			}
			return;
}

buildcraftable( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.a_uts_craftables)
		if ( stub.craftablestub.name == buildable )
        {
			foreach (piece in stub.craftablespawn.a_piecespawns)
			{
				piecespawn = get_craftable_piece( stub.craftablestub.name, piece.piecename );
				if ( isDefined( piecespawn ) )
					player player_take_piece( piecespawn );
			}
            return;
        }
}



get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
		if ( uts_craftable.craftablestub.name == str_craftable )
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
				if ( piecespawn.piecename == str_piece )
					return piecespawn;
	return undefined;
}

player_take_piece_gramophone( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared  && isDefined( piecestub.client_field_id ))
        level setclientfield( piecestub.client_field_id, 1 );

	else if ( isDefined( piecestub.client_field_state ) )
		self setclientfieldtoplayer( "craftable", piecestub.client_field_state );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
		self.model delete();

	self.model = undefined;

	if ( isDefined( self.unitrigger ) )
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger );

	self.unitrigger = undefined;
}

remove_buildable_pieces( buildable_name )
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;
			for(i = 0; i < pieces.size; i++)
				pieces[i] maps\mp\zombies\_zm_buildables::piece_unspawn();
			return;
		}
	}
}

enemies_ignore_equipments()
{
	equipment = getFirstArrayKey(level.zombie_include_equipment);
	while (isDefined(equipment))
	{
		maps\mp\zombies\_zm_equipment::enemies_ignore_equipment(equipment);
		equipment = getNextArrayKey(level.zombie_include_equipment, equipment);
	}
}


/*
* *****************************************************
*	
* ********************** MOTD *************************
*
* *****************************************************
*/

mob_map_changes()
{
	if( ismob() )
		return;
	
	open_warden_fence();
	turn_on_perks();
}

infinite_afterlifes()
{
	if( ismob() )
		return;

	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
		self.lives++;
	}
}
open_warden_fence()
{
	m_lock = getent( "masterkey_lock_2", "targetname" );
	m_lock delete();
	t_warden_fence_damage = getent( "warden_fence_damage", "targetname" );
	t_warden_fence_damage delete();
	admin_powerhouse_puzzle_door_clip = getent( "admin_powerhouse_puzzle_door_clip", "targetname" );
	admin_powerhouse_puzzle_door_clip delete();
	admin_powerhouse_puzzle_door = getent( "admin_powerhouse_puzzle_door", "targetname" );
	admin_powerhouse_puzzle_door rotateyaw( 90, 0.5 );
	exploder( 2000 );
	flag_set( "generator_challenge_completed" );
	wait 0.1;
	level clientnotify( "sndWard" );
	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "piece_mid" );
	t_warden_fence_damage = getent( "warden_fence_damage", "targetname" );
	t_warden_fence_damage delete();
	level setclientfield( "warden_fence_down", 1 );
	array_delete( getentarray( "generator_wires", "script_noteworthy" ) );
	wait 3;
	stop_exploder( 2000 );
	wait 1;
}

turn_on_perks()
{
	flag_wait( "initial_blackscreen_passed" );
	level notify( "sleight_on" );
	wait_network_frame();
	level notify( "doubletap_on" );
	wait_network_frame();
	level notify( "juggernog_on" );
	wait_network_frame();
	level notify( "electric_cherry_on" );
	wait_network_frame();
	level notify( "deadshot_on" );
	wait_network_frame();
	level notify( "divetonuke_on" );
	wait_network_frame();
	level notify( "additionalprimaryweapon_on" );
	wait_network_frame();
	level notify( "Pack_A_Punch_on" );
	wait_network_frame();
}

health_bar_hud()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	health_bar = self createprimaryprogressbar();
	health_bar.hidewheninmenu = 1;
	health_bar.bar.hidewheninmenu = 1;
	health_bar.barframe.hidewheninmenu = 1;
	health_bar_text = self createprimaryprogressbartext();
	health_bar_text.hidewheninmenu = 1;
	
	health_bar setpoint(undefined, "BOTTOM", 0, 5);
	health_bar_text setpoint(undefined, "BOTTOM", 75, 5);

	while(true)
	{
		if (isDefined(self.e_afterlife_corpse))
		{
			if (health_bar.alpha != 0)
			{
				health_bar.alpha = 0;
				health_bar.bar.alpha = 0;
				health_bar.barframe.alpha = 0;
				health_bar_text.alpha = 0;
			}
			
			wait 0.05;
			continue;
		}

		if (health_bar.alpha != 1)
		{
			health_bar.alpha = 1;
			health_bar.bar.alpha = 1;
			health_bar.barframe.alpha = 1;
			health_bar_text.alpha = 1;
		}

		health_bar updatebar (self.health / self.maxhealth);
		health_bar_text setvalue(self.health);
		health_bar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
		wait 0.05;
	}
}