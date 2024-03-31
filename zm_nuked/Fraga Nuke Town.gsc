#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;


#include scripts\zm\fraga\firstbox;
#include scripts\zm\fraga\RNGmoddifier;
#include scripts\zm\fraga\nuketown;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\avgtracker;

init()
{
    level thread connected();
	
	level thread firstbox();
	level thread avg();
	level thread total_hits();
}

connected()
{
	level waittill("connecting", player);
	if(getDvarInt("character") != 0)
		level.givecustomcharacters = ::set_character_option_nuketown;
}
