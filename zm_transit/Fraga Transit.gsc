#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_tombstone;


#include scripts\zm\fraga\visctismaps;
#include scripts\zm\fraga\firstbox;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\ismap;
#include scripts\zm\fraga\bus;
#include scripts\zm\fraga\avgtracker;

init()
{
    if (istranzit())
		level thread connected();

	if(!istranzit())
	{
		level thread avg();
    	level thread total_hits();
	}


	if(istown())
		level thread boxlocation_town();
	
	level thread firstbox();
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
        player thread fridge();
    	player thread bank();
    	player thread award_permaperks_safe();
		player thread buslocation();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_transit;
	}
}