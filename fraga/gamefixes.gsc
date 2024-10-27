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


fixrotationangle()
{
	angulo1 = 0;
	angulo2 = 0;
	level.vueltass = 0;
    level.vueltas = createserverfontstring( "objective", 1.3 );
	level.vueltas.hidewheninmenu = 1;
    level.vueltas.y = -40;
    level.vueltas.x = 0;
    level.vueltas.fontscale = 1.4;
    level.vueltas.alignx = "center";
    level.vueltas.horzalign = "user_center";
    level.vueltas.vertalign = "user_bottom";
    level.vueltas.aligny = "bottom";
    level.vueltas.alpha = 1;
    level.vueltas.label = &"^F^1Warning: you're close to the max rotation angle";
	thread showWarning();
    while(true)
    {
		angulo1 = self.angles[1];
		diferencia = angulo1 - angulo2;
		if(diferencia  < -180)
			level.vueltass++;
		if(diferencia  > 180)
			level.vueltass--;
		
		angulo2 = angulo1;
		wait 0.001;
    }
}

showWarning()
{
	while(!getDvarInt("stop_warning"))
	{
		if(level.vueltass > 5000000 || -level.vueltass > 5000000)
			level.vueltas.alpha = 1;
		else level.vueltas.alpha = 0;
		wait 0.5;
	}
	level.vueltas destroy();
}