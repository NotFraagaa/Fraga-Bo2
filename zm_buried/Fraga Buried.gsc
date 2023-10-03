#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_ai_leaper;
#include mpas\mp\zombies\_zm_perks;

init()
{
	
	if(GetDvar("perkrng") == "")
	{
		setdvar("perkrng", 1);
	}
	//level thread perfectperks();
	if(GetDvar("character") == "")
	{
		setdvar("character", 1);
	}
    level thread connected();
	level thread buildable_controller();
    replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::buried_pap_camo);
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread hands();
        player thread onconnect();
        player thread fridge();
		if(sessionmodeisonlinegame() && level.scr_zm_ui_gametype_group == "zclassic")
		{
			player thread perks();
		}
	}
}

onconnect()
{
    self thread bank();
	if (is_tracking_buildables())
	{
		self.initial_stats = array();
		self thread watch_stat("springpad_zm", array("zm_highrise", "zm_buried"));
		self thread watch_stat("turbine");
		self thread watch_stat("subwoofer_zm");
		self thread buildablesmenu_watcher();
	}
}


buildablesmenu_watcher()
{
	self endon("disconnect");
	level endon("end_game");
	if(GetDvar("buildables") == "")
	{
		setdvar("buildables", 1);
	}

	while(1)
	{
		while(GetDvarInt("buildables") == 0)
		{
			wait(0.1);
		}
		level.turbine_hud.alpha = 1;
		level.subwoofer_hud.alpha = 1;
		level.springpad_hud.alpha = 1;

		while(GetDvarInt("buildables") >= 1)
		{
			wait(0.1);
		}
		level.turbine_hud.alpha = 0;
		level.subwoofer_hud.alpha = 0;
		level.springpad_hud.alpha = 0;
	}
}


hands()
{
	level.givecustomcharacters = ::set_character_option;
}

set_character_option()
{
    switch( getDvarInt("character") )
    {
        case 1:
            self setmodel( "c_zom_player_farmgirl_fb" );
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
            self set_player_is_female( 1 );
            self.characterindex = 2;
            break;
        case 2:
            self setmodel( "c_zom_player_oldman_fb" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_oldman_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "frag_grenade_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "claymore_zm";
            self set_player_is_female( 0 );
            self.characterindex = 0;
            break;
        case 3:
            self setmodel( "c_zom_player_reporter_fb" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_reporter_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "beretta93r_zm";
            self.talks_in_danger = 1;
            level.rich_sq_player = self;
            self set_player_is_female( 0 );
            self.characterindex = 1;
            break;
        case 4:
            self setmodel( "c_zom_player_engineer_fb" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_engineer_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m14_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m16_zm";
            self set_player_is_female( 0 );
            self.characterindex = 3;
            break;
    }

	self setmovespeedscale( 1 );
	self setsprintduration( 4 );
	self setsprintcooldown( 0 );
	self thread set_exert_id();
}


set_exert_id()
{
	self endon("disconnect");
	wait_network_frame();
	self maps\mp\zombies\_zm_audio::setexertvoice(self.characterindex);
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


fridge()
{
	flag_wait("initial_blackscreen_passed");

	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
}

perks()
{
	self waittill("spawned_player");
	self endon("disconnect");
	persistent_upgrades = array("pers_boarding", "pers_revivenoperk", "pers_multikill_headshots", "pers_cash_back_bought", "pers_cash_back_prone", "pers_insta_kill", "pers_jugg", "pers_nube", "pers_carpenter", "pers_flopper_counter", "pers_perk_lose_counter", "pers_pistol_points_counter", "pers_double_points_counter", "pers_sniper_counter");
	persistent_upgrade_values = [];
	persistent_upgrade_values["pers_boarding"] = 74;
	persistent_upgrade_values["pers_revivenoperk"] = 17;
	persistent_upgrade_values["pers_multikill_headshots"] = 5;
	persistent_upgrade_values["pers_cash_back_bought"] = 50;
	persistent_upgrade_values["pers_cash_back_prone"] = 15;
	persistent_upgrade_values["pers_insta_kill"] = 2;
	persistent_upgrade_values["pers_jugg"] = 3;
	persistent_upgrade_values["pers_nube"] = 1;
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

bank()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

    if (level.round_number == 1)
	{
    self.account_value = level.bank_account_max;		
	}
}


/*
perfectperks()
{
	if(GetDvarInt("perkrng") == 0)
	{
		replaceFunc(maps\mp\zombies\_zm_perks::give_random_perk, ::giverandomperk);
	}
}

giverandomperk()
{
    random_perk = undefined;
	perks = array_randomize( "specialty_armorvest","specialty_fastreload","specialty_rof","specialty_longersprint","specialty_additionalprimaryweapon","specialty_quickrevive");
	if ( !self hasperk( perk ) && !self has_perk_paused( perk ) )
		perks[perks.size] = perk;
	
    if ( perks.size > 0 )
    {
        random_perk = perks[0];
        self give_perk( random_perk );
    }
    else
        self playsoundtoplayer( level.zmb_laugh_alias, self );

    return random_perk;
}
*/


watch_stat(stat, map_array)
{
	if (!isDefined(map_array))
		map_array = array("zm_buried");

	if (!IsInArray(map_array, level.script))
		return;

	level endon("end_game");
	self endon("disconnect");

	if (!isDefined(self.initial_stats[stat]))
		self.initial_stats[stat] = self getdstat("buildables", stat, "buildable_pickedup");

	while (true)
	{
		stat_number = self getdstat("buildables", stat, "buildable_pickedup");
		delta = stat_number - self.initial_stats[stat];

		if (delta > 0 && stat_number > 0)
		{
			self.initial_stats[stat] = stat_number;
			level.buildable_stats[stat] += delta;
		}

		wait 0.1;
	}
}


is_tracking_buildables()
{
	if (is_buried() || is_die_rise())
		return true;
	return false;
}

include_buildable( buildable_struct )
{
    maps\mp\zombies\_zm_buildables::include_zombie_buildable( buildable_struct );
}


is_buildable_included( name )
{
    if ( isdefined( level.zombie_include_buildables[name] ) )
        return true;

    return false;
}


buildable_hud()
{

	self.trample = newclienthudelem(self);
	self.trample.alignx = "left";
	self.trample.horzalign = "user_left";
	self.trample.vertalign = "user_top";
	self.trample.aligny = "top";
	self.trample.x = 2;
	self.trample.fontscale = 1.1;
	self.trample.y = 0;
	self.trample.sort = 1;
	self.trample.label = &"Springpads ^6";
	self.trample.hidewheninmenu = 1;

	level.springpad_hud = createserverfontstring("objective", 1.3);
	level.springpad_hud.label = &"SPRINGPADS: ^2";
	level.springpad_hud.y = 0;
	level.springpad_hud.x = 2;
	level.springpad_hud.fontscale = 1.1;
	level.springpad_hud.alignx = "left";
	level.springpad_hud.horzalign = "user_left";
	level.springpad_hud.vertalign = "user_top";
	level.springpad_hud.aligny = "top";
	level.springpad_hud setValue(0);

	level.subwoofer_hud = createserverfontstring("objective", 1.3);
	level.subwoofer_hud.y = 10;
	level.subwoofer_hud.x = 2;
	level.subwoofer_hud.fontscale = 1.1;
	level.subwoofer_hud.alignx = "left";
	level.subwoofer_hud.horzalign = "user_left";
	level.subwoofer_hud.vertalign = "user_top";
	level.subwoofer_hud.aligny = "top";
	level.subwoofer_hud.label = &"SUBWOOFERS: ^3";
	level.subwoofer_hud setValue(0);

	level.turbine_hud = createserverfontstring("objective", 1.3);
	level.turbine_hud.y = 20;
	level.turbine_hud.x = 2;
	level.turbine_hud.fontscale = 1.1;
	level.turbine_hud.alignx = "left";
	level.turbine_hud.horzalign = "user_left";
	level.turbine_hud.vertalign = "user_top";
	level.turbine_hud.aligny = "top";
	level.turbine_hud.label = &"TURBINES: ^1";
	level.turbine_hud setValue(0);
	if (is_die_rise())
	{
		level.subwoofer_hud destroy();
		level.turbine_hud destroy();
	}
}


buildable_controller()
{
	level endon("end_game");

	if (!is_tracking_buildables())
		return;

	buildable_hud();

	level.buildable_stats = array();
	level.buildable_stats["springpad_zm"] = 0;
	level.buildable_stats["turbine"] = 0;
	level.buildable_stats["subwoofer_zm"] = 0;

	while (true)
	{
		if (is_buried())
		{
			level.subwoofer_hud setValue(level.buildable_stats["subwoofer_zm"]);
			level.turbine_hud setValue(level.buildable_stats["turbine"]);
		}
		level.springpad_hud setValue(level.buildable_stats["springpad_zm"]);

		wait 0.1;
	}
}


create_zombie_buildable_piece( modelname, radius, height, hud_icon )
{
    self maps\mp\zombies\_zm_buildables::create_zombie_buildable_piece( modelname, radius, height, hud_icon );
}

is_buildable()
{
    return self maps\mp\zombies\_zm_buildables::is_buildable();
}

wait_for_buildable( buildable_name )
{
    level waittill( buildable_name + "_built", player );

    return player;
}


is_buried()
{
	if (level.script == "zm_buried")
		return true;
	return false;
}

is_die_rise()
{
	if (level.script == "zm_highrise")
		return true;
	return false;
}