#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_ai_leaper;

init()
{
	if(GetDvar("character") == "")
	{
		setdvar("character", 1);
	}
    level thread connected();
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
    self thread buildablesmenu();
    self thread bank();
    self.turbinesused = 0;
    self.resoused = 0;
    self.trampused = 0;
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


hands()
{
	level.givecustomcharacters = ::set_character_option;
}

set_character_option()
{
    switch( getDvarInt("character") )
    {
        case 1:
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            self.voice = "american";
            self.skeleton = "base";
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            level.vox zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
            self set_player_is_female( 1 );
            self.characterindex = 2;
            if( level.script == "zm_highrise" )
            {
                self setmodel( "c_zom_player_farmgirl_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_farmgirl_dlc1_fb";
            }
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
            if( level.script == "zm_highrise" )
            {
                self setmodel( "c_zom_player_oldman_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_oldman_dlc1_fb";
            }
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
            if( level.script == "zm_highrise" )
            {
                self setmodel( "c_zom_player_reporter_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_reporter_dlc1_fb";
            }
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
            if( level.script == "zm_highrise" )
            {
                self setmodel( "c_zom_player_engineer_dlc1_fb" );
                self.whos_who_shader = "c_zom_player_engineer_dlc1_fb";
            }
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