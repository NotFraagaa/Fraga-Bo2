#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_ai_leaper;


#include scripts\zm\fraga\localizedstrings;


trackeralpha()
{
	self endon("disconnect");
	while(1)
	{
		if(getDvarInt("tracker"))
		{
			if(isDefined(level.trackingLeapers))
				self.lastleaperround.alpha  = 1;
			if(isDefined(level.trackingTemplars))
				self.lastTemplarRound.alpha = 1;
			if(isDefined(level.trackingBrutus))
				self.lastBrutusRound.alpha  = 1;
			if(isDefined(level.trackingPanzers))
				self.lastPanzerRound.alpha  = 1;
		}
		if(!getDvarInt("tracker"))
		{
			if(isDefined(level.trackingLeapers))
				self.lastleaperround.alpha  = 0;
			if(isDefined(level.trackingTemplars))
				self.lastTemplarRound.alpha = 0;
			if(isDefined(level.trackingBrutus))
				self.lastBrutusRound.alpha  = 0;
			if(isDefined(level.trackingPanzers))
				self.lastPanzerRound.alpha  = 0;
		}
		wait 0.1;
	}
}

leapertracker()
{
	self endon("disconnect");
	if(!isDefined(level.trackingLeapers))
		level.trackingLeapers = true;

	self.lastleaperround = newclienthudelem(self);
	self.lastleaperround.alignx = "left";
	self.lastleaperround.horzalign = "user_left";
	self.lastleaperround.vertalign = "user_top";
	self.lastleaperround.aligny = "top";
	self.lastleaperround.x = 7;
	self.lastleaperround.y = 370;
	self.lastleaperround.fontscale = 1.1;
	self.lastleaperround.sort = 1;
	self.lastleaperround.color = (1, 1 ,1);
	self.lastleaperround.hidewheninmenu = 1;
	self.lastleaperround.alpha = 1;
	self.lastleaperround setValue(0);
	self thread trackeralpha();
	while(1)
	{
		level waittill("start_of_round");
		if(flag("leaper_round"))
		self.lastleaperround setvalue(level.round_number);
	}
}

PanzerTracker()
{
	self endon("disconnect");
	if(!isDefined(level.trackingPanzers))
		level.trackingPanzers = true;

	self.lastPanzerRound = newclienthudelem(self);
	self.lastPanzerRound.alignx = "left";
	self.lastPanzerRound.horzalign = "user_left";
	self.lastPanzerRound.vertalign = "user_top";
	self.lastPanzerRound.aligny = "top";
	self.lastPanzerRound.x = 7;
	self.lastPanzerRound.y = 390;
	self.lastPanzerRound.fontscale = 1.1;
	self.lastPanzerRound.sort = 1;
	self.lastPanzerRound.color = (1, 1 ,1);
	self.lastPanzerRound.hidewheninmenu = 1;
	self.lastPanzerRound.alpha = 1;
	self.lastPanzerRound setValue(0);
	self thread trackeralpha();
	while(1)
	{
		level waittill( "spawn_mechz" );
		self.lastPanzerRound setvalue(level.round_number);
	}
}

TemplarTracker()
{
	self endon("disconnect");
	if(!isDefined(level.trackingTemplars))
		level.trackingTemplars = true;

	self.lastTemplarRound = newclienthudelem(self);
	self.lastTemplarRound.alignx = "left";
	self.lastTemplarRound.horzalign = "user_left";
	self.lastTemplarRound.vertalign = "user_top";
	self.lastTemplarRound.aligny = "top";
	self.lastTemplarRound.x = 7;
	self.lastTemplarRound.y = 402;
	self.lastTemplarRound.fontscale = 1.1;
	self.lastTemplarRound.sort = 1;
	self.lastTemplarRound.color = (1, 1 ,1);
	self.lastTemplarRound.hidewheninmenu = 1;
	self.lastTemplarRound.alpha = 1;
	self.lastTemplarRound setValue(0);
	self thread trackeralpha();
	while(1)
	{
		level waittill( "generator_under_attack" );
		self.lastTemplarRound setvalue(level.round_number);
	}
}


BrutusTracker()
{
	self endon("disconnect");
	if(!isDefined(level.trackingBrutus))
		level.trackingBrutus = true;

	self.lastBrutusRound = newclienthudelem(self);
	self.lastBrutusRound.alignx = "left";
	self.lastBrutusRound.horzalign = "user_left";
	self.lastBrutusRound.vertalign = "user_top";
	self.lastBrutusRound.aligny = "top";
	self.lastBrutusRound.x = 7;
	self.lastBrutusRound.y = 365;
	self.lastBrutusRound.fontscale = 1.1;
	self.lastBrutusRound.sort = 1;
	self.lastBrutusRound.color = (1, 1 ,1);
	self.lastBrutusRound.hidewheninmenu = 1;
	self.lastBrutusRound.alpha = 1;
	self.lastBrutusRound setValue(0);
	self thread trackeralpha();
	while(1)
	{
		level waittill( "brutus_spawned");
		self.lastBrutusRound setvalue(level.round_number);
	}
}