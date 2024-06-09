#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_ai_leaper;


#include scripts\zm\fraga\victismaps;
#include scripts\zm\fraga\buildables;
#include scripts\zm\fraga\trackers;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\box;

init()
{
    level thread connected();
	level thread buildable_controller();
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread onconnect();
    	player thread bank();
    	player thread award_permaperks_safe();
        player thread fridge();
		player thread leapertracker();
		self.initial_stats = array();
		self thread watch_stat("springpad_zm");
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_dierise;
	}
}

onconnect()
{
	self.initial_stats = array();
	self thread watch_stat( "springpad_zm", array( "zm_highrise", "zm_buried" ) );
}