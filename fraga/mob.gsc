#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include maps\mp\zm_alcatraz_sq;

setup_master_key()
{
	switch(getDvarInt("box"))
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

givetomahawk()
{
	while(true)
	{
		if(self.origin[0] < 2260 && self.origin[0] > 2230 	&& self.origin[1] > 1012 && self.origin[1] < 10050 && self.origin[2] > 1740)
		{
			self play_sound_on_ent( "purchase" );
			self notify( "tomahawk_picked_up" );
			level notify( "bouncing_tomahawk_zm_aquired" );
			self notify( "player_obtained_tomahawk" );
			self.tomahawk_upgrade_kills = 99;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 1;
			self notify( "tomahawk_upgraded_swap" );
			self set_player_tactical_grenade( "upgraded_tomahawk_zm" );
			self.current_tomahawk_weapon = "upgraded_tomahawk_zm";
			gun = self getcurrentweapon();
			self disable_player_move_states( 1 );
			self giveweapon( "zombie_tomahawk_flourish" );
			self switchtoweapon( "zombie_tomahawk_flourish" );
			self waittill_any( "player_downed", "weapon_change_complete" );
			self switchtoweapon( gun );
			self enable_player_move_states();
			self takeweapon( "zombie_tomahawk_flourish" );
			self giveweapon( "upgraded_tomahawk_zm" );
			self givemaxammo( "upgraded_tomahawk_zm" );
			primaryweapons = self getweaponslistprimaries();
			if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
			{
				self switchtoweapon( primaryweapons[ 0] );
				self waittill( "weapon_change_complete" );
			}
		}
		wait 0.1;
	}
}