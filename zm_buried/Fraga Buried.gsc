#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zombies\_zm_perks;

#include scripts\zm\fraga\buildables;
#include scripts\zm\fraga\victismaps;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\box;
#include scripts\zm\fraga\papcamo;
#include scripts\zm\fraga\RNGmoddifier;

init()
{
	level thread perfectperks();
    level thread connected();
	level thread buildable_controller();
	
    replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::buried_pap_camo);
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread onconnect();
		player thread bank();
		player thread award_permaperks_safe();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_buried;
        player waittill("spawned_player");
		player thread fridge();
	}
}

onconnect()
{
	self.initial_stats = array();
	self thread watch_stat( "springpad_zm", array( "zm_highrise", "zm_buried" ) );
	self thread watch_stat( "turbine" );
	self thread watch_stat( "subwoofer_zm" );
}