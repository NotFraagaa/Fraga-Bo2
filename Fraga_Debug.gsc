#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;

init()
{
	if(GetDvar("FragaDebug") == "")
	{
		setdvar( "score", "69420" );
		setdvar("FragaDebug", 0);
	}
	if(getDvarInt("FragaDebug"))
	{
		level thread onconnect();
		level thread power_on();
	}
}

onconnect()
{
	setdvar("sv_cheats", getDvarInt("FragaDebug"));
	setdvar("cg_ufo_scaler", 1);
	level waittill( "connected", player );
	player thread connected();
}

connected()
{
    level endon( "game_ended" );
    self endon( "disconnect" );
	if(level.script == "zm_prison")
	{
		flag_wait( "afterlife_start_over" );
	}
	self set_players_score( getdvarint( "score" ) );
	self thread speak();
}

set_players_score( score )
{
    flag_wait( "start_zombie_round_logic" );

	if(GetDvarInt("FragaDebug") == 1)
	{
		self.score = GetDvarInt("score");
	}
	else
	{
		self.score = 500;
	}
}

power_on() 
{
	flag_wait( "initial_blackscreen_passed" );
	level.local_doors_stay_open = 1;
	level.power_local_doors_globally = 1;
	flag_set( "power_on" );
	level setclientfield( "zombie_power_on", 1 );
}

speak()
{
	player_amount = 0;
	foreach(player in level.players)
		player_amount++;
	while(1)
	{
		self iprintln(self.origin[0] + "     " + self.origin[1]);
		wait 5;
	}
}