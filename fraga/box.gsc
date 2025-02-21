#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;

#include scripts\zm\fraga\ismap;

boxhits()
{
    level thread displayBoxHits();
    while(true)
    {
        level waittill("connecting", player);
        player thread track_rays();
    }
}

track_rays()
{
    wait 2;
    while(true)
    {
        while(self.sessionstate != "playing")
            wait 0.1;
        if(self hasweapon("ray_gun_zm")) level.total_ray++;
        if(self hasweapon("raygun_mark2_zm")) level.total_mk2++;

        while(self has_weapon_or_upgrade("ray_gun_zm") || self has_weapon_or_upgrade("raygun_mark2_zm")) 
            wait 0.1;
        wait 0.1;
    }
}

displayBoxHits()
{
	level.boxhits.hidewheninmenu = true;
    level.boxhits = createserverfontstring( "objective", 1.3 );
    level.boxhits.y = 0;
    level.boxhits.x = 0;
    level.boxhits.fontscale = 1.4;
    level.boxhits.alignx = "center";
    level.boxhits.horzalign = "user_center";
    level.boxhits.vertalign = "user_top";
    level.boxhits.aligny = "top";
    level.boxhits.alpha = 0;
    level.boxhits setvalue(0);
    if(issurvivalmap())
    {
        level.total_chest_accessed_mk2 = 0;
        level.total_chest_accessed_ray = 0;
        level.boxhits.alignx = "left";
        level.boxhits.horzalign = "user_left";
        level.boxhits.x = 2;
        level.boxhits.alpha = 1;
    }

    while(!isDefined(level.total_chest_accessed))
        wait 0.1;
    while(!isdefined(level.chest_accessed))
        wait 0.1;

    counter = 0;
    while(true)
    {
        if(counter != level.chest_accessed)
        {
            counter = level.chest_accessed;
            if(counter == 0) continue;

            level.total_chest_accessed++;

            if(count_for_raygun()) level.total_chest_accessed_ray++;
            if(count_for_mk2()) level.total_chest_accessed_mk2++;
            
            level.boxhits setvalue(level.total_chest_accessed);
            if(!issurvivalmap())
                fade();
        }
        wait 0.1;
    }
}

count_for_raygun()
{
    foreach(player in level.players)
        if (!player has_weapon_or_upgrade("ray_gun_zm"))
            return true;
    return false;
}
count_for_mk2()
{
    foreach(player in level.players)
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            return false;
    return true;
}

fade()
{
    for(i = 0; i > 0.1; i -= 0.02)
    {
        level.boxhits.alpha = i;
        wait 0.1;
    }
    level.boxhits.alpha = 0;
}

raygun_counter()
{
    self endon("disconnect");

    if(!isDefined(level.total_mk2)) level.total_mk2 = 0;
    if(!isDefined(level.total_ray)) level.total_ray = 0;

	level.total_ray_display.hidewheninmenu = true;
    level.total_ray_display = createserverfontstring( "objective", 1.3 );
    level.total_ray_display.y = 26;
    level.total_ray_display.x = 2;
    level.total_ray_display.fontscale = 1.3;
    level.total_ray_display.alignx = "left";
    level.total_ray_display.horzalign = "user_left";
    level.total_ray_display.vertalign = "user_top";
    level.total_ray_display.aligny = "top";
    level.total_ray_display.alpha = 1;
	level.total_mk2_display.hidewheninmenu = true;
    level.total_mk2_display = createserverfontstring( "objective", 1.3 );
    level.total_mk2_display.y = 14;
    level.total_mk2_display.x = 2;
    level.total_mk2_display.fontscale = 1.3;
    level.total_mk2_display.alignx = "left";
    level.total_mk2_display.horzalign = "user_left";
    level.total_mk2_display.vertalign = "user_top";
    level.total_mk2_display.aligny = "top";
    level.total_mk2_display.alpha = 1;
    
    level.total_ray_display setvalue(0);
    level.total_mk2_display setvalue(0);

    while(true)
    {
        if(getDvarInt("avg"))
        {
            level.total_mk2_display.label = &"^3Raygun MK2 AVG: ^4";
            level.total_ray_display.label = &"^3Raygun AVG: ^4";
            if(isDefined(level.total_ray_display)) level.total_ray_display setvalue(level.total_chest_accessed_ray / level.total_ray);
            if(isDefined(level.total_mk2_display)) level.total_mk2_display setvalue(level.total_chest_accessed_mk2 / level.total_mk2);
        }
        else
        {
            level.total_mk2_display.label = &"^3Total Raygun MK2: ^4";
            level.total_ray_display.label = &"^3Total Raygun: ^4";
            if(isDefined(level.total_ray_display)) level.total_ray_display setvalue(level.total_ray);
            if(isDefined(level.total_mk2_display)) level.total_mk2_display setvalue(level.total_mk2);
        }
        wait 0.1;
    }
}

boxlocation()
{
    while(!isdefined(level.chests))
        wait 0.1;
    switch(getDvarInt("box"))
    {
        case 1: 
            if(isorigins()) level thread startbox("bunker_tank_chest");
            if(isnuketown()) level thread startbox("start_chest1");
            if(ismob()) level thread startbox("cafe_chest");
            if(istown()) level thread startbox("town_chest_2");
            break;
        case 2:
            if(isorigins()) level thread startbox("bunker_cp_chest");
            if(isnuketown()) level thread startbox("start_chest2");
            if(ismob()) level thread startbox("start_chest");
            if(istown()) level thread startbox("town_chest");
            break;
        default: break;
    }
}

startBox(chest_name)
{
    self endon("disconnect");
    flag_wait("initial_blackscreen_passed");
    
    foreach(chest in level.chests)
    {
        if(chest.script_noteworthy == chest_name)
        {
            chest.hidden = false;
            chest thread magic_box_arrives(); 
            chest show_chest();
        }
        else
        {
            if (!chest.hidden)
            {
                chest thread magic_box_leaves(); 
                chest hide_chest();
                chest.hidden = true;
            }
            
            if (isdefined(chest.unitrigger_stub)) 
            {
                chest.unitrigger_stub destroy();
                chest.stub.trigger_target.chest_user = undefined;
            }
        }
    }
}

firstbox()
{
    while(!isdefined(level.plutoversion))
        wait 0.1;
    level thread setUpWeapons();
    if(level.plutoversion == 3755) level thread firstbox3755();
    if(level.plutoversion == 2905) level thread firstbox2905();
}

firstbox3755()
{
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");
	
	if(getDvarInt("firstbox"))
	{
        level thread setUpWeapons();

        special_weapon_magicbox_check = level.special_weapon_magicbox_check;
        level.special_weapon_magicbox_check = undefined;

        foreach(weapon in level.zombie_weapons)
            weapon.is_in_box = false;
        
        foreach(weapon in level.forced_box_guns)
            level.zombie_weapons[weapon].is_in_box = true;

        while( (level.total_chest_accessed - level.chest_moves) != level.forced_box_guns.size && level.round_number < 10)
            wait 1;
        
        level.special_weapon_magicbox_check = special_weapon_magicbox_check;

        foreach(weapon in getarraykeys(level.zombie_include_weapons))
            level.zombie_weapons[weapon].is_in_box = level.zombie_include_weapons[weapon];
	}
}

firstbox2905()
{
    if(!getDvarInt("firstbox"))
        return;

	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

   level thread setUpWeapons();

   special_weapon_magicbox_check = level.special_weapon_magicbox_check;
   level.special_weapon_magicbox_check = undefined;

   foreach(weapon in getarraykeys(level.zombie_weapons))   // this is the only difference in the code
       level.zombie_weapons[weapon].is_in_box = false;
   
   foreach(weapon in level.forced_box_guns)
       level.zombie_weapons[weapon].is_in_box = true;

   while( (level.total_chest_accessed - level.chest_moves)!= level.forced_box_guns.size && level.round_number < 10)
       wait 1;

   level.special_weapon_magicbox_check = special_weapon_magicbox_check;
   foreach(weapon in getarraykeys(level.zombie_include_weapons))
       level.zombie_weapons[weapon].is_in_box = level.zombie_include_weapons[weapon];
}

setUpWeapons()
{
    if(isdefined(level.forced_box_guns))
        return;
    if(istranzit())
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "emp_grenade_zm");
            break;
            case 2:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm");
            break;
            case 3:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm", "cymbal_monkey_zm");
            break;
            case 4:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
        }
        
    if(isnuketown())
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm");
            break;
            case 2:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 3:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 4:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
        }
    if(isdierise())
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("cymbal_monkey_zm");
            break;
            case 2:
            level.forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 3:
            level.forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 4:
            level.forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
        }
    if(ismob())
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("raygun_mark2_zm", "blundergat_zm");
            break;
            case 2:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "blundergat_zm");
            break;
            case 3:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "blundergat_zm");
            break;
            case 4:
            level.forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "blundergat_zm");
            break;
        }
    if(isburied())
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "slowgun_zm");
            break;
            case 2:
            level.forced_box_guns = array("raygun_mark2_zm", "raygun_mark2_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
            break;
            case 3:
            level.forced_box_guns = array("raygun_mark2_zm", "raygun_mark2_zm", "raygun_mark2_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
            break;
            case 4:
            level.forced_box_guns = array("raygun_mark2_zm", "raygun_mark2_zm", "raygun_mark2_zm", "raygun_mark2_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
            break;
        }
    if(isorigins() && getDvarInt("SR") == 30)
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("scar_zm", "raygun_mark2_zm", "cymbal_monkey_zm");
            break;
            case 2:
            level.forced_box_guns = array("scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 3:
            level.forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 4:
            level.forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
        }
    if(isorigins() && getDvarInt("SR") != 30)
        switch(level.players.size)
        {
            case 1: 
            level.forced_box_guns = array("scar_zm", "raygun_mark2_zm", "m32_zm", "cymbal_monkey_zm");
            break;
            case 2:
            level.forced_box_guns = array("scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 3:
            level.forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
            case 4:
            level.forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
            break;
        }
}