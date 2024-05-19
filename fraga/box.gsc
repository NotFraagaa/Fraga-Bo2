#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_craftables;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;

#include scripts\zm\fraga\ismap;

boxhits()
{
    level thread displayBoxHits();
}


displayBoxHits()
{
	level.boxhits.hidewheninmenu = 1;
    level.boxhits = createserverfontstring( "objective", 1.3 );
    level.boxhits.y = 0;
    if(isdierise())
        level.boxhits.y = 10;
    level.boxhits.x = 0;
    level.boxhits.fontscale = 1.4;
    level.boxhits.alignx = "center";
    level.boxhits.horzalign = "user_center";
    level.boxhits.vertalign = "user_top";
    level.boxhits.aligny = "top";
    level.boxhits.label = &"^3Box hits: ^4";
    level.boxhits.alpha = 0;
    level.boxhits setvalue(0);
    if(issurvivalmap())
    {
        level.boxhits.alignx = "left";
        level.boxhits.horzalign = "user_left";
        level.boxhits.x = 2;
    }
    if(issurvivalmap())
        level.boxhits.alpha = 1;
    while(!isDefined(level.total_chest_accessed))
        wait 0.1;
    lol = 0;
    while(1)
    {
        while(!isdefined(level.chest_accessed))
            wait 0.1;
        if(lol != level.chest_accessed)
        {
            level.total_chest_accessed++;
            lol = level.chest_accessed;
            level.boxhits setvalue(level.total_chest_accessed);
            i = 1;
            if(!issurvivalmap())
            {
                while(true)
                {
                    i -= 0.02;
                    level.boxhits.alpha = i;
                    wait 0.1;
                    if(i < 0.1)
                    {
                        level.boxhits.alpha = 0;
                        break;
                    }
                }
            }
        }
        wait 0.1;
    }
    wait 1;
}

avg()
{
    level thread label();
    level thread display();
    level thread make_avg();
}

label()
{
    self endon("disconnect");

    /* definimos las varaibles que vamos a trackear */
    if(!isDefined(level.total_mk2))
        level.total_mk2 = 0;
    if(!isDefined(level.total_raygun))
        level.total_raygun = 0;
    if(!isDefined(level.avgraygunmk2))
        level.avgraygunmk2 = 0;
    if(!isDefined(level.avgraygun))
        level.avgraygun = 0;

    /* Creamos el texto que va a aparecer en pantalla */
	level.raygunavg.hidewheninmenu = 1;
    level.raygunavg = createserverfontstring( "objective", 1.3 );
    level.raygunavg.y = 26;
    level.raygunavg.x = 2;
    level.raygunavg.fontscale = 1.3;
    level.raygunavg.alignx = "left";
    level.raygunavg.horzalign = "user_left";
    level.raygunavg.vertalign = "user_top";
    level.raygunavg.aligny = "top";
    level.raygunavg.label = &"^3Raygun AVG: ^4";
    level.raygunavg.alpha = 1;
	level.raygunmk2avg.hidewheninmenu = 1;
    level.raygunmk2avg = createserverfontstring( "objective", 1.3 );
    level.raygunmk2avg.y = 14;
    level.raygunmk2avg.x = 2;
    level.raygunmk2avg.fontscale = 1.3;
    level.raygunmk2avg.alignx = "left";
    level.raygunmk2avg.horzalign = "user_left";
    level.raygunmk2avg.vertalign = "user_top";
    level.raygunmk2avg.aligny = "top";
    level.raygunmk2avg.label = &"^3Raygun MK2 AVG: ^4";
    level.raygunmk2avg.alpha = 1;
    track_rayguns();
}

track_rayguns()
{
	level waittill("connecting", player);
    /* Comprobamos si el jugador tiene un arma de rayos o no */
    /* Cuando tenga el arma de rayos aumentamos el contador  */
    while(true)
    {
        if(player has_weapon_or_upgrade("ray_gun_zm"))
            level.total_raygun++;
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            level.total_mk2++;

        while(player has_weapon_or_upgrade("ray_gun_zm") || player has_weapon_or_upgrade("raygun_mark2_zm")) 
        {
            if(player has_weapon_or_upgrade("ray_gun_zm") || player has_weapon_or_upgrade("raygun_mark2_zm"))
                wait 0.1;
            wait 20; /* Estos 20 segundos son para evitar contar cuando mejora el arma de rayos */
        }
        wait 1;
    }
}

make_avg()
{
    /* Cálculo de la media */
    while(1)
    {
        if(level.total_chest_accessed)
        {
            level.avgraygunmk2 = (level.total_chest_accessed / level.total_mk2);
            level.avgraygun = (level.total_chest_accessed / level.total_raygun);
        }
        wait 0.1;
    }
}
display()
{
    /* Aquí enseñamos la media */
    self endon("disconnect");
    
	level.displayraygunmk2avg.hidewheninmenu = 1;
    level.displayraygunmk2avg = createserverfontstring( "objective", 1.3 );
    level.displayraygunmk2avg.y = 14;
    level.displayraygunmk2avg.x = 80;
    level.displayraygunmk2avg.fontscale = 1.3;
    level.displayraygunmk2avg.alignx = "left";
    level.displayraygunmk2avg.horzalign = "user_left";
    level.displayraygunmk2avg.vertalign = "user_top";
    level.displayraygunmk2avg.aligny = "top";
    level.displayraygunmk2avg.label = &"^4";
    level.displayraygunmk2avg.alpha = 1;
    level.displayraygunmk2avg setvalue(0);

	level.displayraygunavg.hidewheninmenu = 1;
    level.displayraygunavg = createserverfontstring( "objective", 1.3 );
    level.displayraygunavg.y = 26;
    level.displayraygunavg.x = 60;
    level.displayraygunavg.fontscale = 1.3;
    level.displayraygunavg.alignx = "left";
    level.displayraygunavg.horzalign = "user_left";
    level.displayraygunavg.vertalign = "user_top";
    level.displayraygunavg.aligny = "top";
    level.displayraygunavg.label = &"^4";
    level.displayraygunavg.alpha = 1;
    level.displayraygunavg setvalue(0);

    while(1)
    {
        if(isDefined(level.avgraygun))
            level.displayraygunavg setvalue(level.avgraygun);
        if(isDefined(level.avgraygunmk2))
            level.displayraygunmk2avg setvalue(level.avgraygunmk2);
        wait 1;
    }
}
