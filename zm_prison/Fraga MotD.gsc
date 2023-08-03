#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_weap_tomahawk;
#include maps\mp\zm_alcatraz_utility;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_equipment;
#include maps\mp\zm_prison_sq_bg;
#include maps\mp\zm_alcatraz_craftables;
#include maps\mp\zombies\_zm_afterlife;
#include maps\mp\zombies\_zm_magicbox;
init()
{
	replaceFunc( maps\mp\zm_alcatraz_sq::setup_master_key, ::setup_master_key );
	if(GetDvar("character") == "")
	{
		setdvar("character", 1);
	}
    level thread connected();
    thread onplayerconnect();
}

connected()
{
	while(1)
	{
		level waittill("connecting", player);
		player thread hands();
        player thread onconnect();
		player thread lastbrutusround();

	}
}

onconnect()
{
	self thread trap_timer_fraga();
	self thread trap_timer_cooldown_fraga();
}

onplayerconnect()
{
	while(1)
	{
		level waittill("connecting", player);
		level thread startbox("cafe_chest");
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

hands()
{
	level.givecustomcharacters = ::set_character_option;
}

set_character_option()
{
    switch( getDvarInt("character") )
    {
        case 1:
            self character\c_zom_arlington::main();
            self setviewmodel( "c_zom_arlington_coat_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "ray_gun_zm";
            self set_player_is_female( 0 );
            self.character_name = "Arlington";
            break;
        case 2:
            self character\c_zom_oleary::main();
            self setviewmodel( "c_zom_oleary_shortsleeve_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "judge_zm";
            self set_player_is_female( 0 );
            self.character_name = "Finn";
            break;
        case 3:
            self character\c_zom_deluca::main();
            self setviewmodel( "c_zom_deluca_longsleeve_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "thompson_zm";
            self set_player_is_female( 0 );
            self.character_name = "Sal";
            break;
        case 4:
            self character\c_zom_handsome::main();
            self setviewmodel( "c_zom_handsome_sleeveless_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
            self set_player_is_female( 0 );
            self.character_name = "Billy";
            break;
        case 5:
            self character\c_zom_handsome::main();
            self setviewmodel( "c_zom_ghost_viewhands" );
            level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
            self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
            self set_player_is_female( 0 );
            self.character_name = "Billy";
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

setup_master_key()
{
	level.is_master_key_west = 0;
	setclientfield( "fake_master_key", level.is_master_key_west + 1 );
	if ( level.is_master_key_west )
	{
		level thread maps\mp\zm_alcatraz_sq::key_pulley( "west" );
		exploder( 101 );
		array_delete( getentarray( "wires_pulley_east", "script_noteworthy" ) );
	}
	else
	{
		level thread maps\mp\zm_alcatraz_sq::key_pulley( "east" );
		exploder( 100 );
		array_delete( getentarray( "wires_pulley_west", "script_noteworthy" ) );
	}
}


trap_timer_fraga()
{
	self endon( "disconnect" );

	self.trap_timer_fraga = newclienthudelem( self );
	self.trap_timer_fraga.alignx = "right";
	self.trap_timer_fraga.aligny = "top";
	self.trap_timer_fraga.horzalign = "user_right";
	self.trap_timer_fraga.vertalign = "user_top";
	self.trap_timer_fraga.x += -2;
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
	self endon( "disconnect" );

	self.trap_timer_cooldown_fraga = newclienthudelem( self );
	self.trap_timer_cooldown_fraga.alignx = "right";
	self.trap_timer_cooldown_fraga.aligny = "top";
	self.trap_timer_cooldown_fraga.horzalign = "user_right";
	self.trap_timer_cooldown_fraga.vertalign = "user_top";
	self.trap_timer_cooldown_fraga.x += -2;
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

lastbrutusround()
{
	self endon("disconnect");
	brutus_killed = flag("brutus_killed");

	self.lastbrutusround = newclienthudelem(self);
	self.lastbrutusround.alignx = "left";
	self.lastbrutusround.horzalign = "user_left";
	self.lastbrutusround.vertalign = "user_top";
	self.lastbrutusround.aligny = "top";
	self.lastbrutusround.x = 2;
	self.lastbrutusround.y = 0;
	self.lastbrutusround.fontscale = 1.1;
	self.lastbrutusround.sort = 1;
	self.lastbrutusround.color = (1, 1 ,1);
	self.lastbrutusround.label = &"Last Brutus Round: ^2";
	self.lastbrutusround.hidewheninmenu = 1;
	self.lastbrutusround.alpha = 1;
	while(1)
	{ 
		self.lastbrutusround setvalue(level.round_number);
		level waittill("brutus_killed");
	}
}