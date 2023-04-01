#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zombies/_zm_utility;
#include common_scripts/utility;
#include maps/mp/_utility;
#include maps/mp/zm_buried;
#include maps/mp/zombies/_zm_equip_headchopper;
#include maps/mp/zombies/_zm_stats;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_ai_faller;
#include maps/mp/zombies/_zm_powerups;
#include maps/mp/zombies/_zm_buildables;
#include maps/mp/zombies/_zm_devgui;
#include maps/mp/zombies/_zm_pers_upgrades_functions;
#include maps/mp/zm_buried_classic;
#include maps/mp/zombies/_zm_zonemgr;
#include maps/mp/zombies/_zm_weap_time_bomb;
#include maps/mp/zm_buried_jail;
#include maps/mp/zombies/_zm_perk_vulture;
#include maps/mp/zombies/_zm_perk_divetonuke;
#include maps/mp/gametypes_zm/_spawning;
#include maps/mp/teams/_teamset_cdc;
#include maps/mp/animscripts/zm_death;
#include maps/mp/zm_buried_buildables;
#include maps/mp/zm_buried_ffotd;
#include maps/mp/zm_buried_distance_tracking;
#include maps/mp/gametypes_zm_hud_message;
#include maps/mp/zombies/_zm_weap_tomahawk;
#include maps/mp/zm_alcatraz_utility;
#include maps/mp/zombies/_zm_craftables;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zm_prison_sq_bg;
#include maps/mp/zm_alcatraz_craftables;
#include maps/mp/zombies/_zm_afterlife;
#include maps/mp/gametypes_zm/_hud_message;
#include maps/mp/zombies/_zm_magicbox;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/gametypes_zm/_globallogic;
#include maps/mp/zombies/_zm_weapons;
#include maps/mp/zombies/_zm_weap_claymore;
#include maps/mp/zombies/_zm;
#include maps/mp/zombies/_zm_blockers;
#include maps/mp/zombies/_zm_melee_weapon;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_clone;
#include maps/mp/zombies/_zm_laststand;
#include maps/mp/zombies/_zm_ai_basic;
#include maps/mp/animscripts/shared;
#include maps/mp/zombies/_zm_ai_brutus;
#include maps/mp/zombies/_zm_audio;
#include maps/mp/zm_alcatraz_sq_nixie;
#include maps/mp/zombies/_zm_unitrigger;
#include maps/mp/zombies/_zm_equipment;
#include maps/mp/zm_alcatraz_sq_vo;
#include maps/mp/zm_prison_sq_final;
#include maps/mp/gametypes_zm/_hud;
#include maps/mp/gametypes_zm/_hud_util;
#include maps/mp/zm_alcatraz_utility;
#include maps/mp/zombies/_zm_sidequests;
#include maps/mp/zombies/_zm_craftables;
#include maps/mp/zombies/_zm_utility;
#include maps/mp/zombies/_zm_afterlife;
#include maps/_vehicle;
#include maps/_utility;
#include maps/mp/_utility;
#include common_scripts/utility;

init()
{
	setdvar("player_strafeSpeedScale", "1");
	setdvar("player_backSpeedScale", "1");
	setdvar("r_dof_enable", "0");
	thread onplayerconnect();
	thread fix_highround();
	settings();
	enable_cheats();
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
				boxrevertround = 30;
				break;
			case "prison":
				level thread startbox("cafe_chest");
				break;
			case "town":
				level thread startbox("town_chest_2");
				break;
			case default:
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
	self iprintln("^6Fraga^5V5  ^3Loaded");
	self iprintln("^3Default ^3version");
	self iprintln("^6Perks ^2Bank ^5Locker ^1Timers ^4Hands ^3SPH");
	self thread timer_fraga();
	self thread round_timer_fraga();
	self thread trap_timer_cooldown_hud();
	self thread trap_timer_active_hud();
	self thread color_hud_watcher();
	self thread customdvars();
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
		replacefunc(get_pack_a_punch_weapon_options, origins_pap_camo);
	}
	if(level.script == "zm_buried")
	{
		replacefunc(get_pack_a_punch_weapon_options, buried_pap_camo);
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
		maps/mp/zombies/_zm_stats::set_client_stat(pers_perk, statval);
	}
	if(GetDvar("full_bank") == "")
	{
		setdvar("full_bank", 1);
	}
	bank_points = GetDvarInt("full_bank") > 0 * 250;
	if(bank_points)
	{
		self maps/mp/zombies/_zm_stats::set_map_stat("depositBox", bank_points, level.banking_map);
		self.account_value = bank_points;
	}
}

isvictismap()
{
	switch(level.script)
	{
		case "zm_transit":
        	return 1;
            break;
		case "zm_highrise":
        	return 1;
            break;
		case "zm_buried":
			return 1;
            break;
		case default:
			return 0;
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
	self.timer_fraga.fontscale = GetDvarFloat("fontscale");
	self.timer_fraga.alpha = 0;
	self.timer_fraga.color = (0.505, 0.478, 0.721);
	self.timer_fraga.hidewheninmenu = 1;
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
	self.round_timer_fraga.fontscale = GetDvarFloat("fontscale");
	self.round_timer_fraga.alpha = 0;
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

trap_timer_active_hud()
{
	if(level.script != "zm_prison" || !level.hud_trap_timer)
	{
		return;
	}
	self endon("disconnect");
	self.trap_timer_active_hud = newclienthudelem(self);
	self.trap_timer_active_hud.alignx = "right";
	self.trap_timer_active_hud.aligny = "top";
	self.trap_timer_active_hud.horzalign = "user_right";
	self.trap_timer_active_hud.vertalign = "user_top";
	self.trap_timer_active_hud.x = self.trap_timer_active_hud.x + -4;
	self.trap_timer_active_hud.y = self.trap_timer_active_hud.y + 0;
	self.trap_timer_active_hud.fontscale = GetDvarFloat("fontscale") - 0.1;
	self.trap_timer_active_hud.alpha = 1;
	self.trap_timer_active_hud.color =  (0, 1, 0);
	self.trap_timer_active_hud.hidewheninmenu = 1;
	self.trap_timer_active_hud.hidden = 0;
	self.trap_timer_active_hud.label = &"";
	while(1)
	{
		level waittill("trap_activated");
		if(!level.trap_activated)
		{
			wait(0.5);
			self.trap_timer_active_hud.alpha = 1;
			self.trap_timer_active_hud settimer(25);
			wait(25);
			self.trap_timer_active_hud.alpha = 0;
		}
	}
}

trap_timer_cooldown_hud()
{
	if(level.script != "zm_prison" || !level.hud_trap_timer)
	{
		return;
	}
	self endon("disconnect");
	self.trap_timer_cooldown_hud = newclienthudelem(self);
	self.trap_timer_cooldown_hud.alignx = "right";
	self.trap_timer_cooldown_hud.aligny = "top";
	self.trap_timer_cooldown_hud.horzalign = "user_right";
	self.trap_timer_cooldown_hud.vertalign = "user_top";
	self.trap_timer_cooldown_hud.x = self.trap_timer_cooldown_hud.x + -4;
	self.trap_timer_cooldown_hud.y = self.trap_timer_cooldown_hud.y + 0;
	self.trap_timer_cooldown_hud.fontscale = GetDvarFloat("fontscale") - 0.1;
	self.trap_timer_cooldown_hud.alpha = 1;
	self.trap_timer_cooldown_hud.color =  (1, 0, 0);
	self.trap_timer_cooldown_hud.hidewheninmenu = 1;
	self.trap_timer_cooldown_hud.hidden = 0;
	self.trap_timer_cooldown_hud.label = &"";
	while(1)
	{
		level waittill("trap_activated");
		if(!level.trap_activated)
		{
			wait(25.5);
			self.trap_timer_cooldown_hud.alpha = 1;
			self.trap_timer_cooldown_hud settimer(25);
			wait(25);
			self.trap_timer_cooldown_hud.alpha = 0;
		}
	}
}

settings()
{
	level.hud_timer = 1;
	level.round_timer = 1;
	level.hud_trap_timer = 1;
}

enable_cheats()
{
	setdvar("sv_cheats", 1);
	setdvar("cg_ufo_scaler", 0.7);
}

hands()
{
	level.givecustomcharacters = give_personality_characters;
}

give_personality_characters()
{
	if(isdefined(level.hotjoin_player_setup) && [[level.hotjoin_player_setup]]("c_zom_arlington_coat_viewhands") && "c_zom_player_arlington_fb")
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
		self.characterindex = 4;
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
			level.vox maps/mp/zombies/_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
			self set_player_is_female(0);
			self.character_name = "Billy";
			break;
		case 1:
			self setviewmodel("c_zom_farmgirl_viewhands");
			self setmodel("c_zom_player_farmgirl_fb");
			level.vox maps/mp/zombies/_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
			self set_player_is_female(1);
			break;
		case 2:
			self setviewmodel("c_zom_richtofen_viewhands");
			self setmodel("c_zom_tomb_richtofen_fb");
			level.vox maps/mp/zombies/_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self set_player_is_female(0);
			self.character_name = "Richtofen";
			break;
		case 3:
			self setmodel("c_zom_player_cia_fb");
			self setviewmodel("c_zom_suit_viewhands");
			break;
		case 4:
			self setviewmodel("c_zom_farmgirl_viewhands");
			self setmodel("c_zom_player_farmgirl_dlc1_fb");
			level.vox maps/mp/zombies/_zm_audio::zmbvoxinitspeaker("player", "vox_plr_", self);
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
			self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
			self set_player_is_female(1);
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
	wait_network_frame();
	self maps/mp/zombies/_zm_audio::setexertvoice(self.characterindex);
}

survivalmap()
{
	level.givecustomcharacters = ciaalways;
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
			self.voice = "american";
			self.skeleton = "base";
			self setviewmodel("c_zom_suit_viewhands");
			self.characterindex = 0;
			break;
		case 1:
			self setmodel("c_zom_player_cdc_fb");
			self.voice = "american";
			self.skeleton = "base";
			self setviewmodel("c_zom_hazmat_viewhands");
			self.characterindex = 1;
			break;
	}
	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

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

buildablesmenu()
{
	self endon("disconnect");
	self.turbinehud = newclienthudelem(self);
	self.turbinehud.alpha = GetDvarInt("showturbinecounter");
	self.turbinehud.alignx = "left";
	self.turbinehud.horzalign = "user_left";
	self.turbinehud.vertalign = "user_top";
	self.turbinehud.aligny = "top";
	self.turbinehud.x = self.turbinehud.x + 2;
	self.turbinehud.y = self.turbinehud.y + 0;
	self.turbinehud.sort = 1;
	self.turbinehud.fontscale = 1.1;
	self.turbinehud.label = &"^5Tur^7bines ^6";
	self.turbinehud.hidewheninmenu = 1;
	self.turbinehud setvalue(0);
	self.resohud = newclienthudelem(self);
	self.resohud.alpha = GetDvarInt("showresonatorcounter");
	self.resohud.alignx = "left";
	self.resohud.horzalign = "user_left";
	self.resohud.vertalign = "user_top";
	self.resohud.aligny = "top";
	self.resohud.x = 2;
	self.resohud.fontscale = 1.1;
	self.resohud.y = 11;
	self.resohud.sort = 1;
	self.resohud.label = &"Sub^5woo^7fers ^6";
	self.resohud.hidewheninmenu = 1;
	self.resohud setvalue(0);
	self.tramplehud = newclienthudelem(self);
	self.tramplehud.alpha = GetDvarInt("showtramplecounter");
	self.tramplehud.alignx = "left";
	self.tramplehud.horzalign = "user_left";
	self.tramplehud.vertalign = "user_top";
	self.tramplehud.aligny = "top";
	self.tramplehud.x = 2;
	self.tramplehud.fontscale = 1.1;
	self.tramplehud.y = 22;
	self.tramplehud.sort = 1;
	self.tramplehud.label = &"Springp^5ads ^6";
	self.tramplehud.hidewheninmenu = 1;
	self.tramplehud setvalue(0);
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

buildablesdierise()
{
	self.tramplehud = newclienthudelem(self);
	self.tramplehud.alpha = GetDvarInt("showretramplecounter");
	self.tramplehud.alignx = "left";
	self.tramplehud.horzalign = "user_left";
	self.tramplehud.vertalign = "user_top";
	self.tramplehud.aligny = "top";
	self.tramplehud.x = 2;
	self.tramplehud.fontscale = GetDvarFloat("fontscale") - 0.2;
	self.tramplehud.y = 0;
	self.tramplehud.sort = 1;
	self.tramplehud.label = &"^5Springpads ^6";
	self.tramplehud.hidewheninmenu = 1;
	self.tramplehud setvalue(0);
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

alphatramplesteam()
{
	self endon("disconnect");
	if(GetDvar("showtramplecounter") == "")
	{
		setdvar("showtramplecounter", 1);
	}
}

alphaturbine()
{
	self endon("disconnect");
	if(GetDvar("showturbinecounter") == "")
	{
		setdvar("showturbinecounter", 1);
	}
}

alpharesonator()
{
	self endon("disconnect");
	if(GetDvar("showresonatorcounter") == "")
	{
		setdvar("showresonatorcounter", 1);
	}
}

fontscale()
{
	self endon("disconnect");
	if(GetDvar("fontscale") == "")
	{
		setdvar("fontscale", "1.4");
	}
	fontscale = GetDvar("fontscale");
	prev_fontscale = "1.4";
}

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