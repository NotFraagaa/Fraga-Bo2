#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_nuked_perks;

checkpaplocation()
{
	if(getDvarInt("perkrng") == 1)
		return;
	wait 1;
	pap = getent( "specialty_weapupgrade", "script_noteworthy" );
	jug = getent( "vending_jugg", "targetname" );
	if(pap.origin[0] > -1700 || jug.origin[0] > -1700)
		level.players[0] notify ("menuresponse", "", "restart_level_zm");
}

perk_order( machines, machine_triggers )
{
	if(getDvarInt("perkRNG") != 1)
	{
		if(level.players.size == 1)
		{
			if(level.nextperkindex == 2)
				return;
			if(level.nextperkindex == 1)
				level.nextperkindex = 2;
			if(level.nextperkindex == 4)
				level.nextperkindex = 1;
			if(level.nextperkindex == 3)
				level.nextperkindex = 4;
			if(level.nextperkindex == -1)
				level.nextperkindex = 3;
		}
		else
		{
			if(level.nextperkindex == 0)
				return;
			if(level.nextperkindex == 1)
				level.nextperkindex = 2;
			if(level.nextperkindex == 4)
				level.nextperkindex = 1;
			if(level.nextperkindex == 3)
				level.nextperkindex = 4;
			if(level.nextperkindex == -1)
				level.nextperkindex = 3;
			if(level.nextperkindex == 2)
				level.nextperkindex = 0;
		}
		index = level.nextperkindex - 1;
		maps\mp\zm_nuked_perks::bring_perk( machines[index], machine_triggers[index] );
		/*
		arrayremoveindex( machines, index );
		arrayremoveindex( machine_triggers, index );
		*/
	}
	else
	{
		count = machines.size;

		if ( count <= 0 )
			return;

		index = randomintrange( 0, count );
		maps\mp\zm_nuked_perks::bring_perk( machines[index], machine_triggers[index] );
		arrayremoveindex( machines, index );
		arrayremoveindex( machine_triggers, index );
	}
}
/*
bring_perk( machine, trigger )
{
    players = get_players();
    is_doubletap = 0;
    is_sleight = 0;
    is_revive = 0;
    is_jugger = 0;
    flag_waitopen( "perk_vehicle_bringing_in_perk" );
    playsoundatposition( "zmb_perks_incoming_quad_front", ( 0, 0, 0 ) );
    playsoundatposition( "zmb_perks_incoming_alarm", ( -2198, 486, 327 ) );
    machine setclientfield( "clientfield_perk_intro_fx", 1 );
    machine.fx = spawn( "script_model", machine.origin );
    machine.fx playloopsound( "zmb_perks_incoming_loop", 6 );
    machine.fx thread perk_incoming_sound();
    machine.fx.angles = machine.angles;
    machine.fx setmodel( "tag_origin" );
    machine.fx linkto( machine );
    machine linkto( level.perk_arrival_vehicle, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
    start_node = getvehiclenode( "perk_arrival_path_" + machine.script_int, "targetname" );
    level.perk_arrival_vehicle perk_follow_path( start_node );
    machine unlink();
    offset = ( 0, 0, 0 );

    if ( issubstr( machine.targetname, "doubletap" ) )
    {
        forward_dir = anglestoforward( machine.original_angles + vectorscale( ( 0, -1, 0 ), 90.0 ) );
        offset = vectorscale( forward_dir * -1, 20 );
        is_doubletap = 1;
    }
    else if ( issubstr( machine.targetname, "sleight" ) )
    {
        forward_dir = anglestoforward( machine.original_angles + vectorscale( ( 0, -1, 0 ), 90.0 ) );
        offset = vectorscale( forward_dir * -1, 5 );
        is_sleight = 1;
    }
    else if ( issubstr( machine.targetname, "revive" ) )
    {
        forward_dir = anglestoforward( machine.original_angles + vectorscale( ( 0, -1, 0 ), 90.0 ) );
        offset = vectorscale( forward_dir * -1, 10 );
        trigger.blocker_model hide();
        is_revive = 1;
    }
    else if ( issubstr( machine.targetname, "jugger" ) )
    {
        forward_dir = anglestoforward( machine.original_angles + vectorscale( ( 0, -1, 0 ), 90.0 ) );
        offset = vectorscale( forward_dir * -1, 10 );
        is_jugger = 1;
    }

    if ( !is_revive )
        trigger.blocker_model delete();

    machine.original_pos += ( offset[0], offset[1], 0 );
    machine.origin = machine.original_pos;
    machine.angles = machine.original_angles;

    if ( is_revive )
    {
        level.quick_revive_final_pos = machine.origin;
        level.quick_revive_final_angles = machine.angles;
    }

    machine.fx stoploopsound( 0.5 );
    machine setclientfield( "clientfield_perk_intro_fx", 0 );
    playsoundatposition( "zmb_perks_incoming_land", machine.origin );
    trigger trigger_on();
    machine thread bring_perk_landing_damage();
    machine.fx unlink();
    machine.fx delete();
    machine notify( machine.turn_on_notify );
    level notify( machine.turn_on_notify );
    machine vibrate( vectorscale( ( 0, -1, 0 ), 100.0 ), 0.3, 0.4, 3 );
    machine playsound( "zmb_perks_power_on" );
    machine maps\mp\zombies\_zm_perks::perk_fx( undefined, 1 );

    if ( is_revive )
    {
        level.revive_machine_spawned = 1;
        machine thread maps\mp\zombies\_zm_perks::perk_fx( "revive_light" );
    }
    else if ( is_jugger )
        machine thread maps\mp\zombies\_zm_perks::perk_fx( "jugger_light" );
    else if ( is_doubletap )
        machine thread maps\mp\zombies\_zm_perks::perk_fx( "doubletap_light" );
    else if ( is_sleight )
        machine thread maps\mp\zombies\_zm_perks::perk_fx( "sleight_light" );
}
*/