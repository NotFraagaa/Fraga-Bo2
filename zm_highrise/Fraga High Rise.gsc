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
    self thread buildablesmenu();
    self thread bank();
    self.trampused = 0;
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


buildablesmenu()
{
	self endon("disconnect");

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
	self.trample setvalue(0);
	buildablesmenu_watcher();

	while(1)
	{
        which = self waittill_any_return("equip_turbine_zm_given", "equip_springpad_zm_given", "equip_subwoofer_zm_given");
		if(which == "equip_springpad_zm_given")
		{
			self.trampused = self.trampused + 1;
			self.tramplehud setvalue(self.trampused);
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