#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\RNGmoddifier;
#include scripts\zm\fraga\nuketown;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\box;

init()
{
    level thread connected();
	level thread firstbox();
	level thread boxlocation();
	level thread avg();
	level waittill("connecting", player);
	player thread checkpaplocation();
	level.nextperkindex = -1;
	replacefunc(maps\mp\zm_nuked_perks::bring_random_perk, ::perk_order);
}

connected()
{
	if(getDvarInt("character") != 0)
		level.givecustomcharacters = ::set_character_option_nuketown;
}