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


monitor_init()
{
	level thread readchat();
	level thread drops_spawned();
	level thread track_round_times();
	level thread track_times();
	level.bs_fix = true;
	flag_wait("initial_blackscreen_passed");
	level.game_start_time = int(gettime() / 1000);
	if(isdierise()) level thread track_leapers();
	if(isorigins())
	{
		level thread track_templars();
		level thread track_panzers();
	}
	if(ismob()) level thread track_brutus();
	if(istranzit()) level thread track_avogadros();
}

readchat() 
{
    self endon("end_game");
    while (true) 
    {
        level waittill("say", message, player);
		message = tolower(message);
        msg = strtok(message, " ");

        if(msg[0][0] != "!")
            continue;

        switch(msg[0])
        {
			case "!fov": setDvar("cg_fov", msg[1]); break;

			case "!zc": print_zombies_at_round(msg[1]); break;
			case "!tzc": total_zombie_count(msg[1], msg[2]); break;
			case "!ds": print_drops_spawned(msg[1]); break;

			case "!nightmode": setDvar("nightmode", !getDvarInt("nightmode")); break;

			case "!perkrng": setDvar("perkrng", !getDvarInt("perkrng")); break;
			case "!firstbox": case "!fb": setDvar("firstbox", !getDvarInt("firstbox")); break;
			case "!templars": setDvar("templars", !getDvarInt("templars")); break;
			case "!traptimer": case "tt": setDvar("traptimer", !getDvarInt("traptimer")); break;
			case "!box": setDvar("box", msg[1]); break;
			case "!character": setDvar("character", msg[1]); break;

			case "!times": print_times(); break;
			case "!rt": print_round_times(msg[1]); break;
			case "!t":  print_game_time(); break;
			case "!timer": setDvar("timer", msg[1]); break;
			case "!sph": print_sph(msg[1]); break;

			case "!test": fragaprint("IT WOKRS!"); break;
			case "!debug": setDvar("fragadebug", !getDvarInt("fragadebug")); break;

			case "!na": next_avogadro(); break;
			case "!nb": next_brutus(); break;
			case "!nt": next_templars(); break;
			case "!np": next_panzers(); break;
			case "!nl": next_leapers(); break;
			case "!rounders": rounders(); break;
			case "!panzers": panzers(); break;
			case "!templars": templars(); break;
			case "!leapers": leapers(); break;
			case "!brutus": brutus(); break;
			case "!avogadros": avogadros(); break;

			case "!papcamo": camo(msg[1]); break;

			case "!bs": level.bs_fix = !level.bs_fix; break;
			default: break;
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
			fragaprint("Back speed fixed!");
		}
		else
		{
			setdvar("player_strafeSpeedScale", 0.8 );
			setdvar("player_backSpeedScale", 0.7 );
			setdvar("r_dof_enable", 1 );
			fragaprint("Back speed unfixed!");
		}
		wait 0.1;
	}
}

print_game_time()
{
	time_now = int(gettime() / 1000);
	game_time = time_now - level.start_time;
	fragaprint("Game time: " + int_to_time(game_time));
}

next_leapers()
{
	if(!isdefined(level.leapers))
	{
		fragaprint("Not tracking leapers");
		return;
	}
	n1 = 4 + level.leapers[level.leapers.size - 1];
	n2 = 5 + level.leapers[level.leapers.size - 1];
	fragaprint("Next potential leaper rounds: " + n1 + ", " + n2);
}

next_brutus()
{
	if(!isdefined(level.brutus))
	{
		fragaprint("Not tracking brutus");
		return;
	}
	n1 = 4 + level.brutus[level.brutus.size - 1];
	n2 = 5 + level.brutus[level.brutus.size - 1];
	n3 = 6 + level.brutus[level.brutus.size - 1];
	fragaprint("Next potential brutus rounds: " + n1 + ", " + n2 + ", " + n3);
}

next_avogadro()
{
	if(!isdefined(level.avogadros))
	{
		fragaprint("Not tracking avogadro");
		return;
	}
	n1 = 3 + level.avogadros[level.avogadros.size - 1];
	n2 = 4 + level.avogadros[level.avogadros.size - 1];
	n3 = 5 + level.avogadros[level.avogadros.size - 1];
	fragaprint("Next potential avogadro rounds: " + n1 + ", " + n2 + ", " + n3);
}

next_panzers()
{
	if(!isdefined(level.panzers))
	{
		fragaprint("Not tracking panzers");
		return;
	}
	if(level.panzers.size == 0)
	{
		fragaprint("Next panzer round: 8");
		return;
	}
	if(level.players.size == 1)
	{
		n1 = 4 + level.panzers[level.panzers.size - 1];
		n2 = 5 + level.panzers[level.panzers.size - 1];
		n3 = 6 + level.panzers[level.panzers.size - 1];
		fragaprint("Next potential panzer rounds: " + n1 + ", " + n2);
		return;
	}
	
	fragaprint("Next panzer round: " + level.panzers[level.panzers.size - 1] + 3);
}

next_templars()
{
	if(!isdefined(level.templars))
	{
		fragaprint("Not tracking templars");
		return;
	}
	n1 = 3 + level.templars[level.templars.size - 1];
	n2 = 4 + level.templars[level.templars.size - 1];
	n3 = 5 + level.templars[level.templars.size - 1];
	fragaprint("Next potential templar rounds: " + n1 + ", " + n2 + ", " + n3);
}

print_drops_spawned(round)
{
	if(!isdefined(round))
		rnd = level.round_number;
	else
		rnd = string_to_float(round);
	
	if(rnd > level.round_number)
		fragaprint("You haven't reached round " + rnd + " yet.");
	else
		fragaprint("Drops spawned on round " + rnd + ": " + level.drops_spawned[rnd]);
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
	fragaprint("Zombies at round " + rnd + ": " + zombies_at_round(rnd) + ", horedes: " + zombies_at_round(rnd) / 24);
}

print_sph(round)
{
	rnd = string_to_float(round);
	fragaprint("SPH on round " + rnd + ": " + level.round_times[rnd - 1] / (zombies_at_round(rnd) / 24));
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
			fragaprint("Round time: " + int_to_time(int(gettime() / 1000) - level.round_start_time / 1000));
		else
			fragaprint("Round time on " + rnd + ": " + int_to_time(level.round_times[rnd - 1]));
	}
	else
		fragaprint("You havent reach round " + rnd + " yet.");
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
			if(player.origin[2] < -7000)	// Ignore brutus from the bridge
				continue;
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
		fragaprint("Times:");
		print_times_aux(1, 2);
		print_times_aux(3, 4);
		print_times_aux(5, 6);
		print_times_aux(7, 8);
		print_times_aux(9, 10);
		return;
	}
	if(rnd < 20)
	{
		fragaprint("Times:");
		print_times_aux(5, 10);
		print_times_aux(15);
		return;
	}
	if(rnd < 30)
	{
		fragaprint("Times:");
		print_times_aux(5, 10);
		print_times_aux(15, 20);
		print_times_aux(25);
		return;
	}
	if(rnd < 50)
	{
		fragaprint("Times:");
		print_times_aux(5, 10);
		print_times_aux(15, 20);
		print_times_aux(25, 30);
		return;
	}
	if(rnd < 70)
	{
		fragaprint("Times:");
		print_times_aux(10, 20);
		print_times_aux(30, 40);
		print_times_aux(50);
		return;
	}
	if(rnd < 100)
	{
		fragaprint("Times:");
		print_times_aux(10, 20);
		print_times_aux(30, 40);
		print_times_aux(50, 60);
		print_times_aux(70);
		return;
	}
	if(rnd < 125)
	{
		fragaprint("Times:");
		print_times_aux(30, 50);
		print_times_aux(70, 80);
		print_times_aux(90, 100);
		return;
	}
	if(rnd < 150)
	{
		fragaprint("Times:");
		print_times_aux(30, 50);
		print_times_aux(70, 100);
		print_times_aux(110, 120);
		print_times_aux(125);
		return;
	}
	if(rnd < 200)
	{
		fragaprint("Times:");
		print_times_aux(100, 110);
		print_times_aux(120, 130);
		print_times_aux(140, 150);
		return;
	}
	if(rnd < 255)
	{
		fragaprint("Times:");
		print_times_aux(100, 125);
		print_times_aux(150, 160);
		print_times_aux(170, 180);
		print_times_aux(190, 200);
		return;
	}
}

print_times_aux(r1, r2)
{
	wait 0.5;
	if(isdefined(r2) && isdefined(level.round_total_time[r2]))
		fragaprint("["+(r1)+"]: " + int_to_time(level.round_total_time[r1-1]) + "  "  + "["+(r2)+"]: " + int_to_time(level.round_total_time[r2-1]));
	else
		fragaprint("["+(r1)+"]: " + int_to_time(level.round_total_time[r1-1]));
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
		fragaprint("Zombies from round 1 to round " + iz + ": " + zm);
	else
		fragaprint("Zombies from round " + iz + " to round " + dr + ": " + zm);
}

rounders()
{
	threerounders = 0; fourrounderss = 0; fiverounders = 0; sixrounderss = 0;
	if(ismob())
	{
		for(i = 0; i < level.brutus.size - 1; i++)
		{
			diff = level.brutus[i + 1] - level.brutus[i];
			if(diff == 4) fourrounderss++;
			if(diff == 5) fiverounders++;
			if(diff == 6) sixrounderss++;
		}
		avg = (fourrounderss * 4 + fiverounders * 5 + sixrounderss * 6) / (fourrounderss + fiverounders + sixrounderss);
		fragaprint("Brutus rounders: 4 [" + fourrounderss + "] 5 [" + fiverounders + "] 6 [" + sixrounderss + "] avg [" + avg + "]" );
	}
	if(isdierise())
	{
		for(i = 0; i < level.leapers.size - 1; i++)
		{
			diff = level.leapers[i + 1] - level.leapers[i];
			if(diff == 4) fourrounderss++;
			if(diff == 5) fiverounders++;
		}
		avg = (fourrounderss * 4 + fiverounders * 5) / (fourrounderss + fiverounders);
		fragaprint("Leaper rounders: 4 [" + fourrounderss + "] 5 [" + fiverounders + "] 6 [" + sixrounderss + "] avg [" + avg + "]" );
	}
	if(isorigins())
	{
		for(i = 0; i < level.templars.size - 1; i++)
		{
			diff = level.templars[i + 1] - level.templars[i];
			if(diff == 3) threerounders++;
			if(diff == 4) fourrounderss++;
			if(diff == 5) fiverounders++;
		}
		avg = (threerounders * 3 + fourrounderss * 4 + fiverounders * 5) / (threerounders + fourrounderss + fiverounders);
		fragaprint("Templar rounders: 3 [" + threerounders + "] 4 [" + fourrounderss + "] 5 [" + fiverounders + "] avg [" + avg + "]" );

		threerounders = 0; fourrounderss = 0; fiverounders = 0; sixrounderss = 0;
		for(i = 0; i < level.templars.size - 1; i++)
		{
			diff = level.panzers[i + 1] - level.panzers[i];
			if(diff == 6) sixrounderss++;
			if(diff == 5) fiverounders++;
			if(diff == 4) fourrounderss++;
		}
		avg = (fourrounderss * 4 + fiverounders * 5 + sixrounderss * 6) / (fourrounderss + fiverounders + sixrounderss);
		fragaprint("Panzer rounders: 4 [" + fourrounderss + "] 5 [" + fiverounders + "] 6 [" + sixrounderss + "] avg [" + avg + "]" );
	}
}

panzers()
{
	if(!isdefined(level.panzers))
	{
		fragaprint("Not Tracking Panzers");
		return;
	}
	msg = "^5[^6Fraga^5]^7 Panzer rounds: " + level.panzers[0];
	if(level.panzers.size < 10)
	{
		for(i = 1; i < level.panzers.size; i++)
			if(isdefined(level.panzers[i]))
				msg += (", " + level.panzers[i]);
		fragaprint(msg);
		return;
	}
	if(level.panzers.size < 20)
	{
		msg2 = "";
		for(i = 1; i < 10; i++)
				msg += (", " + level.panzers[i]);
		for(i = 10; i < 20; i++)
			if(isdefined(level.panzers[i]) && isdefined(level.panzers[i + 1]))
				msg2 += (level.panzers[i] + ", ");
			else if(isdefined(level.panzers[i]))
				msg2 += (level.panzers[i]);
		fragaprint(msg);
		fragaprint(msg2);
		return;
	}
	if(level.panzers.size < 30)
	{
		msg2 = "";
		msg3 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.panzers[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.panzers[i] + ", ");
		for(i = 20; i < 30; i++)
			if(isdefined(level.panzers[i]) && isdefined(level.panzers[i + 1]))
				msg3 += (level.panzers[i] + ", ");
			else if(isdefined(level.panzers[i]))
				msg3 += (level.panzers[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		return;
	}
	if(level.panzers.size < 40)
	{
		msg2 = "";
		msg3 = msg2; msg4 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.panzers[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.panzers[i] + ", ");
		for(i = 20; i < 30; i++)
				msg3 += (level.panzers[i] + ", ");
		for(i = 30; i < 40; i++)
			if(isdefined(level.panzers[i]) && isdefined(level.panzers[i + 1]))
				msg4 += (level.panzers[i] + ", ");
			else if(isdefined(level.panzers[i]))
				msg4 += (level.panzers[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		fragaprint(msg4);
		return;
	}
}

templars()
{
	if(!isdefined(level.templars))
	{
		fragaprint("Not Tracking templars");
		return;
	}
	msg = "^5[^6Fraga^5]^7 Templar rounds: " + level.templars[0];
	if(level.templars.size < 10)
	{
		for(i = 1; i < level.templars.size; i++)
			if(isdefined(level.templars[i]))
				msg += (", " + level.templars[i]);
		fragaprint(msg);
		return;
	}
	if(level.templars.size < 20)
	{
		msg2 = "";
		for(i = 1; i < 10; i++)
				msg += (", " + level.templars[i]);
		for(i = 10; i < 20; i++)
			if(isdefined(level.templars[i]) && isdefined(level.templars[i + 1]))
				msg2 += (level.templars[i] + ", ");
			else if(isdefined(level.templars[i]))
				msg2 += (level.templars[i]);
		fragaprint(msg);
		fragaprint(msg2);
		return;
	}
	if(level.templars.size < 30)
	{
		msg2 = "";
		msg3 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.templars[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.templars[i] + ", ");
		for(i = 20; i < 30; i++)
			if(isdefined(level.templars[i]) && isdefined(level.templars[i + 1]))
				msg3 += (level.templars[i] + ", ");
			else if(isdefined(level.templars[i]))
				msg3 += (level.templars[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		return;
	}
	if(level.templars.size < 40)
	{
		msg2 = "";
		msg3 = msg2; msg4 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.templars[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.templars[i] + ", ");
		for(i = 20; i < 30; i++)
				msg3 += (level.templars[i] + ", ");
		for(i = 30; i < 40; i++)
			if(isdefined(level.templars[i]) && isdefined(level.templars[i + 1]))
				msg4 += (level.templars[i] + ", ");
			else if(isdefined(level.templars[i]))
				msg4 += (level.templars[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		fragaprint(msg4);
		return;
	}
}

leapers()
{
	if(!isdefined(level.leapers))
	{
		fragaprint("Not Tracking Leapers");
		return;
	}
	msg = "^5[^6Fraga^5]^7 Leaper rounds: " + level.leapers[0];
	if(level.leapers.size < 10)
	{
		for(i = 1; i < level.leapers.size; i++)
			if(isdefined(level.leapers[i]))
				msg += (", " + level.leapers[i]);
		fragaprint(msg);
		return;
	}
	if(level.leapers.size < 20)
	{
		msg2 = "";
		for(i = 1; i < 10; i++)
				msg += (", " + level.leapers[i]);
		for(i = 10; i < 20; i++)
			if(isdefined(level.leapers[i]) && isdefined(level.leapers[i + 1]))
				msg2 += (level.leapers[i] + ", ");
			else if(isdefined(level.leapers[i]))
				msg2 += (level.leapers[i]);
		fragaprint(msg);
		fragaprint(msg2);
		return;
	}
	if(level.leapers.size < 30)
	{
		msg2 = "";
		msg3 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.leapers[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.leapers[i] + ", ");
		for(i = 20; i < 30; i++)
			if(isdefined(level.leapers[i]) && isdefined(level.leapers[i + 1]))
				msg3 += (level.leapers[i] + ", ");
			else if(isdefined(level.leapers[i]))
				msg3 += (level.leapers[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		return;
	}
	if(level.leapers.size < 40)
	{
		msg2 = "";
		msg3 = msg2; msg4 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.leapers[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.leapers[i] + ", ");
		for(i = 20; i < 30; i++)
				msg3 += (level.leapers[i] + ", ");
		for(i = 30; i < 40; i++)
			if(isdefined(level.leapers[i]) && isdefined(level.leapers[i + 1]))
				msg4 += (level.leapers[i] + ", ");
			else if(isdefined(level.leapers[i]))
				msg4 += (level.leapers[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		fragaprint(msg4);
		return;
	}
}

brutus()
{
	if(!isdefined(level.brutus))
	{
		fragaprint("Not Tracking Brutus");
		return;
	}
	msg = "^5[^6Fraga^5]^7 Brutus rounds: " + level.brutus[0];
	if(level.brutus.size < 10)
	{
		for(i = 1; i < level.brutus.size; i++)
			if(isdefined(level.brutus[i]))
				msg += (", " + level.brutus[i]);
		fragaprint(msg);
		return;
	}
	if(level.brutus.size < 20)
	{
		msg2 = "";
		for(i = 1; i < 10; i++)
				msg += (", " + level.brutus[i]);
		for(i = 10; i < 20; i++)
			if(isdefined(level.brutus[i]) && isdefined(level.brutus[i + 1]))
				msg2 += (level.brutus[i] + ", ");
			else if(isdefined(level.brutus[i]))
				msg2 += (level.brutus[i]);
		fragaprint(msg);
		fragaprint(msg2);
		return;
	}
	if(level.brutus.size < 30)
	{
		msg2 = "";
		msg3 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.brutus[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.brutus[i] + ", ");
		for(i = 20; i < 30; i++)
			if(isdefined(level.brutus[i]) && isdefined(level.brutus[i + 1]))
				msg3 += (level.brutus[i] + ", ");
			else if(isdefined(level.brutus[i]))
				msg3 += (level.brutus[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		return;
	}
	if(level.brutus.size < 40)
	{
		msg2 = "";
		msg3 = msg2; msg4 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.brutus[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.brutus[i] + ", ");
		for(i = 20; i < 30; i++)
				msg3 += (level.brutus[i] + ", ");
		for(i = 30; i < 40; i++)
			if(isdefined(level.brutus[i]) && isdefined(level.brutus[i + 1]))
				msg4 += (level.brutus[i] + ", ");
			else if(isdefined(level.brutus[i]))
				msg4 += (level.brutus[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		fragaprint(msg4);
		return;
	}
}

avogadros()
{
	if(!isdefined(level.avogadros))
	{
		fragaprint("Not Tracking Avogadros");
		return;
	}
	msg = "^5[^6Fraga^5]^7 Avogadro rounds: " + level.avogadros[0];
	if(level.avogadros.size < 10)
	{
		for(i = 1; i < level.avogadros.size; i++)
			if(isdefined(level.avogadros[i]))
				msg += (", " + level.avogadros[i]);
		fragaprint(msg);
		return;
	}
	if(level.avogadros.size < 20)
	{
		msg2 = "";
		for(i = 1; i < 10; i++)
				msg += (", " + level.avogadros[i]);
		for(i = 10; i < 20; i++)
			if(isdefined(level.avogadros[i]) && isdefined(level.avogadros[i + 1]))
				msg2 += (level.avogadros[i] + ", ");
			else if(isdefined(level.avogadros[i]))
				msg2 += (level.avogadros[i]);
		fragaprint(msg);
		fragaprint(msg2);
		return;
	}
	if(level.avogadros.size < 30)
	{
		msg2 = "";
		msg3 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.avogadros[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.avogadros[i] + ", ");
		for(i = 20; i < 30; i++)
			if(isdefined(level.avogadros[i]) && isdefined(level.avogadros[i + 1]))
				msg3 += (level.avogadros[i] + ", ");
			else if(isdefined(level.avogadros[i]))
				msg3 += (level.avogadros[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		return;
	}
	if(level.avogadros.size < 40)
	{
		msg2 = "";
		msg3 = msg2; msg4 = msg2;
		for(i = 1; i < 10; i++)
				msg += (", " + level.avogadros[i]);
		for(i = 10; i < 20; i++)
				msg2 += (level.avogadros[i] + ", ");
		for(i = 20; i < 30; i++)
				msg3 += (level.avogadros[i] + ", ");
		for(i = 30; i < 40; i++)
			if(isdefined(level.avogadros[i]) && isdefined(level.avogadros[i + 1]))
				msg4 += (level.avogadros[i] + ", ");
			else if(isdefined(level.avogadros[i]))
				msg4 += (level.avogadros[i]);
		fragaprint(msg);
		fragaprint(msg2);
		fragaprint(msg3);
		fragaprint(msg4);
		return;
	}
}

camo(str)
{
	switch(str)
	{
		// 1 to 38 are unusable on zombies
		case "origins": if(isorigins()) {setDvar("papcamo", 41); IPrintLn("^5[^6Fraga^5]^7 Pap camo changed to ice crystal"); } else fragaprint("Unable to switch pap camo"); break;
		case "mob": if(isorigins() || isburied() || ismob()) {setDvar("papcamo", 40); fragaprint("Pap camo changed to burning embers"); } else fragaprint("Unable to switch pap camo"); break;
		case "greenrun": setDvar("papcamo", 39); fragaprint("Pap camo changed to greenrun"); break;
		case "none": setDvar("papcamo", 1); fragaprint("Pap camo removed"); break;
		case "camo2": setDvar("papcamo", 42); fragaprint("Pap camo changed to camo2"); break;
		case "white": setDvar("papcamo", 43); fragaprint("Pap camo changed to white"); break;
		case "weird": setDvar("papcamo", 43); fragaprint("Pap camo changed to weird"); break;
		default: break;
	}
}

fragaprint(message)
{
	foreach(player in level.players)
		player IPrintLn("^5[^6Fraga^5]^7 " + message);
}