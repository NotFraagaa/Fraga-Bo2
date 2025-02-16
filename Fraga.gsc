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

    thread SRswitch();
    level thread firstbox();
	level thread boxhits();
    level thread roundcounter();
    if(!level.debug || !level.strat_tester)
        level thread detect_cheats();
    if(getDvarInt("st"))
        thread st_init();
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

	self thread timer();
	self thread timerlocation();
	self useservervisionset(1);
	self setvisionsetforplayer(GetDvar( "mapname" ), 1.0 );
	self thread rotate_skydome();
	self thread graphic_tweaks();
	self thread nightmode();
    self thread setFragaLanguage();
    self thread rainbow();
    self thread fixrotationangle();
    self iprintln("^6Fraga^5V15  ^3Active");
    if(getDvar("language") == "french")
        self iprintln("^1Spanish ^3Ruleset  ^1Active");
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
    if(getdvar("SR") == "")
        setdvar("SR", 0 );
    if(getdvar("bus") == "")
        setdvar("bus", 0 );
    if(getdvar("graphictweaks") == "")
        setdvar("graphictweaks", 0 );
    if(getdvar("sph") == "")
        setdvar("sph", 50 );
    if(getdvar("timer") == "")
        setdvar("timer", 1 );
    if(getdvar("splits") != "")
        setdvar("splits", 0 );
	if( getdvar("nightmode") == "")
		setdvar("nightmode", 0 );
	if(GetDvar("firstbox") == "")
		setdvar("firstbox", 0);
    if(getDvar("st") == "")
        setDvar("st", 0);
    if(getDvar("stop_warning") == "")
        setDvar("stop_warning", 0);
    
    if(issurvivalmap())
    {
        if(!getDvar("avg") == "")
            setDvar("avg", 1);
    }
    if(isvictismap())
    {
        if(GetDvar("pers_perk") == "")
            setdvar("pers_perk", 1);
        if(GetDvar("full_bank") == "")
            setdvar("full_bank", 1);
        if(GetDvar("buildables") == "")
            setdvar("buildables", 1);
        if(getdvar("fridge") == "")
            setdvar("fridge", "m16");
    }
    if(ismob())
    {
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 1);
        if(getdvar("traptimer") == "")
            setdvar("traptimer", 0 );
    }
    if(isorigins())
    {
        if(GetDvar("templars") == "")
            setdvar("templars", 0);
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 1);
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
            setDvar("tracker", 1);
    }
    if(isnuketown())
    {
        if(getDvar("perkRNG") == "")
            setDvar("perkRNG", 1);
        if(getDvar("pap") == "")
            setDvar("pap", 0);
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
	flag_wait("initial_blackscreen_passed");
    level.start_time = int(gettime() / 1000);
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