#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_magicbox;

init()
{
	thread onplayerconnect();
	if(GetDvar("FirstBox") == "")
	{
		setdvar("FirstBox", 0);
	}
}

onplayerconnect()
{
	if(GetDvarInt("FirstBox") > 0)
	{
	thread firstbox();
	}
}

firstbox()
{
	level waittill("connecting", player);
	player thread showConnectMessage();
	boxRevertRound = 10;
    level thread boxWeapons(level.script, boxRevertRound);
}

startBox(start_chest)
{
    self endon("disconnect");
	level waittill("initial_players_connected");
    
	for(i = 0; i < level.chests.size; i++)
	{
        if(level.chests[i].script_noteworthy == start_chest)
    		desired_chest_index = i; 
        else if(level.chests[i].hidden == 0)
     		nondesired_chest_index = i;               	
	}

	if( isdefined(nondesired_chest_index) && (nondesired_chest_index < desired_chest_index))
	{
		level.chests[nondesired_chest_index] hide_chest();
		level.chests[nondesired_chest_index].hidden = 1;

		level.chests[desired_chest_index].hidden = 0;
		level.chests[desired_chest_index] show_chest();
		level.chest_index = desired_chest_index;
	}	
}

boxWeapons(map_name, boxRevertRound)
{
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");
	forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "scar_zm");

	level.special_weapon_magicbox_check = undefined;
	foreach(weapon in level.zombie_weapons) 
		weapon.is_in_box = 0;

	boxhits = -1;
	while((boxhits < forced_box_guns.size) && (level.round_number < boxRevertRound + 1))
	{
		if(boxhits < level.chest_accessed)
		{
			if(level.chest_accessed != forced_box_guns.size)
			{
				gun = forced_box_guns[boxhits+1];
				level.zombie_weapons[gun].is_in_box = 1;
			}
			boxhits++;		
		}
	wait 2;
	}
	level.special_weapon_magicbox_check = ::tomb_special_weapon_magicbox_check;

	keys = getarraykeys(level.zombie_include_weapons);
	foreach(weapon in keys)
	{
		if(level.zombie_include_weapons[weapon] == 1)
			level.zombie_weapons[weapon].is_in_box = 1;
	}
}

tomb_special_weapon_magicbox_check(weapon)
{
	if ( isDefined( level.raygun2_included ) && level.raygun2_included )
	{
		if ( weapon == "ray_gun_zm" )
		{
			if ( self has_weapon_or_upgrade( "raygun_mark2_zm" ) )
			{
				return 0;
			}
		}
		if ( weapon == "raygun_mark2_zm" )
		{
			if ( self has_weapon_or_upgrade( "ray_gun_zm" ) )
			{
				return 0;
			}
			if ( randomint( 100 ) >= 33 )
			{
				return 0;
			}
		}
	}
	if ( weapon == "beacon_zm" )
	{
		if ( isDefined( self.beacon_ready ) && self.beacon_ready )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	if ( isDefined( level.zombie_weapons[ weapon ].shared_ammo_weapon ) )
	{
		if ( self has_weapon_or_upgrade( level.zombie_weapons[ weapon ].shared_ammo_weapon ) )
		{
			return 0;
		}
	}
	return 1;
}

showConnectMessage()
{
	self endon( "disconnect" );
	flag_wait("initial_blackscreen_passed");
	self iprintln("^3FirstBox ^1Active");
}