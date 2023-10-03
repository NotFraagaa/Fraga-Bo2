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
}

onconnect()
{
    self thread bank();
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread hands();
        player thread onconnect();
        player thread fridge();
		player thread lastleaperround();
		if(sessionmodeisonlinegame() && level.scr_zm_ui_gametype_group == "zclassic")
		{
			player thread perks();
		}

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
            self setmodel( "c_zom_player_farmgirl_dlc1_fb" );
            self.whos_who_shader = "c_zom_player_farmgirl_dlc1_fb";
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
            self setmodel( "c_zom_player_oldman_dlc1_fb" );
            self.whos_who_shader = "c_zom_player_oldman_dlc1_fb";
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
			self setmodel( "c_zom_player_reporter_dlc1_fb" );
			self.whos_who_shader = "c_zom_player_reporter_dlc1_fb";
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
            self setmodel( "c_zom_player_engineer_dlc1_fb" );
            self.whos_who_shader = "c_zom_player_engineer_dlc1_fb";
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
	persistent_upgrades = array("pers_boarding", "pers_revivenoperk", "pers_multikill_headshots", "pers_cash_back_bought", "pers_cash_back_prone", "pers_insta_kill", "pers_jugg","pers_nube", "pers_carpenter", "pers_flopper_counter", "pers_perk_lose_counter", "pers_pistol_points_counter", "pers_double_points_counter", "pers_sniper_counter");
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

lastleaperround()
{
	self endon("disconnect");
	leaper_round = flag("leaper_round");

	self.lastleaperround = newclienthudelem(self);
	self.lastleaperround.alignx = "left";
	self.lastleaperround.horzalign = "user_left";
	self.lastleaperround.vertalign = "user_top";
	self.lastleaperround.aligny = "top";
	self.lastleaperround.x = 2;
	self.lastleaperround.y = 0;
	self.lastleaperround.fontscale = 1.1;
	self.lastleaperround.sort = 1;
	self.lastleaperround.color = (1, 1 ,1);
	self.lastleaperround.label = &"Last Leaper Round: ^2";
	self.lastleaperround.hidewheninmenu = 1;
	self.lastleaperround.alpha = 1;
	while(1)
	{
		if(flag("leaper_round"))
		{
		self.lastleaperround setvalue(level.round_number);
		}
		level waittill("leaper_round");
	}
}