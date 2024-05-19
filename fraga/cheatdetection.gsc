#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;

detect_cheats()
{
    level thread cheatsActivated();
    level thread firstboxActivated();
    level thread perkrng();
    level thread language();
}

language()
{
    switch(getDvar("Language"))
    {
        case "spanish":
		level.cheats.label = &"^1^FCheats activados";
		level.firstbox_active.label = &"^2^FFirstbox activado";
		level.perkrng_desabled.label = &"^4^FPerk RNG manipulada";
        break;
        case "galego":
		level.cheats.label = &"^1^FCheats activados";
		level.firstbox_active.label = &"^2^FFirstbox activado";
		level.perkrng_desabled.label = &"^4^FPerk RNG manipulada";
        break;
        default:
		level.cheats.label = &"^1^FCheats active";
		level.firstbox_active.label = &"^2^FFirstbox active";
		level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
        break;
    }
}
cheatsActivated()
{
	level.cheats.hidewheninmenu = 1;
    level.cheats = createserverfontstring( "objective", 1.3 );
    level.cheats.y = 20;
    level.cheats.x = 0;
    level.cheats.fontscale = 3;
    level.cheats.alignx = "center";
    level.cheats.horzalign = "user_center";
    level.cheats.vertalign = "user_top";
    level.cheats.aligny = "top";
    level.cheats.alpha = 0;

    while(1)
    {
        if(getDvarInt("sv_cheats"))
            level.cheats.alpha = 1;
        if(!getDvarInt("sv_cheats"))
            level.cheats.alpha = 0;
        wait 0.1;
    }
}

firstboxActivated()
{
	level.firstbox_active.hidewheninmenu = 1;
    level.firstbox_active = createserverfontstring( "objective", 1.3 );
    level.firstbox_active.y = -20;
    level.firstbox_active.x = 0;
    level.firstbox_active.fontscale = 1;
    level.firstbox_active.alignx = "center";
    level.firstbox_active.horzalign = "user_center";
    level.firstbox_active.vertalign = "user_bottom";
    level.firstbox_active.aligny = "bottom";
    level.firstbox_active.alpha = 0;

    while(level.round_number < 2)
    {
        if(getDvarInt("firstbox"))
            level.firstbox_active.alpha = 1;
        if(!getDvarInt("firstbox"))
            level.firstbox_active.alpha = 0;
        wait 0.1;
    }
    level.firstbox_active.alpha = 0;
}

perkrng()
{
	level.perkrng_desabled.hidewheninmenu = 1;
    level.perkrng_desabled = createserverfontstring( "objective", 1.3 );
    level.perkrng_desabled.y = -30;
    level.perkrng_desabled.x = 0;
    level.perkrng_desabled.fontscale = 1;
    level.perkrng_desabled.alignx = "center";
    level.perkrng_desabled.horzalign = "user_center";
    level.perkrng_desabled.vertalign = "user_bottom";
    level.perkrng_desabled.aligny = "bottom";
    if(isburied() || isorigins() || isnuketown())
    {
        while(level.round_number < 2)
        {
            if(!getDvarInt("perkRNG"))
                level.perkrng_desabled.alpha = 1;
            if(getDvarInt("perkRNG"))
                level.perkrng_desabled.alpha = 0;
            wait 0.1;
        }
    }
    level.perkrng_desabled.alpha = 0;
}