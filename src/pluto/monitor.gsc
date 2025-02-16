#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_perks;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_prison_sq_bg;
#include maps\mp\zm_alcatraz_craftables;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zombies\_zm_perk_random;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zombies\_zm_pers_upgrades_system;
#include maps\mp\zombies\_zm_pers_upgrades;

#include scripts\zm\fraga\ismap;


init()
{
	level thread readchat();
	level thread drops_spawned();
	level thread track_round_times();
	level thread track_times();
	level.bs_fix = true;
	flag_wait("initial_blackscreen_passed");
	level.game_start_time = int(gettime() / 1000);
	if(isdierise())
	level thread track_leapers();
	if(isorigins())
	{
		level thread track_templars();
		level thread track_panzers();
	}
	if(ismob())
	level thread track_brutus();
	if(istranzit())
	level thread track_avogadros();
}

readchat() 
{
    self endon("end_game");
    while (true) 
    {
        level waittill("say", message, player);
        msg = strtok(message, " ");

        if(msg[0][0] != "!")
            continue;

        switch(msg[0])
        {
			case "!timer": setDvar("timer", msg[1]); break;
			case "!sph": print_sph(msg[1]); break;
			case "!fov": setDvar("cg_fov", msg[1]); break;
			case "!rt": print_round_times(msg[1]); break;
			case "!t":  print_game_time(); break;
			case "!zc": print_zombies_at_round(msg[1]); break;
			case "!tzc": total_zombie_count(msg[1], msg[2]); break;
			case "!ds": print_drops_spawned(msg[1]); break;
			case "!nightmode": setDvar("nightmode", !getDvarInt("nightmode")); break;
			case "!perkrng": setDvar("perkrng", !getDvarInt("perkrng")); break;
			case "!firstbox": case "fb": setDvar("firstbox", !getDvarInt("firstbox")); break;
			case "!templars": setDvar("templars", !getDvarInt("templars")); break;
			case "!traptimer": case "tt": setDvar("traptimer", !getDvarInt("traptimer")); break;
			case "!box": setDvar("box", msg[1]); break;
			case "!character": setDvar("character", msg[1]); break;
			case "!debug": setDvar("fragadebug", !getDvarInt("fragadebug")); break;
			case "!nl": next_leapers(); break;
			case "!times": print_times(); break;
			case "!nb": next_brutus(); break;
			case "!nt": next_templars(); break;
			case "!np": next_panzers(); break;
			case "!test": level.players[0] iprintln("^5[^6Fraga^5]^7 IT WOKRS!"); break;
			case "!na": next_avogadro(); break;
			case "!bs": level.bs_fix = !level.bs_fix; break;
        }
    }
}

fix_bs()
{
	while(true)
	{
		if(level.bs_fix)
		{
			setdvar("player_strafeSpeedScale", 1 );
			setdvar("player_backSpeedScale", 1 );
			setdvar("r_dof_enable", 0 );
			level.players[0] iprintln("^5[^6Fraga^5]^7 Back speed fixed!");
		}
		else
		{
			setdvar("player_strafeSpeedScale", 0.8 );
			setdvar("player_backSpeedScale", 0.7 );
			setdvar("r_dof_enable", 1 );
			level.players[0] iprintln("^5[^6Fraga^5]^7 Back speed unfixed!");
		}
		wait 0.1;
	}
}

print_game_time()
{
	time_now = int(gettime() / 1000);
	game_time = time_now - level.start_time;
	level.players[0] iprintln("^5[^6Fraga^5]^7 Game time: " + int_to_time(game_time));
}

next_leapers()
{
	if(!isdefined(level.leapers))
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Not tracking leapers");
		return;
	}
	n1 = 4 + level.leapers[level.leapers.size - 1];
	n2 = 5 + level.leapers[level.leapers.size - 1];
	level.players[0] iprintln("^5[^6Fraga^5]^7 Next potential leaper rounds: " + n1 + ", " + n2);
}

next_brutus()
{
	if(!isdefined(level.brutus))
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Not tracking brutus");
		return;
	}
	n1 = 4 + level.brutus[level.brutus.size - 1];
	n2 = 5 + level.brutus[level.brutus.size - 1];
	n3 = 6 + level.brutus[level.brutus.size - 1];
	level.players[0] iprintln("^5[^6Fraga^5]^7 Next potential brutus rounds: " + n1 + ", " + n2 + ", " + n3);
}

next_avogadro()
{
	if(!isdefined(level.avogadros))
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Not tracking avogadro");
		return;
	}
	n1 = 3 + level.avogadros[level.avogadros.size - 1];
	n2 = 4 + level.avogadros[level.avogadros.size - 1];
	n3 = 5 + level.avogadros[level.avogadros.size - 1];
	level.players[0] iprintln("^5[^6Fraga^5]^7 Next potential avogadro rounds: " + n1 + ", " + n2 + ", " + n3);
}

next_panzers()
{
	if(!isdefined(level.panzers))
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Not tracking panzers");
		return;
	}
	if(level.panzers.size == 1)
	{
		n1 = 4 + level.panzers[level.panzers.size - 1];
		n2 = 5 + level.panzers[level.panzers.size - 1];
		n3 = 6 + level.panzers[level.panzers.size - 1];
		level.players[0] iprintln("^5[^6Fraga^5]^7 Next potential panzer rounds: " + n1 + ", " + n2);
		return;
	}
	level.players[0] iprintln("^5[^6Fraga^5]^7 Next panzer round: " + level.panzers[level.panzers.size - 1] + 3);
}

next_templars()
{
	if(!isdefined(level.templars))
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Not tracking templars");
		return;
	}
	n1 = 3 + level.templars[level.templars.size - 1];
	n2 = 4 + level.templars[level.templars.size - 1];
	n3 = 5 + level.templars[level.templars.size - 1];
	level.players[0] iprintln("^5[^6Fraga^5]^7 Next potential templar rounds: " + n1 + ", " + n2 + ", " + n3);
}

print_drops_spawned(round)
{
	if(!isdefined(round))
		rnd = level.round_number;
	else
		rnd = string_to_float(round);
	
	if(rnd > level.round_number)
		level.players[0] iprintln("^5[^6Fraga^5]^7 You haven't reached round " + rnd + " yet.");
	else
		level.players[0] iprintln("^5[^6Fraga^5]^7 Drops spawned on round " + rnd + ": " + level.drops_spawned[rnd]);
}

drops_spawned()
{
	level.drops_spawned = array();  
	level.drops_this_round = 0;
	while(true)
	{
		level waittill_any("powerup_dropped", "end_of_round");
		wait 0.1;
		level.drops_spawned[level.round_number] = level.drops_this_round;
		level.drops_this_round++;
	}
}

print_zombies_at_round(round)
{
	if(!isdefined(round))
		rnd = level.round_number;
	else
		rnd = string_to_float(round);
	level.players[0] iprintln("^5[^6Fraga^5]^7 Zombies at round " + rnd + ": " + zombies_at_round(rnd) + ", horedes: " + zombies_at_round(rnd) / 24);
}

print_sph(round)
{
	rnd = string_to_float(round);
	level.players[0] iprintln("^5[^6Fraga^5]^7 SPH on round " + rnd + ": " + level.round_times[rnd - 1] / (zombies_at_round(rnd) / 24));
}

zombies_at_round(round)
{
	if(!isdefined(round))
		rnd = level.round_number;
	else
		rnd = string_to_float(round);

	zombies1p = array(6, 8, 13, 18, 24, 27, 28, 28, 29);
	zombies2p = array(7, 9, 15, 21, 27, 31, 32, 33, 34);
	zombies3p = array(9, 10, 18, 25, 32, 38, 40, 43, 45);
	zombies4p = array(10, 12, 21, 29, 37, 45, 49, 52, 56);
	if(rnd < 10)
	{
		if(level.players.size == 1) return zombies1p[rnd - 1];
		if(level.players.size == 2) return zombies2p[rnd - 1];
		if(level.players.size == 3) return zombies3p[rnd - 1];
		if(level.players.size == 4) return zombies4p[rnd - 1];
	}
	
	switch(level.players.size)
	{
		case 1: return int(0.09 * rnd * rnd + 24);
		case 2: return int(0.09 * 2 * rnd * rnd + 24);
		case 3: return int(0.09 * 4 * rnd * rnd + 24);
		case 4: return int(0.09 * 6 * rnd * rnd + 24);
	}
}

print_round_times(round)
{
	if(!isdefined(round))
		rnd = level.round_number;
	else
		rnd = string_to_float(round);
	if(rnd <= level.round_number)
	{
		if(rnd == level.round_number)
			level.players[0] iprintln("^5[^6Fraga^5]^7 Round time: " + int_to_time(int(gettime() / 1000) - level.round_start_time / 1000));
		else
			level.players[0] iprintln("^5[^6Fraga^5]^7 Round time on " + rnd + ": " + int_to_time(level.round_times[rnd - 1]));
	}
	else
		level.players[0] iprintln("^5[^6Fraga^5]^7 You havent reach round " + rnd + " yet.");
}

track_round_times()
{
	level.round_times = array();
	while(true)
	{
		level waittill("start_of_round");
		level.round_start_time = gettime();
		level waittill("end_of_round");
		level.drops_this_round = 0;
		level.round_end_time = gettime();
		level.round_times[level.round_times.size] = (level.round_end_time - level.round_start_time) / 1000;
	}
}

track_leapers()
{
	level.leapers = array();
	while(true)
	{
		level waittill("start_of_round");
		if(flag("leaper_round"))
		level.leapers[level.leapers.size] = level.round_number;
	}
}

track_brutus()
{
	level.brutus = array();
	while(true)
	{
		level waittill( "brutus_spawned");
		level.brutus[level.brutus.size] = level.round_number;
		foreach(player in level.players)
		{
			if(player.origin[2] < -7000)
				continue;
		}
		level waittill("end_of_round");
	}
}

track_templars()
{
	level.templars = array();
	while(true)
	{
		level waittill( "generator_under_attack" );
		level.templars[level.templars.size] = level.round_number;
		level waittill("end_of_round");
	}
}

track_avogadros()
{
	level.avogadros = array();
	while(true)
	{
		level waittill( "avogadro_defeated" );
		level.avogadros[level.avogadros.size] = level.round_number;
		level waittill("end_of_round");
	}
}


track_panzers()
{
	level.panzers = array();
	while(true)
	{
		level waittill( "spawn_mechz" );
		level.panzers[level.panzers.size] = level.round_number;
		level waittill("end_of_round");
	}
}

int_to_time(duration)
{
	println(duration);
    time_string = "";
	total_sec = int(duration);
	total_min = int(total_sec / 60);
	total_hours = int(total_min / 60);
    remaining_sec = int(total_sec % 60);
    remaining_min = int(total_min % 60);

	if(total_hours > 0)
	{
        if(total_hours <= 9 && total_hours != 0) {time_string += "0" + total_hours + ":";}
        if(total_hours > 9) {time_string += total_hours + ":";}
        if(remaining_min <= 9) {time_string += "0" + remaining_min + ":";}
        if(remaining_min > 9) {time_string += remaining_min + ":";}
        if(remaining_sec <= 9) {time_string += "0" + remaining_sec;}
        return time_string;
	}
	else
	{
		if(total_min > 0)
		{
			if(remaining_min < 9 && remaining_sec < 9) {time_string = "0" + remaining_min + ":" + "0" + remaining_sec; return time_string;}
			if(remaining_min < 9) {time_string = "0" + remaining_min + ":" + remaining_sec; return time_string;}
			if(remaining_sec < 9) {time_string = remaining_min + ":" + "0" + remaining_sec; return time_string;}
			time_string = remaining_min + ":" + remaining_sec; return time_string;
		}
		else
		{
			if(remaining_sec <= 9) {time_string = "0:0" + remaining_sec; return time_string;}
			time_string = "0:" + remaining_sec; return time_string;
		}
	}
}

track_times()
{
	level.round_total_time = array();
	while(true)
	{
		level waittill("end_of_round");
		end_time = int(gettime() / 1000);
		time = end_time - level.game_start_time;
		level.round_total_time[level.round_total_time.size] = time;
	}
}

print_times()
{
	rnd = level.round_number;
	if(rnd < 10)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(1, 2);
		print_times_aux(3, 4);
		print_times_aux(5, 6);
		print_times_aux(7, 8);
		print_times_aux(9, 10);
	}
	if(rnd >= 10 && rnd < 20)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(5, 10);
		print_times_aux(15);
	}
	if(rnd >= 20 && rnd < 30)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(5, 10);
		print_times_aux(15, 20);
		print_times_aux(25);
	}
	if(rnd >= 30 && rnd < 50)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(5, 10);
		print_times_aux(15, 20);
		print_times_aux(25, 30);
	}
	if(rnd >= 50 && rnd < 70)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(10, 20);
		print_times_aux(30, 40);
		print_times_aux(50);
	}
	if(rnd >= 70 && rnd < 100)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(10, 20);
		print_times_aux(30, 40);
		print_times_aux(50, 60);
		print_times_aux(70);
	}
	if(rnd >= 100 && rnd < 125)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(30, 50);
		print_times_aux(70, 80);
		print_times_aux(90, 100);
	}
	if(rnd >= 125 && rnd < 150)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(30, 50);
		print_times_aux(70, 100);
		print_times_aux(110, 120);
		print_times_aux(125);
	}
	if(rnd >= 150 && rnd < 200)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(100, 110);
		print_times_aux(120, 130);
		print_times_aux(140, 150);
	}
	if(rnd >= 200 && rnd < 255)
	{
		level.players[0] iprintln("^5[^6Fraga^5]^7 Times:");
		print_times_aux(100, 125);
		print_times_aux(150, 160);
		print_times_aux(170, 180);
		print_times_aux(190, 200);
	}
}

print_times_aux(r1, r2)
{
	wait 0.5;
	if(isdefined(r2) && isdefined(level.round_total_time[r2-2]))
		level.players[0] iprintln("["+(r1)+"]: " + int_to_time(level.round_total_time[r1-2]) + "  "  + "["+(r2)+"]: " + int_to_time(level.round_total_time[r2-2]));
	else
		level.players[0] iprintln("["+(r1)+"]: " + int_to_time(level.round_total_time[r1-2]));
}

total_zombie_count(iz, dr)
{
	iz = string_to_float(iz);
	if(isdefined(dr))
		dr = string_to_float(dr);
	zm = 0;
	if(!isdefined(dr))
		for(i = 1; i <= iz; i++)
			zm+= zombies_at_round(i);
	else
		if(iz > dr) return;
		else
			for(i = iz; i <= dr; i++)
				zm+= zombies_at_round(i);
	if(!isdefined(dr))
		level.players[0] iprintln("^5[^6Fraga^5]^7 Zombies from round 1 to round " + iz + ": " + zm);
	else
		level.players[0] iprintln("^5[^6Fraga^5]^7 Zombies from round " + iz + " to round " + dr + ": " + zm);
}

rounders()
{
	3rounders = 0; 4rounders = 0; 5rounders = 0; 6rounders = 0;
	if(ismob())
	{
		for(i = 0; i < level.brutus.size - 1; i++)
		{
			if(level.brutus[i] - level.brutus[i + 1] == 4)
				4rounders++;
			if(level.brutus[i] - level.brutus[i + 1] == 5)
				5rounders++;
			if(level.brutus[i] - level.brutus[i + 1] == 6)
				6rounders++;
		}
		avg = (4rounders * 4 + 5rounders * 5 + 6rounders * 6) / (4rounders + 5rounders + 6rounders)
		level.players[0] iprintln("^5[^6Fraga^5]^7 Brutus rounders: 4 [" + 4rounders + "] 5 [" + 5rounder + "] 6 [" + 6rounders + "] avg [" + avg + "]" );
	}
	if(isdierise())
	{
		for(i = 0; i < level.leapers.size - 1; i++)
		{
			if(level.leapers[i] - level.leapers[i + 1] == 4)
				4rounders++;
			if(level.leapers[i] - level.leapers[i + 1] == 5)
				5rounders++;
		}
		avg = (4rounders * 4 + 5rounders * 5) / (4rounders + 5rounders)
		level.players[0] iprintln("^5[^6Fraga^5]^7 Leaper rounders: 4 [" + 4rounders + "] 5 [" + 5rounder + "] 6 [" + 6rounders + "] avg [" + avg + "]" );
	}
	if(origins())
	{
		for(i = 0; i < level.templars.size - 1; i++)
		{
			if(level.templars[i] - level.templars[i + 1] == 3)
				3rounders++;
			if(level.templars[i] - level.templars[i + 1] == 4)
				4rounders++;
			if(level.templars[i] - level.templars[i + 1] == 5)
				5rounders++;
		}
		avg = (4rounders * 4 + 5rounders * 5) / (4rounders + 5rounders)
		level.players[0] iprintln("^5[^6Fraga^5]^7 Templar rounders: 4 [" + 4rounders + "] 5 [" + 5rounder + "] 6 [" + 6rounders + "] avg [" + avg + "]" );

		3rounders = 0; 4rounders = 0; 5rounders = 0; 6rounders = 0;
		for(i = 0; i < level.templars.size - 1; i++)
		{
			if(level.panzers[i] - level.panzers[i + 1] == 6)
				6rounders++;
			if(level.panzers[i] - level.panzers[i + 1] == 4)
				4rounders++;
			if(level.panzers[i] - level.panzers[i + 1] == 5)
				5rounders++;
		}
		avg = (4rounders * 4 + 5rounders * 5 + 6rounders * 6) / (4rounders + 5rounders + 6rounders)
		level.players[0] iprintln("^5[^6Fraga^5]^7 Panzer rounders: 4 [" + 4rounders + "] 5 [" + 5rounder + "] 6 [" + 6rounders + "] avg [" + avg + "]" );
	}
}
istown()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "town" && level.scr_zm_ui_gametype_group == "zsurvival");
}

isfarm()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "farm" && level.scr_zm_ui_gametype_group == "zsurvival");
}

isdepot()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zsurvival");
}

istranzit()
{
	return (level.script == "zm_transit" && level.scr_zm_map_start_location == "transit" && level.scr_zm_ui_gametype_group == "zclassic");
}

isnuketown()
{
	return (level.script == "zm_nuked");
}

isdierise()
{
	return (level.script == "zm_highrise");
}

ismob()
{
	return (level.script == "zm_prison");
}

isburied()
{
	return (level.script == "zm_buried");
}

isorigins()
{
	return (level.script == "zm_tomb");
}

is_round(round)
{
	return round <= level.round_number;
}

issurvivalmap()
{
	return (isnuketown() || istown() || isfarm() || isdepot());
}

isvictismap()
{
	return (istranzit() || isburied() || isdierise());
}