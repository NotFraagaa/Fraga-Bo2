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
	thread onplayerconnect();
}

onplayerconnect()
{
	while(1)
	{
		if(level.scr_zm_map_start_location == "town")
		{
		level thread startbox("town_chest_2");
		level waittill("connecting", player);
		}
	}
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

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		if(level.scr_zm_ui_gametype_group != "zclassic")
		{
			level thread hands();
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
			self setmodel("c_zom_player_cdc_fb");
			self setviewmodel("c_zom_suit_viewhands");
			self.voice = "american";
			self.skeleton = "base";
			break;
		case 2:
			self setmodel("c_zom_player_cia_fb");
			self setviewmodel("c_zom_hazmat_viewhands");
			self.voice = "american";
			self.skeleton = "base";
			break;
		case 3:
			self setmodel("c_zom_player_cdc_fb");
			self setviewmodel("c_zom_hazmat_viewhands");
			self.voice = "american";
			self.skeleton = "base";
			break;
		case 4:
			self setmodel("c_zom_player_cia_fb");
			self setviewmodel("c_zom_suit_viewhands");
			self.voice = "american";
			self.skeleton = "base";
			break;
	}

	self setmovespeedscale(1);
	self setsprintduration(4);
	self setsprintcooldown(0);
}

set_exert_id()
{
	self endon("disconnect");
	wait_network_frame();
	self maps\mp\zombies\_zm_audio::setexertvoice(self.characterindex);
}