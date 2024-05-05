#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;

setDvars()
{
    setdvar("player_strafeSpeedScale", 1 );
    setdvar("player_backSpeedScale", 1 );
    setdvar("r_dof_enable", 0 );
	if(GetDvar("character") == "")
		setdvar("character", 0);
    if(getdvar("SR") == "")
        setdvar("SR", 0 );
    if(getdvar("bus") == "")
        setdvar("bus", 0 );
    if(getdvar("graphictweaks") == "")
        setdvar("graphictweaks", 0 );
    if(getdvar("color") == "")
        setdvar("color", "0.505 0.478 0.721");
    if(getdvar("sph") == "")
        setdvar("sph", 50 );
    if(getdvar("timer") == "")
        setdvar("timer", 1 );
    if(getdvar("roundtimer") == "")
        setdvar("roundtimer", 1 );
    if(getdvar("splits") != "")
        setdvar("splits", 0 );
	if( getdvar("nightmode") == "")
		setdvar("nightmode", 0 );
	if(GetDvar("firstbox") == "")
		setdvar("firstbox", 0);
    
    if(isvictismap())
    {
        if(GetDvar("pers_perk") == "")
            setdvar("pers_perk", 1);
        if(GetDvar("full_bank") == "")
            setdvar("full_bank", 1);
        if(GetDvar("buildables") == "")
            setdvar("buildables", 1);
        if(getdvar("fridge") == "")
            setdvar("fridge", "m16");
    }
    if(ismob())
    {
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 1);
        if(getdvar("traptimer") == "")
            setdvar("traptimer", 0 );
    }
    if(isorigins())
    {
        if(GetDvar("templars") == "")
            setdvar("templars", 0);
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 1);
        if(GetDvar("perkRNG") == "")
            setdvar("perkRNG", 1);
    }
    if(isburied())
    {
        if(GetDvar("perkRNG") == "")
            setdvar("perkRNG", 1);
    }
    if(isdierise())
    {
        if(getDvarInt("tracker") == "")
            setDvar("tracker", 1);
    }

}