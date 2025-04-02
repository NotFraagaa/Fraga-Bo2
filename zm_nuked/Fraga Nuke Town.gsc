#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_nuked_perks;

#include scripts\zm\fraga\RNGmoddifier;
#include scripts\zm\fraga\character;
#include scripts\zm\fraga\box;
#include scripts\zm\fraga\papcamo;

init()
{
    level thread connected();
	level thread boxlocation();
	level thread raygun_counter();
	level waittill("connecting", player);
	player thread checkpaplocation();
	level.nextperkindex = -1;
	replacefunc(maps\mp\zm_nuked_perks::bring_random_perk, ::perk_order);
    replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::pap_camo);
}

connected()
{
	if(getDvarInt("character") != 0) level.givecustomcharacters = ::set_character_option;
}

checkpaplocation()
{
	if(getDvarInt("pap") || !getDvarInt("perkrng"))
	{
		wait 1;
		if(level.players.size > 1)
		wait 4;
		pap = getent( "specialty_weapupgrade", "script_noteworthy" );
		jug = getent( "vending_jugg", "targetname" );
		if(pap.origin[0] > -1700 || jug.origin[0] > -1700) level.players[0] notify ("menuresponse", "", "restart_level_zm");
	}
}

perk_order( machines, machine_triggers )
{
	if(getDvarInt("perkRNG") != 1)
	{
		if(level.players.size == 1)
		{
			if(level.nextperkindex == 2)
				return;
			if(level.nextperkindex == 1)
				level.nextperkindex = 2;
			if(level.nextperkindex == 4)
				level.nextperkindex = 1;
			if(level.nextperkindex == 3)
				level.nextperkindex = 4;
			if(level.nextperkindex == -1)
				level.nextperkindex = 3;
		}
		else
		{
			if(level.nextperkindex == 0)
				return;
			if(level.nextperkindex == 1)
				level.nextperkindex = 2;
			if(level.nextperkindex == 4)
				level.nextperkindex = 1;
			if(level.nextperkindex == 3)
				level.nextperkindex = 4;
			if(level.nextperkindex == -1)
				level.nextperkindex = 3;
			if(level.nextperkindex == 2)
				level.nextperkindex = 0;
		}
		index = level.nextperkindex - 1;
		maps\mp\zm_nuked_perks::bring_perk( machines[index], machine_triggers[index] );
	}
	else
	{
		count = machines.size;

		if ( count <= 0 )
			return;

		index = randomintrange( 0, count );
		maps\mp\zm_nuked_perks::bring_perk( machines[index], machine_triggers[index] );
		arrayremoveindex( machines, index );
		arrayremoveindex( machine_triggers, index );
	}
}