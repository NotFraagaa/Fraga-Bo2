#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_ai_leaper;


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
	self.lastleaperround.alignx = "right";
	self.lastleaperround.horzalign = "user_right";
	self.lastleaperround.vertalign = "user_top";
	self.lastleaperround.aligny = "top";
	self.lastleaperround.x = 0;
	self.lastleaperround.y = 20;
	self.lastleaperround.fontscale = 1.1;
	self.lastleaperround.sort = 1;
	self.lastleaperround.color = (1, 1 ,1);
	if(getDvar("Language") == "spanish")
		self.lastleaperround.label = &"^3URL: ^4";
	if(getDvar("Language") == "galego")
		self.lastleaperround.label = &"^3URL: ^4";
	if(getDvar("Language") != "galego" && getDvar("Language") != "spanish")
		self.lastleaperround.label = &"^3LLR: ^4";
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
	self.lastPanzerRound.alignx = "right";
	self.lastPanzerRound.horzalign = "user_right";
	self.lastPanzerRound.vertalign = "user_top";
	self.lastPanzerRound.aligny = "top";
	self.lastPanzerRound.x = 0;
	self.lastPanzerRound.y = 20;
	self.lastPanzerRound.fontscale = 1.1;
	self.lastPanzerRound.sort = 1;
	self.lastPanzerRound.color = (1, 1 ,1);
	if(getDvar("Language") == "spanish")
		self.lastPanzerRound.label = &"^3URP: ^4";
	if(getDvar("Language") == "galego")
		self.lastPanzerRound.label = &"^3URP: ^4";
	if(getDvar("Language") != "galego" && getDvar("Language") != "spanish")
		self.lastPanzerRound.label = &"^3LPR: ^4";
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
	self.lastTemplarRound.alignx = "right";
	self.lastTemplarRound.horzalign = "user_right";
	self.lastTemplarRound.vertalign = "user_top";
	self.lastTemplarRound.aligny = "top";
	self.lastTemplarRound.x = 0;
	self.lastTemplarRound.y = 30;
	self.lastTemplarRound.fontscale = 1.1;
	self.lastTemplarRound.sort = 1;
	self.lastTemplarRound.color = (1, 1 ,1);
	if(getDvar("Language") == "spanish")
		self.lastTemplarRound.label = &"^3URT: ^4";
	if(getDvar("Language") == "galego")
		self.lastTemplarRound.label = &"^3URT: ^4";
	if(getDvar("Language") != "galego" && getDvar("Language") != "spanish")
		self.lastTemplarRound.label = &"^3LTR: ^4";
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
	self.lastBrutusRound.alignx = "right";
	self.lastBrutusRound.horzalign = "user_right";
	self.lastBrutusRound.vertalign = "user_top";
	self.lastBrutusRound.aligny = "top";
	self.lastBrutusRound.x = 0;
	if(getDvar("cg_drawfps" != "Off"))
		self.lastBrutusRound.y = 30;
	self.lastBrutusRound.fontscale = 1.4;
	self.lastBrutusRound.sort = 1;
	self.lastBrutusRound.color = (1, 1 ,1);
	if(getDvar("Language") == "spanish")
		self.lastBrutusRound.label = &"^3URB: ^4";
	if(getDvar("Language") == "galego")
		self.lastBrutusRound.label = &"^3URB: ^4";
	if(getDvar("Language") != "galego" && getDvar("Language") != "spanish")
		self.lastBrutusRound.label = &"^3LBR: ^4";
	self.lastBrutusRound.hidewheninmenu = 1;
	self.lastBrutusRound.alpha = 1;
	self.lastBrutusRound setValue(0);
	self thread trackeralpha();
	thread position();
	while(1)
	{
		level waittill( "brutus_spawned");
		self.lastBrutusRound setvalue(level.round_number);
	}
}

position()
{
	while(1)
	{
		if(getDvar("cg_drawfps" != "Off"))
			self.lastBrutusRound.y = 30;
		else
			self.lastBrutusRound.y = 25;
		wait 0.1;
	}
}

tankTracker()
{
	tank_moves = -1;
	while(1)
	{
		if(level.vh_tank.origin[0] < -320 && level.vh_tank.origin[0] > -340)
		{
			if(tank_last_check_church)
			{
				tank_moves += 1;
                if(tank_moves != 0 && GetDvarInt("tracker") != 0 && getDvar("language" == "spanish"))
					self iprintln("El tanque se ha movido " + tank_moves + " veces.");
                if(tank_moves != 0 && GetDvarInt("tracker") != 0 && getDvar("language" == "galego"))
					self iprintln("O tanque moveuse " + tank_moves + " veces.");
                if(tank_moves != 0 && GetDvarInt("tracker") != 0 && getDvar("language" != "galego") && getDvar("language" != "spanish"))
					self iprintln("The tank has been moved " + tank_moves + " times.");
			}
			tank_last_check_gen2 = 1;
			tank_last_check_church = 0;
		}
		if(level.vh_tank.origin[0] > 430 &&  level.vh_tank.origin[0] < 450)
		{
			if(tank_last_check_gen2)
			{
				tank_moves += 1;
                if(tank_moves != 0 && GetDvarInt("tracker") != 0 && getDvar("language" == "spanish"))
					self iprintln("El tanque se ha movido " + tank_moves + " veces.");
                if(tank_moves != 0 && GetDvarInt("tracker") != 0 && getDvar("language" == "galego"))
					self iprintln("O tanque moveuse " + tank_moves + " veces.");
                if(tank_moves != 0 && GetDvarInt("tracker") != 0 && getDvar("language" != "galego") && getDvar("language" != "spanish"))
					self iprintln("The tank has been moved " + tank_moves + " times.");
			}
			tank_last_check_church = 1;
			tank_last_check_gen2 = 0;
		}
		wait 1;
	}
}