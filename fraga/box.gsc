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
    }
    if(issurvivalmap())
        level.boxhits.alpha = 1;
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

    /* definimos las varaibles que vamos a trackear */
    if(!isDefined(level.total_mk2))
        level.total_mk2 = 0;
    if(!isDefined(level.total_raygun))
        level.total_raygun = 0;
    if(!isDefined(level.avgraygunmk2))
        level.avgraygunmk2 = 0;
    if(!isDefined(level.avgraygun))
        level.avgraygun = 0;

    /* Creamos el texto que va a aparecer en pantalla */
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
    /* Comprobamos si el jugador tiene un arma de rayos o no */
    /* Cuando tenga el arma de rayos aumentamos el contador  */
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
            wait 20; /* Estos 20 segundos son para evitar contar cuando mejora el arma de rayos */
        }
        wait 1;
    }
}

make_avg()
{
    /* Cálculo de la media */
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
    /* Aquí enseñamos la media */
    self endon("disconnect");
    
	level.displayraygunmk2avg.hidewheninmenu = 1;
    level.displayraygunmk2avg = createserverfontstring( "objective", 1.3 );
    level.displayraygunmk2avg.y = 14;
    level.displayraygunmk2avg.x = 80;
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
	self endon("disconnect");
	flag_wait("initial_blackscreen_passed");
	
	player_amount = 0;
	foreach(player in level.players)
		player_amount++;
	
	if(level.round_number < 50 && getDvarInt("firstbox"))
	{
		switch(level.script)
		{
			case "zm_transit":
				switch(player_amount)
				{
					case 1: 
					forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "emp_grenade_zm");
					break;
					case 2:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm");
					break;
					case 3:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm", "cymbal_monkey_zm");
					break;
					case 4:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "emp_grenade_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
				}
				break;
			
			case "zm_nuked":
				switch(player_amount)
				{
					case 1: 
					forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm");
					break;
					case 2:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
					case 3:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
					case 4:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
				}
				break;

			case "zm_highrise":
				switch(player_amount)
				{
					case 1: 
					forced_box_guns = array("cymbal_monkey_zm");
					break;
					case 2:
					forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
					case 3:
					forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
					case 4:
					forced_box_guns = array("cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
					break;
				}
				break;

			case "zm_prison":
				switch(player_amount)
				{
					case 1: 
					forced_box_guns = array("raygun_mark2_zm", "blundergat_zm");
					break;
					case 2:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "blundergat_zm");
					break;
					case 3:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "blundergat_zm");
					break;
					case 4:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "blundergat_zm");
					break;
				}
				break;
			case "zm_buried":
				switch(player_amount)
				{
					case 1: 
					forced_box_guns = array("raygun_mark2_zm", "cymbal_monkey_zm", "slowgun_zm");
					break;
					case 2:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
					break;
					case 3:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
					break;
					case 4:
					forced_box_guns = array("raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "slowgun_zm");
					break;
				}
				break;
			case "zm_tomb":
				if(getDvar("SR") == 30)
					switch(player_amount)
					{
						case 1: 
						forced_box_guns = array("scar_zm", "raygun_mark2_zm", "cymbal_monkey_zm");
						break;
						case 2:
						forced_box_guns = array("scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
						break;
						case 3:
						forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
						break;
						case 4:
						forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
						break;
					}
				else
					switch(player_amount)
					{
						case 1: 
						forced_box_guns = array("scar_zm", "raygun_mark2_zm", "m32_zm");
						break;
						case 2:
						forced_box_guns = array("scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
						break;
						case 3:
						forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
						break;
						case 4:
						forced_box_guns = array("scar_zm", "scar_zm", "scar_zm", "scar_zm", "raygun_mark2_zm", "ray_gun_zm", "ray_gun_zm", "ray_gun_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm", "cymbal_monkey_zm");
						break;
					}
				break;
			default:
				break;
		}

		level.special_weapon_magicbox_check = undefined;
		foreach(weapon in level.zombie_weapons) 
			weapon.is_in_box = 0;

		boxhits = -1;
		while((boxhits < forced_box_guns.size))
		{
			if(boxhits < level.chest_accessed)
			{
				if(level.chest_accessed != forced_box_guns.size)
				{
					gun = forced_box_guns[boxhits+1];
					level.zombie_weapons[gun].is_in_box = 1;
				}
				boxhits++;		
			}
		wait 2;
		}
		
		switch(level.script)
		{
			case "zm_transit":
				if(level.scr_zm_map_start_location == "town" || level.scr_zm_ui_gametype_group == "zclassic")
					level.special_weapon_magicbox_check = ::transit_special_weapon_magicbox_check;
				else
					level.special_weapon_magicbox_check = ::general_weapon_magicbox_check;
				break;

			case "zm_nuked":
				level.special_weapon_magicbox_check = ::general_weapon_magicbox_check;
			case "zm_prison":
				level.special_weapon_magicbox_check = ::general_weapon_magicbox_check;
				break;

			case "zm_highrise":
				level.special_weapon_magicbox_check = ::highrise_special_weapon_magicbox_check;
				break;

			case "zm_buried":
				level.special_weapon_magicbox_check = ::buried_special_weapon_magicbox_check;
				break;

			case "zm_tomb":
				level.special_weapon_magicbox_check = ::tomb_special_weapon_magicbox_check;
				break;
				
			default:
				break;
		}

		keys = getarraykeys(level.zombie_include_weapons);
		foreach(weapon in keys)
		{
			if(level.zombie_include_weapons[weapon] == 1)
				level.zombie_weapons[weapon].is_in_box = 1;
		}
	}
}

transit_special_weapon_magicbox_check(weapon)
{
	if(isdefined(level.raygun2_included) && level.raygun2_included)
	{
		if(weapon == "ray_gun_zm")
		{
			if(self has_weapon_or_upgrade("raygun_mark2_zm") || maps\mp\zombies\_zm_tombstone::is_weapon_available_in_tombstone("raygun_mark2_zm", self))
			{
				return 0;
			}
		}
		if(weapon == "raygun_mark2_zm")
		{
			if(self has_weapon_or_upgrade("ray_gun_zm") || maps\mp\zombies\_zm_tombstone::is_weapon_available_in_tombstone("ray_gun_zm", self))
			{
				return 0;
			}
			if(randomint(100) >= 33)
			{
				return 0;
			}
		}
	}
	return 1;
}

buried_special_weapon_magicbox_check(weapon)
{
	if(weapon == "ray_gun_zm")
	{
		if(self has_weapon_or_upgrade("raygun_mark2_zm"))
		{
			return 0;
		}
	}
	if(weapon == "raygun_mark2_zm")
	{
		if(self has_weapon_or_upgrade("ray_gun_zm"))
		{
			return 0;
		}
	}
	if(weapon == "time_bomb_zm")
	{
		players = get_players();
		for(i = 0; i < players.size; i++)
		{
			if(is_player_valid(players[i], undefined, 1) && players[i] is_player_tactical_grenade(weapon))
			{
				return 0;
			}
		}
	}
	return 1;
}

highrise_special_weapon_magicbox_check(weapon)
{
	if(isdefined(level.raygun2_included) && level.raygun2_included)
	{
		if(weapon == "ray_gun_zm")
		{
			if(self has_weapon_or_upgrade("raygun_mark2_zm") || maps\mp\zombies\_zm_chugabud::is_weapon_available_in_chugabud_corpse("raygun_mark2_zm", self))
			{
				return 0;
			}
		}
		if(weapon == "raygun_mark2_zm")
		{
			if(self has_weapon_or_upgrade("ray_gun_zm") || maps\mp\zombies\_zm_chugabud::is_weapon_available_in_chugabud_corpse("ray_gun_zm", self))
			{
				return 0;
			}
			if(randomint(100) >= 33)
			{
				return 0;
			}
		}
	}
	return 1;
}

general_weapon_magicbox_check(weapon)
{
	if (isDefined( level.raygun2_included ) && level.raygun2_included)
	{
		if (weapon == "ray_gun_zm")
		{
			if (self has_weapon_or_upgrade("raygun_mark2_zm"))
			{
				return 0;
			}
		}
		if (weapon == "raygun_mark2_zm")
		{
			if (self has_weapon_or_upgrade("ray_gun_zm"))
			{
				return 0;
			}
			if (randomint(100) >= 33)
			{
				return 0;
			}
		}
	}
	return 1;
}

tomb_special_weapon_magicbox_check(weapon)
{
	if ( isDefined( level.raygun2_included ) && level.raygun2_included )
	{
		if ( weapon == "ray_gun_zm" )
		{
			if ( self has_weapon_or_upgrade( "raygun_mark2_zm" ) )
			{
				return 0;
			}
		}
		if ( weapon == "raygun_mark2_zm" )
		{
			if ( self has_weapon_or_upgrade( "ray_gun_zm" ) )
			{
				return 0;
			}
			if ( randomint( 100 ) >= 33 )
			{
				return 0;
			}
		}
	}
	if ( weapon == "beacon_zm" )
	{
		if ( isDefined( self.beacon_ready ) && self.beacon_ready )
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
	if ( isDefined( level.zombie_weapons[ weapon ].shared_ammo_weapon ) )
	{
		if ( self has_weapon_or_upgrade( level.zombie_weapons[ weapon ].shared_ammo_weapon ) )
		{
			return 0;
		}
	}
	return 1;
}

