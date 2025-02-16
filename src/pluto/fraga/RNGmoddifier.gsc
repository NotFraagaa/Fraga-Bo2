#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_perk_random;
#include maps\mp\zombies\_zm_perks;

#include scripts\zm\fraga\ismap;

Templars( s_last_recapture_zone )
{
	a_s_player_zones = [];

	foreach ( str_key, s_zone in level.zone_capture.zones )
	{
		if ( s_zone ent_flag( "player_controlled" ) )
			a_s_player_zones[str_key] = s_zone;
	}

	s_recapture_zone = undefined;

	if ( a_s_player_zones.size )
	{
		if ( isdefined( s_last_recapture_zone ) )
		{
			n_distance_closest = undefined;

			foreach ( s_zone in a_s_player_zones )
			{
				n_distance = distancesquared( s_zone.origin, s_last_recapture_zone.origin );

				if ( !isdefined( n_distance_closest ) || n_distance < n_distance_closest )
				{
					s_recapture_zone = s_zone;
					n_distance_closest = n_distance;
				}
			}
		}
		else if (GetDvarInt("Templars") != 0)  
		{
			s_recapture_zone = level.zone_capture.zones["generator_nml_right"];
		}
		else
		{
			s_recapture_zone = random( a_s_player_zones );
		}
	}

	return s_recapture_zone;

}

perkorderorigins( player )
{
	if(getDvarInt("perkRNG") == 0)
	{
		if(!player hasperk("specialty_armorvest"))
			return("specialty_armorvest");
		if(!player hasperk("specialty_rof"))
			return("specialty_rof");
		if(!player hasperk("specialty_fastreload"))
			return("specialty_fastreload");
		if(!player hasperk("specialty_additionalprimaryweapon"))
			return("specialty_additionalprimaryweapon");
		if(!player hasperk("specialty_longersprint"))
			return("specialty_longersprint");
		if(!player hasperk("specialty_quickrevive"))
			return("specialty_quickrevive");
		if(!player hasperk("specialty_grenadepulldeath"))
			return("specialty_grenadepulldeath");
		if(!player hasperk("specialty_flakjacket"))
			return("specialty_flakjacket");
		return("specialty_deadshot");
	}
	else	// Base game code
	{
		keys = array_randomize( getarraykeys( level._random_perk_machine_perk_list ) );

		if ( isdefined( level.custom_random_perk_weights ) )
			keys = player [[ level.custom_random_perk_weights ]]();
		for ( i = 0; i < keys.size; i++ )
		{
			if ( player hasperk( level._random_perk_machine_perk_list[keys[i]] ) )
				continue;
			else
				return level._random_perk_machine_perk_list[keys[i]];
		}
		return level._random_perk_machine_perk_list[keys[0]];
	}
}

perfectperks()
{
	if(GetDvarInt("perkrng") == 0)
	{
		replaceFunc(maps\mp\zombies\_zm_perks::give_random_perk, ::giverandomperk);
	}
}

giverandomperk()
{
	random_perk = undefined;
	vending_triggers = getentarray( "zombie_vending", "targetname" );
	perks = [];
	i = 0;
	while ( i < vending_triggers.size )
	{
		perk = vending_triggers[ i ].script_noteworthy;
		if ( isDefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
			i++;
			continue;
		}
		if ( perk == "specialty_weapupgrade" )
		{
			i++;
			continue;
		}
		if ( !self hasperk( perk ) && !self has_perk_paused( perk ) )
		{
			perks[ perks.size ] = perk;
		}
		i++;
	}
	if ( perks.size > 0 )
	{
		perks = array_randomize( perks );
		random_perk = perks[ 0 ];
		if(isburied())
		{
			while ( random_perk == "specialty_nomotionsensor" && perks.size > 1 )
			{
				perks = array_randomize( perks );
				random_perk = perks[ 0 ];
			}
			self give_perk( random_perk );
		}
	}
	else
	{
		self playsoundtoplayer( level.zmb_laugh_alias, self );
	}
	return random_perk;
}