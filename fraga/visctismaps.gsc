#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_stats;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_magicbox;
#include maps\mp\zombies\_zm_ai_leaper;
#include maps\mp\zombies\_zm_perks;

#include scripts\zm\fraga\ismap;

fridge()
{
	if(level.round_number >= 15)
		return;
	if(getDvar("fridge") == "mp5")
	{
		if(isdierise() || isburied())
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
		}
		if(istranzit())
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "mp5k_upgraded_zm");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 200);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 40);
		}
	}
	if(getDvar("fridge") == "m16")
	{
		if(isdierise() || isburied())
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "an94_upgraded_zm+mms");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 600);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 50);
		}
		if(istranzit())
		{
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "name", "m16_gl_upgraded_zm");
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "stock", 200);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "clip", 40);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_clip", 1);
			self setdstat("PlayerStatsByMap", "zm_transit", "weaponLocker", "alt_stock", 8);
		}
	}
}


award_permaperks_safe()
{
	if(level.round_number >= 15)
		return;
	level endon("end_game");
	self endon("disconnect");

	while (!isalive(self))
		wait 0.05;

	wait 0.5;

	perks_to_process = [];
	perks_to_process[perks_to_process.size] = permaperk_array("revive");
	perks_to_process[perks_to_process.size] = permaperk_array("multikill_headshots");
	perks_to_process[perks_to_process.size] = permaperk_array("perk_lose");
	perks_to_process[perks_to_process.size] = permaperk_array("jugg", undefined, undefined, 15);
	perks_to_process[perks_to_process.size] = permaperk_array("flopper", array("zm_buried"));
	perks_to_process[perks_to_process.size] = permaperk_array("box_weapon", array("zm_highrise", "zm_buried"), array("zm_transit"));
	perks_to_process[perks_to_process.size] = permaperk_array("cash_back");
	perks_to_process[perks_to_process.size] = permaperk_array("sniper");
	perks_to_process[perks_to_process.size] = permaperk_array("insta_kill");
	perks_to_process[perks_to_process.size] = permaperk_array("pistol_points");
	perks_to_process[perks_to_process.size] = permaperk_array("double_points");

	self.awarding_permaperks_now = true;

	foreach (perk in perks_to_process)
	{
		self resolve_permaperk(perk);
		wait 0.05;
	}

	wait 0.5;
	perks_to_process = undefined;
	self.awarding_permaperks_now = undefined;
	self maps\mp\zombies\_zm_stats::uploadstatssoon();
}

permaperk_array(code, maps_award, maps_take, to_round)
{
	if (!isDefined(maps_award))
		maps_award = array("zm_transit", "zm_highrise", "zm_buried");
	if (!isDefined(maps_take))
		maps_take = [];
	if (!isDefined(to_round))
		to_round = 255;

	permaperk = [];
	permaperk["code"] = code;
	permaperk["maps_award"] = maps_award;
	permaperk["maps_take"] = maps_take;
	permaperk["to_round"] = to_round;

	return permaperk;
}

resolve_permaperk(perk)
{
	wait 0.05;

	perk_code = perk["code"];

	/* Too high of a round, return out */
	if (is_round(perk["to_round"]))
		return;

	if (isinarray(perk["maps_award"], level.script) && !self.pers_upgrades_awarded[perk_code])
	{
		for (j = 0; j < level.pers_upgrades[perk_code].stat_names.size; j++)
		{
			stat_name = level.pers_upgrades[perk_code].stat_names[j];
			stat_value = level.pers_upgrades[perk_code].stat_desired_values[j];

			self award_permaperk(stat_name, perk_code, stat_value);
		}
	}

	if (isinarray(perk["maps_take"], level.script) && self.pers_upgrades_awarded[perk_code])
		self remove_permaperk(perk_code);
}


award_permaperk(stat_name, perk_code, stat_value)
{
	flag_set("permaperks_were_set");
	self.stats_this_frame[stat_name] = 1;
	self maps\mp\zombies\_zm_stats::set_global_stat(stat_name, stat_value);
	self playsoundtoplayer("evt_player_upgrade", self);
}

remove_permaperk(perk_code)
{
	self.pers_upgrades_awarded[perk_code] = 0;
	self playsoundtoplayer("evt_player_downgrade", self);
}

bank()
{
	level endon("end_game");
	self endon("disconnect");

	flag_wait("initial_blackscreen_passed");

    if (level.round_number == 1)
	{
    self.account_value = level.bank_account_max;		
	}
}