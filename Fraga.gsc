#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;


#include scripts\zm\fraga\timers;
#include scripts\zm\fraga\graphics;
#include scripts\zm\fraga\splits;
#include scripts\zm\fraga\wellcome;
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
	thread setdvars();
	thread fix_highround();
    if(!isDefined(level.total_chest_accessed))
        level.total_chest_accessed = 0;

	if(getDvar("scr_kill_infinite_loops") != "")
		thread SRswitch();

	level waittill("connecting", player);
	level thread boxhits();
	player thread connected();
	level thread frkills();
	if(!level.debug)
		level thread detect_cheats();
}

connected()
{
	self endon("disconnect");
	self waittill("spawned_player");
	self thread setFragaLanguage();

	self thread timer_fraga();
	self thread color_hud_watcher();
	self thread timerlocation();
	self useservervisionset(1);
	self setvisionsetforplayer(GetDvar( "mapname" ), 1.0 );
	self thread rotate_skydome();
	self thread graphic_tweaks();
	self thread nightmode();
	self thread velocity_meter();
}

setDvars()
{
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
    if(getdvar("color") == "")
        setdvar("color", "0.505 0.478 0.721");
    if(getdvar("sph") == "")
        setdvar("sph", 50 );
    if(getdvar("timer") == "")
        setdvar("timer", 1 );
    if(getdvar("roundtimer") == "")
        setdvar("roundtimer", 1 );
    if(getdvar("splits") != "")
        setdvar("splits", 0 );
	if( getdvar("nightmode") == "")
		setdvar("nightmode", 0 );
	if(GetDvar("firstbox") == "")
		setdvar("firstbox", 0);
    
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
    }
}