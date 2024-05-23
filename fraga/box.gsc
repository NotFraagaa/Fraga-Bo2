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
}

displayBoxHits()
{
	level.boxhits.hidewheninmenu = 1;
    level.boxhits = createserverfontstring( "objective", 1.3 );
    level.boxhits.y = 0;
    if(isdierise())
        level.boxhits.y = 10;
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
        level.boxhits.alignx = "left";
        level.boxhits.horzalign = "user_left";
        level.boxhits.x = 2;
        level.boxhits.alpha = 1;
    }
    while(!isDefined(level.total_chest_accessed))
        wait 0.1;
    lol = 0;
    while(1)
    {
        while(!isdefined(level.chest_accessed))
            wait 0.1;
        if(lol != level.chest_accessed)
        {
            level.total_chest_accessed++;
            lol = level.chest_accessed;
            level.boxhits setvalue(level.total_chest_accessed);
            i = 1;
            if(!issurvivalmap())
            {
                while(true)
                {
                    i -= 0.02;
                    level.boxhits.alpha = i;
                    wait 0.1;
                    if(i < 0.1)
                    {
                        level.boxhits.alpha = 0;
                        break;
                    }
                }
            }
        }
        wait 0.1;
    }
    wait 1;
}

avg()
{
    level thread label();
    level thread display();
    level thread make_avg();
}

label()
{
    self endon("disconnect");

    if(!isDefined(level.total_mk2))
        level.total_mk2 = 0;
    if(!isDefined(level.total_raygun))
        level.total_raygun = 0;
    if(!isDefined(level.avgraygunmk2))
        level.avgraygunmk2 = 0;
    if(!isDefined(level.avgraygun))
        level.avgraygun = 0;

	level.raygunavg.hidewheninmenu = 1;
    level.raygunavg = createserverfontstring( "objective", 1.3 );
    level.raygunavg.y = 26;
    level.raygunavg.x = 2;
    level.raygunavg.fontscale = 1.3;
    level.raygunavg.alignx = "left";
    level.raygunavg.horzalign = "user_left";
    level.raygunavg.vertalign = "user_top";
    level.raygunavg.aligny = "top";
    level.raygunavg.label = &"^3Raygun AVG: ^4";
    level.raygunavg.alpha = 1;
	level.raygunmk2avg.hidewheninmenu = 1;
    level.raygunmk2avg = createserverfontstring( "objective", 1.3 );
    level.raygunmk2avg.y = 14;
    level.raygunmk2avg.x = 2;
    level.raygunmk2avg.fontscale = 1.3;
    level.raygunmk2avg.alignx = "left";
    level.raygunmk2avg.horzalign = "user_left";
    level.raygunmk2avg.vertalign = "user_top";
    level.raygunmk2avg.aligny = "top";
    level.raygunmk2avg.label = &"^3Raygun MK2 AVG: ^4";
    level.raygunmk2avg.alpha = 1;
    track_rayguns();
}

track_rayguns()
{
	level waittill("connecting", player);
    while(true)
    {
        if(player has_weapon_or_upgrade("ray_gun_zm"))
            level.total_raygun++;
        if(player has_weapon_or_upgrade("raygun_mark2_zm"))
            level.total_mk2++;

        while(player has_weapon_or_upgrade("ray_gun_zm") || player has_weapon_or_upgrade("raygun_mark2_zm")) 
        {
            if(player has_weapon_or_upgrade("ray_gun_zm") || player has_weapon_or_upgrade("raygun_mark2_zm"))
                wait 0.1;
        }
        wait 1;
    }
}

make_avg()
{
    while(1)
    {
        if(level.total_chest_accessed)
        {
            level.avgraygunmk2 = (level.total_chest_accessed / level.total_mk2);
            level.avgraygun = (level.total_chest_accessed / level.total_raygun);
        }
        wait 0.1;
    }
}
display()
{
    self endon("disconnect");
    
	level.displayraygunmk2avg.hidewheninmenu = 1;
    level.displayraygunmk2avg = createserverfontstring( "objective", 1.3 );
    level.displayraygunmk2avg.y = 14;
    level.displayraygunmk2avg.x = 143;
    level.displayraygunmk2avg.fontscale = 1.3;
    level.displayraygunmk2avg.alignx = "left";
    level.displayraygunmk2avg.horzalign = "user_left";
    level.displayraygunmk2avg.vertalign = "user_top";
    level.displayraygunmk2avg.aligny = "top";
    level.displayraygunmk2avg.label = &"^4";
    level.displayraygunmk2avg.alpha = 1;
    level.displayraygunmk2avg setvalue(0);

	level.displayraygunavg.hidewheninmenu = 1;
    level.displayraygunavg = createserverfontstring( "objective", 1.3 );
    level.displayraygunavg.y = 26;
    level.displayraygunavg.x = 60;
    if(getDvar("language") == "japanese")
        level.displayraygunavg.x = 103;
    level.displayraygunavg.fontscale = 1.3;
    level.displayraygunavg.alignx = "left";
    level.displayraygunavg.horzalign = "user_left";
    level.displayraygunavg.vertalign = "user_top";
    level.displayraygunavg.aligny = "top";
    level.displayraygunavg.label = &"^4";
    level.displayraygunavg.alpha = 1;
    level.displayraygunavg setvalue(0);

    while(1)
    {
        if(isDefined(level.avgraygun))
            level.displayraygunavg setvalue(level.avgraygun);
        if(isDefined(level.avgraygunmk2))
            level.displayraygunmk2avg setvalue(level.avgraygunmk2);
        wait 1;
    }
}

boxlocation()
{
    while(!isdefined(level.chests))
        wait 0.1;
    switch(getDvarInt("box"))
    {
        case 1: 
            if(isorigins())
                level thread startbox("bunker_tank_chest");
            if(isnuketown())
                level thread startbox("start_chest1");
            if(ismob())
                level thread startbox("cafe_chest");
            if(istown())
                level thread startbox("town_chest_2");
            break;
        case 2:
            if(isorigins())
                level thread startbox("bunker_cp_chest");
            if(isnuketown())
                level thread startbox("start_chest2");
            if(ismob())
                level thread startbox("start_chest");
            if(istown())
                level thread startbox("town_chest");
            break;
        default: break;
    }
}

startBox(start_chest)
{
    self endon("disconnect");
    
	for(i = 0; i < level.chests.size; i++)
	{
        if(level.chests[i].script_noteworthy == start_chest)
    		desired_chest_index = i; 
        else if(level.chests[i].hidden == 0)
     		nondesired_chest_index = i;               	
	}

	if( isdefined(nondesired_chest_index) && (nondesired_chest_index < desired_chest_index))
	{
		level.chests[nondesired_chest_index] hide_chest();
		level.chests[nondesired_chest_index].hidden = 1;

		level.chests[desired_chest_index].hidden = 0;
		level.chests[desired_chest_index] show_chest();
		level.chest_index = desired_chest_index;
	}
}


firstbox()
{
    while(!isdefined(level.plutoversion))
        wait 0.1;
    level thread setUpWeapons();
    if(level.plutoversion == 3755)
        level thread firstbox3755();
    if(level.plutoversion == 2905)
        level thread firstbox2905();
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
        {
            if(weapon.is_in_box)
            {
                if(level.debug)
                println("Removing " + weapon.weapon_name + " from the box");
                weapon.is_in_box = 0;
            }
        }
        
        foreach(weapon in level.forced_box_guns)
        {
            if(level.debug)
            println("Adding " + level.zombie_weapons[weapon].weapon_name + " to the box");
            level.zombie_weapons[weapon].is_in_box = 1;
        }

        while( (level.total_chest_accessed- level.chest_moves) != level.forced_box_guns.size && level.round_number < 10)
            wait 1;
        
        level.special_weapon_magicbox_check = special_weapon_magicbox_check;

        foreach(weapon in getarraykeys(level.zombie_include_weapons))
        {
            if(level.zombie_include_weapons[weapon] == 1)
                level.zombie_weapons[weapon].is_in_box = 1;
        }
	}
}

firstbox2905()
{
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");

    if(getDvarInt("firstbox"))
    {
        level thread setUpWeapons();

        special_weapon_magicbox_check = level.special_weapon_magicbox_check;
        level.special_weapon_magicbox_check = undefined;

        foreach(weapon in getarraykeys(level.zombie_weapons))   // this is the only difference in the code
            level.zombie_weapons[weapon].is_in_box = 0;
        
        foreach(weapon in level.forced_box_guns)
            level.zombie_weapons[weapon].is_in_box = 1;

        while( (level.total_chest_accessed - level.chest_moves)!= level.forced_box_guns.size && level.round_number < 10)
            wait 1;

        level.special_weapon_magicbox_check = special_weapon_magicbox_check;
        foreach(weapon in getarraykeys(level.zombie_include_weapons))
        {
            if(level.zombie_include_weapons[weapon] == 1)
                level.zombie_weapons[weapon].is_in_box = 1;
        }
    }
}

setUpWeapons()
{
    if(isdefined(level.forced_box_guns))
        return;
    switch(level.script)
    {
        case "zm_transit":
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
            break;
        
        case "zm_nuked":
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
            break;

        case "zm_highrise":
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
            break;

        case "zm_prison":
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
            break;
        case "zm_buried":
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
            break;
        case "zm_tomb":
            if(getDvar("SR") == 30)
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
            else
                switch(level.players.size)
                {
                    case 1: 
                    level.forced_box_guns = array("scar_zm", "raygun_mark2_zm", "m32_zm");
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
            break;
        default:
            break;
    }
}