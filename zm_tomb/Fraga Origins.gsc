#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_perk_random;

#include scripts\zm\fraga\character;
#include scripts\zm\fraga\trackers;
#include scripts\zm\fraga\papcamo;
#include scripts\zm\fraga\RNGmoddifier;
#include scripts\zm\fraga\box;

init()
{
	level thread fizzStartLocation();
	level thread connected();


	replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::origins_pap_camo);
	replaceFunc(maps\mp\zombies\_zm_perk_random::get_weighted_random_perk, ::perkorderorigins);
    replaceFunc(maps\mp\zm_tomb_tank::tank_push_player_off_edge, ::tank_push_player_off_edge);
	
	level thread boxlocation();
}

tank_push_player_off_edge()
{
    return;
}

connected()
{
	while(true)
	{
		level waittill("connecting", player);
		if(getDvarInt("character") != 0) level.givecustomcharacters = ::set_character_option;
	}
}

fizzStartLocation()
{
	level waittill("initial_players_connected");
	wait(3);
	machines = getentarray("random_perk_machine", "targetname");
	index = 2;
	level.random_perk_start_machine = machines[index];
	foreach(machine in machines)
	{
		machine hidepart("j_ball");
		machine.is_current_ball_location = false;
		machine setclientfield("turn_on_location_indicator", false);
	}

	level.random_perk_start_machine.is_current_ball_location = true;
	level notify("wunderfizz_setup");
	level.random_perk_start_machine thread maps\mp\zombies\_zm_perk_random::machine_think();
}