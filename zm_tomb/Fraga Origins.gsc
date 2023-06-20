#include maps\mp\zombies\_zm;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zm_tomb_giant_robot_ffotd;
#include maps\mp\zombies\_zm_net;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
init()
{
	level thread fizzStartLocation();
	if(GetDvar("DoubleTap") == "")
	{
		setdvar("DoubleTap", 0);
	}
	level thread doubletap();
}

fizzStartLocation()
{
	level waittill("connecting", player);
	level waittill("initial_players_connected");
	wait(3);
	machines = getentarray("random_perk_machine", "targetname");
	index = 2;
	level.random_perk_start_machine = machines[index];
	foreach(machine in machines)
	{
		if(machine != level.random_perk_start_machine)
		{
			machine hidepart("j_ball");
			machine.is_current_ball_location = 0;
			machine setclientfield("turn_on_location_indicator", 0);
			continue;
		}
		machine.is_current_ball_location = 1;
		level.wunderfizz_starting_machine = machine;
		level notify("wunderfizz_setup");
		machine thread maps\mp\zombies\_zm_perk_random::machine_think();
	}
}

doubletap()
{
	if(GetDvarInt("DoubleTap") == 1)
	{
		replaceFunc(maps\mp\zombies\_zm_perk_random::get_weighted_random_perk, ::getWeightedRandomPerk);
	}
}

getWeightedRandomPerk( player ) 
{
    return "specialty_rof";
}