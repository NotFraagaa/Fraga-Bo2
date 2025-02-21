#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_tombstone;


#include scripts\zm\fraga\victismaps;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\ismap;
#include scripts\zm\fraga\bus;
#include scripts\zm\fraga\box;

init()
{
    if(istranzit()) level thread connected();
	if(!istranzit()) level thread raygun_counter();
	if(istown()) level thread boxlocation();
}

connected()
{
	while(true)
	{
		level waittill("connecting", player);
    	player thread bank();
    	player thread award_permaperks_safe();
		if(getDvarInt("character") != 0) level.givecustomcharacters = ::set_character_option;
        player waittill("spawned_player");
		player thread fridge();
	}
}