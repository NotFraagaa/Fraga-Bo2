#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\character;
#include scripts\zm\fraga\trackers;
#include scripts\zm\fraga\papcamo;
#include scripts\zm\fraga\RNGmoddifier;
#include scripts\zm\fraga\firstbox;

init()
{
	level thread fizzStartLocation();
	//level thread perkRNG();
	level thread connected();


	replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::origins_pap_camo);
	if(GetDvar("Templars" != 0))
		replaceFunc(maps\mp\zm_tomb_capture_zones::get_recapture_zone, ::Templars);
	

	level thread firstbox();
	level thread boxlocation_origins();
}


connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread TemplarsManipulated();
		player thread tankTracker();
		player thread PanzerTracker();
		player thread TemplarTracker();
		if(getDvarInt("character") != 0)
			level.givecustomcharacters = ::set_character_option_origins;
	}
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