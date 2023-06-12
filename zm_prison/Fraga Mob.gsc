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
init()
{
	replaceFunc( maps\mp\zm_alcatraz_sq::setup_master_key, ::setup_master_key );   
}

setup_master_key()
{
	level.is_master_key_west = 0;
	setclientfield( "fake_master_key", level.is_master_key_west + 1 );
	if ( level.is_master_key_west )
	{
		level thread maps\mp\zm_alcatraz_sq::key_pulley( "west" );
		exploder( 101 );
		array_delete( getentarray( "wires_pulley_east", "script_noteworthy" ) );
	}
	else
	{
		level thread maps\mp\zm_alcatraz_sq::key_pulley( "east" );
		exploder( 100 );
		array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
	}
}