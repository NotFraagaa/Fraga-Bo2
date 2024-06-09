#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

fix_highround()
{
	if(level.script == "zm_tomb")
		return;
	while(level.round_number > 155)
	{
		zombies = getaiarray("axis");
		i = 0;
		while(i < zombies.size)
		{
			if(zombies[i].targetname != "zombie")
			{
				continue;
			}
			if(zombies[i].targetname == "zombie")
			{
				if(!isdefined(zombies[i].health_override))
				{
					zombies[i].health_override = 1;
					zombies[i].health = 1044606723;
				}
			}
			i++;
		}
		wait(0.1);
	}
}

roundcounter()
{
	round = 0;
	level.roundcounter setvalue(round);
	level.roundcounter.hidewheninmenu = 1;
    level.roundcounter = createserverfontstring( "objective", 1.3 );
    level.roundcounter.y = -5;
    level.roundcounter.x = 70;
    level.roundcounter.fontscale = 10;
    level.roundcounter.alignx = "left";
    level.roundcounter.horzalign = "user_left";
    level.roundcounter.vertalign = "user_bottom";
    level.roundcounter.aligny = "bottom";
    level.roundcounter.alpha = 0;
    level.roundcounter.color = (0.27, 0, 0);
	while(true)
	{
		level waittill("start_of_round");
		round++;
    	level.roundcounter setvalue(round);
		if(round >= 255)
    	level.roundcounter.alpha = 1;
	}
}