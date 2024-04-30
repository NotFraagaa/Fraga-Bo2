#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_tomb;

buslocation()
{
    
	self.buslocation = newclienthudelem(self);
	self.buslocation.alignx = "left";
	self.buslocation.horzalign = "user_left";
	self.buslocation.vertalign = "user_top";
	self.buslocation.aligny = "top";
	self.buslocation.x = 2;
	self.buslocation.y = 0;
	self.buslocation.fontscale = 1.3;
	self.buslocation.sort = 1;
	self.buslocation.color = (1, 1 ,1);
	self.buslocation.label = &"Waiting for bus";
	self.buslocation.hidewheninmenu = 1;
	self.buslocation.alpha = 1;
	self thread watcher();

    wait 14;
    while(1)
    {
		if(getDvar("Language") != "spanish" && getDvar("Language") != "galego")
		{
			if(level.the_bus.origin[0] > -6530 && level.the_bus.origin[0] < -6520 && level.the_bus.origin[1] < 4800 && level.the_bus.origin[1] > 4600)	// Depot
				self.buslocation.label = &"^3Bus: ^4Depot";
			if(level.the_bus.origin[0] > -5560 && level.the_bus.origin[0] < -5550  && level.the_bus.origin[1] > -6870 && level.the_bus.origin[1] < -6800)	// Dinner
				self.buslocation.label = &"^3Bus: ^4Dinner";
			if(level.the_bus.origin[0] > 6400 && level.the_bus.origin[1] < 6440 && level.the_bus.origin[1] > -5850 && level.the_bus.origin[1] < -5820)	// Farm
				self.buslocation.label = &"^3Bus: ^4Farm";
			if(level.the_bus.origin[0] > 10280 && level.the_bus.origin[0] < 10320 && level.the_bus.origin[1] < 7500 && level.the_bus.origin[1] > 7400)	// Power
				self.buslocation.label = &"^3Bus: ^4Power";
			if(level.the_bus.origin[0] > 1460 && level.the_bus.origin[0] < 1490 && level.the_bus.origin[1] < 900 && level.the_bus.origin[1] > 800) 	// Town
				self.buslocation.label = &"^3Bus: ^4Town";
			wait 0.1;
		}
		if(getDvar("Language") == "spanish")
		{
			if(level.the_bus.origin[0] > -6530 && level.the_bus.origin[0] < -6520 && level.the_bus.origin[1] < 4800 && level.the_bus.origin[1] > 4600)	// Depot
				self.buslocation.label = &"^3Bus: ^4Estación";
			if(level.the_bus.origin[0] > -5560 && level.the_bus.origin[0] < -5550  && level.the_bus.origin[1] > -6870 && level.the_bus.origin[1] < -6800)	// Dinner
				self.buslocation.label = &"^3Bus: ^4Restaurante";
			if(level.the_bus.origin[0] > 6400 && level.the_bus.origin[1] < 6440 && level.the_bus.origin[1] > -5850 && level.the_bus.origin[1] < -5820)	// Farm
				self.buslocation.label = &"^3Bus: ^4Granja";
			if(level.the_bus.origin[0] > 10280 && level.the_bus.origin[0] < 10320 && level.the_bus.origin[1] < 7500 && level.the_bus.origin[1] > 7400)	// Power
				self.buslocation.label = &"^3Bus: ^4Electicidad";
			if(level.the_bus.origin[0] > 1460 && level.the_bus.origin[0] < 1490 && level.the_bus.origin[1] < 900 && level.the_bus.origin[1] > 800) 	// Town
				self.buslocation.label = &"^3Bus: ^4Ciudad";
			wait 0.1;
		}
		if(getDvar("Language") == "galego")
		{
			if(level.the_bus.origin[0] > -6530 && level.the_bus.origin[0] < -6520 && level.the_bus.origin[1] < 4800 && level.the_bus.origin[1] > 4600)	// Depot
				self.buslocation.label = &"^3Bus: ^4Ferrol";
			if(level.the_bus.origin[0] > -5560 && level.the_bus.origin[0] < -5550  && level.the_bus.origin[1] > -6870 && level.the_bus.origin[1] < -6800)	// Dinner
				self.buslocation.label = &"^3Bus: ^4Fene";
			if(level.the_bus.origin[0] > 6400 && level.the_bus.origin[1] < 6440 && level.the_bus.origin[1] > -5850 && level.the_bus.origin[1] < -5820)	// Farm
				self.buslocation.label = &"^3Bus: ^4Granxa";
			if(level.the_bus.origin[0] > 10280 && level.the_bus.origin[0] < 10320 && level.the_bus.origin[1] < 7500 && level.the_bus.origin[1] > 7400)	// Power
				self.buslocation.label = &"^3Bus: ^4Caranza";
			if(level.the_bus.origin[0] > 1460 && level.the_bus.origin[0] < 1490 && level.the_bus.origin[1] < 900 && level.the_bus.origin[1] > 800) 	// Town
				self.buslocation.label = &"^3Bus: ^4Coruña";
			wait 0.1;
		}
    }
}
watcher()
{
	while(1)
	{
		if(getDvarInt("bus") == 1)
		{
			self.buslocation.alpha = 1;
			self.busmoving.alpha = 1;
		}
		if(getDvarInt("bus") == 0)
		{
			self.buslocation.alpha = 0;
			self.busmoving.alpha = 0;
		}
		wait 0.1;
	}
}

busMoving()
{
	self.busmoving = newclienthudelem(self);
	self.busmoving.alignx = "left";
	self.busmoving.horzalign = "user_left";
	self.busmoving.vertalign = "user_top";
	self.busmoving.aligny = "top";
	self.busmoving.label = &"^3Mooving";
	self.busmoving.x = 2;
	self.busmoving.y = 20;
	self.busmoving.fontscale = 1.3;
	self.busmoving.sort = 1;
	self.busmoving.hidewheninmenu = 1;
	self.busmoving.alpha = 1;

	buslastpos = level.the_bus.origin;
	wait 5;

	while(1)
	{
		if(buslastpos != level.the_bus.origin)
		{
			self.busmoving.label = &"^3Mooving";
			wait 0.1;
		}
		else
		{
			self.busmoving.label = &"^1Stopped";
			wait 0.1;
		}
		buslastpos = level.the_bus.origin;
		wait 0.5;
	}
}