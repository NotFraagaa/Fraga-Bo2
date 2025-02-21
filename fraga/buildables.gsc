#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\zombies\_zm_craftables;

#include scripts\zm\fraga\ismap;


watch_stat( stat, map_array )
{
    if ( !isdefined( map_array ) )
        map_array = array( "zm_buried" );

    if ( !isinarray( map_array, level.script ) )
        return;

    level endon( "end_game" );
    self endon( "disconnect" );

    if ( !isdefined( self.initial_stats[stat] ) )
        self.initial_stats[stat] = self getdstat( "buildables", stat, "buildable_pickedup" );

    while ( true )
    {
        stat_number = self getdstat( "buildables", stat, "buildable_pickedup" );
        delta = stat_number - self.initial_stats[stat];

        if ( delta > 0 && stat_number > 0 )
        {
            self.initial_stats[stat] = stat_number;
            level.buildable_stats[stat] = level.buildable_stats[stat] + delta;
            i = 1;
            while(i != 0)
            {
    
                level.turbine_hud.alpha = i;
                level.subwoofer_hud.alpha = i;
                level.springpad_hud.alpha = i;
                i = i -0.02;
                wait 0.1;
            }
            level.turbine_hud.alpha = 0;
            level.subwoofer_hud.alpha = 0;
            level.springpad_hud.alpha = 0;
        }

        wait 0.1;
    }
}

buildable_hud()
{
	level.springpad_hud.hidewheninmenu = true;
    level.springpad_hud = createserverfontstring( "objective", 1.3 );
    if(level.script == "zm_buried") level.springpad_hud.y = 0;
    else level.springpad_hud.y = 15;
    level.springpad_hud.x = 2;
    level.springpad_hud.fontscale = 1.1;
    level.springpad_hud.alignx = "left";
    level.springpad_hud.horzalign = "user_left";
    level.springpad_hud.vertalign = "user_top";
    level.springpad_hud.aligny = "top";
    level.springpad_hud setvalue( 0 );
	level.subwoofer_hud.hidewheninmenu = true;
    level.subwoofer_hud = createserverfontstring( "objective", 1.3 );
    level.subwoofer_hud.y = 10;
    level.subwoofer_hud.x = 2;
    level.subwoofer_hud.fontscale = 1.1;
    level.subwoofer_hud.alignx = "left";
    level.subwoofer_hud.horzalign = "user_left";
    level.subwoofer_hud.vertalign = "user_top";
    level.subwoofer_hud.aligny = "top";
    level.subwoofer_hud setvalue( 0 );
	level.turbine_hud.hidewheninmenu = true;
    level.turbine_hud = createserverfontstring( "objective", 1.3 );
    level.turbine_hud.y = 20;
    level.turbine_hud.x = 2;
    level.turbine_hud.fontscale = 1.1;
    level.turbine_hud.alignx = "left";
    level.turbine_hud.horzalign = "user_left";
    level.turbine_hud.vertalign = "user_top";
    level.turbine_hud.aligny = "top";
    level.turbine_hud setvalue( 0 );
    level.turbine_hud.alpha = 0;
    level.subwoofer_hud.alpha = 0;
    level.springpad_hud.alpha = 0;

    if (isdierise())
    {
        level.subwoofer_hud destroy();
        level.turbine_hud destroy();
    }
}

buildable_controller()
{
    level endon( "end_game" );

    buildable_hud();
    level.buildable_stats = array();
    level.buildable_stats["springpad_zm"] = 0;
    level.buildable_stats["turbine"] = 0;
    level.buildable_stats["subwoofer_zm"] = 0;

	wait 1;
	if(level.buildable_stats["springpad_zm"] > 0)
		level.buildable_stats["springpad_zm"] = 0;
	if(level.buildable_stats["turbine"] > 0)
		level.buildable_stats["turbine"] = 0;
	if(level.buildable_stats["subwoofer_zm"] > 0)
		level.buildable_stats["subwoofer_zm"] = 0;

    if(isburied())
        while(true)
        {
            level.subwoofer_hud setvalue( level.buildable_stats["subwoofer_zm"] );
            level.turbine_hud setvalue( level.buildable_stats["turbine"] );
            level.springpad_hud setvalue( level.buildable_stats["springpad_zm"] );
            wait 0.1;
        }
    if(isdierise())
        while(true)
        {
            level.springpad_hud setvalue( level.buildable_stats["springpad_zm"] );
            wait 0.1;
        }
}