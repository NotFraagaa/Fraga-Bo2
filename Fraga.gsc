#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;


#include scripts\zm\fraga\dvars;
#include scripts\zm\fraga\timers;
#include scripts\zm\fraga\graphics;
#include scripts\zm\fraga\splits;
#include scripts\zm\fraga\wellcome;
#include scripts\zm\fraga\gamefixes;
#include scripts\zm\fraga\cheatdetection;
#include scripts\zm\fraga\trackers;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\box;

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
	if(!getDvarInt("FragaDebug"))
		level thread detect_cheats();
}

connected()
{
	self endon("disconnect");
	self waittill("spawned_player");
	self thread wellcome(GetDvar("language"));

	self thread timer_fraga();
	self thread color_hud_watcher();
	self thread timerlocation();
	self useservervisionset(1);
	self setvisionsetforplayer(GetDvar( "mapname" ), 1.0 );
	self thread rotate_skydome();
	self thread graphic_tweaks();
	self thread nightmode();
}