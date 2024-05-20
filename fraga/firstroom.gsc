#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;
#include scripts\zm\fraga\localizedstrings;

frkills()
{
    while(level.round_number != 5)
        level waittill("end_of_round");
    while(!level.exited_spawn_room)
    {
        level waittill("end_of_round");
        switch(level.players.size)
        {
            case 1: level thread displaykills1(); break;
            case 2: level thread displaykills1(); level thread displaykills2(); break;
            case 3: level thread displaykills1(); level thread displaykills2(); level thread displaykills3(); break;
            case 4: level thread displaykills1(); level thread displaykills2(); level thread displaykills3(); level thread displaykills4(); break;
        }
        level thread printplayerkills();
    }
}

displaykills1()
{
	level.playerkills1.hidewheninmenu = 1;
    level.playerkills1 = createserverfontstring( "objective", 1.3 );
    level.playerkills1.y = 0;
    level.playerkills1.x = 0;
    level.playerkills1.fontscale = 1.4;
    level.playerkills1.alignx = "center";
    level.playerkills1.horzalign = "user_center";
    level.playerkills1.vertalign = "user_top";
    level.playerkills1.aligny = "top";
    level.playerkills1.alpha = 1;
    level.playerkills1 setvalue(level.players[0].kills);
    wait 11;
    level.playerkills1 destroy();
}

displaykills2()
{
	level.playerkills2.hidewheninmenu = 1;
    level.playerkills2 = createserverfontstring( "objective", 1.3 );
    level.playerkills2.y = 12;
    level.playerkills2.x = 0;
    level.playerkills2.fontscale = 1.4;
    level.playerkills2.alignx = "center";
    level.playerkills2.horzalign = "user_center";
    level.playerkills2.vertalign = "user_top";
    level.playerkills2.aligny = "top";
    level.playerkills2.alpha = 1;
    level.playerkills2 setvalue(level.players[1].kills);
    wait 11;
    level.playerkills2 destroy();
}

displaykills3()
{
	level.playerkills3.hidewheninmenu = 1;
    level.playerkills3 = createserverfontstring( "objective", 1.3 );
    level.playerkills3.y = 24;
    level.playerkills3.x = 0;
    level.playerkills3.fontscale = 1.4;
    level.playerkills3.alignx = "center";
    level.playerkills3.horzalign = "user_center";
    level.playerkills3.vertalign = "user_top";
    level.playerkills3.aligny = "top";
    level.playerkills3.alpha = 1;
    level.playerkills3 setvalue(level.players[2].kills);
    wait 11;
    level.playerkills3 destroy();
}

displaykills4()
{
	level.playerkills4.hidewheninmenu = 1;
    level.playerkills4 = createserverfontstring( "objective", 1.3 );
    level.playerkills4.y = 36;
    level.playerkills4.x = 0;
    level.playerkills4.fontscale = 1.4;
    level.playerkills4.alignx = "center";
    level.playerkills4.horzalign = "user_center";
    level.playerkills4.vertalign = "user_top";
    level.playerkills4.aligny = "top";
    level.playerkills4.alpha = 1;
    level.playerkills4 setvalue(level.players[3].kills);
    wait 11;
    level.playerkills4 destroy();
}

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
    self.velocity.alpha = 0;
    while(level.round_number != 5)
        level waittill("end_of_round");
    while(!level.exited_spawn_room)
    {
        zone = self get_current_zone();
        if(istranzit() && zone != "zone_pri")
	        level.exited_spawn_room = true;
        if(isnuketown() && playerexitnuketownfr(zone))
	        level.exited_spawn_room = true;
        if(isdierise() && zone != "zone_green_start")
	        level.exited_spawn_room = true;
        if(ismob() && playerexitedmobfr())
	        level.exited_spawn_room = true;
        if(isburied() && playerexitburiedfr())
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
    self.velocity destroy();
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
		return true;
	return false;
}

playerexitburiedfr()
{
	if(self.origin [0] < -2200 && self.origin[0] > -3200 && self.origin[1] > -850 && self.origin[1] < 150)
		return false;
	return true;
}

playerexitnuketownfr(zone)
{
	if(zone == "openhouse1_backyard_zone" || zone == "openhouse2_backyard_zone" || zone == "openhouse2_f2_zone" || zone == "openhouse1_f2_zone")
		return true;
	return false;
}