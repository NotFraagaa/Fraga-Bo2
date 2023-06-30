#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\teams\_teamset_cdc;
#include maps\mp\animscripts\zm_death;
#include maps\mp\gametypes_zm_hud_message;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_score;
#include maps\_utility;

init()
{
	setdvar("player_strafeSpeedScale", "1");
	setdvar("player_backSpeedScale", "1");
	setdvar("r_dof_enable", "0");
    self endon( "disconnect" );
    self.init = 0;
	
	thread onplayerconnect();
	thread fix_highround();
	level thread RoundSplits();
	level thread enableGraphicTweaks();
	enable_cheats();
	if(GetDvar("traptimer") == "")
	{
		setdvar("traptimer", "0");
	}

	if(GetDvar("5SR") == "1")
    {
        level thread timer( strtok("Round 2|Round 3|Round 4|Round 5", "|"), 50, 0);
    }
    if(GetDvar("30SR") == "1")
    {
        level thread timer( strtok("Round 5|Round 10|Round 15|Round 20|Round 25|Round 30", "|"), 50, 0);
    }
    if(GetDvar("50SR") == "1")
    {
        level thread timer( strtok("Round 10|Round 20|Round 30|Round 40|Round 50", "|"), 50, 0);
    }
    if(GetDvar("70SR") == "1")
    {
        level thread timer( strtok("Round 10|Round 20|Round 30|Round 40|Round 50|Round 60|Round 70", "|"), 50, 0);
    }
    if(GetDvar("100SR") == "1")
    {
        level thread timer( strtok("Round 30|Round 50|Round 70|Round 80|Round 90|Round 95|Round 100", "|"), 50, 0);
    }
    if(GetDvar("150SR") == "1")
    {
        level thread timer( strtok("Round 50|Round 70|Round 100|Round 125|Round 130|Round 140|Round 150", "|"), 50, 0);
    }
    if(GetDvar("2000SR") == "1")
    {
        level thread timer( strtok("Round 50|Round 70|Round 100|Round 150|Round 175|Round 200", "|"), 50, 0);
    }
    level.fraga_splits_complete_color = (0, 1, 1);
    
}

onplayerconnect()
{
	while(1)
	{
		player thread onconnect();
		level waittill("connecting", player);
	}
}

enableGraphicTweaks()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread connected();
    }
}

connected()
{
    level endon( "game_ended" );
    self endon("disconnect");

    self.initial_spawn = true;

    for(;;)
    {
        self waittill("spawned_player");

    	if(self.initial_spawn)
		{
			self graphic_tweaks();
			self thread night_mode();
			self thread rotate_skydome();
			self set_visionset();
        }
	}
}

onconnect()
{
	self waittill("spawned_player");
	self endon("disconnect");

	self iprintln("^6Fraga^5V8  ^3Loaded");
	self iprintln("^3Download at ^6discord.gg/UWkTzrgd8D ^3or ^6github.com/Fraagaa/Fraga-Bo2");

	self thread timer_fraga();
	self thread round_timer_fraga();
	self thread color_hud_watcher();
	self thread customdvars();
}

//TIMERS
timer_fraga()
{
	if(isdefined(level.strat_tester) && level.strat_tester)
	{
		return;
	}

	self endon("disconnect");

	if(GetDvar("timer") == "")
	{
		setdvar("timer", 1);
	}

	self.timer_fraga = newclienthudelem(self);
	self.timer_fraga.alignx = "left";
	self.timer_fraga.aligny = "top";
	self.timer_fraga.horzalign = "user_left";
	self.timer_fraga.vertalign = "user_top";
	self.timer_fraga.x = self.timer_fraga.x + 4;
	self.timer_fraga.y = self.timer_fraga.y + 324;
	self.timer_fraga.alpha = 0;
	self.timer_fraga.color = (0.505, 0.478, 0.721);
	self.timer_fraga.hidewheninmenu = 1;
	self.timer_fraga.fontscale = 1.7;
	self thread timer_fraga_watcher();
	self thread round_timer_fraga();
	flag_wait("initial_blackscreen_passed");
	self.timer_fraga settimerup(0);
	level waittill("end_game");
	level.total_time = level.total_time - 0.1;

	while(1)
	{
		self.timer_fraga settimer(level.total_time);
		self.timer_fraga.alpha = 1;
		self.round_timer_fraga.alpha = 0;
		wait(0.1);
	}
}

timer_fraga_watcher()
{
	self endon("disconnect");
	level endon("end_game");

	while(1)
	{
		while(GetDvarInt("timer") == 0)
		{
			wait(0.1);
		}
		self.timer_fraga.y = 2 + self.timer_fraga_offset;
		self.timer_fraga.alpha = 1;
		while(GetDvarInt("timer") >= 1)
		{
			wait(0.1);
		}
		self.timer_fraga.alpha = 0;
	}
}

round_timer_fraga()
{
	if(isdefined(level.strat_tester) && level.strat_tester)
	{
		return;
	}

	self endon("disconnect");

	if(GetDvar("round_timer") == "")
	{
		setdvar("round_timer", 1);
	}

	self.round_timer_fraga = newclienthudelem(self);
	self.round_timer_fraga.alignx = "left";
	self.round_timer_fraga.aligny = "top";
	self.round_timer_fraga.horzalign = "user_left";
	self.round_timer_fraga.vertalign = "user_top";
	self.round_timer_fraga.x = self.round_timer_fraga.x + 4;
	self.round_timer_fraga.y = self.round_timer_fraga.y + 339;
	self.round_timer_fraga.alpha = 0;
	self.round_timer_fraga.fontscale = 1.7;
	self.round_timer_fraga.color = (0.505, 0.478, 0.721);
	self.round_timer_fraga.hidewheninmenu = 1;
	flag_wait("initial_blackscreen_passed");
	self thread round_timer_fraga_watcher();
	level.fade_time = 0.2;

	while(1)
	{
		zombies_this_round = level.zombie_total + get_round_enemy_array().size;
		hordes = zombies_this_round / 24;
		dog_round = flag("dog_round");
		leaper_round = flag("leaper_round");
		self.round_timer_fraga settimerup(0);
		start_time = int(GetTime() / 1000);
		level waittill("end_of_round");
		end_time = int(GetTime() / 1000);
		time = end_time - start_time;
		self display_round_time(time, hordes, dog_round, leaper_round);
		level waittill("start_of_round");
		if(GetDvarInt("round_timer") >= 1)
		{
			self.round_timer_fraga fadeovertime(level.fade_time);
			self.round_timer_fraga.alpha = 1;
		}
	}
}

display_round_time(time, hordes, dog_round, leaper_round)
{
	timer_for_hud = time - 0.1;
	sph_off = 1;

	if(level.round_number > GetDvarInt("sph_start") && !dog_round && !leaper_round)
	{
		sph_off = 0;
	}

	self.round_timer_fraga fadeovertime(level.fade_time);
	self.round_timer_fraga.alpha = 0;
	wait(level.fade_time * 2);
	self.round_timer_fraga.label = &"Round Time: ";
	self.round_timer_fraga fadeovertime(level.fade_time);
	self.round_timer_fraga.alpha = 1;

	for(i = 0; i < 100 + 100 * sph_off; i++)
	{
		self.round_timer_fraga settimer(timer_for_hud);
		wait(0.05);
	}

	self.round_timer_fraga fadeovertime(level.fade_time);
	self.round_timer_fraga.alpha = 0;
	wait(level.fade_time * 2);

	if(sph_off == 0)
	{
		self display_sph(time, hordes);
	}

	self.round_timer_fraga.label = &"";
}

display_sph(time, hordes)
{
	sph = time / hordes;
	self.round_timer_fraga fadeovertime(level.fade_time);
	self.round_timer_fraga.alpha = 1;
	self.round_timer_fraga.label = &"SPH: ";
	self.round_timer_fraga setvalue(sph);

	for(i = 0; i < 5; i++)
	{
		wait(1);
	}

	self.round_timer_fraga fadeovertime(level.fade_time);
	self.round_timer_fraga.alpha = 0;
	wait(level.fade_time);
}

round_timer_fraga_watcher()
{
	self endon("disconnect");
	level endon("end_game");

	while(1)
	{
		while(GetDvarInt("round_timer") == 0)
		{
			wait(0.1);
		}

		self.round_timer_fraga.y = 2 + 15 * GetDvarInt("timer") + self.timer_fraga_offset;
		self.round_timer_fraga.alpha = 1;

		while(GetDvarInt("round_timer") >= 1)
		{
			wait(0.1);
		}

		self.round_timer_fraga.alpha = 0;
	}
}

//HEALTH FIX

fix_highround()
{
	while(level.round_number > 155)
	{
		zombies = getaiarray("axis");
		i = 0;
		while(i < zombies.size)
		{
			if(zombies[i].targetname != "zombie")
			{
				continue;
			}
			if(zombies[i].targetname == "zombie")
			{
				if(!isdefined(zombies[i].health_override))
				{
					zombies[i].health_override = 1;
					zombies[i].health = 1044606723;
				}
			}
			i++;
		}
		wait(0.1);
	}
}

//SPLITS

timer( split_list, y_offset, branching )
{
    level endon( "game_ended" );

    foreach(split in split_list)
        create_new_split(split, y_offset);

    if(!isdefined(level.fraga_splits_start_time))
    {
        flag_wait("initial_blackscreen_passed");
        level.fraga_splits_start_time = gettime();
    }

    for(i = 0; i < split_list.size - branching; i++)
    {
        split = split_list[i];
        unhide(split);
        split(split, wait_split(split));
    }
}

create_new_split(split_name, y_offset)
{
    y = y_offset;

    if(isdefined(level.fraga_splits_splits)) y += level.fraga_splits_splits.size * 16;
    level.fraga_splits_splits[split_name] = newhudelem();
    level.fraga_splits_splits[split_name].alignx = "left";
    level.fraga_splits_splits[split_name].aligny = "center";
    level.fraga_splits_splits[split_name].horzalign = "left";
    level.fraga_splits_splits[split_name].vertalign = "top";
    level.fraga_splits_splits[split_name].x = -62;
    level.fraga_splits_splits[split_name].y = -30 + y;
	level.fraga_splits_splits[split_name].alpha = 0;
    level.fraga_splits_splits[split_name].fontscale = 1.4;
    level.fraga_splits_splits[split_name].hidewheninmenu = 1;
    level.fraga_splits_splits[split_name].color = (0, 0, 0);
    level thread split_start_thread(split_name);
	level thread split_alpha(split_name);
    set_split_label(split_name);
}

split_alpha(split_name)
{
	self endon("disconnect");
	level endon("end_game");
	if(GetDvar("splits") == "")
	{
		setdvar("splits", 0);
	}

	while(1)
	{
		while(GetDvarInt("splits") == 0)
		{
			wait(0.1);
		}
		level.fraga_splits_splits[split_name].alpha = 1;
		while(GetDvarInt("splits") >= 1)
		{
			wait(0.1);
		}
		level.fraga_splits_splits[split_name].alpha = 0;
	}
}

split_start_thread(split_name)
{
    flag_wait("initial_blackscreen_passed");
    level.fraga_splits_splits[split_name] settenthstimerup(0.01);
}

set_split_label(split_name)
{
        switch(split_name)
        {
            case "Round 2": level.fraga_splits_splits[split_name].label = &"^3Round 2 ^7"; break;    
            case "Round 3": level.fraga_splits_splits[split_name].label = &"^3Round 3 ^7"; break;    
            case "Round 4": level.fraga_splits_splits[split_name].label = &"^3Round 4 ^7"; break;    
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Round 5 ^7"; break;
            case "Round 5": level.fraga_splits_splits[split_name].label = &"^3Round 5 ^7"; break;  
            case "Round 10": level.fraga_splits_splits[split_name].label = &"^3Round 10 ^7"; break;  
            case "Round 15": level.fraga_splits_splits[split_name].label = &"^3Round 15 ^7"; break;  
            case "Round 20": level.fraga_splits_splits[split_name].label = &"^3Round 20 ^7"; break;  
            case "Round 25": level.fraga_splits_splits[split_name].label = &"^3Round 25 ^7"; break;  
            case "Round 30": level.fraga_splits_splits[split_name].label = &"^3Round 30 ^7"; break;  
            case "Round 40": level.fraga_splits_splits[split_name].label = &"^3Round 40 ^7"; break;  
            case "Round 50": level.fraga_splits_splits[split_name].label = &"^3Round 50 ^7"; break;   
            case "Round 60": level.fraga_splits_splits[split_name].label = &"^3Round 60 ^7"; break;  
            case "Round 70": level.fraga_splits_splits[split_name].label = &"^3Round 70 ^7"; break;  
            case "Round 80": level.fraga_splits_splits[split_name].label = &"^3Round 80 ^7"; break; 
            case "Round 90": level.fraga_splits_splits[split_name].label = &"^3Round 90 ^7"; break; 
            case "Round 95": level.fraga_splits_splits[split_name].label = &"^3Round 95 ^7"; break; 
            case "Round 100": level.fraga_splits_splits[split_name].label = &"^3Round 100 ^7"; break;
            case "Round 125": level.fraga_splits_splits[split_name].label = &"^3Round 125 ^7"; break;
            case "Round 130": level.fraga_splits_splits[split_name].label = &"^3Round 130 ^7"; break;
            case "Round 140": level.fraga_splits_splits[split_name].label = &"^3Round 140 ^7"; break;
            case "Round 150": level.fraga_splits_splits[split_name].label = &"^3Round 150 ^7"; break; 
            case "Round 175": level.fraga_splits_splits[split_name].label = &"^3Round 175 ^7"; break;
            case "Round 200": level.fraga_splits_splits[split_name].label = &"^3Round 200 ^7"; break;                   
        }
}

unhide(split_name)
{
    level.fraga_splits_splits[split_name].color = (1, 0.5, 1);
}

split(split_name, time)
{
    level.fraga_splits_splits[split_name].color = level.fraga_splits_complete_color;
    level.fraga_splits_splits[split_name] settext(game_time_string(time - level.fraga_splits_start_time));
}

wait_split(split)
{
    switch (split)
    {
        case "Round 2":
            while(level.round_number < 2) wait 1;
            break;
        case "Round 3":
            while(level.round_number < 3) wait 1;
            break;
        case "Round 4":
            while(level.round_number < 4) wait 1;
            break;
        case "Round 5":
            while(level.round_number < 5) wait 1;
            break;
        case "Round 10":
            while(level.round_number < 10) wait 1;
            break;
        case "Round 15":
            while(level.round_number < 15) wait 1;
            break;
        case "Round 20":
            while(level.round_number < 20) wait 1;
            break;
        case "Round 25":
            while(level.round_number < 25) wait 1;
            break;
        case "Round 30":
            while(level.round_number < 30) wait 1;
            break;
        case "Round 40":
            while(level.round_number < 40) wait 1;
            break;
        case "Round 50":
            while(level.round_number < 50) wait 1;
            break;
        case "Round 60":
            while(level.round_number < 60) wait 1;
            break;
        case "Round 70":
            while(level.round_number < 70) wait 1;
            break;
        case "Round 80":
            while(level.round_number < 80) wait 1;
            break;
        case "Round 90":
            while(level.round_number < 90) wait 1;
            break;
        case "Round 100":
            while(level.round_number < 100) wait 1;
            break;
        case "Round 125":
            while(level.round_number < 125) wait 1;
            break;
        case "Round 130":
            while(level.round_number < 130) wait 1;
            break;
        case "Round 140":
            while(level.round_number < 140) wait 1;
            break;
        case "Round 150":
            while(level.round_number < 150) wait 1;
            break;
        case "Round 175":
            while(level.round_number < 175) wait 1;
            break;
        case "Round 200":
            while(level.round_number < 200) wait 1;
            break;
    }
    return gettime();
}

game_time_string(duration)
{
    total_sec = int(duration / 1000);
    total_min = int(total_sec / 60);
    total_hours = int(total_min / 60);
    remaining_ms = (duration % 1000) / 10;
    remaining_sec = total_sec % 60;
    remaining_min = total_min % 60;
    time_string = "";

    if(total_hours > 0)     { time_string += total_hours + ":"; }
    else
    {
    if(total_min > 9)       { time_string += total_min + ":"; }
    else                    { time_string += "0" + total_min + ":"; }
    if(remaining_sec > 9)   { time_string += remaining_sec; }
    else                    { time_string += "0" + remaining_sec; }
    return time_string;
	}
}

RoundSplits()
{
    //5SR
	if(GetDvar("5SR") == "")
	{
		setdvar("5SR", "0");
	}
    //30SR
	if(GetDvar("30SR") == "")
	{
		setdvar("30SR", "0");
	}
    //50SR
	if(GetDvar("50SR") == "")
	{
		setdvar("50SR", "0");
	}
    //70SR
	if(GetDvar("70SR") == "")
	{
		setdvar("70SR", "0");
	}
    //100SR
	if(GetDvar("100SR") == "")
	{
		setdvar("100SR", "0");
	}
    //150SR
	if(GetDvar("150SR") == "")
	{
		setdvar("150SR", "0");
	}
    //200SR
	if(GetDvar("200SR") == "")
	{
		setdvar("200SR", "1");
	}
    //Desable other DVARS
    //5SR
	if(GetDvar("5SR") == "1")
	{
		setdvar("30SR", "0");
		setdvar("50SR", "0");
		setdvar("70SR", "0");
		setdvar("150SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
		setdvar("100SR", "0");
	}
    //30SR
	if(GetDvar("30SR") == "1")
	{
		setdvar("5SR", "0");
		setdvar("50SR", "0");
		setdvar("70SR", "0");
		setdvar("150SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
		setdvar("100SR", "0");
	}
    //50SR
	if(GetDvar("50SR") == "1")
	{
		setdvar("5SR", "0");
		setdvar("30SR", "0");
		setdvar("70SR", "0");
		setdvar("150SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
		setdvar("100SR", "0");
	}
    //70SR
	if(GetDvar("70SR") == "1")
	{
		setdvar("5SR", "0");
		setdvar("50SR", "0");
		setdvar("30SR", "0");
		setdvar("150SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
		setdvar("100SR", "0");
	}
    //100SR
	if(GetDvar("100SR") == "1")
	{
		setdvar("5SR", "0");
		setdvar("50SR", "0");
		setdvar("70SR", "0");
		setdvar("30SR", "0");
		setdvar("150SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
	}
    //150SR
	if(GetDvar("150SR") == "1")
	{
		setdvar("5SR", "0");
		setdvar("50SR", "0");
		setdvar("70SR", "0");
		setdvar("30SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
		setdvar("100SR", "0");
	}
    //200SR
	if(GetDvar("150SR") == "1")
	{
		setdvar("5SR", "0");
		setdvar("50SR", "0");
		setdvar("70SR", "0");
		setdvar("30SR", "0");
		setdvar("200SR", "0");
		setdvar("200SR", "0");
		setdvar("100SR", "0");
	}   
}

//UTILITY

enable_cheats()
{
	setdvar("sv_cheats", 1);
	setdvar("cg_ufo_scaler", 0.7);
}

customdvars()
{
	self thread timer_x_position();
	self thread timer_y_position();

	self thread sph_start();

	self thread fontscale();
}

//TIMER UTILITY

fontscale()
{
	self endon("disconnect");
	if(GetDvar("fontscale") == "")
	{
		setdvar("fontscale", "1.7");
	}
	fontscale = GetDvar("fontscale");
	prev_fontscale = "1.7";
}

color_hud_watcher()
{
	self endon("disconnect");

	if(GetDvar("timer_color") == "")
	{
		setdvar("timer_color", "0.505 0.478 0.721");
	}

	color = GetDvar("timer_color");
	prev_color = "0.505 0.478 0.721";
	while(1)
	{
		while(color == prev_color)
		{
			color = GetDvar("timer_color");
			wait(0.1);
		}

		colors = strtok(color, " ");
		if(colors.size != 3)
		{
			continue;
		}

		prev_color = color;
		self.timer_fraga.color = (string_to_float(colors[0]), string_to_float(colors[1]), string_to_float(colors[2]));
		self.round_timer_fraga.color = (string_to_float(colors[0]), string_to_float(colors[1]), string_to_float(colors[2]));
	}
}

sph_start()
{
	self endon("disconnect");

	if(GetDvar("sph_start") == "")
	{
		setdvar("sph_start", "30");
	}

	sph_start = GetDvar("sph_start");
	prev_sph_start = "30";

	while(1)
	{
		while(sph_start == prev_sph_start)
		{
			sph_start = GetDvar("sph_start");
			wait(0.1);
		}
		prev_sph_start = sph_start;
	}
}

timer_y_position()
{
	self endon("disconnect");

	if(GetDvar("timer_yposition") == "")
	{
		setdvar("timer_yposition", "339");
	}

	timerypos = GetDvar("timer_yposition");
	prev_timerypos = "339";

	while(1)
	{
		while(timerypos == prev_timerypos)
		{
			timerypos = GetDvar("timer_yposition");
			wait(0.1);
		}

		prev_timerypos = timerypos;
		self.round_timer_fraga.y = GetDvarInt("timer_yposition");
		self.timer_fraga.y = GetDvarInt("timer_yposition") - 15 * GetDvarInt("fontscale");
	}
}

timer_x_position()
{
	self endon("disconnect");

	if(GetDvar("timer_xposition") == "")
	{
		setdvar("timer_xposition", "4");
	}

	timerxpos = GetDvar("timer_xposition");
	prev_timerxpos = "4";

	while(1)
	{
		while(timerxpos == prev_timerxpos)
		{
			timerxpos = GetDvar("timer_xposition");
			wait(0.1);
		}

		prev_timerxpos = timerxpos;
		self.round_timer_fraga.x = GetDvarInt("timer_xposition");
		self.timer_fraga.x = GetDvarInt("timer_xposition");
	}
}


graphic_tweaks()
{
	if( level.script != "zm_tomb")
	self setclientdvar("r_dof_enable", 0);
	self setclientdvar("r_lodBiasRigid", -1000);
	self setclientdvar("r_lodBiasSkinned", -1000);
	self setClientDvar("r_lodScaleRigid", 1);
	self setClientDvar("r_lodScaleSkinned", 1);
	self setclientdvar("sm_sunquality", 2);
	self setclientdvar("r_enablePlayerShadow", 1);
	self setclientdvar( "vc_fbm", "0 0 0 0" );
	self setclientdvar( "vc_fsm", "1 1 1 1" );
	self setclientdvar( "vc_fgm", "1 1 1 1" );
}

night_mode()
{
	if ( !isDefined( self.night_mode ) )
	{
		self.night_mode = true;
	}
	else
	{
		return;
	}

	flag_wait( "start_zombie_round_logic" );
	wait 0.05;	

	self thread night_mode_watcher();
}

night_mode_watcher()
{	
	if( getDvar( "night_mode") == "" )
		setDvar( "night_mode", 0 );

	wait 1;

	while(1)
	{
		while( !getDvarInt( "night_mode" ) )
		{
			wait 0.1;
		}
		self thread enable_night_mode();
		self thread visual_fix();

		while( getDvarInt( "night_mode" ) )
		{
			wait 0.1;
		}
		self thread disable_night_mode();
	}
}

enable_night_mode()
{
	if( !isDefined( level.default_r_exposureValue ) )
		level.default_r_exposureValue = getDvar( "r_exposureValue" );
	if( !isDefined( level.default_r_lightTweakSunLight ) )
		level.default_r_lightTweakSunLight = getDvar( "r_lightTweakSunLight" );
	if( !isDefined( level.default_r_sky_intensity_factor0 ) )
		level.default_r_sky_intensity_factor0 = getDvar( "r_sky_intensity_factor0" );
	// if( !isDefined( level.default_r_sky_intensity_factor0 ) )
	// 	level.default_r_lightTweakSunColor = getDvar( "r_lightTweakSunColor" );

	//self setclientdvar( "r_fog", 0 );
	self setclientdvar( "r_filmUseTweaks", 1 );
	self setclientdvar( "r_bloomTweaks", 1 );
	self setclientdvar( "r_exposureTweak", 1 );
	self setclientdvar( "vc_rgbh", "0.07 0 0.25 0" );
	self setclientdvar( "vc_yl", "0 0 0.25 0" );
	self setclientdvar( "vc_yh", "0.015 0 0.07 0" );
	self setclientdvar( "vc_rgbl", "0.015 0 0.07 0" );
	self setclientdvar( "vc_rgbh", "0.015 0 0.07 0" );
	self setclientdvar( "r_exposureValue", 3.9 );
	self setclientdvar( "r_lightTweakSunLight", 16 );
	self setclientdvar( "r_sky_intensity_factor0", 3 );
	//self setclientdvar( "r_lightTweakSunColor", ( 0.015, 0, 0.07 ) );
	if( level.script == "zm_buried" )
	{
		self setclientdvar( "r_exposureValue", 3.5 );
	}
	else if( level.script == "zm_tomb" )
	{
		self setclientdvar( "r_exposureValue", 4 );
	}
	else if( level.script == "zm_nuked" )
	{
		self setclientdvar( "r_exposureValue", 5.6 );
	}
	else if( level.script == "zm_highrise" )
	{
		self setclientdvar( "r_exposureValue", 3 );
	}
}

disable_night_mode()
{
	self notify( "disable_nightmode" );
	self setclientdvar( "r_filmUseTweaks", 0 );
	self setclientdvar( "r_bloomTweaks", 0 );
	self setclientdvar( "r_exposureTweak", 0 );
	self setclientdvar( "vc_rgbh", "0 0 0 0" );
	self setclientdvar( "vc_yl", "0 0 0 0" );
	self setclientdvar( "vc_yh", "0 0 0 0" );
	self setclientdvar( "vc_rgbl", "0 0 0 0" );
	self setclientdvar( "r_exposureValue", int( level.default_r_exposureValue ) );
	self setclientdvar( "r_lightTweakSunLight", int( level.default_r_lightTweakSunLight ) );
	self setclientdvar( "r_sky_intensity_factor0", int( level.default_r_sky_intensity_factor0 ) );
}

visual_fix()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "disable_nightmode" );
	if( level.script == "zm_buried" )
	{
		while( getDvar( "r_sky_intensity_factor0" ) != 0 )
		{	
			self setclientdvar( "r_lightTweakSunLight", 1 );
			self setclientdvar( "r_sky_intensity_factor0", 0 );
			wait 0.05;
		}
	}
	else if( level.script == "zm_prison" || level.script == "zm_tomb" )
	{
		while( getDvar( "r_lightTweakSunLight" ) != 0 )
		{
			for( i = getDvar( "r_lightTweakSunLight" ); i >= 0; i = ( i - 0.05 ) )
			{
				self setclientdvar( "r_lightTweakSunLight", i );
				wait 0.05;
			}
			wait 0.05;
		}
	}
	else return;
}

rotate_skydome()
{
	if ( level.script == "zm_tomb" )
	{
		return;
	}
	
	x = 360;
	
	self endon("disconnect");
	for(;;)
	{
		x -= 0.025;
		if ( x < 0 )
		{
			x += 360;
		}
		self setclientdvar( "r_skyRotation", x );
		wait 0.1;
	}
}

change_skydome()
{
	x = 6500;
	
	self endon("disconnect");
	for(;;)
	{
		x += 1.626;
		if ( x > 25000 )
		{
			x -= 23350;
		}
		self setclientdvar( "r_skyColorTemp", x );
		wait 0.1;
	}
}

set_visionset()
{
	self useservervisionset(1);
	self setvisionsetforplayer(GetDvar( "mapname" ), 1.0 );
}