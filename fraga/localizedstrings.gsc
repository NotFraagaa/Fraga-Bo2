#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\fraga\ismap;

setFragaLanguage()
{
    switch(getDvar("language"))
    {
        case "spanish":
            level.boxhits.label = &"^3Tiradas de caja: ^4";
            level.cheats.label = &"^1^FCheats activados";
            level.firstbox_active.label = &"^2^FFirstbox activado";
            if(isorigins() || isburied() || isnuketown() && !level.debug)
                level.perkrng_desabled.label = &"^4^FPerk RNG manipulada";
            if(isorigins() && !level.debug)
                level.templar_modiffied.label = &"^6^FTemplarios manipulados";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3Última ronda de brutus: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3Última ronda de templarios: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3Última ronda de panzer: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3Última ronda de novas: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3TRAMPOLINES: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3TRAMPOLINES: ^4";
                level.subwoofer_hud.label = &"^3RESONADORES: ^4";
                level.turbine_hud.label = &"^3TURBINAS: ^4";
            }
            break;
        case "french":
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats actif";
            level.firstbox_active.label = &"^2^FFirstbox actif";
            if(isorigins() || isburied() || isnuketown())
                level.perkrng_desabled.label = &"^4^FLa RNG des atouts est manipulé";
            if(isorigins())
                level.templar_modiffied.label = &"^6^FTemplier est manipulé";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3Dernière manche de brutus: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3Dernière manche des templiers: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3Dernière manche de panzer: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3Dernière manche de leapers: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3PROPULSEURS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3PROPULSEURS: ^4";
                level.subwoofer_hud.label = &"^3RÉSONATEUR: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;
        case "japanese":
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats アクティブ";
            level.firstbox_active.label = &"^2^FFirstbox アクティブ";
            if(isorigins() || isburied() || isnuketown() && !level.debug)
                level.perkrng_desabled.label = &"^4^F特典 RNG 操作された";
            if(isorigins() && !level.debug)
                level.templar_modiffied.label = &"^6^Fテンプラー 操作された";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3ブルータス最後のラウンド: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3テンプル騎士団の最後のラウンド: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3最後の装甲ラウンド: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3最後のリーパーラウンド: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3スプリングパッド: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3スプリングパッド: ^4";
                level.subwoofer_hud.label = &"^3レゾネーター: ^4";
                level.turbine_hud.label = &"^3タービン: ^4";
            }
            break;
        default:
            level.boxhits.label = &"^3Box hits: ^4";
            level.cheats.label = &"^1^FCheats active";
            level.firstbox_active.label = &"^2^FFirstbox active";
            if(isorigins() || isburied() || isnuketown() && !level.debug)
                level.perkrng_desabled.label = &"^4^FPerk RNG manipulated";
            if(isorigins() && !level.debug)
                level.templar_modiffied.label = &"^6^FTemplars manipulated";
            if(isdefined(self.lastBrutusRound))
		        self.lastBrutusRound.label = &"^3Last brutus round: ^4";
            if(isdefined(self.lastTemplarRound))
		        self.lastTemplarRound.label = &"^3Last templar round: ^4";
            if(isdefined(self.lastPanzerRound))
		        self.lastPanzerRound.label = &"^3Last panzer round: ^4";
            if(isdefined(self.lastleaperround))
                self.lastleaperround.label = &"^3Last leaper round: ^4";
            flag_wait("initial_blackscreen_passed");
            if(isdefined(level.springpad_hud))
                level.springpad_hud.label = &"^3SPRINGPADS: ^4";
            if(isdefined(level.subwoofer_hud))
            {
                level.springpad_hud.label = &"^3SPRINGPADS: ^4";
                level.subwoofer_hud.label = &"^3RESONATORS: ^4";
                level.turbine_hud.label = &"^3TURBINES: ^4";
            }
            break;
    }
    if(level.debug)
    {
        level.cheats.label = &"";
        level.firstbox_active.label = &"";
        level.perkrng_desabled.label = &"";
        level.templar_modiffied.label = &"";
    }
}