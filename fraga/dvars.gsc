#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

setDvars()
{
    setdvar( "player_strafeSpeedScale", 1 );
    setdvar( "player_backSpeedScale", 1 );
    setdvar( "r_dof_enable", 0 );
    if(GetDvar("Fragalanguage") == "")
        setDvar("Fragalanguage", "galego");
	if(GetDvar("perkRNG") == "")
		setdvar("perkRNG", 1);
	if(GetDvar("character") == "")
		setdvar("character", 1);
    if ( getdvar( "SR" ) == "" )
        setdvar( "SR", 0 );
    if ( getdvar( "bus" ) == "" )
        setdvar( "bus", 0 );
    if ( getdvar( "graphictweaks" ) == "" )
        setdvar( "graphictweaks", 0 );
    if ( getdvar( "color" ) == "" )
        setdvar( "color", "0.505 0.478 0.721" );
    if ( getdvar( "sph" ) == "" )
        setdvar( "sph", 30 );
    if ( getdvar( "timery" ) == "" )
        setdvar( "timery", 250 );
    if ( getdvar( "timerx" ) == "" )
        setdvar( "timerx", 4 );
    if ( getdvar( "traptimer" ) == "" )
        setdvar( "traptimer", 0 );
    if ( getdvar( "timer" ) == "" )
        setdvar( "timer", 1 );
    if ( getdvar( "roundtimer" ) == "" )
        setdvar( "roundtimer", 1 );
    if ( getdvar( "splits" ) != "" )
        setdvar( "splits", 0 );
	if( getDvar( "nightmode") == "" )
		setDvar( "nightmode", 0 );
	if(getDvarInt("tracker") == "")
		setDvar("tracker", 1);
    if(GetDvar("pers_perk") == "")
        setdvar("pers_perk", 1);
	if(GetDvar("full_bank") == "")
	    setdvar("full_bank", 1);
	if(GetDvar("buildables") == "")
		setdvar("buildables", 1);
	if(GetDvar("firstbox") == "")
		setdvar("firstbox", 0);

    if(level.script == "zm_tomb")
    {
        if(GetDvar("Templars") == "")
            setDvar("Templars", 0);
        if(GetDvar("box") != "")
        {
            if(getDvar("box") == "gen3")
            {
                setdvar("box", "gen3");
            }
            else
            {
                setdvar("box", "gen2");
            }
        }
        if(GetDvar("box") == "")
            setDvar("box", "gen2");
    }
    if(level.scr_zm_map_start_location == "town")
    {
        if(GetDvar("box") != "")
        {
            if(getDvar("box") == "dt")
            {
                setdvar("box", "dt");
            }
            else
            {
                setdvar("box", "qr");
            }
        }
        if(GetDvar("box") == "")
            setDvar("box", "dt");
    }

    if(level.script == "zm_prison")
    {
        if(GetDvar("box") != "")
        {
            if(getDvar("box") == "office")
            {
                setdvar("box", "office");
            }
            else
            {
                setdvar("box", "cafe");
            }
        }
        if(GetDvar("box") == "")
            setDvar("box", "cafe");
    }

}