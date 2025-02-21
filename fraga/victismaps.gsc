#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_perks;

#include scripts\zm\fraga\ismap;

fridge()
{
	if(level.round_number >= 15)
		return;
	
	if(isdierise() || isburied())
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
	}
	if(istranzit())
	{
		if(getDvar("fridge") == "m16")
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "m16_gl_upgraded_zm");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 270);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 30);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_clip", 1);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_stock", 8);
		}
		else
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "mp5k_upgraded_zm");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 200);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 40);
		}
	}
}


award_permaperks_safe()
{
	if(level.round_number >= 15)
		return;
	level endon("end_game");
	self endon("disconnect");

	while (!isalive(self))
		wait 0.05;

	wait 0.5;
    perks_to_process = [];
    
    perks_to_process[perks_to_process.size] = permaperk_array("revive");
    perks_to_process[perks_to_process.size] = permaperk_array("multikill_headshots");
    perks_to_process[perks_to_process.size] = permaperk_array("perk_lose");
    perks_to_process[perks_to_process.size] = permaperk_array("jugg", undefined, undefined, 15);
    perks_to_process[perks_to_process.size] = permaperk_array("flopper", array("zm_buried"));
    perks_to_process[perks_to_process.size] = permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"));
    perks_to_process[perks_to_process.size] = permaperk_array("cash_back");
    perks_to_process[perks_to_process.size] = permaperk_array("sniper");
    perks_to_process[perks_to_process.size] = permaperk_array("insta_kill");
    perks_to_process[perks_to_process.size] = permaperk_array("pistol_points");
    perks_to_process[perks_to_process.size] = permaperk_array("double_points");

	foreach (perk in perks_to_process)
	{
		if( !(istranzit() && perk == permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"))))
		self resolve_permaperk(perk);
		wait 0.05;
	}
	if(istranzit())
        level.pers_box_weapon_lose_round = 0;

	wait 0.5;
	self maps\mp\zombies\_zm_stats::uploadstatssoon();
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	if (!isDefined(maps_award))
		maps_award = array("zm_transit", "zm_highrise", "zm_buried");
	if (!isDefined(maps_take))
		maps_take = [];
	if (!isDefined(to_round))
		to_round = 255;

	permaperk = [];
	permaperk["code"] = code;
	permaperk["maps_award"] = maps_award;
	permaperk["maps_take"] = maps_take;
	permaperk["to_round"] = to_round;

	return permaperk;
}

resolve_permaperk(perk)
{
	wait 0.05;

	perk_code = perk["code"];

	if (is_round(perk["to_round"]))
		return;

	if (isinarray(perk["maps_award"], level.script) && !self.pers_upgrades_awarded[perk_code])
	{
		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			self award_permaperk(stat_name, perk_code, stat_value);
		}
	}

	if (isinarray(perk["maps_take"], level.script) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}


award_permaperk(stat_name, perk_code, stat_value)
{
	flag_set("permaperks_were_set");
	self.stats_this_frame[stat_name] = 1;
	self maps\mp\zombies\_zm_stats::set_global_stat(stat_name, stat_value);
	self playsoundtoplayer("evt_player_upgrade", self);
}

remove_permaperk(perk_code)
{
	self.pers_upgrades_awarded[perk_code] = 0;
	self playsoundtoplayer("evt_player_downgrade", self);
}

bank()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	if(level.round_number != 1)
		return;
	self.account_value = level.bank_account_max;
}

enablepersperks()
{
    if(!isvictismap()) return;
	if(level.round_number >= 15) return;
    self thread minijug();
    self thread tombstone();
    if(isburied())
    {
        wait 5;
        maps\mp\zombies\_zm::register_player_damage_callback( ::phd );
        self playsound( "evt_player_upgrade" ); wait 0.5;
        self playsound( "evt_player_upgrade" ); wait 0.5;
        self playsound( "evt_player_upgrade" );
    }
    else
    {
        self playsound( "evt_player_upgrade" ); wait 0.5;
        self playsound( "evt_player_upgrade" );
    }
}


minijug()
{
    while(self.downs == 0)
    {
        if(!self hasperk("specialty_armorvest")) self.maxhealth = 190;
        else self.maxhealth = 340;
        wait 0.5;
    }
    self playsoundtoplayer("evt_player_downgrade", self);
}
tombstone()
{
    // Player shouldnt get the effect if he dies due to falling on the maze's fountain
    wait 1;
    self thread saveplayerdata();

    while(true)
    {
        if(isdefined( self.revivetrigger ))
        {
            while(isdefined( self.revivetrigger ))
                wait 1;
            self thread giveplayerdata();
        }
        wait 1;
    }
}

saveplayerdata()
{
    while(true)
    {
		self waittill_any("perk_acquired", "perk_lost");
        wait 5; // so we dont overwrite them while we're giving them to the player

        if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
			continue;

        self.a_saved_perks = [];

        if(self hasperk("specialty_additionalprimaryweapon"))
        {
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_additionalprimaryweapon";
            self thread scanweapons();
        }
        if(self hasperk("specialty_armorvest"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_armorvest";    // JUG
        if(self hasperk("specialty_fastreload"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_fastreload";   // SPEED
        if(self hasperk("specialty_rof"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_rof";          // DT
        if(self hasperk("specialty_finalstand"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_finalstand";   // Who's who
        if(self hasperk("specialty_scavenger"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_scavenger";    // tumba
        if(self hasperk("specialty_nomotionsensor"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_nomotionsensor"; // Vulture
        if(self hasperk("specialty_longersprint"))
            self.a_saved_perks[self.a_saved_perks.size] = "specialty_longersprint"; // Stam
    }
}

scanweapons()
{
    while(true)
    {
        wait 5;
        if ( self maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
			continue;
        self.a_saved_primaries = self getweaponslistprimaries();
        self.a_saved_primaries_weapons = [];
        index = 0;

        foreach ( weapon in self.a_saved_primaries )
        {
            self.a_saved_primaries_weapons[index] = maps\mp\zombies\_zm_weapons::get_player_weapondata( self, weapon );
            index++;
        }
    }
}

giveplayerdata()
{
    player_has_mule_kick = 0;
    discard_quickrevive = 0;

    for ( i = 0; i < self.a_saved_perks.size; i++ )
    {
        perk = self.a_saved_perks[i];

        if ( self.a_saved_perks[i] == "specialty_additionalprimaryweapon" )
            player_has_mule_kick = 1;

        self maps\mp\zombies\_zm_perks::give_perk( self.a_saved_perks[i] );
        wait 0.5;
    }

    if ( player_has_mule_kick )
    {
        a_current_weapons = self getweaponslistprimaries();

        for ( i = 0; i <= self.a_saved_primaries_weapons.size; i++ )
        {
            saved_weapon = self.a_saved_primaries_weapons[i];
            found = 0;

            for ( j = 0; j < a_current_weapons.size; j++ )
            {
                current_weapon = a_current_weapons[j];

                if ( current_weapon == saved_weapon["name"] )
                {
                    found = 1;
                    break;
                }
            }

            if ( found == 0 )
            {
                self maps\mp\zombies\_zm_weapons::weapondata_give( self.a_saved_primaries_weapons[i] );
                self switchtoweapon( a_current_weapons[0] );
                break;
            }
        }
    }
    self.a_saved_perks = undefined;
    self.a_saved_primaries = undefined;
    self.a_saved_primaries_weapons = undefined;
}

phd( e_inflictor, e_attacker, n_damage, n_dflags, str_means_of_death, str_weapon, v_point, v_dir, str_hit_loc, psoffsettime, b_damage_from_underneath, n_model_index, str_part_name )
{
    if( str_means_of_death == "MOD_FALLING" )
    {
        if(self.haspersphd)
        {
            if(isdefined( self.divetoprone ) && self.divetoprone == 1)
            {
                self thread pers_flopper_damage_network_optimized( self.origin, 300, 5000, 1000, "MOD_GRENADE_SPLASH" );
                if( getdvar( "mapname" ) == "zm_buried" || getdvar( "mapname" ) == "zm_tomb" )
                    fx = level._effect[ "divetonuke_groundhit"];
                self playsound( "zmb_phdflop_explo" );
                playfx( fx, self.origin );
                return 0;
            }
            else
            {
                self.haspersphd = false;
                self playsound( "evt_player_downgrade" );
                return 0;
            }
        }
        else
        {
            if(!isdefined(self.damagebyfalling))
                self.damagebyfalling = 0;

            self.damagebyfalling += n_damage;
            if(self.damagebyfalling >= 1000)
            {
                self.damagebyfalling = 0;
                self playsound( "evt_player_upgrade" );
                self.haspersphd = true;
            }
        }
    }
    if ( str_means_of_death == "MOD_PROJECTILE" || str_means_of_death == "MOD_PROJECTILE_SPLASH" || str_means_of_death == "MOD_GRENADE" || str_means_of_death == "MOD_GRENADE_SPLASH" )
    {
        if (self.haspersphd)
            return 0;
    }

    if ( isdefined( self.is_in_fountain_transport_trigger ) && self.is_in_fountain_transport_trigger && str_means_of_death == "MOD_FALLING" )
        return 0;

    return n_damage;
}

pers_flopper_damage_network_optimized( origin, radius, max_damage, min_damage, damage_mod )
{
    self endon( "disconnect" );
    a_zombies = get_array_of_closest( origin, get_round_enemy_array(), undefined, undefined, radius );
    network_stall_counter = 0;

    if ( isdefined( a_zombies ) )
    {
        for ( i = 0; i < a_zombies.size; i++ )
        {
            e_zombie = a_zombies[i];

            if ( !isdefined( e_zombie ) || !isalive( e_zombie ) )
                continue;

            dist = distance( e_zombie.origin, origin );
            damage = min_damage + ( max_damage - min_damage ) * ( 1.0 - dist / radius );
            e_zombie dodamage( damage, e_zombie.origin, self, self, 0, damage_mod );
            network_stall_counter--;

            if ( network_stall_counter <= 0 )
            {
                wait_network_frame();
                network_stall_counter = randomintrange( 1, 3 );
            }
        }
    }
}