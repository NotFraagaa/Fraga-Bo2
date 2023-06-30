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
        player thread onconnect();
        player thread fridge();
		player thread hands();
		if(sessionmodeisonlinegame() && level.scr_zm_ui_gametype_group == "zclassic")
		{
			player thread perks();
		}

	}
}

fridge()
{
	flag_wait("initial_blackscreen_passed");

	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "mp5k_upgraded_zm");
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 200);
	self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 40);
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


hands()
{
	level.givecustomcharacters = ::set_character_option;
}

set_character_option()
{
    switch( getDvarInt("character") )
    {
        case 1:
            self character\c_transit_player_farmgirl::main();
            self setviewmodel( "c_zom_farmgirl_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
            self set_player_is_female( 1 );
            break;
        case 2:
            self character\c_transit_player_oldman::main();
            self setviewmodel( "c_zom_oldman_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "frag_grenade_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "claymore_zm";
            self set_player_is_female( 0 );
            break;
        case 3:
            self character\c_transit_player_reporter::main();
            self setviewmodel( "c_zom_reporter_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.talks_in_danger = 1;
            level.rich_sq_player = self;
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "beretta93r_zm";
            self set_player_is_female( 0 );
            break;
        case 4:
            self character\c_transit_player_engineer::main();
            self setviewmodel( "c_zom_engineer_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m14_zm";
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m16_zm";
            self set_player_is_female( 0 );
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
