#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\timers;
#include scripts\zm\fraga\graphics;
#include scripts\zm\fraga\splits;
#include scripts\zm\fraga\gamefixes;
#include scripts\zm\fraga\cheatdetection;
#include scripts\zm\fraga\trackers;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\box;
#include scripts\zm\fraga\firstroom;
#include scripts\zm\fraga\localizedstrings;
#include scripts\zm\fraga\monitor;
#include scripts\zm\fraga\ismap;

init()
{
    self endon( "disconnect" );
	replaceFunc(maps\mp\animscripts\zm_utility::wait_network_frame, ::base_game_network_frame);
	replaceFunc(maps\mp\zombies\_zm_utility::wait_network_frame, ::base_game_network_frame);
	thread setdvars();
	thread fix_highround();
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;

	if(getDvar("scr_kill_infinite_loops") != "")
        level.plutoVersion = 3755;
    else
        level.plutoVersion = 2905;

    level thread SRswitch();
    level thread monitor_init();
    level thread firstbox();
	level thread boxhits();
    level thread roundcounter();
    if(!level.debug || !level.strat_tester) level thread detect_cheats();
    while(true)
    {
        level waittill("connecting", player);
        player thread fraga_connected();
    }
}

fraga_connected()
{
	self endon("disconnect");
	self waittill("spawned_player");

    if(!isdefined(self.has_timers))
    {   // No duplicates after bleeding out on coop
        self thread timer();
        self thread timerlocation();
        self.has_timers = true;
    }
	self useservervisionset(true);
	self setvisionsetforplayer(GetDvar( "mapname" ), 1.0 );
	self thread rotate_skydome();
	self thread graphic_tweaks();
	self thread nightmode();
    self thread setFragaLanguage();
    if(self == level.players[0]) self thread fixrotationangle();
    self iprintln("^6Fraga^5V15  ^3Active");
    if(getDvar("language") == "french") self iprintln("^1Spanish ^3Ruleset  ^1Active");
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
    createDvar("SR", 0);
    createDvar("graphictweaks", 0);
    createDvar("sph", 50);
    createDvar("timer", 1);
    createDvar("splits", 0);
    createDvar("nightmode", 0);
    createDvar("firstbox", 0);
    createDvar("stop_warning", 0);
    createDvar("papcamo", 0);
    
    if (issurvivalmap()) createDvar("avg", 1);
    if (isvictismap())
    {
        createDvar("pers_perk", 1);
        createDvar("full_bank", 1);
        createDvar("buildables", 1);
        createDvar("fridge", "m16");
    }
    if (ismob())
    {
        createDvar("tracker", 0);
        createDvar("traptimer", 0);
    }
    if (isorigins())
    {
        createDvar("templars", 0);
        createDvar("tracker", 0);
        createDvar("perkRNG", 1);
    }
    if (isburied()) createDvar("perkRNG", 1);
    if (isdierise()) createDvar("tracker", 0);
    if (isnuketown())
    {
        createDvar("perkRNG", 1);
        createDvar("pap", 0);
    }

    flag_wait("initial_blackscreen_passed");
    level.start_time = int(gettime() / 1000);
}

createDvar(dvar, set)
{
    if (getDvar(dvar) == "")
        setDvar(dvar, set);
}

base_game_network_frame()
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