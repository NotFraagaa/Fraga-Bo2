#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zm_tomb;

#include scripts\zm\fraga\localizedstrings;

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
		self thread printbuslocation();
		wait 5;
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
	self.busmoving.x = 2;
	self.busmoving.y = 11;
	self.busmoving.fontscale = 1.3;
	self.busmoving.sort = 1;
	self.busmoving.hidewheninmenu = 1;
	self.busmoving.alpha = 1;

	buslastpos = level.the_bus.origin;
	wait 0.1;

	while(1)
	{
		buslastpos = level.the_bus.origin;
		wait 0.5;
		self thread printbusstatus(buslastpos);
	}
}