#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_ai_leaper;

init()
{
	if(GetDvar("FragaDebug") == "")
	{
		setdvar( "score", "69420" );
		setdvar("FragaDebug", 0);
	}
	thread FragaDebug();
}

FragaDebug()
{
	level thread onconnect();
}

onconnect()
{
	setdvar("sv_cheats", getDvarInt("FragaDebug"));
	setdvar("cg_ufo_scaler", 1);
    for (;;)
    {
        level waittill( "connected", player );
        player thread connected();
    }
}

connected()
{
    level endon( "game_ended" );
    self endon( "disconnect" );

    for (;;)
    {
        self waittill( "spawned_player" );
        self set_players_score( getdvarint( "score" ) );
    }
}

set_players_score( score )
{
    flag_wait( "start_zombie_round_logic" );

	if(GetDvarInt("FragaDebug") == 1)
	{
		self.score = 69420;
	}
	else
	{
		self.score = 500;
	}
}

