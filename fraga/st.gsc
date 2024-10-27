#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;

#include scripts\zm\fraga\ismap;

st_init()
{
	while(!isdefined(level.cheats))
		wait 0.1;
    level.cheats destroy();
    thread wait_for_players();
    level thread turn_on_power();
    level thread set_starting_round();
    level thread remove_boards_from_windows();
    level thread mob_map_changes();
    
	flag_wait("initial_blackscreen_passed");
    level thread round_pause();
    level thread buildbuildables();
    level thread buildcraftables();
}

wait_for_players()
{
    while(true)
    {
        level waittill( "connected" , player);
        player thread connected_st();
    }
}
connected_st()
{
    self endon( "disconnect" );

    while(true)
    {
        self waittill( "spawned_player" );
		self thread health_bar_hud();
		self tomb_give_shovel();
        self.score = 500000;
		self iprintln("^6Strat Tester");

        self thread zone_hud();
        self thread zombie_remaining_hud();

        self thread give_weapons_on_spawn();
        self thread give_perks_on_spawn();
        self thread give_perks_on_revive();

        self thread infinite_afterlifes();

        enable_cheats();
        
        wait 0.05;
    }
}

enable_cheats()
{
    setDvar( "sv_cheats", 1 );
	setDvar( "cg_ufo_scaler", 0.7 );

    if( level.player_out_of_playable_area_monitor && IsDefined( level.player_out_of_playable_area_monitor ) )
		self notify( "stop_player_out_of_playable_area_monitor" );

	level.player_out_of_playable_area_monitor = 0;
}

set_starting_round()
{
    level.zombie_move_speed = 130;
	level.zombie_vars[ "zombie_spawn_delay" ] = 0.08;
	level.round_number = getDvarInt( "start_round" );
}

zombie_spawn_wait()
{
	level endon("end_game");
	level endon( "restart_round" );

	flag_clear("spawn_zombies");

	wait getDvarInt("start_delay");

	flag_set("spawn_zombies");
	level notify("start_delay_over");
}

round_pause()
{
	delay = getDvarInt("start_delay");
    
	if(ismob())
	flag_wait( "afterlife_start_over" );


	level.countdown_hud = create_simple_hud();
	level.countdown_hud.alignx = "center";
	level.countdown_hud.aligny = "top";
	level.countdown_hud.horzalign = "user_center";
	level.countdown_hud.vertalign = "user_top";
	level.countdown_hud.fontscale = 32;
	level.countdown_hud setshader( "hud_chalk_1", 64, 64 );
	level.countdown_hud SetValue( delay );
	level.countdown_hud.color = ( 1, 1, 1 );
	level.countdown_hud.alpha = 0;
	level.countdown_hud FadeOverTime( 2.0 );
	level.countdown_hud.color = ( 0.21, 0, 0 );
	level.countdown_hud.alpha = 1;
	wait 2;
	level thread zombie_spawn_wait();

	while (delay >= 1)
	{
		wait 1;
		delay--;
		level.countdown_hud SetValue( delay );
	}

	level.countdown_hud FadeOverTime( 1.0 );
	level.countdown_hud.color = (1,1,1);
	level.countdown_hud.alpha = 0;
	wait( 1.0 );
	
	foreach(player in level.players)
		player.round_timer settimerup(0);
	level.countdown_hud destroy_hud();
}

remove_boards_from_windows()
{
	if(!getDvarInt("st_remove_boards"))
		return;

	flag_wait( "initial_blackscreen_passed" );

	maps\mp\zombies\_zm_blockers::open_all_zbarriers();
}

turn_on_power() //by xepixtvx
{
	if(!getDvarInt("st_power_on"))
		return;

	flag_wait( "initial_blackscreen_passed" );
	wait 5;
	trig = getEnt( "use_elec_switch", "targetname" );
	powerSwitch = getEnt( "elec_switch", "targetname" );
	powerSwitch notSolid();
	trig setHintString( &"ZOMBIE_ELECTRIC_SWITCH" );
	trig setVisibleToAll();
	trig notify( "trigger", self );
	trig setInvisibleToAll();
	powerSwitch rotateRoll( -90, 0, 3 );
	level thread maps\mp\zombies\_zm_perks::perk_unpause_all_perks();
	powerSwitch waittill( "rotatedone" );
	flag_set( "power_on" );
	level setClientField( "zombie_power_on", 1 ); 
}

/*
* *****************************************************
*	
* ****************** Weapons\Perks ********************
*
* *****************************************************
*/

give_perks_on_revive()
{
    if(!getDvarInt("st_perks"))
        return;

	level endon("end_game");
	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
        self give_perks_by_map();
	}
}

give_perks_on_spawn()
{
	if(!getDvarInt("st_perks"))
		return;

    level waittill("initial_blackscreen_passed");
    wait 0.5;
    self give_perks_by_map();
}

give_perks_by_map()
{
    if (isfarm())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(istown())
    {
        perks = array( "specialty_fastreload", "specialty_longersprint", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if (istranzit())
    {
        perks = array( "specialty_armorvest", "specialty_longersprint", "specialty_fastreload", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(isnuketown())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(isdierise())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(ismob())
    {
        flag_wait( "afterlife_start_over" );
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_rof", "specialty_grenadepulldeath" );
        self give_perks( perks );
    }
    if(isburied())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_rof", "specialty_longersprint", "specialty_quickrevive" );
        self give_perks( perks );
    }
    if(isorigins())
    {
        perks = array( "specialty_armorvest", "specialty_fastreload", "specialty_additionalprimaryweapon", "specialty_flakjacket", "specialty_rof", "specialty_longersprint", "specialty_quickrevive" );
        self give_perks( perks );
    }
}

give_perks( perk_array )
{
	foreach( perk in perk_array )
	{
		self give_perk( perk, 0 );
		wait 0.15;
	}
}

give_weapons_on_spawn()
{
	if(!getDvarInt("st_weapons"))
		return;
	
    level waittill("initial_blackscreen_passed");

    switch( level.script )
    {
        case "zm_transit":
        	location = level.scr_zm_map_start_location;
            if ( location == "farm" )
            {
				self giveweapon_nzv( "raygun_mark2_zm" );
                self giveweapon_nzv( "cymbal_monkey_zm" );
                self giveweapon_nzv( "qcw05_zm" );
            }
            else if ( location == "town" )
            {
                self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
                self giveweapon_nzv( "m1911_upgraded_zm" );
                self giveweapon_nzv( "cymbal_monkey_zm" );
                self giveweapon_nzv( "tazer_knuckles_zm" );
                self switchToWeapon( "raygun_mark2_upgraded_zm" );
            }
            else if ( location == "transit" && !is_classic() ) //depot
            {
				self giveweapon_nzv( "raygun_mark2_zm" );
                self giveweapon_nzv( "qcw05_zm" );
                self giveweapon_nzv( "cymbal_monkey_zm" );
                self giveweapon_nzv( "tazer_knuckles_zm" );
            }
            else if ( location == "transit" )
            {
                self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
                self giveweapon_nzv( "m1911_upgraded_zm" );
                self giveweapon_nzv( "jetgun_zm" );
                self giveweapon_nzv( "cymbal_monkey_zm" );
                self giveweapon_nzv( "tazer_knuckles_zm" );
                self switchToWeapon( "raygun_mark2_upgraded_zm" );
            }
            break;
        case "zm_nuked":
            self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
            self giveweapon_nzv( "m1911_upgraded_zm" );
            self giveweapon_nzv( "cymbal_monkey_zm" );
            self switchToWeapon( "raygun_mark2_upgraded_zm" );
            break;
        case "zm_highrise":
            self giveweapon_nzv( "slipgun_zm" );
            self giveweapon_nzv( "qcw05_zm" );
            self giveweapon_nzv( "cymbal_monkey_zm" );
            self switchToWeapon( "slipgun_zm" );
            break;
        case "zm_prison":
            flag_wait( "afterlife_start_over" );
            self giveweapon_nzv( "blundersplat_upgraded_zm" );
            self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
			self giveweapon_nzv( "claymore_zm" );
            self giveweapon_nzv( "upgraded_tomahawk_zm" );
            self setclientfieldtoplayer( "upgraded_tomahawk_in_use", 1 );
            break;
        case "zm_buried":
            self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
            self giveweapon_nzv( "m1911_upgraded_zm" );
            self giveweapon_nzv( "slowgun_upgraded_zm" );
            self giveweapon_nzv( "cymbal_monkey_zm" );
			self giveweapon_nzv( "claymore_zm" );
            self switchToWeapon( "slowgun_upgraded_zm" );
            break;
        case "zm_tomb":
			if( cointoss() )
            	self giveweapon_nzv( "staff_air_upgraded_zm" );
			else
				self giveweapon_nzv( "staff_water_upgraded_zm" );
            self giveweapon_nzv( "raygun_mark2_upgraded_zm" );
            self giveweapon_nzv( "cymbal_monkey_zm" );
            self giveweapon_nzv( "mp40_upgraded_zm" );
			self giveweapon_nzv( "claymore_zm" );
            self switchToWeapon( "staff_air_upgraded_zm" );
			self switchToWeapon( "staff_water_upgraded_zm" );
            break;
    }
}

giveweapon_nzv( weapon )
{
	if( issubstr( weapon, "tomahawk_zm" ) && level.script == "zm_prison" )
	{
		self play_sound_on_ent( "purchase" );
		self notify( "tomahawk_picked_up" );
		level notify( "bouncing_tomahawk_zm_aquired" );
		self notify( "player_obtained_tomahawk" );
		if( weapon == "bouncing_tomahawk_zm" )
		{
			self.tomahawk_upgrade_kills = 0;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 0;
		}
		else
		{
			self.tomahawk_upgrade_kills = 99;
			self.killed_with_only_tomahawk = 1;
			self.killed_something_thq = 1;
			self notify( "tomahawk_upgraded_swap" );
		}
		old_tactical = self get_player_tactical_grenade();
		if( old_tactical != "none" && IsDefined( old_tactical ) )
		{
			self takeweapon( old_tactical );
		}
		self set_player_tactical_grenade( weapon );
		self.current_tomahawk_weapon = weapon;
		gun = self getcurrentweapon();
		self disable_player_move_states( 1 );
		self giveweapon( "zombie_tomahawk_flourish" );
		self switchtoweapon( "zombie_tomahawk_flourish" );
		self waittill_any( "player_downed", "weapon_change_complete" );
		self switchtoweapon( gun );
		self enable_player_move_states();
		self takeweapon( "zombie_tomahawk_flourish" );
		self giveweapon( weapon );
		self givemaxammo( weapon );
		if( !(is_equipment( gun )) && !(is_placeable_mine( gun )) )
		{
			self switchtoweapon( gun );
			self waittill( "weapon_change_complete" );
		}
		else
		{
			primaryweapons = self getweaponslistprimaries();
			if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
			{
				self switchtoweapon( primaryweapons[ 0] );
				self waittill( "weapon_change_complete" );
			}
		}
		self play_weapon_vo( weapon );
	}
	else
	{
		if( issubstr( weapon, "staff_" ) && isorigins() )
		{
			if( issubstr( weapon, "_upgraded_zm" ) )
			{
				if( !(self hasweapon( "staff_revive_zm" )) )
				{
					self setactionslot( 3, "weapon", "staff_revive_zm" );
					self giveweapon( "staff_revive_zm" );
				}
				self givemaxammo( "staff_revive_zm" );
			}
			else
			{
				if( self hasweapon( "staff_revive_zm" ) )
				{
					self takeweapon( "staff_revive_zm" );
					self setactionslot( 3, "altmode" );
				}
			}
			self weapon_give( weapon, undefined, undefined, 0 );
		}
		else
		{
			if( self is_melee_weapon( weapon ) )
			{
				if( weapon == "bowie_knife_zm" || weapon == "tazer_knuckles_zm" )
				{
					// self give_melee_weapon_by_name( weapon );
					self give_melee_weapon_instant( weapon );
				}
				else
				{
					self play_sound_on_ent( "purchase" );
					gun = self getcurrentweapon();
					gun = self change_melee_weapon( weapon, gun );
					self giveweapon( weapon );
					if( !(is_equipment( gun )) && !(is_placeable_mine( gun )) )
					{
						self switchtoweapon( gun );
						self waittill( "weapon_change_complete" );
					}
					else
					{
						primaryweapons = self getweaponslistprimaries();
						if( primaryweapons.size > 0 && IsDefined( primaryweapons ) )
						{
							self switchtoweapon( primaryweapons[ 0] );
							self waittill( "weapon_change_complete" );
						}
					}
					self play_weapon_vo( weapon );
				}
			}
			else
			{
				if( self is_equipment( weapon ) )
				{
					self play_sound_on_ent( "purchase" );
					if( level.destructible_equipment.size > 0 && IsDefined( level.destructible_equipment ) )
					{
						i = 0;
						while( i < level.destructible_equipment.size )
						{
							equip = level.destructible_equipment[ i];
							if( equip.name == weapon && IsDefined( equip.name ) && equip.owner == self && IsDefined( equip.owner ) )
							{
								equip item_damage( 9999 );
								break;
							}
							else
							{
								if( equip.name == weapon && IsDefined( equip.name ) && weapon == "jetgun_zm" )
								{
									equip item_damage( 9999 );
									break;
								}
								else
								{
									i++;
								}
							}
							i++;
						}
					}
					self equipment_take( weapon );
					self equipment_buy( weapon );
					self play_weapon_vo( weapon );
				}
				else
				{
					if( self is_weapon_upgraded( weapon ) )
					{
						self weapon_give( weapon, 1, undefined, 0 );
					}
					else
					{
						self weapon_give( weapon, undefined, undefined, 0 );
					}
				}
			}
		}
	}
}

give_melee_weapon_instant( weapon_name )
{
	self giveweapon( weapon_name );
	gun = change_melee_weapon( weapon_name, "knife_zm" );
	if ( self hasweapon( "knife_zm" ) )
		self takeweapon( "knife_zm" );

    gun = self getcurrentweapon();
	if ( gun != "none" && !is_placeable_mine( gun ) && !is_equipment( gun ) )
		self switchtoweapon( gun );
}


/*
* *****************************************************
*	
* *********************** HUD *************************
*
* *****************************************************
*/

zombie_remaining_hud()
{
	self endon( "disconnect" );
	level endon( "end_game" );

	level waittill( "start_of_round" );

    self.zombie_counter_hud = maps\mp\gametypes_zm\_hud_util::createFontString( "hudsmall" , 1.4 );
    self.zombie_counter_hud maps\mp\gametypes_zm\_hud_util::setPoint( "CENTER", "CENTER", "CENTER", 190 );
    self.zombie_counter_hud.alpha = 0;
    self.zombie_counter_hud.label = &"Zombies: ^1";
	self thread zombie_remaining_hud_watcher();

    while(true)
    {
        self.zombie_counter_hud setValue( ( maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total ) );
        wait 0.05; 
    }
}

zombie_remaining_hud_watcher()
{	
	self endon("disconnect");
	level endon( "end_game" );

	while(true)
	{
		self.zombie_counter_hud.alpha = getDvarInt("hud_remaining");
        wait 0.1;
	}
}

zone_hud()
{
	if(!getDvarInt("hud_zone"))
		return;

	self endon("disconnect");

	x = 8;
	y = -111;
	if (isburied())
		y -= 25;
	if (isorigins())
		y -= 30;

	self.zone_hud = newClientHudElem(self);
	self.zone_hud.alignx = "left";
	self.zone_hud.aligny = "bottom";
	self.zone_hud.horzalign = "user_left";
	self.zone_hud.vertalign = "user_bottom";
	self.zone_hud.x += x;
	self.zone_hud.y += y;
	self.zone_hud.fontscale = 1.3;
	self.zone_hud.alpha = 0;
	self.zone_hud.color = ( 1, 1, 1 );
	self.zone_hud.hidewheninmenu = 1;

	flag_wait( "initial_blackscreen_passed" );

	self thread zone_hud_watcher(x, y);
}

zone_hud_watcher( x, y )
{	
	self endon("disconnect");
	level endon( "end_game" );

	prev_zone = "";
	while(true)
	{
		while( !getDvarInt("hud_zone") )
			wait 0.1;

		self.zone_hud.alpha = 1;

		while( getDvarInt("hud_zone") )
		{
			self.zone_hud.y = (y + (self.zone_hud_offset * !level.hud_health_bar ) );

			zone = self get_zone_name();
			if(prev_zone != zone)
			{
				prev_zone = zone;

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 0;
				wait 0.2;

				self.zone_hud settext(zone);

				self.zone_hud fadeovertime(0.2);
				self.zone_hud.alpha = 1;
				wait 0.15;
			}

			wait 0.05;
		}
		self.zone_hud.alpha = 0;
	}
}

get_zone_name()
{
	zone = self get_current_zone();
	if (!isDefined(zone))
		return "";

	name = "";

	if (istranzit())
	{
        switch(zone)
        {
            case "zone_pri": name = "Bus Depot"; break;
            case "zone_pri2": name = "Bus Depot Hallway"; break;
            case "zone_station_ext": name = "Outside Bus Depot"; break;
            case "zone_trans_2b": name = "Fog After Bus Depot"; break;
            case "zone_trans_2": name = "Tunnel Entrance"; break;
            case "zone_amb_tunnel": name = "Tunnel"; break;
            case "zone_trans_3": name = "Tunnel Exit"; break;
            case "zone_roadside_west": name = "Outside Diner"; break;
            case "zone_gas": name = "Gas Station"; break;
            case "zone_roadside_east": name = "Outside Garage"; break;
            case "zone_trans_diner": name = "Fog Outside Diner"; break;
            case "zone_trans_diner2": name = "Fog Outside Garage"; break;
            case "zone_gar": name = "Garage"; break;
            case "zone_din": name = "Diner"; break;
            case "zone_diner_roof": name = "Diner Roof"; break;
            case "zone_trans_4": name = "Fog After Diner"; break;
            case "zone_amb_forest": name = "Forest"; break;
            case "zone_trans_10": name = "Outside Church"; break;
            case "zone_town_church": name = "Church"; break;
            case "zone_trans_5": name = "Fog Before Farm"; break;
            case "zone_far": name = "Outside Farm"; break;
            case "zone_far_ext": name = "Farm"; break;
            case "zone_brn": name = "Barn"; break;
            case "zone_farm_house": name = "Farmhouse"; break;
            case "zone_trans_6": name = "Fog After Farm"; break;
            case "zone_amb_cornfield": name = "Cornfield"; break;
            case "zone_cornfield_prototype": name = "Nacht"; break;
            case "zone_trans_7": name = "Upper Fog Before Power"; break;
            case "zone_trans_pow_ext1": name = "Fog Before Power"; break;
            case "zone_pow": name = "Outside Power Station"; break;
            case "zone_prr": name = "Power Station"; break;
            case "zone_pcr": name = "Power Control Room"; break;
            case "zone_pow_warehouse": name = "Warehouse"; break;
            case "zone_trans_8": name = "Fog After Power"; break;
            case "zone_amb_power2town": name = "Cabin"; break;
            case "zone_trans_9": name = "Fog Before Town"; break;
            case "zone_town_north": name = "North Town"; break;
            case "zone_tow": name = "Center Town"; break;
            case "zone_town_east": name = "East Town"; break;
            case "zone_town_west": name = "West Town"; break;
            case "zone_town_south": name = "South Town"; break;
            case "zone_bar": name = "Bar"; break;
            case "zone_town_barber": name = "Bookstore"; break;
            case "zone_ban": name = "Bank"; break;
            case "zone_ban_vault": name = "Bank Vault"; break;
            case "zone_tbu": name = "Below Bank"; break;
            case "zone_trans_11": name = "Fog After Town"; break;
            case "zone_amb_bridge": name = "Bridge"; break;
            case "zone_trans_1": name = "Fog Before Bus Depot"; break;
        }
		return name;
	}
	if (isnuketown())
	{
        switch (zone)
        {
            case "culdesac_yellow_zone": name = "Yellow House Middle"; break;
            case "culdesac_green_zone": name = "Green House Middle"; break;
            case "truck_zone": name = "Truck"; break;
            case "openhouse1_f1_zone": name = "Green House Downstairs"; break;
            case "openhouse1_f2_zone": name = "Green House Upstairs"; break;
            case "openhouse1_backyard_zone": name = "Green House Backyard"; break;
            case "openhouse2_f1_zone": name = "Yellow House Downstairs"; break;
            case "openhouse2_f2_zone": name = "Yellow House Upstairs"; break;
            case "openhouse2_backyard_zone": name = "Yellow House Backyard"; break;
            case "ammo_door_zone": name = "Yellow House Backyard Door"; break;
        }
		return name;
	}
	if (isdierise())
	{
        switch (zone)
        {
            case "zone_green_start": name = "Green Highrise Level 3b"; break;
            case "zone_green_escape_pod": name = "Escape Pod"; break;
            case "zone_green_escape_pod_ground": name = "Escape Pod Shaft"; break;
            case "zone_green_level1": name = "Green Highrise Level 3a"; break;
            case "zone_green_level2a": name = "Green Highrise Level 2a"; break;
            case "zone_green_level2b": name = "Green Highrise Level 2b"; break;
            case "zone_green_level3a": name = "Green Highrise Restaurant"; break;
            case "zone_green_level3b": name = "Green Highrise Level 1a"; break;
            case "zone_green_level3c": name = "Green Highrise Level 1b"; break;
            case "zone_green_level3d": name = "Green Highrise Behind Restaurant"; break;
            case "zone_orange_level1": name = "Upper Orange Highrise Level 2"; break;
            case "zone_orange_level2": name = "Upper Orange Highrise Level 1"; break;
            case "zone_orange_elevator_shaft_top": name = "Elevator Shaft Level 3"; break;
            case "zone_orange_elevator_shaft_middle_1": name = "Elevator Shaft Level 2"; break;
            case "zone_orange_elevator_shaft_middle_2": name = "Elevator Shaft Level 1"; break;
            case "zone_orange_elevator_shaft_bottom": name = "Elevator Shaft Bottom"; break;
            case "zone_orange_level3a": name = "Lower Orange Highrise Level 1a"; break;
            case "zone_orange_level3b": name = "Lower Orange Highrise Level 1b"; break;
            case "zone_blue_level5": name = "Lower Blue Highrise Level 1"; break;
            case "zone_blue_level4a": name = "Lower Blue Highrise Level 2a"; break;
            case "zone_blue_level4b": name = "Lower Blue Highrise Level 2b"; break;
            case "zone_blue_level4c": name = "Lower Blue Highrise Level 2c"; break;
            case "zone_blue_level2a": name = "Upper Blue Highrise Level 1a"; break;
            case "zone_blue_level2b": name = "Upper Blue Highrise Level 1b"; break;
            case "zone_blue_level2c": name = "Upper Blue Highrise Level 1c"; break;
            case "zone_blue_level2d": name = "Upper Blue Highrise Level 1d"; break;
            case "zone_blue_level1a": name = "Upper Blue Highrise Level 2a"; break;
            case "zone_blue_level1b": name = "Upper Blue Highrise Level 2b"; break;
            case "zone_blue_level1c": name = "Upper Blue Highrise Level 2c"; break;
        }
	}
	if (ismob())
	{
        switch (zone)
        {
            case "zone_start": name = "D-Block"; break;
            case "zone_library": name = "Library"; break;
            case "zone_cellblock_west": name = "Cellblock 2nd Floor"; break;
            case "zone_cellblock_west_gondola": name = "Cellblock 3rd Floor"; break;
            case "zone_cellblock_west_gondola_dock": name = "Cellblock Gondola"; break;
            case "zone_cellblock_west_barber": name = "Michigan Avenue"; break;
            case "zone_cellblock_east": name = "Times Square"; break;
            case "zone_cafeteria": name = "Cafeteria"; break;
            case "zone_cafeteria_end": name = "Cafeteria End"; break;
            case "zone_infirmary": name = "Infirmary 1"; break;
            case "zone_infirmary_roof": name = "Infirmary 2"; break;
            case "zone_roof_infirmary": name = "Roof 1"; break;
            case "zone_roof": name = "Roof 2"; break;
            case "zone_cellblock_west_warden": name = "Sally Port"; break;
            case "zone_warden_office": name = "Warden's Office"; break;
            case "cellblock_shower": name = "Showers"; break;
            case "zone_citadel_shower": name = "Citadel To Showers"; break;
            case "zone_citadel": name = "Citadel"; break;
            case "zone_citadel_warden": name = "Citadel To Warden's Office"; break;
            case "zone_citadel_stairs": name = "Citadel Tunnels"; break;
            case "zone_citadel_basement": name = "Citadel Basement"; break;
            case "zone_citadel_basement_building": name = "China Alley"; break;
            case "zone_studio": name = "Building 64"; break;
            case "zone_dock": name = "Docks"; break;
            case "zone_dock_puzzle": name = "Docks Gates"; break;
            case "zone_dock_gondola": name = "Upper Docks"; break;
            case "zone_golden_gate_bridge": name = "Golden Gate Bridge"; break;
            case "zone_gondola_ride": name = "Gondola"; break;
        }
		return name;
	}
	if (isburied())
	{
        switch (zone)
        {
            case "zone_start": name = "Processing"; break;
            case "zone_start_lower": name = "Lower Processing"; break;
            case "zone_tunnels_center": name = "Center Tunnels"; break;
            case "zone_tunnels_north": name = "Courthouse Tunnels 2"; break;
            case "zone_tunnels_north2": name = "Courthouse Tunnels 1"; break;
            case "zone_tunnels_south": name = "Saloon Tunnels 3"; break;
            case "zone_tunnels_south2": name = "Saloon Tunnels 2"; break;
            case "zone_tunnels_south3": name = "Saloon Tunnels 1"; break;
            case "zone_street_lightwest": name = "Outside General Store & Bank"; break;
            case "zone_street_lightwest_alley": name = "Outside General Store & Bank Alley"; break;
            case "zone_morgue_upstairs": name = "Morgue"; break;
            case "zone_underground_jail": name = "Jail Downstairs"; break;
            case "zone_underground_jail2": name = "Jail Upstairs"; break;
            case "zone_general_store": name = "General Store"; break;
            case "zone_stables": name = "Stables"; break;
            case "zone_street_darkwest": name = "Outside Gunsmith"; break;
            case "zone_street_darkwest_nook": name = "Outside Gunsmith Nook"; break;
            case "zone_gun_store": name = "Gunsmith"; break;
            case "zone_bank": name = "Bank"; break;
            case "zone_tunnel_gun2stables": name = "Stables To Gunsmith Tunnel 2"; break;
            case "zone_tunnel_gun2stables2": name = "Stables To Gunsmith Tunnel"; break;
            case "zone_street_darkeast": name = "Outside Saloon & Toy Store"; break;
            case "zone_street_darkeast_nook": name = "Outside Saloon & Toy Store Nook"; break;
            case "zone_underground_bar": name = "Saloon"; break;
            case "zone_tunnel_gun2saloon": name = "Saloon To Gunsmith Tunnel"; break;
            case "zone_toy_store": name = "Toy Store Downstairs"; break;
            case "zone_toy_store_floor2": name = "Toy Store Upstairs"; break;
            case "zone_toy_store_tunnel": name = "Toy Store Tunnel"; break;
            case "zone_candy_store": name = "Candy Store Downstairs"; break;
            case "zone_candy_store_floor2": name = "Candy Store Upstairs"; break;
            case "zone_street_lighteast": name = "Outside Courthouse & Candy Store"; break;
            case "zone_underground_courthouse": name = "Courthouse Downstairs"; break;
            case "zone_underground_courthouse2": name = "Courthouse Upstairs"; break;
            case "zone_street_fountain": name = "Fountain"; break;
            case "zone_church_graveyard": name = "Graveyard"; break;
            case "zone_church_main": name = "Church Downstairs"; break;
            case "zone_church_upstairs": name = "Church Upstairs"; break;
            case "zone_mansion_lawn": name = "Mansion Lawn"; break;
            case "zone_mansion": name = "Mansion"; break;
            case "zone_mansion_backyard": name = "Mansion Backyard"; break;
            case "zone_maze": name = "Maze"; break;
            case "zone_maze_staircase": name = "Maze Staircase"; break;
        }
		return name;
	}
	else if (isorigins())
	{
        switch (zone)
        {
            case "zone_start": name = "Lower Laboratory"; break;
            case "zone_start_a": name = "Upper Laboratory"; break;
            case "zone_start_b": name = "Generator 1"; break;
            case "zone_bunker_1a": name = "Generator 3 Bunker 1"; break;
            case "zone_fire_stairs": name = "Fire Tunnel"; break;
            case "zone_bunker_1": name = "Generator 3 Bunker 2"; break;
            case "zone_bunker_3a": name = "Generator 3"; break;
            case "zone_bunker_3b": name = "Generator 3 Bunker 3"; break;
            case "zone_bunker_2a": name = "Generator 2 Bunker 1"; break;
            case "zone_bunker_2": name = "Generator 2 Bunker 2"; break;
            case "zone_bunker_4a": name = "Generator 2"; break;
            case "zone_bunker_4b": name = "Generator 2 Bunker 3"; break;
            case "zone_bunker_4c": name = "Tank Station"; break;
            case "zone_bunker_4d": name = "Above Tank Station"; break;
            case "zone_bunker_tank_c": name = "Generator 2 Tank Route 1"; break;
            case "zone_bunker_tank_c1": name = "Generator 2 Tank Route 2"; break;
            case "zone_bunker_4e": name = "Generator 2 Tank Route 3"; break;
            case "zone_bunker_tank_d": name = "Generator 2 Tank Route 4"; break;
            case "zone_bunker_tank_d1": name = "Generator 2 Tank Route 5"; break;
            case "zone_bunker_4f": name = "zone_bunker_4f"; break;
            case "zone_bunker_5a": name = "Workshop Downstairs"; break;
            case "zone_bunker_5b": name = "Workshop Upstairs"; break;
            case "zone_nml_2a": name = "No Man's Land Walkway"; break;
            case "zone_nml_2": name = "No Man's Land Entrance"; break;
            case "zone_bunker_tank_e": name = "Generator 5 Tank Route 1"; break;
            case "zone_bunker_tank_e1": name = "Generator 5 Tank Route 2"; break;
            case "zone_bunker_tank_e2": name = "zone_bunker_tank_e2"; break;
            case "zone_bunker_tank_f": name = "Generator 5 Tank Route 3"; break;
            case "zone_nml_1": name = "Generator 5 Tank Route 4"; break;
            case "zone_nml_4": name = "Generator 5 Tank Route 5"; break;
            case "zone_nml_0": name = "Generator 5 Left Footstep"; break;
            case "zone_nml_5": name = "Generator 5 Right Footstep Walkway"; break;
            case "zone_nml_farm": name = "Generator 5"; break;
            case "zone_nml_celllar": name = "Generator 5 Cellar"; break;
            case "zone_bolt_stairs": name = "Lightning Tunnel"; break;
            case "zone_nml_3": name = "No Man's Land 1st Right Footstep"; break;
            case "zone_nml_2b": name = "No Man's Land Stairs"; break;
            case "zone_nml_6": name = "No Man's Land Left Footstep"; break;
            case "zone_nml_8": name = "No Man's Land 2nd Right Footstep"; break;
            case "zone_nml_10a": name = "Generator 4 Tank Route 1"; break;
            case "zone_nml_10": name = "Generator 4 Tank Route 2"; break;
            case "zone_nml_7": name = "Generator 4 Tank Route 3"; break;
            case "zone_bunker_tank_a": name = "Generator 4 Tank Route 4"; break;
            case "zone_bunker_tank_a1": name = "Generator 4 Tank Route 5"; break;
            case "zone_bunker_tank_a2": name = "zone_bunker_tank_a2"; break;
            case "zone_bunker_tank_b": name = "Generator 4 Tank Route 6"; break;
            case "zone_nml_9": name = "Generator 4 Left Footstep"; break;
            case "zone_air_stairs": name = "Wind Tunnel"; break;
            case "zone_nml_11": name = "Generator 4"; break;
            case "zone_nml_12": name = "Generator 4 Right Footstep"; break;
            case "zone_nml_16": name = "Excavation Site Front Path"; break;
            case "zone_nml_17": name = "Excavation Site Back Path"; break;
            case "zone_nml_18": name = "Excavation Site Level 3"; break;
            case "zone_nml_19": name = "Excavation Site Level 2"; break;
            case "ug_bottom_zone": name = "Excavation Site Level 1"; break;
            case "zone_nml_13": name = "Generator 5 To Generator 6 Path"; break;
            case "zone_nml_14": name = "Generator 4 To Generator 6 Path"; break;
            case "zone_nml_15": name = "Generator 6 Entrance"; break;
            case "zone_village_0": name = "Generator 6 Left Footstep"; break;
            case "zone_village_5": name = "Generator 6 Tank Route 1"; break;
            case "zone_village_5a": name = "Generator 6 Tank Route 2"; break;
            case "zone_village_5b": name = "Generator 6 Tank Route 3"; break;
            case "zone_village_1": name = "Generator 6 Tank Route 4"; break;
            case "zone_village_4b": name = "Generator 6 Tank Route 5"; break;
            case "zone_village_4a": name = "Generator 6 Tank Route 6"; break;
            case "zone_village_4": name = "Generator 6 Tank Route 7"; break;
            case "zone_village_2": name = "Church"; break;
            case "zone_village_3": name = "Generator 6 Right Footstep"; break;
            case "zone_village_3a": name = "Generator 6"; break;
            case "zone_ice_stairs": name = "Ice Tunnel"; break;
            case "zone_bunker_6": name = "Above Generator 3 Bunker"; break;
            case "zone_nml_20": name = "Above No Man's Land"; break;
            case "zone_village_6": name = "Behind Church"; break;
            case "zone_chamber_0": name = "The Crazy Place Lightning Chamber"; break;
            case "zone_chamber_1": name = "The Crazy Place Lightning & Ice"; break;
            case "zone_chamber_2": name = "The Crazy Place Ice Chamber"; break;
            case "zone_chamber_3": name = "The Crazy Place Fire & Lightning"; break;
            case "zone_chamber_4": name = "The Crazy Place Center"; break;
            case "zone_chamber_5": name = "The Crazy Place Ice & Wind"; break;
            case "zone_chamber_6": name = "The Crazy Place Fire Chamber"; break;
            case "zone_chamber_7": name = "The Crazy Place Wind & Fire"; break;
            case "zone_chamber_8": name = "The Crazy Place Wind Chamber"; break;
            case "zone_robot_head": name = "Robot's Head"; break;
        }
		return name;
	}
		return name;
}


/*
* *****************************************************
*	
* ******************** Buildables *********************
*
* *****************************************************
*/

tomb_give_shovel()
{
	if( level.script != "zm_tomb" )
		return;

	self.dig_vars[ "has_shovel" ] = 1;
	n_player = self getentitynumber() + 1;
	level setclientfield( "shovel_player" + n_player, 1 );
}

buildbuildables()
{
	if(is_classic())
	{
		if(istranzit())
		{
			buildbuildable( "turbine" );
			buildbuildable( "electric_trap" );
			buildbuildable( "turret" );
			buildbuildable( "riotshield_zm" );
			buildbuildable( "jetgun_zm" );
			buildbuildable( "powerswitch", 1 );
			buildbuildable( "pap", 1 );
			buildbuildable( "sq_common", 1 );
			buildbuildable( "dinerhatch", 1 );
			buildbuildable( "bushatch", 1 );
			buildbuildable( "busladder", 1 );
			removebuildable( "dinerhatch" );
			removebuildable( "bushatch" );
			removebuildable( "busladder" );

			getent( "powerswitch_p6_zm_buildable_pswitch_hand", "targetname" ) show();
			getent( "powerswitch_p6_zm_buildable_pswitch_body", "targetname" ) show();
			getent( "powerswitch_p6_zm_buildable_pswitch_lever", "targetname" ) show();
		}
		if(isdierise())
		{
			buildbuildable( "slipgun_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "sq_common", 1 );
		}
	    if(isburied())
		{
			level waittill( "buildables_setup" );
			wait 0.05;

			level.buildables_available = array("subwoofer_zm", "springpad_zm", "headchopper_zm", "turbine");

			buildbuildable( "turbine" );
			buildbuildable( "subwoofer_zm" );
			buildbuildable( "springpad_zm" );
			buildbuildable( "headchopper_zm" );
			buildbuildable( "sq_common", 1 );
		}
	}
}

buildbuildable( buildable, craft )
{
	if (!isDefined(craft))
		craft = 0;

	player = get_players()[ 0 ];
	foreach (stub in level.buildable_stubs)
	{
		if ( !isDefined( buildable ) || stub.equipname == buildable && (isDefined( buildable ) || stub.persistent != 3))
		{
            if (craft)
            {
                stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build( player );
                stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
                stub.model notsolid();
                stub.model show();
            }
            else
            {
                equipname = stub get_equipname();
                level.zombie_buildables[stub.equipname].hint = "Hold ^3[{+activate}]^7 to craft " + equipname;
                stub.prompt_and_visibility_func = ::buildabletrigger_update_prompt;
            }

            i = 0;
            foreach (piece in stub.buildablezone.pieces)
            {
                piece maps\mp\zombies\_zm_buildables::piece_unspawn();
                if (!craft && i > 0)
                    stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_set_piece_built(piece);
                i++;
            }

            return;
		}
	}
}

get_equipname()
{
    switch(self.equipname)
    {
	    case   "turbine": return "Turbine";
	    case   "electric_trap": return "Electric Trap";
	    case   "riotshield_zm": return "Zombie Shield";
	    case   "jetgun_zm": return "Jet Gun";
	    case   "slipgun_zm": return "Sliquifier";
	    case   "subwoofer_zm": return "Subsurface Resonator";
	    case   "springpad_zm": return "Trample Steam";
	    case   "headchopper_zm": return "Head Chopper";
    }
}
buildabletrigger_update_prompt( player )
{
	can_use = 0;
	if (isDefined(level.buildablepools))
		can_use = self.stub pooledbuildablestub_update_prompt( player, self );
	else
		can_use = self.stub buildablestub_update_prompt( player, self );
	
	self sethintstring( self.stub.hint_string );
	if ( isDefined( self.stub.cursor_hint ) )
	{
		if ( self.stub.cursor_hint == "HINT_WEAPON" && isDefined( self.stub.cursor_hint_weapon ) )
			self setcursorhint( self.stub.cursor_hint, self.stub.cursor_hint_weapon );
		else
			self setcursorhint( self.stub.cursor_hint );
	}
	return can_use;
}

buildablestub_update_prompt( player, trigger )
{
	if ( !self maps\mp\zombies\_zm_buildables::anystub_update_prompt( player ) )
		return 0;

	if ( isDefined( self.buildablestub_reject_func ) )
	{
		rval = self [[ self.buildablestub_reject_func ]]( player );
		if ( rval )
			return 0;
	}

	if ( isDefined( self.custom_buildablestub_update_prompt ) && !( self [[ self.custom_buildablestub_update_prompt ]]( player ) ) )
		return 0;

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if ( isDefined( self.built ) && !self.built )
	{
		slot = self.buildablestruct.buildable_slot;
		piece = self.buildablezone.pieces[0];
		player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

		if ( !isDefined( player maps\mp\zombies\_zm_buildables::player_get_buildable_piece( slot ) ) )
		{
			if ( isDefined( level.zombie_buildables[ self.equipname ].hint_more ) )
				self.hint_string = level.zombie_buildables[ self.equipname ].hint_more;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
			return 0;
		}
		else
		{
			if ( !self.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( player maps\mp\zombies\_zm_buildables::player_get_buildable_piece( slot ) ) )
			{
				if ( isDefined( level.zombie_buildables[ self.equipname ].hint_wrong ) )
					self.hint_string = level.zombie_buildables[ self.equipname ].hint_wrong;
				else
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";

				return 0;
			}
			else
			{
				if ( isDefined( level.zombie_buildables[ self.equipname ].hint ) )
					self.hint_string = level.zombie_buildables[ self.equipname ].hint;
				else
					self.hint_string = "Missing buildable hint";
			}
		}
	}
	else
	{
		if ( self.persistent == 1 )
		{
			if ( maps\mp\zombies\_zm_equipment::is_limited_equipment( self.weaponname ) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use( self.weaponname ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
				return 0;
			}

			if ( player has_player_equipment( self.weaponname ) )
			{
				self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
				return 0;
			}

			self.hint_string = self.trigger_hintstring;
		}
		else if ( self.persistent == 2 )
		{
			if ( !maps\mp\zombies\_zm_weapons::limited_weapon_below_quota( self.weaponname, undefined ) )
			{
				self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
				return 0;
			}
			else
				if ( isDefined( self.bought ) && self.bought )
				{
					self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
					return 0;
				}
			self.hint_string = self.trigger_hintstring;
		}
		else
		{
			self.hint_string = "";
			return 0;
		}
	}
	return 1;
}

pooledbuildablestub_update_prompt( player, trigger )
{
	if ( !self maps\mp\zombies\_zm_buildables::anystub_update_prompt( player ) )
		return 0;

	if ( isDefined( self.custom_buildablestub_update_prompt ) && !( self [[ self.custom_buildablestub_update_prompt ]]( player ) ) )
		return 0;

	self.cursor_hint = "HINT_NOICON";
	self.cursor_hint_weapon = undefined;
	if ( isDefined( self.built ) && !self.built )
	{
		trigger thread buildablestub_build_succeed();

		if (level.buildables_available.size > 1)
			self thread choose_open_buildable(player);

		slot = self.buildablestruct.buildable_slot;

		if (self.buildables_available_index >= level.buildables_available.size)
			self.buildables_available_index = 0;

		foreach (stub in level.buildable_stubs)
			if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
			{
				piece = stub.buildablezone.pieces[0];
				break;
			}

		player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

		piece = player maps\mp\zombies\_zm_buildables::player_get_buildable_piece(slot);

		if ( !isDefined( piece ) )
		{
			if ( isDefined( level.zombie_buildables[ self.equipname ].hint_more ) )
				self.hint_string = level.zombie_buildables[ self.equipname ].hint_more;
			else
				self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";

			if ( isDefined( level.custom_buildable_need_part_vo ) )
				player thread [[ level.custom_buildable_need_part_vo ]]();

			return 0;
		}
		else
		{
			if ( isDefined( self.bound_to_buildable ) && !self.bound_to_buildable.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( piece ) )
			{
				if ( isDefined( level.zombie_buildables[ self.bound_to_buildable.equipname ].hint_wrong ) )
					self.hint_string = level.zombie_buildables[ self.bound_to_buildable.equipname ].hint_wrong;
				else
					self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";

				if ( isDefined( level.custom_buildable_wrong_part_vo ) )
					player thread [[ level.custom_buildable_wrong_part_vo ]]();

				return 0;
			}
			else
			{
				if ( !isDefined( self.bound_to_buildable ) && !self.buildable_pool pooledbuildable_has_piece( piece ) )
				{
					if ( isDefined( level.zombie_buildables[ self.equipname ].hint_wrong ) )
						self.hint_string = level.zombie_buildables[ self.equipname ].hint_wrong;
					else
						self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";

					return 0;
				}
				else
				{
					if ( isDefined( self.bound_to_buildable ) )
					{
						if ( isDefined( level.zombie_buildables[ piece.buildablename ].hint ) )
							self.hint_string = level.zombie_buildables[ piece.buildablename ].hint;
						else
							self.hint_string = "Missing buildable hint";
					}
					
					if ( isDefined( level.zombie_buildables[ piece.buildablename ].hint ) )
						self.hint_string = level.zombie_buildables[ piece.buildablename ].hint;
					else
						self.hint_string = "Missing buildable hint";
				}
			}
		}
	}
	else
	{
		return trigger [[ self.original_prompt_and_visibility_func ]]( player );
	}
	return 1;
}

pooledbuildable_has_piece( piece )
{
	return isDefined( self pooledbuildable_stub_for_piece( piece ) );
}

pooledbuildable_stub_for_piece( piece )
{
	foreach (stub in self.stubs)
		if ( !isDefined( stub.bound_to_buildable ) && stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece( piece ))
            return stub;

	return undefined;
}

choose_open_buildable( player )
{
	self endon( "kill_choose_open_buildable" );

	n_playernum = player getentitynumber();
	b_got_input = 1;
	hinttexthudelem = newclienthudelem( player );
	hinttexthudelem.alignx = "center";
	hinttexthudelem.aligny = "middle";
	hinttexthudelem.horzalign = "center";
	hinttexthudelem.vertalign = "bottom";
	hinttexthudelem.y = -100;
	hinttexthudelem.foreground = 1;
	hinttexthudelem.font = "default";
	hinttexthudelem.fontscale = 1;
	hinttexthudelem.alpha = 1;
	hinttexthudelem.color = ( 1, 1, 1 );
	hinttexthudelem settext( "Press [{+actionslot 1}] or [{+actionslot 2}] to change item" );

	if (!isDefined(self.buildables_available_index))
		self.buildables_available_index = 0;

	while ( isDefined( self.playertrigger[ n_playernum ] ) && !self.built )
	{
		if (!player isTouching(self.playertrigger[n_playernum]))
		{
			hinttexthudelem.alpha = 0;
			wait 0.05;
			continue;
		}

		hinttexthudelem.alpha = 1;

		if ( player actionslotonebuttonpressed() )
		{
			self.buildables_available_index++;
			b_got_input = 1;
		}
		else if ( player actionslottwobuttonpressed() )
            {
                self.buildables_available_index--;

                b_got_input = 1;
            }

		if ( self.buildables_available_index >= level.buildables_available.size )
			self.buildables_available_index = 0;

		else if ( self.buildables_available_index < 0 )
			self.buildables_available_index = level.buildables_available.size - 1;


		if ( b_got_input )
		{
			piece = undefined;
			foreach (stub in level.buildable_stubs)
				if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
				{
					piece = stub.buildablezone.pieces[0];
					break;
				}
			slot = self.buildablestruct.buildable_slot;
			player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

			self.equipname = level.buildables_available[self.buildables_available_index];
			self.hint_string = level.zombie_buildables[self.equipname].hint;
			self.playertrigger[n_playernum] sethintstring(self.hint_string);
			b_got_input = 0;
		}

		if ( player is_player_looking_at( self.playertrigger[n_playernum].origin, 0.76 ) )
			hinttexthudelem.alpha = 1;
		else
			hinttexthudelem.alpha = 0;

		wait 0.05;
	}

	hinttexthudelem destroy();
}

buildablestub_build_succeed()
{
	self notify("buildablestub_build_succeed");
	self endon("buildablestub_build_succeed");

	self waittill( "build_succeed" );

	self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
	arrayremovevalue(level.buildables_available, self.stub.buildablezone.buildable_name);
	if (level.buildables_available.size == 0)
		foreach (stub in level.buildable_stubs)
			switch(stub.equipname)
			{
				case "turbine":
				case "subwoofer_zm":
				case "springpad_zm":
				case "headchopper_zm":
					maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
					break;
			}
}

removebuildable( buildable, after_built )
{
	if (!isDefined(after_built))
		after_built = 0;

	if (after_built)
	{
		foreach (stub in level._unitriggers.trigger_stubs)
			if(IsDefined(stub.equipname) && stub.equipname == buildable)
			{
				stub.model hide();
				maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( stub );
				return;
			}
	}
	else
	{
        foreach (stub in level.buildable_stubs)
            if ( !isDefined( buildable ) || stub.equipname == buildable && (isDefined( buildable ) || stub.persistent != 3))
            {
                stub maps\mp\zombies\_zm_buildables::buildablestub_remove();

                foreach (piece in stub.buildablezone.pieces)
                    piece maps\mp\zombies\_zm_buildables::piece_unspawn();

                maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( stub );
                return;
            }
	}
}

buildable_piece_remove_on_last_stand()
{
	self endon( "disconnect" );

	self thread buildable_get_last_piece();

	while (true)
	{
		self waittill("entering_last_stand");

		if (isDefined(self.last_piece))
			self.last_piece maps\mp\zombies\_zm_buildables::piece_unspawn();
	}
}

buildable_get_last_piece()
{
	self endon( "disconnect" );

	while (true)
	{
		if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
			self.last_piece = maps\mp\zombies\_zm_buildables::player_get_buildable_piece(0);
		wait 0.05;
	}
}


/*
* *****************************************************
*	
* ********** MOTD\Origins style buildables ************
*
* *****************************************************
*/

buildcraftables()
{
	if(is_classic())
	{
		if(level.scr_zm_map_start_location == "prison")
		{
			buildcraftable( "alcatraz_shield_zm" );
			buildcraftable( "packasplat" );
			if(level.is_forever_solo_game)
				buildcraftable( "plane" );
			changecraftableoption( 0 );
		}
		else if(level.scr_zm_map_start_location == "tomb")
		{
			buildcraftable( "tomb_shield_zm" );
			buildcraftable( "equip_dieseldrone_zm" );
			takecraftableparts( "gramophone" );
		}
	}
}

changecraftableoption( index )
{
	foreach (craftable in level.a_uts_craftables)
		if (craftable.equipname == "open_table")
			craftable thread setcraftableoption( index );
}

setcraftableoption( index )
{
	self endon("death");

	while (self.a_uts_open_craftables_available.size <= 0)
		wait 0.05;

	if (self.a_uts_open_craftables_available.size > 1)
	{
		self.n_open_craftable_choice = index;
		self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
		self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
		foreach (trig in self.playertrigger)
			trig sethintstring( self.hint_string );
	}
}

takecraftableparts( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.zombie_include_craftables)
		if ( stub.name == buildable )
			foreach (piece in stub.a_piecestubs)
			{
				piecespawn = piece.piecespawn;
				if ( isDefined( piecespawn ) )
					player player_take_piece_gramophone( piecespawn );
			}
			return;
}

buildcraftable( buildable )
{
	player = get_players()[ 0 ];
	foreach (stub in level.a_uts_craftables)
		if ( stub.craftablestub.name == buildable )
        {
			foreach (piece in stub.craftablespawn.a_piecespawns)
			{
				piecespawn = get_craftable_piece( stub.craftablestub.name, piece.piecename );
				if ( isDefined( piecespawn ) )
					player player_take_piece( piecespawn );
			}
            return;
        }
}



get_craftable_piece( str_craftable, str_piece )
{
	foreach (uts_craftable in level.a_uts_craftables)
		if ( uts_craftable.craftablestub.name == str_craftable )
			foreach (piecespawn in uts_craftable.craftablespawn.a_piecespawns)
				if ( piecespawn.piecename == str_piece )
					return piecespawn;
	return undefined;
}

player_take_piece_gramophone( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

player_take_piece( piecespawn )
{
	piecestub = piecespawn.piecestub;
	damage = piecespawn.damage;

	if ( isDefined( piecestub.onpickup ) )
		piecespawn [[ piecestub.onpickup ]]( self );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared  && isDefined( piecestub.client_field_id ))
        level setclientfield( piecestub.client_field_id, 1 );

	else if ( isDefined( piecestub.client_field_state ) )
		self setclientfieldtoplayer( "craftable", piecestub.client_field_state );

	piecespawn piece_unspawn();
	piecespawn notify( "pickup" );

	if ( isDefined( piecestub.is_shared ) && piecestub.is_shared )
		piecespawn.in_shared_inventory = 1;

	self adddstat( "buildables", piecespawn.craftablename, "pieces_pickedup", 1 );
}

piece_unspawn()
{
	if ( isDefined( self.model ) )
		self.model delete();

	self.model = undefined;

	if ( isDefined( self.unitrigger ) )
		thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger( self.unitrigger );

	self.unitrigger = undefined;
}

remove_buildable_pieces( buildable_name )
{
	foreach (buildable in level.zombie_include_buildables)
	{
		if(IsDefined(buildable.name) && buildable.name == buildable_name)
		{
			pieces = buildable.buildablepieces;
			for(i = 0; i < pieces.size; i++)
				pieces[i] maps\mp\zombies\_zm_buildables::piece_unspawn();
			return;
		}
	}
}

enemies_ignore_equipments()
{
	equipment = getFirstArrayKey(level.zombie_include_equipment);
	while (isDefined(equipment))
	{
		maps\mp\zombies\_zm_equipment::enemies_ignore_equipment(equipment);
		equipment = getNextArrayKey(level.zombie_include_equipment, equipment);
	}
}


/*
* *****************************************************
*	
* ********************** MOTD *************************
*
* *****************************************************
*/

mob_map_changes()
{
	if( ismob() )
		return;
	
	open_warden_fence();
	turn_on_perks();
}

infinite_afterlifes()
{
	if( ismob() )
		return;

	self endon( "disconnect" );

	while(true)
	{
		self waittill( "player_revived", reviver );
		wait 2;
		self.lives++;
	}
}
open_warden_fence()
{
	m_lock = getent( "masterkey_lock_2", "targetname" );
	m_lock delete();
	t_warden_fence_damage = getent( "warden_fence_damage", "targetname" );
	t_warden_fence_damage delete();
	admin_powerhouse_puzzle_door_clip = getent( "admin_powerhouse_puzzle_door_clip", "targetname" );
	admin_powerhouse_puzzle_door_clip delete();
	admin_powerhouse_puzzle_door = getent( "admin_powerhouse_puzzle_door", "targetname" );
	admin_powerhouse_puzzle_door rotateyaw( 90, 0.5 );
	exploder( 2000 );
	flag_set( "generator_challenge_completed" );
	wait 0.1;
	level clientnotify( "sndWard" );
	level thread maps\mp\zombies\_zm_audio::sndmusicstingerevent( "piece_mid" );
	t_warden_fence_damage = getent( "warden_fence_damage", "targetname" );
	t_warden_fence_damage delete();
	level setclientfield( "warden_fence_down", 1 );
	array_delete( getentarray( "generator_wires", "script_noteworthy" ) );
	wait 3;
	stop_exploder( 2000 );
	wait 1;
}

turn_on_perks()
{
	flag_wait( "initial_blackscreen_passed" );
	level notify( "sleight_on" );
	wait_network_frame();
	level notify( "doubletap_on" );
	wait_network_frame();
	level notify( "juggernog_on" );
	wait_network_frame();
	level notify( "electric_cherry_on" );
	wait_network_frame();
	level notify( "deadshot_on" );
	wait_network_frame();
	level notify( "divetonuke_on" );
	wait_network_frame();
	level notify( "additionalprimaryweapon_on" );
	wait_network_frame();
	level notify( "Pack_A_Punch_on" );
	wait_network_frame();
}

health_bar_hud()
{
	level endon("end_game");
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

	health_bar = self createprimaryprogressbar();
	health_bar.hidewheninmenu = 1;
	health_bar.bar.hidewheninmenu = 1;
	health_bar.barframe.hidewheninmenu = 1;
	health_bar_text = self createprimaryprogressbartext();
	health_bar_text.hidewheninmenu = 1;
	
	health_bar setpoint(undefined, "BOTTOM", 0, 5);
	health_bar_text setpoint(undefined, "BOTTOM", 75, 5);

	while(true)
	{
		if (isDefined(self.e_afterlife_corpse))
		{
			if (health_bar.alpha != 0)
			{
				health_bar.alpha = 0;
				health_bar.bar.alpha = 0;
				health_bar.barframe.alpha = 0;
				health_bar_text.alpha = 0;
			}
			
			wait 0.05;
			continue;
		}

		if (health_bar.alpha != 1)
		{
			health_bar.alpha = 1;
			health_bar.bar.alpha = 1;
			health_bar.barframe.alpha = 1;
			health_bar_text.alpha = 1;
		}

		health_bar updatebar (self.health / self.maxhealth);
		health_bar_text setvalue(self.health);
		health_bar.bar.color = (1 - self.health / self.maxhealth, self.health / self.maxhealth, 0);
		wait 0.05;
	}
}