#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;

velocity_meter()
{
    self endon("disconnect");

	self.velocity = newclienthudelem(self);
	self.velocity.alignx = "center";
	self.velocity.fontscale = 1.1;
	self.velocity.horzalign = "user_center";
	self.velocity.vertalign = "user_bottom";
	self.velocity.aligny = "user_bottom";
	self.velocity.y = -100;
	self.velocity.alpha = 1;
	self.velocity.hidewheninmenu = 1;
    self.velocity setValue(0);
	level.exited_spawn_room = false;

    while (true)
    {
		if(level.exited_spawn_room == false)
        	self thread velocity_visible();

		velocity = int(length(self getvelocity() * (1, 1, 1)));
		if (!self isOnGround())
			velocity = int(length(self getvelocity() * (1, 1, 0)));

		self thread velocity_meter_scale(velocity);
        self.velocity setValue(velocity);

        wait 0.05;
    }
}
velocity_visible()
{
    while(!level.exited_spawn_room)
    {
        zone = self get_current_zone();
        if(istranzit() && zone != "zone_pri")
	        level.exited_spawn_room = true;
        if(isnuketown() && (zone != "culdesac_yellow_zone" && zone != "culdesac_green_zone" && zone != "truck_zone"))
	        level.exited_spawn_room = true;
        if(isdierise() && zone != "zone_green_start")
	        level.exited_spawn_room = true;
        if(ismob() && playerexitedmobfr())
	        level.exited_spawn_room = true;
        if(isburied() && zone != "zone_start")
	        level.exited_spawn_room = true;
        if(isorigins() && zone != "zone_start" && zone != "zone_start_a" && zone != "zone_start_b")
	        level.exited_spawn_room = true;
        if(isfarm() && zone == "zone_farm_house")
	        level.exited_spawn_room = true;
        if(istown() && (zone == "zone_bar" || zone == "zone_town_barber" || zone == "zone_ban"))
	        level.exited_spawn_room = true;
        self.velocity.alpha = 1;
        wait 1;
    }
    self.velocity.alpha = 0;
}

velocity_meter_scale(vel)
{
	self.velocity.color = (0.6, 0, 0);
	self.velocity.glowcolor = (0.3, 0, 0);

	if (vel < 330)
	{
		self.velocity.color = (0.6, 1, 0.6);
		self.velocity.glowcolor = (0.4, 0.7, 0.4);
	}

	else if (vel <= 340)
	{
		self.velocity.color = (0.8, 1, 0.6);
		self.velocity.glowcolor = (0.6, 0.7, 0.4);
	}

	else if (vel <= 350)
	{
		self.velocity.color = (1, 1, 0.6);
		self.velocity.glowcolor = (0.7, 0.7, 0.4);
	}

	else if (vel <= 360)
	{
		self.velocity.color = (1, 0.8, 0.4);
		self.velocity.glowcolor = (0.7, 0.6, 0.2);
	}

	else if (vel <= 370)
	{
		self.velocity.color = (1, 0.6, 0.2);
		self.velocity.glowcolor = (0.7, 0.4, 0.1);
	}

	else if (vel <= 380)
	{
		self.velocity.color = (1, 0.2, 0);
		self.velocity.glowcolor = (0.7, 0.1, 0);
	}
}

playerexitedmobfr()
{
	if(self.origin[1] < 10700 && self.origin[1] > 10300 && self.origin[0] > 300 && self.origin[0] < 2130)
		return false;
	return true;
}