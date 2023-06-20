#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_buried;
#include maps\mp\zombies\_zm_equip_headchopper;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_ai_faller;
#include maps\mp\zombies\_zm_powerups;
#include maps\mp\zombies\_zm_buildables;
#include maps\mp\zombies\_zm_devgui;
#include maps\mp\zombies\_zm_pers_upgrades_functions;
#include maps\mp\zm_buried_classic;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_weap_time_bomb;
#include maps\mp\zm_buried_jail;
#include maps\mp\zombies\_zm_perk_vulture;
#include maps\mp\zombies\_zm_perk_divetonuke;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\teams\_teamset_cdc;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zm_buried_buildables;
#include maps\mp\zm_buried_ffotd;
#include maps\mp\zm_buried_distance_tracking;
#include maps\mp\gametypes_zm_hud_message;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zm_prison_sq_bg;
#include maps\mp\zm_alcatraz_craftables;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_claymore;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_blockers;
#include maps\mp\zombies\_zm_melee_weapon;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_ai_basic;
#include maps\mp\animscripts\shared;
#include maps\mp\zombies\_zm_ai_brutus;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zm_alcatraz_sq_nixie;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_alcatraz_sq_vo;
#include maps\mp\zm_prison_sq_final;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\zombies\_zm_sidequests;
#include maps\mp\zombies\_zm_score;
#include maps\_vehicle;
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
		switch(level.scr_zm_map_start_location)
		{
			case "tomb":
				level thread startbox("bunker_tank_chest");
				break;
			case "prison":
				level thread startbox("cafe_chest");
				break;
			case "town":
				level thread startbox("town_chest_2");
				break;
		}

		level waittill("connecting", player);

		if(sessionmodeisonlinegame() && isvictismap() && level.scr_zm_ui_gametype_group == "zclassic")
		{
			player thread onplayerspawned();
			player thread clear_stored_weapondata();
		}

		if(level.script != "zm_transit")
		{
			player thread hands();
		}

		else if(level.scr_zm_ui_gametype_group != "zclassic")
		{
			player thread survivalmap();
		}
	}
}

onconnect()
{
	self waittill("spawned_player");
	self endon("disconnect");

	self iprintln("^6Fraga^5V6  ^3Loaded");
	self iprintln("^3Download at ^6https://discord.gg/UWkTzrgd8D ^3or ^6https://github.com/Fraagaa/Fraga-Bo2");
	self iprintln("Patch includes: ^1autoslpits^7, ^2set hands^7, ^3permanperks^7, ^4full bank^7, ^5timers^7, ^6sph meter^7, ^1buildables counters ^2and more!");

	self thread timer_fraga();
	self thread round_timer_fraga();
	self thread trap_timer_fraga();
	self thread trap_timer_cooldown_fraga();
	self thread color_hud_watcher();
	self thread customdvars();
	self thread fill_up_bank();
	

	if(level.script == "zm_buried")
	{
		self thread buildablesmenu();
		self.turbinesused = 0;
		self.resoused = 0;
		self.trampused = 0;
	}

	if(level.script == "zm_highrise")
	{
		self.trampuseddr = 0;
		self thread buildablesdierise();
	}

	if(level.script == "zm_tomb")
	{
		replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::origins_pap_camo);
	}

	if(level.script == "zm_buried")
	{
		replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::buried_pap_camo);
	}
}

onplayerspawned()
{
	self waittill("spawned_player");
	self endon("disconnect");
	persistent_upgrades = array("pers_boarding", "pers_revivenoperk", "pers_multikill_headshots", "pers_cash_back_bought", "pers_cash_back_prone", "pers_insta_kill", "pers_jugg", "pers_carpenter", "pers_flopper_counter", "pers_perk_lose_counter", "pers_pistol_points_counter", "pers_double_points_counter", "pers_sniper_counter");
	persistent_upgrade_values = [];
	persistent_upgrade_values["pers_boarding"] = 74;
	persistent_upgrade_values["pers_revivenoperk"] = 17;
	persistent_upgrade_values["pers_multikill_headshots"] = 5;
	persistent_upgrade_values["pers_cash_back_bought"] = 50;
	persistent_upgrade_values["pers_cash_back_prone"] = 15;
	persistent_upgrade_values["pers_insta_kill"] = 2;
	persistent_upgrade_values["pers_jugg"] = 3;
	persistent_upgrade_values["pers_carpenter"] = 1;
	persistent_upgrade_values["pers_flopper_counter"] = 1;
	persistent_upgrade_values["pers_perk_lose_counter"] = 3;
	persistent_upgrade_values["pers_pistol_points_counter"] = 1;
	persistent_upgrade_values["pers_double_points_counter"] = 1;
	persistent_upgrade_values["pers_sniper_counter"] = 1;
	foreach(pers_perk in persistent_upgrades)
	{
		if(GetDvar(pers_perk) == "")
		{
			setdvar(pers_perk, 1);
		}
		statval = GetDvarInt(pers_perk) > 0 * persistent_upgrade_values[pers_perk];
		maps\mp\zombies\_zm_stats::set_client_stat(pers_perk, statval);
	}
	if(GetDvar("full_bank") == "")
	{
		setdvar("full_bank", 1);
	}
	bank_points = GetDvarInt("full_bank") > 0 * 250;
	if(bank_points)
	{
		self maps\mp\zombies\_zm_stats::set_map_stat("depositBox", bank_points, level.banking_map);
		self.account_value = bank_points;
	}
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

trap_timer_fraga()
{
	if( level.script != "zm_prison" || !level.hud_trap_timer )
		return;

	self endon( "disconnect" );

	self.trap_timer_fraga = newclienthudelem( self );
	self.trap_timer_fraga.alignx = "right";
	self.trap_timer_fraga.aligny = "top";
	self.trap_timer_fraga.horzalign = "user_right";
	self.trap_timer_fraga.vertalign = "user_top";
	self.trap_timer_fraga.x += 0;
	self.trap_timer_fraga.y += 20;
	self.trap_timer_fraga.fontscale = 1.4;
	self.trap_timer_fraga.alpha = 0;
	self.trap_timer_fraga.color = ( 0, 1, 0 );
	self.trap_timer_fraga.hidewheninmenu = 1;
	self.trap_timer_fraga.hidden = 0;
	self.trap_timer_fraga.label = &"";

	while( 1 )
	{
		level waittill( "trap_activated" );
		if( !level.trap_activated )
		{
			wait 0.5;
			self.trap_timer_fraga.alpha = 1 * GetDvarInt("traptimer");
			self.trap_timer_fraga settimer( 25 );
			wait 25;
			self.trap_timer_fraga.alpha = 0;
		}
	}
}

trap_timer_cooldown_fraga()
{
	if( level.script != "zm_prison" || !level.hud_trap_timer )
		return;

	self endon( "disconnect" );

	self.trap_timer_cooldown_fraga = newclienthudelem( self );
	self.trap_timer_cooldown_fraga.alignx = "right";
	self.trap_timer_cooldown_fraga.aligny = "top";
	self.trap_timer_cooldown_fraga.horzalign = "user_right";
	self.trap_timer_cooldown_fraga.vertalign = "user_top";
	self.trap_timer_cooldown_fraga.x += 0;
	self.trap_timer_cooldown_fraga.y += 20;
	self.trap_timer_cooldown_fraga.fontscale = 1.4;
	self.trap_timer_cooldown_fraga.alpha = 0;
	self.trap_timer_cooldown_fraga.color = ( 1, 0, 0 );
	self.trap_timer_cooldown_fraga.hidewheninmenu = 1;
	self.trap_timer_cooldown_fraga.hidden = 0;
	self.trap_timer_cooldown_fraga.label = &"";

	while( 1 )
	{
		level waittill( "trap_activated" );

		if( !level.trap_activated )
		{
			wait 25.5;
			self.trap_timer_cooldown_fraga.alpha = 1 * GetDvarInt("traptimer");
			self.trap_timer_cooldown_fraga settimer( 25 );
			wait 25.5;
			self.trap_timer_cooldown_fraga.alpha = 0;
		}
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

//BOX LOCATION

startbox(start_chest)
{
	self endon("disconnect");
	level waittill("initial_players_connected");

	for(i = 0; i < level.chests.size; i++)
	{
		if(level.chests[i].script_noteworthy == start_chest)
		{
			desired_chest_index = i;
			continue;
		}

		if(level.chests[i].hidden == 0)
		{
			nondesired_chest_index = i;
		}
	}

	if(isdefined(nondesired_chest_index) && nondesired_chest_index < desired_chest_index)
	{
		level.chests[nondesired_chest_index] hide_chest();
		level.chests[nondesired_chest_index].hidden = 1;
		level.chests[desired_chest_index].hidden = 0;
		level.chests[desired_chest_index] show_chest();
		level.chest_index = desired_chest_index;
	}
}

//BANK AND FRIDGE

isvictismap()
{
	switch(level.script)
	{
		case "zm_transit": return true;
		case "zm_highrise": return true;
		case "zm_buried": return true;
		default: return false;
	}	
}

fill_up_bank()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

    if (level.round_number == 1)
	{
    self.account_value = level.bank_account_max;		
	}
}

clear_stored_weapondata()
{
	flag_wait("initial_blackscreen_passed");

	if(level.script == "zm_highrise")
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
	}

	else if(level.script == "zm_buried")
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
	}

	else if(level.script == "zm_transit")
	{
		self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "mp5k_upgraded_zm");
	}

	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
}

//HANDS

hands()
{
	level.givecustomcharacters = ::give_personality_characters;
}

give_personality_characters()
{
	if ( isDefined( level.hotjoin_player_setup ) && [[ level.hotjoin_player_setup ]]( "c_zom_farmgirl_viewhands" ) )
	{
		return;
	}
	self detachall();

	if(level.script == "zm_transit")
	{
		self.characterindex = 1;
	}

	else if(level.script == "zm_highrise")
	{
		self.characterindex = 1;
	}

	else if(level.script == "zm_prison")
	{
		self.characterindex = 0;
	}

	else if(level.script == "zm_buried")
	{
		self.characterindex = 1;
	}

	else if(level.script == "zm_tomb")
	{
		self.characterindex = 2;
	}

	else if(level.script == "zm_nuked")
	{
		self.characterindex = 3;
	}

	self.favorite_wall_weapons_list = [];
	self.talks_in_danger = 1;

	switch(self.characterindex)
	{
		case 0:
			self setviewmodel("c_zom_arlington_coat_viewhands");
			self setmodel("c_zom_player_arlington_fb");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
			self set_player_is_female(0);
			self.character_name = "Billy";
			break;

		case 1:
			self setviewmodel("c_zom_farmgirl_viewhands");
			self setmodel("c_zom_player_farmgirl_dlc1_fb");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
			self setmovespeedscale(1);
			self setsprintduration(4);
			self setsprintcooldown(0);
			self thread set_exert_id();
			self set_player_is_female(1);
			break;

		case 2:
			self setviewmodel("c_zom_richtofen_viewhands");
			self setmodel("c_zom_tomb_richtofen_fb");
			level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self set_player_is_female(0);
			self.character_name = "Richtofen";
			break;
		case 3:
			self setmodel("c_zom_player_cdc_fb");
			self setviewmodel("c_zom_suit_viewhands");
			break;

	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
	self thread set_exert_id();
}

set_exert_id()
{
	self endon("disconnect");
	wait_network_frame();
	self maps\mp\zombies\_zm_audio::setexertvoice(self.characterindex);
}

survivalmap()
{
	level.givecustomcharacters = ::ciaalways;
}

ciaalways()
{
	self detachall();
	self set_player_is_female(0);

	self.characterindex = 0;

	switch(self.characterindex)
	{
		case 0:
			self setmodel("c_zom_player_cdc_fb");
			self setviewmodel("c_zom_suit_viewhands");

			self.voice = "american";
			self.skeleton = "base";

			self.characterindex = 0;

			break;
		case 1:
			self setmodel("c_zom_player_cdc_fb");
			self setviewmodel("c_zom_hazmat_viewhands");

			self.voice = "american";
			self.skeleton = "base";

			self.characterindex = 1;
			break;
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);

}

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
	self thread alphatramplesteam();
	self thread alphaturbine();
	self thread alpharesonator();
	self thread fontscale();
}

//BUILDABLES

alpharesonator()
{
	self endon("disconnect");
	if(GetDvar("resonator") == "")
	{
		setdvar("resonator", 1);
	}
}

alphaturbine()
{
	self endon("disconnect");
	if(GetDvar("turbine") == "")
	{
		setdvar("turbine", 1);
	}
}

alphatramplesteam()
{
	self endon("disconnect");
	if(GetDvar("trample") == "")
	{
		setdvar("trample", 1);
	}
}

buildablesdierise()
{
	self.tramplehud = newclienthudelem(self);
	self.tramplehud.alignx = "left";
	self.tramplehud.horzalign = "user_left";
	self.tramplehud.vertalign = "user_top";
	self.tramplehud.aligny = "top";
	self.tramplehud.x = 2;
	self.tramplehud.fontscale = 1.1;
	self.tramplehud.y = 0;
	self.tramplehud.sort = 1;
	self.tramplehud.label = &"^5Springpads ^6";
	self.tramplehud.hidewheninmenu = 1;
	self.tramplehud setvalue(0);
	buildablesmenu_watcher();

	while(1)
	{
		which = self waittill_any_return("equip_springpad_zm_given");
		if(which == "equip_springpad_zm_given")
		{
			self.trampuseddr = self.trampuseddr + 1;
			self.tramplehud setvalue(self.trampuseddr);
		}
	}
}

buildablesmenu()
{
	self endon("disconnect");

	self.turbine = newclienthudelem(self);
	self.turbine.alignx = "left";
	self.turbine.horzalign = "user_left";
	self.turbine.vertalign = "user_top";
	self.turbine.aligny = "top";
	self.turbine.x = self.turbine.x + 2;
	self.turbine.y = self.turbine.y + 0;
	self.turbine.sort = 1;
	self.turbine.fontscale = 1.1;
	self.turbine.label = &"^5Tur^7bines ^6";
	self.turbine.hidewheninmenu = 1;
	self.turbine setvalue(0);
	self.resonator = newclienthudelem(self);
	self.resonator.alignx = "left";
	self.resonator.horzalign = "user_left";
	self.resonator.vertalign = "user_top";
	self.resonator.aligny = "top";
	self.resonator.x = 2;
	self.resonator.fontscale = 1.1;
	self.resonator.y = 11;
	self.resonator.sort = 1;
	self.resonator.label = &"Sub^5woo^7fers ^6";
	self.resonator.hidewheninmenu = 1;
	self.resonator setvalue(0);
	self.trample = newclienthudelem(self);
	self.trample.alignx = "left";
	self.trample.horzalign = "user_left";
	self.trample.vertalign = "user_top";
	self.trample.aligny = "top";
	self.trample.x = 2;
	self.trample.fontscale = 1.1;
	self.trample.y = 22;
	self.trample.sort = 1;
	self.trample.label = &"Springp^5ads ^6";
	self.trample.hidewheninmenu = 1;
	self.trample setvalue(0);
	buildablesmenu_watcher();

	while(1)
	{
		which = self waittill_any_return("equip_turbine_zm_given", "equip_springpad_zm_given", "equip_subwoofer_zm_given");
		if(which == "equip_turbine_zm_given")
		{
			self.turbinesused = self.turbinesused + 1;
			self.turbinehud setvalue(self.turbinesused);
		}
		if(which == "equip_springpad_zm_given")
		{
			self.trampused = self.trampused + 1;
			self.tramplehud setvalue(self.trampused);
		}
		if(which == "equip_subwoofer_zm_given")
		{
			self.resoused = self.resoused + 1;
			self.resohud setvalue(self.resoused);
		}
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
    y =y_offset;

    if(isdefined(level.fraga_splits_splits)) y += level.fraga_splits_splits.size * 16;
    level.fraga_splits_splits[split_name] = newhudelem();
    level.fraga_splits_splits[split_name].alignx = "left";
    level.fraga_splits_splits[split_name].aligny = "center";
    level.fraga_splits_splits[split_name].horzalign = "left";
    level.fraga_splits_splits[split_name].vertalign = "top";
    level.fraga_splits_splits[split_name].x = -62;
    level.fraga_splits_splits[split_name].y = -30 + y;
    level.fraga_splits_splits[split_name].fontscale = 1.4;
    level.fraga_splits_splits[split_name].hidewheninmenu = 1;
    level.fraga_splits_splits[split_name].alpha = 0;
    level.fraga_splits_splits[split_name].color = (1, 0.5, 1);
    level thread split_start_thread(split_name);
    set_split_label(split_name);
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
    level.fraga_splits_splits[split_name].alpha = 0.8;
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


// -----------------------------------------------------------------------
// -----------------------------------------------------------------------
// ------------------------ Replaced Functions ---------------------------
// -----------------------------------------------------------------------
// -----------------------------------------------------------------------

origins_pap_camo(weapon)
{
	if(!isdefined(self.pack_a_punch_weapon_options))
	{
		self.pack_a_punch_weapon_options = [];
	}

	if(!is_weapon_upgraded(weapon))
	{
		return self calcweaponoptions(0, 0, 0, 0, 0);
	}

	if(isdefined(self.pack_a_punch_weapon_options[weapon]))
	{
		return self.pack_a_punch_weapon_options[weapon];
	}

	smiley_face_reticle_index = 1;
	base = get_base_name(weapon);
	camo_index = 39;

	if(level.script == "zm_tomb")
	{
		if(base == "mg08_upgraded_zm" || base == "mg08_zm" || (base == "c96_upgraded_zm" || base == "c96_zm"))
		{
			camo_index = 40;
		}
		else
		{
			camo_index = 40;
		}
	}

	lens_index = randomintrange(0, 6);
	reticle_index = randomintrange(0, 16);
	reticle_color_index = randomintrange(0, 6);
	plain_reticle_index = 16;
	r = randomint(10);
	use_plain = r < 3;

	if(base == "saritch_upgraded_zm")
	{
		reticle_index = smiley_face_reticle_index;
	}

	else if(use_plain)
	{
		reticle_index = plain_reticle_index;
	}

	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if(reticle_index == scary_eyes_reticle_index)
	{
		reticle_color_index = purple_reticle_color_index;
	}

	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	
	if(reticle_index == letter_a_reticle_index)
	{
		reticle_color_index = pink_reticle_color_index;
	}

	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if(reticle_index == letter_e_reticle_index)
	{
		reticle_color_index = green_reticle_color_index;
	}

	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions(camo_index, lens_index, reticle_index, reticle_color_index);
	return self.pack_a_punch_weapon_options[weapon];
}

buried_pap_camo(weapon)
{
	if(!isdefined(self.pack_a_punch_weapon_options))
	{
		self.pack_a_punch_weapon_options = [];
	}

	if(!is_weapon_upgraded(weapon))
	{
		return self calcweaponoptions(0, 0, 0, 0, 0);
	}

	if(isdefined(self.pack_a_punch_weapon_options[weapon]))
	{
		return self.pack_a_punch_weapon_options[weapon];
	}

	smiley_face_reticle_index = 1;
	base = get_base_name(weapon);
	camo_index = 39;

	if(level.script == "zm_buried")
	{
		if(base == "rnma_upgraded_zm" || base == "rnma_zm")
		{
			camo_index = 39;
		}
		else
		{
			camo_index = 40;
		}
	}

	lens_index = randomintrange(0, 6);
	reticle_index = randomintrange(0, 16);
	reticle_color_index = randomintrange(0, 6);
	plain_reticle_index = 16;
	r = randomint(10);
	use_plain = r < 3;

	if(base == "saritch_upgraded_zm")
	{
		reticle_index = smiley_face_reticle_index;
	}

	else if(use_plain)
	{
		reticle_index = plain_reticle_index;
	}

	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if(reticle_index == scary_eyes_reticle_index)
	{
		reticle_color_index = purple_reticle_color_index;
	}

	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if(reticle_index == letter_a_reticle_index)
	{
		reticle_color_index = pink_reticle_color_index;
	}

	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;

	if(reticle_index == letter_e_reticle_index)
	{
		reticle_color_index = green_reticle_color_index;
	}

	self.pack_a_punch_weapon_options[weapon] = self calcweaponoptions(camo_index, lens_index, reticle_index, reticle_color_index);
	return self.pack_a_punch_weapon_options[weapon];
}

//TESTS

buildablesmenu_watcher()
{
	self endon("disconnect");
	level endon("end_game");
	if(GetDvar("buildablesmenu") == "")
	{
		setdvar("buildablesmenu", 1);
	}

	while(1)
	{
		while(GetDvarInt("buildablesmenu") == 0)
		{
			wait(0.1);
		}
		self.turbine.alpha = 1;
		self.resonator.alpha = 1;
		self.trample.alpha = 1;
		while(GetDvarInt("buildablesmenu") >= 1)
		{
			wait(0.1);
		}
		self.turbine.alpha = 0;
		self.resonator.alpha = 0;
		self.trample.alpha = 0;
	}
}