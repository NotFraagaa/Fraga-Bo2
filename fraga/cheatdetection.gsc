#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;

#include scripts\zm\fraga\ismap;

detect_cheats()
{
    level thread cheatsActivated();
    level thread firstboxActivated();
    level thread perkrng();
    level thread tempalars();
    level waittill("connecting", player);
    {
        //player thread boxrngmanipulation();
        //player thread autentification();
    }
}

cheatsActivated()
{
    if(level.debug) return;
	level.cheats.hidewheninmenu = true;
    level.cheats = createserverfontstring( "objective", 1.3 );
    level.cheats.y = 20;
    level.cheats.x = 0;
    level.cheats.fontscale = 3;
    level.cheats.alignx = "center";
    level.cheats.horzalign = "user_center";
    level.cheats.vertalign = "user_top";
    level.cheats.aligny = "top";
    level.cheats.alpha = 0;

    while(true)
    {
        level.cheats.alpha = getDvarInt("sv_cheats");
        wait 0.1;
    }
}

firstboxActivated()
{
	level.firstbox_active.hidewheninmenu = true;
    level.firstbox_active = createserverfontstring( "objective", 1.3 );
    level.firstbox_active.y = -20;
    level.firstbox_active.x = 0;
    level.firstbox_active.fontscale = 1;
    level.firstbox_active.alignx = "center";
    level.firstbox_active.horzalign = "user_center";
    level.firstbox_active.vertalign = "user_bottom";
    level.firstbox_active.aligny = "bottom";
    level.firstbox_active.label = &"^2^FFirstbox active";
    level.firstbox_active.alpha = 0;
    if(getDvarInt("firstbox"))
    while(level.round_number < 2)
    {
        level.firstbox_active.alpha = 1;
        wait 0.1;
    }
    level.firstbox_active destroy();
}

perkrng()
{
	level.perkrng_desabled.hidewheninmenu = true;
    level.perkrng_desabled = createserverfontstring( "objective", 1.3 );
    level.perkrng_desabled.y = -30;
    level.perkrng_desabled.x = 0;
    level.perkrng_desabled.fontscale = 1;
    level.perkrng_desabled.alignx = "center";
    level.perkrng_desabled.horzalign = "user_center";
    level.perkrng_desabled.vertalign = "user_bottom";
    level.perkrng_desabled.aligny = "bottom";
    level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
    if(isburied() || isorigins() || isnuketown())
    {
        if(!getDvarInt("perkRNG"))
        while(level.round_number < 2)
        {
            level.perkrng_desabled.alpha = 1;
            wait 0.1;
        }
    }
    level.perkrng_desabled destroy();
}

tempalars()
{
	level.templar_modiffied.hidewheninmenu = true;
    level.templar_modiffied = createserverfontstring( "objective", 1.3 );
    level.templar_modiffied.y = -40;
    level.templar_modiffied.x = 0;
    level.templar_modiffied.fontscale = 1;
    level.templar_modiffied.alignx = "center";
    level.templar_modiffied.horzalign = "user_center";
    level.templar_modiffied.vertalign = "user_bottom";
    level.templar_modiffied.aligny = "bottom";
    level.templar_modiffied.label = &"^6^FTemplars manipulated";
    if(isorigins() && getDvarInt("templars"))
    {
        if(getDvarInt("templars"))
        while(level.round_number < 2)
        {
            level.templar_modiffied.alpha = 1;
            wait 0.1;
        }
    }
    level.templar_modiffied destroy();
}