#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;

graphic_tweaks()
{
	if(GetDvarInt("graphictweaks") != 0)
	{
		if( level.script != "zm_tomb")
		self setclientdvar("r_dof_enable", 0);
		self setclientdvar("r_lodBiasRigid", -1000);
		self setclientdvar("r_lodBiasSkinned", -1000);
		self setClientDvar("r_lodScaleRigid", 1);
		self setClientDvar("r_lodScaleSkinned", 1);
		self setclientdvar("sm_sunquality", 2);
		self setclientdvar("r_enablePlayerShadow", 1);
		self setclientdvar( "vc_fbm", "0 0 0 0" );
		self setclientdvar( "vc_fsm", "1 1 1 1" );
		self setclientdvar( "vc_fgm", "1 1 1 1" );
	}
}

nightmode()
{
	if (!isDefined( self.nightmode))
		self.nightmode = true;
	else
		return;

	flag_wait( "start_zombie_round_logic" );
	wait 0.05;	

	self thread nightmode_watcher();
}


nightmode_watcher()
{	
	wait 1;
	while(true)
	{
		while(!getDvarInt("nightmode"))
			wait 0.1;

		self thread enable_nightmode();
		self thread visual_fix();

		while(getDvarInt("nightmode"))
			wait 0.1;

		self thread disable_nightmode();
	}
}

enable_nightmode()
{
	if( !isDefined( level.default_r_exposureValue ) )
		level.default_r_exposureValue = getDvar( "r_exposureValue" );
	if( !isDefined( level.default_r_lightTweakSunLight ) )
		level.default_r_lightTweakSunLight = getDvar( "r_lightTweakSunLight" );
	if( !isDefined( level.default_r_sky_intensity_factor0 ) )
		level.default_r_sky_intensity_factor0 = getDvar( "r_sky_intensity_factor0" );
	self setclientdvar( "r_bloomTweaks", 1 );
	self setclientdvar( "r_exposureTweak", 1 );
	self setclientdvar( "vc_rgbh", "0.07 0 0.25 0" );
	self setclientdvar( "vc_yl", "0 0 0.25 0" );
	self setclientdvar( "vc_yh", "0.015 0 0.07 0" );
	self setclientdvar( "vc_rgbl", "0.015 0 0.07 0" );
	self setclientdvar( "vc_rgbh", "0.015 0 0.07 0" );
	self setclientdvar( "r_exposureValue", 3.9 );
	self setclientdvar( "r_lightTweakSunLight", 16 );
	self setclientdvar( "r_sky_intensity_factor0", 3 );
	if(isburied()) self setclientdvar( "r_exposureValue", 3.5 );
	if(isorigins()) self setclientdvar( "r_exposureValue", 4 );
	if(isnuketown()) self setclientdvar( "r_exposureValue", 5.6 );
	if(isdierise()) self setclientdvar( "r_exposureValue", 3 );
}

disable_nightmode()
{
	self notify( "disable_nightmode" );
	self setclientdvar( "r_filmUseTweaks", 0 );
	self setclientdvar( "r_bloomTweaks", 0 );
	self setclientdvar( "r_exposureTweak", 0 );
	self setclientdvar( "vc_rgbh", "0 0 0 0" );
	self setclientdvar( "vc_yl", "0 0 0 0" );
	self setclientdvar( "vc_yh", "0 0 0 0" );
	self setclientdvar( "vc_rgbl", "0 0 0 0" );
	self setclientdvar( "r_exposureValue", int( level.default_r_exposureValue ) );
	self setclientdvar( "r_lightTweakSunLight", int( level.default_r_lightTweakSunLight ) );
	self setclientdvar( "r_sky_intensity_factor0", int( level.default_r_sky_intensity_factor0 ) );
}

visual_fix()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "disable_nightmode" );
	if(isburied())
	{
		while( getDvar( "r_sky_intensity_factor0" ) != 0 )
		{	
			self setclientdvar( "r_lightTweakSunLight", 1 );
			self setclientdvar( "r_sky_intensity_factor0", 0 );
			wait 0.05;
		}
	}
	else if(ismob()|| isorigins())
	{
		while( getDvar( "r_lightTweakSunLight" ) != 0 )
		{
			for( i = getDvar( "r_lightTweakSunLight" ); i >= 0; i = ( i - 0.05 ) )
			{
				self setclientdvar( "r_lightTweakSunLight", i );
				wait 0.05;
			}
			wait 0.05;
		}
	}
	else return;
}

rotate_skydome()
{
	if (isorigins()) return;

	self endon("disconnect");

	while(true)
		for(x = 360; x > 0; x -= 0.025)
		{
			self setclientdvar( "r_skyRotation", x );
			wait 0.1;
		}
}
