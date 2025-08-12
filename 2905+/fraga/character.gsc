#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_tomb;


#include scripts\zm\fraga\ismap;


set_character_option()
{
    if(istranzit())
    {
        self.favorite_wall_weapons_list = [];
        self.talks_in_danger = 0;
        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_player_farmgirl_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_farmgirl_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "rottweil72_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "870mcs_zm";
                self set_player_is_female( 1 );
            break;
            case 2:
                self setmodel( "c_zom_player_oldman_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_oldman_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "frag_grenade_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "claymore_zm";
                self set_player_is_female( 0 );
            break;
            case 3:
                self setmodel( "c_zom_player_reporter_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_reporter_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.talks_in_danger = 1;
                level.rich_sq_player = self;
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "beretta93r_zm";
                self set_player_is_female( 0 );
            break;
            case 4:
                self setmodel( "c_zom_player_engineer_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_engineer_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m14_zm";
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "m16_zm";
                self set_player_is_female( 0 );
            break;
        }
    }
    if(isnuketown())
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
    }
    if(isdierise())
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
    }
    if(ismob())
    {
        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_player_arlington_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_arlington_coat_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "ray_gun_zm";
                self set_player_is_female( 0 );
                self.character_name = "Arlington";
            break;
            case 2:
                self setmodel( "c_zom_player_oleary_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_oleary_shortsleeve_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "judge_zm";
                self set_player_is_female( 0 );
                self.character_name = "Finn";
            break;
            case 3:
                self setmodel( "c_zom_player_deluca_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_deluca_longsleeve_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "thompson_zm";
                self set_player_is_female( 0 );
                self.character_name = "Sal";
            break;
            case 4:
                self setmodel( "c_zom_player_handsome_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_handsome_sleeveless_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
                self set_player_is_female( 0 );
                self.character_name = "Billy";
            break;
            case 5:
                self setmodel( "c_zom_player_handsome_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_ghost_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self.favorite_wall_weapons_list[self.favorite_wall_weapons_list.size] = "blundergat_zm";
                self set_player_is_female( 0 );
                self.character_name = "Billy";
            break;
        }
    }
    if(isburied())
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
    }
    if(isorigins())
    {
        self detachall();

        if ( !isdefined( self.characterindex ) )
            self.characterindex = assign_lowest_unused_character_index();

        self.favorite_wall_weapons_list = [];
        self.talks_in_danger = 0;

        switch( getDvarInt("character") )
        {
            case 1:
                self setmodel( "c_zom_tomb_richtofen_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_richtofen_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Richtofen";
            break;
            case 2:
                self setmodel( "c_zom_tomb_dempsey_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_dempsey_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Dempsey";
            break;
            case 3:
                self setmodel( "c_zom_tomb_nikolai_fb" );
                self.voice = "russian";
                self.skeleton = "base";
                self setviewmodel( "c_zom_nikolai_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Nikolai";
            break;
            case 4:
                self setmodel( "c_zom_tomb_takeo_fb" );
                self.voice = "american";
                self.skeleton = "base";
                self setviewmodel( "c_zom_takeo_viewhands" );
                level.vox maps\mp\zombies\_zm_audio::zmbvoxinitspeaker( "player", "vox_plr_", self );
                self set_player_is_female( 0 );
                self.character_name = "Takeo";
            break;
        }
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
