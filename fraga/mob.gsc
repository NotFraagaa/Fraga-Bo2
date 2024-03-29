#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include maps\mp\zm_alcatraz_sq;

setup_master_key()
{
	switch(getDvarInt("firstbox"))
	{
		case 1:
			level.is_master_key_west = 0;
        	setclientfield( "fake_master_key", level.is_master_key_west + 1 );
			exploder( 100 );
			level thread maps\mp\zm_alcatraz_sq::key_pulley( "east" );
			array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
			break;
		case 2:
			level.is_master_key_west = 1;
        	setclientfield( "fake_master_key", level.is_master_key_west + 1 );
			level thread maps\mp\zm_alcatraz_sq::key_pulley( "west" );
			exploder( 101 );
			array_delete( getentarray( "wires_pulley_east", "script_noteworthy" ) );
			break;
		default:
			level.is_master_key_west = 0;
        	setclientfield( "fake_master_key", level.is_master_key_west + 1 );
			exploder( 100 );
			level thread maps\mp\zm_alcatraz_sq::key_pulley( "east" );
			array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
			break;
	}
}