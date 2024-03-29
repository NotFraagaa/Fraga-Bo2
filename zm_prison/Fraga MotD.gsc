#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_prison_sq_bg;
#include maps\mp\zm_alcatraz_craftables;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_magicbox;


#include scripts\zm\fraga\firstbox;
#include scripts\zm\fraga\mob;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\timers;
#include scripts\zm\fraga\trackers;

init()
{
	replaceFunc( maps\mp\zm_alcatraz_sq::setup_master_key, ::setup_master_key );
    level thread connected();
	level thread firstbox();
	level thread boxlocation_mob();
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread BrutusTracker();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_mob;
		player thread trap_timer_fraga();
		player thread trap_timer_cooldown_fraga();
	}
}