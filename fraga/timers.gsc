#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;


color_hud_watcher()
{
	self endon("disconnect");

	color = GetDvar("color");
	prev_color = "0.505 0.478 0.721";
	while(1)
	{
		while(color == prev_color)
		{
			color = GetDvar("color");
			wait(0.1);
		}

		colors = strtok(color, " ");
		if(colors.size != 3)
		{
			continue;
		}
		prev_color = color;
		self.timer_fraga.color = (string_to_float(colors[0]), string_to_float(colors[1]), string_to_float(colors[2]));
		self.roundtimer_fraga.color = (string_to_float(colors[0]), string_to_float(colors[1]), string_to_float(colors[2]));
		wait 0.1;
	}
}

timer_fraga()
{
	self endon("disconnect");

	self.timer_fraga = newclienthudelem(self);
	self.timer_fraga.alpha = 0;
	self.timer_fraga.color = (0.505, 0.478, 0.721);
	self.timer_fraga.hidewheninmenu = 1;
	self.timer_fraga.fontscale = 1.7;
	self thread timer_fraga_watcher();
	self thread roundtimer_fraga();
	flag_wait("initial_blackscreen_passed");
	self.timer_fraga settimerup(0);
	level waittill("end_game");
	level.total_time = level.total_time - 0.1;

	while(1)
	{
		self.timer_fraga settimer(level.total_time);
		wait(0.1);
	}
}

timer_fraga_watcher()
{
	self endon("disconnect");
	level endon("end_game");

	while(1)
	{
		while(GetDvarInt("timer") == 0)
		{
			wait(0.1);
		}
		self.timer_fraga.alpha = 1;
		while(GetDvarInt("timer") >= 1)
		{
			wait(0.1);
		}
		self.timer_fraga.alpha = 0;
	}
}

roundtimer_fraga()
{
	self endon("disconnect");

	self.roundtimer_fraga = newclienthudelem(self);
	self.roundtimer_fraga.alpha = 0;
	self.roundtimer_fraga.fontscale = 1.7;
	self.roundtimer_fraga.color = (0.505, 0.478, 0.721);
	self.roundtimer_fraga.hidewheninmenu = 1;
	flag_wait("initial_blackscreen_passed");
	self thread roundtimer_fraga_watcher();
	level.fade_time = 0.2;

	while(1)
	{
		zombies_this_round = level.zombie_total + get_round_enemy_array().size;
		hordes = zombies_this_round / 24;
		dog_round = flag("dog_round");
		leaper_round = flag("leaper_round");
		self.roundtimer_fraga settimerup(0);
		start_time = int(GetTime() / 1000);
		level waittill("end_of_round");
		end_time = int(GetTime() / 1000);
		time = end_time - start_time;
		self display_round_time(time, hordes, dog_round, leaper_round);
		level waittill("start_of_round");
		if(GetDvarInt("roundtimer") >= 1)
		{
			self.roundtimer_fraga fadeovertime(level.fade_time);
			self.roundtimer_fraga.alpha = 1;
		}
	}
}

display_round_time(time, hordes, dog_round, leaper_round)
{
	timer_for_hud = time - 0.1;
	sph_off = 1;

	if(level.round_number > GetDvarInt("sph") && !dog_round && !leaper_round)
	{
		sph_off = 0;	// Do not show sph on dog rounds
	}

	self.roundtimer_fraga fadeovertime(level.fade_time);
	self.roundtimer_fraga.alpha = 0;
	wait(level.fade_time * 2);
	self.roundtimer_fraga.label = &"Round Time: ";
	self.roundtimer_fraga fadeovertime(level.fade_time);
	self.roundtimer_fraga.alpha = 1;

	for(i = 0; i < 100 + 100 * sph_off; i++)
	{
		self.roundtimer_fraga settimer(timer_for_hud);
		wait(0.05);
	}

	self.roundtimer_fraga fadeovertime(level.fade_time);
	self.roundtimer_fraga.alpha = 0;
	wait(level.fade_time * 2);

	if(sph_off == 0)
	{
		self display_sph(time, hordes);
	}

	self.roundtimer_fraga.label = &"";
}

display_sph(time, hordes)
{
	sph = time / hordes;
	self.roundtimer_fraga fadeovertime(level.fade_time);
	self.roundtimer_fraga.alpha = 1;
	self.roundtimer_fraga.label = &"SPH: ";
	self.roundtimer_fraga setvalue(sph);

	for(i = 0; i < 5; i++)
	{
		wait(1);
	}

	self.roundtimer_fraga fadeovertime(level.fade_time);
	self.roundtimer_fraga.alpha = 0;
	wait(level.fade_time);
}

roundtimer_fraga_watcher()
{
	self endon("disconnect");
	level endon("end_game");

	while(1)
	{
		while(GetDvarInt("roundtimer") == 0)
		{
			wait(0.1);
		}

		self.roundtimer_fraga.y = GetDvarInt("timery") + 15;
		self.roundtimer_fraga.alpha = 1;

		while(GetDvarInt("roundtimer") >= 1)
		{
			wait(0.1);
		}

		self.roundtimer_fraga.alpha = 0;
	}
}


trap_timer_fraga()
{
	self endon( "disconnect" );

	self.trap_timer_fraga = newclienthudelem( self );
	self.trap_timer_fraga.alignx = "right";
	self.trap_timer_fraga.aligny = "top";
	self.trap_timer_fraga.horzalign = "user_right";
	self.trap_timer_fraga.vertalign = "user_top";
	self.trap_timer_fraga.x = -2;
	self.trap_timer_fraga.y = 14;
	self.trap_timer_fraga.fontscale = 1.4;
	self.trap_timer_fraga.hidewheninmenu = 1;
	self.trap_timer_fraga.hidden = 0;
	self.trap_timer_fraga.label = &"";
	self.trap_timer_fragax.alpha = 1;

	while( 1 )
	{
		if(getDvarInt("traptimer"))
		{
			level waittill( "trap_activated" );
			if( level.trap_activated )
			{
				wait 0.1;
				self.trap_timer_fraga.color = ( 0, 1, 0 );
				self.trap_timer_fraga.alpha = 1;
				self.trap_timer_fraga settimer( 25 );
				wait 25;
				self.trap_timer_fraga settimer( 25 );
				self.trap_timer_fraga.color = ( 1, 0, 0 );
				wait 25;
				self.trap_timer_fraga.alpha = 0;
			}
		}
		wait 0.1;	
	}
}

timerlocation()
{
	self endon("disconnect");

	while(true)
	{
		switch(getDvarInt("timer"))
		{
			case 0:
				self.timer_fraga.alpha = 0;
				self.roundtimer_fraga.alpha = 0;
				break;
			case 1:
				self.timer_fraga.alignx = "left";
				self.timer_fraga.aligny = "top";
				self.timer_fraga.horzalign = "user_left";
				self.timer_fraga.vertalign = "user_top";
				self.roundtimer_fraga.alignx = "left";
				self.roundtimer_fraga.aligny = "top";
				self.roundtimer_fraga.horzalign = "user_left";
				self.roundtimer_fraga.vertalign = "user_top";
				self.timer_fraga.x = 1;
				self.timer_fraga.y = 250;
				self.timer_fraga.alpha = 1;
				self.roundtimer_fraga.alpha = 1;
				break;
			case 2:
				self.roundtimer_fraga.alignx = "left";
				self.roundtimer_fraga.aligny = "top";
				self.roundtimer_fraga.horzalign = "user_left";
				self.roundtimer_fraga.vertalign = "user_top";
				self.timer_fraga.alignx = "left";
				self.timer_fraga.aligny = "top";
				self.timer_fraga.horzalign = "user_left";
				self.timer_fraga.vertalign = "user_top";
				self.timer_fraga.x = 1;
				self.timer_fraga.y = 0;
				self.timer_fraga.alpha = 1;
				self.roundtimer_fraga.alpha = 1;
				if(isorigins())
					self.timer_fraga.y = 45;
				if(issurvivalmap())
					self.timer_fraga.y = 40;
				if(isdierise() && level.springpad_hud.alpha != 0)
					self.timer_fraga.y = 10;
				if(isburied() && level.springpad_hud.alpha != 0)
					self.timer_fraga.y = 35;
				if(istranzit() && getDvarInt("bus"))
					self.timer_fraga.y = 21;
				break;
			case 3:
				self.roundtimer_fraga.alignx = "right";
				self.roundtimer_fraga.aligny = "top";
				self.roundtimer_fraga.horzalign = "user_right";
				self.roundtimer_fraga.vertalign = "user_top";
				self.timer_fraga.alignx = "right";
				self.timer_fraga.aligny = "top";
				self.timer_fraga.horzalign = "user_right";
				self.timer_fraga.vertalign = "user_top";
				self.timer_fraga.x = -1;
				self.timer_fraga.y = 13;
				self.timer_fraga.alpha = 1;
				self.roundtimer_fraga.alpha = 1;
				if(getDvar("cg_drawFPS") != "Off")
					self.timer_fraga.y += 4;
				if(isorigins())
					self.timer_fraga.y = 40;
				if(ismob())
				{
					self.timer_fraga.y = 40;
					self.trap_timer_fraga.y = 19;
				}
				if(isdierise())
					self.timer_fraga.y = 30;
				break;
			case 4:
				self.roundtimer_fraga.alignx = "right";
				self.roundtimer_fraga.aligny = "top";
				self.roundtimer_fraga.horzalign = "user_right";
				self.roundtimer_fraga.vertalign = "user_top";
				self.timer_fraga.alignx = "right";
				self.timer_fraga.aligny = "top";
				self.timer_fraga.horzalign = "user_right";
				self.timer_fraga.vertalign = "user_top";
				self.timer_fraga.x = -170;
				self.timer_fraga.y = 415;
				self.timer_fraga.alpha = 1;
				self.roundtimer_fraga.alpha = 1;
				break;

			default: break;
		}
		self.roundtimer_fraga.x = self.timer_fraga.x;
		self.roundtimer_fraga.y = self.timer_fraga.y + 15;
		
		wait 0.1;
	}
}