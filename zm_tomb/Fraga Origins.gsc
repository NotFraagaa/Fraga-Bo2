#include maps\mp\zombies\_zm;
#include maps\mp\zm_tomb_vo;
#include maps\mp\zombies\_zm_clone;
#include maps\mp\zombies\_zm_unitrigger;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zm_tomb_teleporter;
#include maps\mp\zombies\_zm_weap_one_inch_punch;
#include maps\mp\zombies\_zm_ai_mechz;
#include maps\mp\animscripts\zm_shared;
#include maps\mp\zm_tomb_giant_robot_ffotd;
#include maps\mp\zombies\_zm_net;
#include maps\mp\gametypes_zm\_hud;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\animscripts\zm_utility;
#include maps\mp\animscripts\zm_death;
#include maps\mp\zombies\_zm_laststand;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_perks;

init()
{
	replacefunc(maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options, ::origins_pap_camo);
	level thread fizzStartLocation();
	if(GetDvar("DoubleTap") == "")
	{
		setdvar("DoubleTap", 0);
	}
	level thread doubletap();
	level thread connected();
	thread onplayerconnect();
	if(GetDvar("character") == "")
	{
		setdvar("character", 1);
	}
}

onplayerconnect()
{
	while(1)
	{
		level thread startbox("bunker_tank_chest");
		level waittill("connecting", player);
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

    if ( !isdefined( self.characterindex ) )
	{
		self.characterindex = assign_lowest_unused_character_index();
	}

    self.favorite_wall_weapons_list = [];
    self.talks_in_danger = 0;

    switch( getDvarInt("character") )
    {
	case 1:
		self character\c_ger_richtofen_dlc4::main();
		self setviewmodel( "c_zom_richtofen_viewhands" );
		level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
		self set_player_is_female( 0 );
		self.character_name = "Richtofen";
		break;
	case 2:
		self character\c_usa_dempsey_dlc4::main();
		self setviewmodel( "c_zom_dempsey_viewhands" );
		level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
		self set_player_is_female( 0 );
		self.character_name = "Dempsey";
		break;
	case 3:
		self character\c_rus_nikolai_dlc4::main();
		self setviewmodel( "c_zom_nikolai_viewhands" );
		level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
		self set_player_is_female( 0 );
		self.character_name = "Nikolai";
		break;
	case 4:
		self character\c_jap_takeo_dlc4::main();
		self setviewmodel( "c_zom_takeo_viewhands" );
		level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
		self set_player_is_female( 0 );
		self.character_name = "Takeo";
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


fizzStartLocation()
{
	level waittill("connecting", player);
	level waittill("initial_players_connected");
	wait(3);
	machines = getentarray("random_perk_machine", "targetname");
	index = 2;
	level.random_perk_start_machine = machines[index];
	foreach(machine in machines)
	{
		if(machine != level.random_perk_start_machine)
		{
			machine hidepart("j_ball");
			machine.is_current_ball_location = 0;
			machine setclientfield("turn_on_location_indicator", 0);
			continue;
		}
		machine.is_current_ball_location = 1;
		level.wunderfizz_starting_machine = machine;
		level notify("wunderfizz_setup");
		machine thread maps\mp\zombies\_zm_perk_random::machine_think();
	}
}

doubletap()
{
	if(GetDvarInt("DoubleTap") >= 1)
	{
		replaceFunc(maps\mp\zombies\_zm_perk_random::get_weighted_random_perk, ::getWeightedRandomPerk);
	}
}


//No funciona
getWeightedRandomPerk( player ) 
{
	while(1)
	{
		wait(1);
		if (self HasPerk("specialty_rof"))
			{
				return "specialty_divetonuke";
			}
		else
			return "specialty_rof";
	}
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


assign_lowest_unused_character_index()
{
    charindexarray = [];
    charindexarray[0] = 0;
    charindexarray[1] = 1;
    charindexarray[2] = 2;
    charindexarray[3] = 3;
    players = get_players();

    if ( players.size == 1 )
    {
        charindexarray = array_randomize( charindexarray );

        if ( charindexarray[0] == 2 )
            level.has_richtofen = 1;

        return charindexarray[0];
    }
    else
    {
        n_characters_defined = 0;

        foreach ( player in players )
        {
            if ( isdefined( player.characterindex ) )
            {
                arrayremovevalue( charindexarray, player.characterindex, 0 );
                n_characters_defined++;
            }
        }

        if ( charindexarray.size > 0 )
        {
            if ( n_characters_defined == players.size - 1 )
            {
                if ( !( isdefined( level.has_richtofen ) && level.has_richtofen ) )
                {
                    level.has_richtofen = 1;
                    return 2;
                }
            }

            charindexarray = array_randomize( charindexarray );

            if ( charindexarray[0] == 2 )
                level.has_richtofen = 1;

            return charindexarray[0];
        }
    }

    return 0;
}