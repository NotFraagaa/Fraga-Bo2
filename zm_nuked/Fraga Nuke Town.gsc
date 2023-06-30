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

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread hands();

	}
}

hands()
{
	level.givecustomcharacters = ::set_character_option;
}

set_character_option()
{
	self detachall();
	switch( getDvarInt("character") )
	{
    case 1:
        self setmodel("c_zom_player_cdc_fb");
        self setviewmodel("c_zom_suit_viewhands");
        self.voice = "american";
        self.skeleton = "base";
        self set_player_is_female( 0 );
        break;
    case 2:
        self setmodel("c_zom_player_cdc_fb");
        self setviewmodel("c_zom_suit_viewhands");
        self.voice = "american";
        self.skeleton = "base";
        self set_player_is_female( 0 );
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