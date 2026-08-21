class CfgPatches
{
	class BSO_System_Main
	{
		units[]={};
		weapons[]={
			"BSO_System_ids_SOB",                  		
			"BSO_System_ids_RC",                    	
    		"BSO_System_ids_ARF",                       
    		"BSO_System_ids_ARC",                       
			"BSO_System_ids_General_Zey",                   
            "BSO_System_ids_RC_Nexus",                  
            "BSO_System_ids_Dark",                      
            "BSO_System_ids_Henker"                     
		};
		requiredVersion=0.1;
		requiredAddons[]={
			"A3_Ui_F", "JLTS_C_IDs"
		};
	};
};

class CfgSounds
{
	class BSO_System_TakingBattery
	{
		name="BSO_System__armor_TakingBattery";
		sound[]=
		{
			"\BSOSystem\sounds\armor_TakingBattery.ogg",
			2.2387211,
			1
		};
		titles[]={};
	};
	class BSO_System_useSyringe
	{
		name="BSO_System_useSyringe";
		sound[]=
		{
			"\BSOSystem\sounds\medkit.ogg",
			3.1622777,
			1
		};
		titles[]={};
	};
	class BSO_System_openSyringe
	{
		name="BSO_System_openSyringe";
		sound[]=
		{
			"\BSOSystem\sounds\medkit_open.ogg",
			3.1622777,
			1
		};
		titles[]={};
	};
};

class CfgMovesBasic
{
	class Default;
	class StandBase;
	class BlendAnims;
	class ManActions
	{
		BSO_System_Gest_Heal = "BSO_System_Gest_Heal";
	};
};

class CfgGesturesMale
{
	class ManActions
	{
	};
	class Actions;
	class Default;
	class BlendAnims{};
	class States
	{
		class BSO_System_Gest_Heal: Default
		{
			speed=-2.4000001;
			looped=0;
			file="\BSOSystem\anims\Exo_Gest_Heal.rtm";
			mask="handsWeapon";
			headBobStrength=-1;
			headBobMode=4;
			disableWeapons=1;
			interpolationRestart=2;
			leftHandIKCurve[]={0.0099999998,1,0.1,0,0.94,0,0.98000002,1};
			rightHandIKBeg=1;
			leftHandIKEnd=1;
			rightHandIKCurve[]={1};
			weaponIK=1;
			canReload=1;
		};
	};
};

class CfgVehicles
{
	class Man;
	class CAManBase : Man
	{
		class UserActions
		{
			class BSO_System_Hyper_Stimulator
			{
				displayName = "Использовать стимулятор";
				displayNameDefault = "Использовать Стимулятор";
				priority = 0;
				radius = 5;
				position = "";
				showWindow = 0;
				hideOnUse = 1;
				onlyForPlayer = 0;
				shortcut = "";
				condition = "(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && !(player getVariable ['BSO_System_Stimulator_Activ', false]) && (gestureState this != 'BSO_System_Gest_Heal') && ([['ARC', 'General_Zey', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder)";
				statement = "[this, 600] spawn BSO_System_fnc_Stimulator_System";
			};

			class BSO_System_Auto_Heal_Activ
			{
				displayName = "Активировать Автохил";
				displayNameDefault = "Активировать Автохил";
				priority = 0;
				radius = 5;
				position = "";
				showWindow = 0;
				hideOnUse = 1;
				onlyForPlayer = 0;
				shortcut = "";
				condition = "(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable ['BSO_System_Auto_Heal_Active', false] == false) && ([['RC', 'General_Zey', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder)";
				statement = " this setVariable ['BSO_System_Auto_Heal_Active', true]; [this] spawn BSO_System_fnc_Auto_Heal;";
			};

			class BSO_System_Auto_Heal_Deactiv
			{
				displayName = "Выключить Автохил";
				displayNameDefault = "Выключить Автохил";
				priority = 0;
				radius = 5;
				position = "";
				showWindow = 0;
				hideOnUse = 1;
				onlyForPlayer = 0;
				shortcut = "";
				condition = "(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable ['BSO_System_Auto_Heal_Active', false] == true) && ([['RC', 'General_Zey', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder)";
				statement = "this setVariable ['BSO_System_Auto_Heal_Active', false]; ['', 'heal_ui_green'] spawn BSO_System_fnc_ctrl_filling;";
			};

			class BSO_System_SpeedUp
			{
				displayName = "<t color='#80ff00'>Скорость бега</t>";
				priority = 0;
				radius = 5;
				position = "";
				showWindow = 0;
				hideOnUse = 1;
				onlyForPlayer = 0;
				shortcut = "";
				condition = "(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive this) && ((this getVariable ['bigspeed', false]) == false) && (([['RC', 'ARF', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder) or (getPlayerUID player == '76561198183586917'))";
				statement = "[this] spawn BSO_System_fnc_Speed_Toggle;";
			};

			class BSO_System_SpeedDown
			{
				displayName = "<t color='#ff4d4d'>Скорость бега</t>";
				priority = 0;
				radius = 5;
				position = "";
				showWindow = 0;
				hideOnUse = 1;
				onlyForPlayer = 0;
				shortcut = "";
				condition = "(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive this) && ((this getVariable ['bigspeed', false]) == true) && (([['RC', 'ARF', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder) or (getPlayerUID player == '76561198183586917'))";
				statement = "[this] spawn BSO_System_fnc_Speed_Toggle;";
			};
		};
		class ACE_SelfActions
		{
			class BSO_System_ACE_Action
			{
				displayName = "БСО";
				condition = "([['SOB', 'General_Zey', 'Henker'] , this] call BSO_System_fnc_cards_arr_finder)";
				exceptions[] = {"isNotInside"};
				icon = "\BSOSystem\data\bso.paa";

				class BSO_System_Drones
				{
					displayName = "Дроны";
					condition = "([['SOB', 'General_Zey', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder)";
					exceptions[] = {};
					icon = "";

					class BSO_System_Razved_Dron
					{
						displayName = "Собрать разведовательный дрон";
						condition = "([['SOB', 'General_Zey'] , this] call BSO_System_fnc_cards_arr_finder) && ('ACE_UAVBattery' in items player)";
						exceptions[] = {};
						statement = "player removeItem 'ACE_UAVBattery'; ['mti_armoury_drones_prowler_1500'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";
					};
					class BSO_System_Mouse_Dron
					{
						displayName = "Собрать дрон мышь";
						condition = "([['SOB', 'General_Zey'] , this] call BSO_System_fnc_cards_arr_finder)";
						exceptions[] = {};
						statement = "['mti_armoury_drones_mse_Spyro'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";
					};
				};

				class BSO_System_Mashalat
				{
					displayName = "Маскхалаты";
					condition = "([['General_Zey'] , this] call BSO_System_fnc_cards_arr_finder)";
					icon = "";
					class BSO_System_Mashalat_dust
					{
						displayName = "Пустынный Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[1] spawn BSO_System_fnc_Mashalat_System;";
						icon = "";
					};
					class BSO_System_Mashalat_swamp
					{
						displayName = "Болотный Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[2] spawn BSO_System_fnc_Mashalat_System;";
						icon = "";
					};
					class BSO_System_Mashalat_half_dust
					{
						displayName = "Полузасушлевый Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[3] spawn BSO_System_fnc_Mashalat_System;";
						icon = "";
					};
					class BSO_System_Mashalat_jungle
					{
						displayName = "Джунгли Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[4] spawn BSO_System_fnc_Mashalat_System;";
						icon = "";
					};
					class BSO_System_Mashalat_disable
					{
						displayName = "Снять Маскхалат";
						condition = "!(isNil { player getVariable 'BSO_System_Uniform'})";
						exceptions[] = {};
						statement = "[5] spawn BSO_System_fnc_Mashalat_System;";
						icon = "";
					};
				};

				class BSO_System_changePlayerSide
				{
					displayName = "Сменить сторону Синяя/Фиолетовая";
					condition = "([['SOB'] , this] call BSO_System_fnc_cards_arr_finder)";
					exceptions[] = {};
					statement = "[_player] spawn BSO_System_fnc_changePlayerSide;";
					icon = "";
				};

				class BSO_System_vehicle_ACE_act
				{
					displayName = "Вызов техники";
					condition = "([['SOB', 'General_Zey', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder)";
					icon = "\BSOSystem\data\laat_ui_black.paa";
					insertChildren = "_this call BSO_System_fnc_Vehicle_jedi_card_act;";
					class BSO_System_Laat_Evac
					{
						displayName = "Вызвать эвакуационный LAAT";
						condition = "(player getVariable ['BSO_System_LAAT_Act_Active', true]) && ([['SOB', 'General_Zey', 'RC_Nexus'] , this] call BSO_System_fnc_cards_arr_finder)";
						exceptions[] = {};
						statement = "[] call BSO_System_fnc_RequestEvacLAAT";
						icon = "";
					};
					class BSO_System_Var_Drone
					{
						displayName = "Вызвать боевой дрон";
						condition = "([['SOB', 'General_Zey'] , this] call BSO_System_fnc_cards_arr_finder) && ('ACE_UAVBattery' in items player)";
						exceptions[] = {};
						statement = "player removeItem 'ACE_UAVBattery'; [player, 0, 'B_T_arf_drone_dynemic_Loadout_F'] spawn BSO_System_fnc_Laat;";
						icon = "";
					};
				};

				class BSO_System_Change_Uniform
				{
					displayName = "Комплект одежды";
					condition = "([['SOB'] , this] call BSO_System_fnc_cards_arr_finder)";
					icon = "";
					class BSO_System_Change_Save_Uniform
					{
						displayName = "Поменять одежду";
						condition = "(!(player getVariable ['tts_cloak_isCloaked',false])) && (player getVariable ['shadowCamo', false] == false) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[1] spawn BSO_System_fnc_change_Uniform;";
						icon = "";
					};
					class BSO_System_Change_Save_Uniform_2
					{
						displayName = "Поменять одежду";
						condition = "(!(player getVariable ['tts_cloak_isCloaked',false])) && (player getVariable ['shadowCamo', false] == true) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[2] spawn BSO_System_fnc_change_Uniform;";
						icon = "";
					};
					class BSO_System_Save_Uniform
					{
						displayName = "Сохранить одежду";
						condition = "(player getVariable ['shadowCamo', false] == false) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[0] spawn BSO_System_fnc_change_Uniform;";
						icon = "";
					};
				};

				class BSO_System_Artillery_Strike
				{
					displayName = "<t color='#ff0000'>Вызвать артподдержку</t>";
					condition = "(((name player) find '1171') >= 0) or ([['Henker'] , this] call BSO_System_fnc_cards_arr_finder)";
					exceptions[] = {};
					statement = "[] spawn BSO_System_fnc_selectArtilleryTarget;";
					icon = "";
				};

				class BSO_System_Defender_Toggle
				{
					displayName = "Переключить противоугонку";
					condition = "vehicle _player != _player";
					exceptions[] = {"isNotInside"};
					statement = "[_player] call BSO_System_fnc_Vehicle_Defender_Toggle";
				};
			};
		};
	};
};

class CfgWeapons 
{
	class JLTS_ids_gar_army;

	class BSO_System_ids_SOB: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - SOB";
		shortDisplayName="SOB";
	};	
	class BSO_System_ids_RC: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - RC";
		shortDisplayName="RC";
	};	

	class BSO_System_ids_ARF: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - ARF";
		shortDisplayName="ARF";
	};

	class BSO_System_ids_ARC: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - ARC";
		shortDisplayName="ARC";
	};

	class BSO_System_ids_RC_Nexus: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - RC Nexus";
		shortDisplayName="RC_Nexus";
	};

	class BSO_System_ids_General_Zey: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - General Zey";
		shortDisplayName="General_Zey";
	};

	class BSO_System_ids_Dark: JLTS_ids_gar_army
	{
		displayName="[SOB] Identification Card - Dark";
		shortDisplayName="Dark";
	};

	class BSO_System_ids_Henker: JLTS_ids_gar_army
	{
		displayName="Identification Card - Henker";
		shortDisplayName="Henker";
	};
};

class CfgFunctions
{
	#include "cfg\cfgFunction.hpp"
};

class RscPictureKeepAspect;

class RscTitles
{
	class RscDisplay_BSO_System
	{
		idd = -1;
		fadeout = 0;
		fadein = 0;
		duration = 1e+010;
		name = "RscDisplay_BSO_System";
		onLoad = "uiNamespace setVariable ['RscDisplay_BSO_System', _this select 0];";
		onUnload = "uiNamespace setVariable ['RscDisplay_BSO_System', nil];";
		class controlsBackground
		{
			class BSO_System_CTRL_1 : RscPictureKeepAspect
			{
				idc = 1200;
				text = "";
				x = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_1_grid_X', (-0.000156274 * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_1_grid_Y', (0.324 * safezoneH + safezoneY)]";
				w = 0.0458333 * safezoneW;
				h = 0.055 * safezoneH;
			};
			class BSO_System_CTRL_2 : RscPictureKeepAspect
			{
				idc = 1201;
				text = "";
				x = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_2_grid_X', (-0.000156274 * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_2_grid_Y', (0.379 * safezoneH + safezoneY)]";
				w = 0.0458333 * safezoneW;
				h = 0.055 * safezoneH;
			};
			class BSO_System_CTRL_3 : RscPictureKeepAspect
			{
				idc = 1202;
				text = "";
				x = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_3_grid_X', (-0.000156274 * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_3_grid_Y', (0.434 * safezoneH + safezoneY)]";
				w = 0.0458333 * safezoneW;
				h = 0.055 * safezoneH;
			};
			class BSO_System_CTRL_4 : RscPictureKeepAspect
			{
				idc = 1203;
				text = "";
				x = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_4_grid_X', (-0.000156274 * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_4_grid_Y', (0.489 * safezoneH + safezoneY)]";
				w = 0.0458333 * safezoneW;
				h = 0.055 * safezoneH;
			};
			class BSO_System_CTRL_5 : RscPictureKeepAspect
			{
				idc = 1204;
				text = "";
				x = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_5_grid_X', (-0.000156274 * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_5_grid_Y', (0.544 * safezoneH + safezoneY)]";
				w = 0.0458333 * safezoneW;
				h = 0.055 * safezoneH;
			};
			class BSO_System_CTRL_6 : RscPictureKeepAspect
			{
				idc = 1205;
				text = "";
				x = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_6_grid_X', (-0.000156274 * safezoneW + safezoneX)]";
				y = "profileNamespace getVariable ['IGUI_BSO_System_CTRL_6_grid_Y', (0.599 * safezoneH + safezoneY)]";
				w = 0.0458333 * safezoneW;
				h = 0.055 * safezoneH;
			};
		};
	};
};

class CfgUIGrids
{
	class IGUI
	{
		class Presets
		{
			class Arma3
			{
				class Variables
				{
					BSO_System_CTRL_1[]=
					{
						{
							"(-0.000156274 * safezoneW + safezoneX)",    // X
							"(0.324 * safezoneH + safezoneY)",            // Y
							"0.0458333 * safezoneW",                                // W
							"0.055 * safezoneH"                                  // H
						},
						"(((safezoneW / safezoneH) min 1.2) / 40)",         // pixelW
						"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"  // pixelH
					};
					BSO_System_CTRL_2[]=
					{
						{
							"(-0.000156274 * safezoneW + safezoneX)",    // X
							"(0.379 * safezoneH + safezoneY)",            // Y
							"0.0458333 * safezoneW",                                // W
							"0.055 * safezoneH"                                  // H
						},
						"(((safezoneW / safezoneH) min 1.2) / 40)",         // pixelW
						"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"  // pixelH
					};
					BSO_System_CTRL_3[]=
					{
						{
							"(-0.000156274 * safezoneW + safezoneX)",    // X
							"(0.434 * safezoneH + safezoneY)",            // Y
							"0.0458333 * safezoneW",                                // W
							"0.055 * safezoneH"                                  // H
						},
						"(((safezoneW / safezoneH) min 1.2) / 40)",         // pixelW
						"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"  // pixelH
					};
					BSO_System_CTRL_4[]=
					{
						{
							"(-0.000156274 * safezoneW + safezoneX)",    // X
							"(0.489 * safezoneH + safezoneY)",            // Y
							"0.0458333 * safezoneW",                                // W
							"0.055 * safezoneH"                                  // H
						},
						"(((safezoneW / safezoneH) min 1.2) / 40)",         // pixelW
						"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"  // pixelH
					};
					BSO_System_CTRL_5[]=
					{
						{
							"(-0.000156274 * safezoneW + safezoneX)",    // X
							"(0.544 * safezoneH + safezoneY)",            // Y
							"0.0458333 * safezoneW",                                // W
							"0.055 * safezoneH"                                  // H
						},
						"(((safezoneW / safezoneH) min 1.2) / 40)",         // pixelW
						"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"  // pixelH
					};
					BSO_System_CTRL_6[]=
					{
						{
							"(-0.000156274 * safezoneW + safezoneX)",    // X
							"(0.599 * safezoneH + safezoneY)",            // Y
							"0.0458333 * safezoneW",                                // W
							"0.055 * safezoneH"                                  // H
						},
						"(((safezoneW / safezoneH) min 1.2) / 40)",         // pixelW
						"((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)"  // pixelH
					};																									
				};
			};
		};
		class Variables
		{
			class BSO_System_CTRL_1
			{
				displayName = "Bso_System_CTRL_1";
				description = "Первое появление картинок при использовании скриптов из BSO_System";
				preview = "#(argb,8,8,3)color(0,0,0,0.25)";
				saveToProfile[] = {0,1};
				canResize = 0;
			};
			class BSO_System_CTRL_2
			{
				displayName = "Bso_System_CTRL_2";
				description = "Второе появление картинок при использовании скриптов из BSO_System";
				preview = "#(argb,8,8,3)color(0,0,0,0.25)";
				saveToProfile[] = {0,1};
				canResize = 0;
			};
			class BSO_System_CTRL_3
			{
				displayName = "Bso_System_CTRL_3";
				description = "Третье появление картинок при использовании скриптов из BSO_System";
				preview = "#(argb,8,8,3)color(0,0,0,0.25)";
				saveToProfile[] = {0,1};
				canResize = 0;
			};
			class BSO_System_CTRL_4
			{
				displayName = "Bso_System_CTRL_4";
				description = "Четвёртое появление картинок при использовании скриптов из BSO_System";
				preview = "#(argb,8,8,3)color(0,0,0,0.25)";
				saveToProfile[] = {0,1};
				canResize = 0;
			};
			class BSO_System_CTRL_5
			{
				displayName = "Bso_System_CTRL_5";
				description = "Пятое появление картинок при использовании скриптов из BSO_System";
				preview = "#(argb,8,8,3)color(0,0,0,0.25)";
				saveToProfile[] = {0,1};
				canResize = 0;
			};
			class BSO_System_CTRL_6
			{
				displayName = "Bso_System_CTRL_6";
				description = "Шестое появление картинок при использовании скриптов из BSO_System";
				preview = "#(argb,8,8,3)color(0,0,0,0.25)";
				saveToProfile[] = {0,1};
				canResize = 0;
			};																	
		};
	};
};

class Extended_PreInit_EventHandlers
{
	class BSO_System_PreInit
	{
		init="call compile preprocessFileLineNumbers '\BSOSystem\XEH\XEH_preInit.sqf'";
	};
};

class Extended_PostInit_EventHandlers
{
	class BSO_System_PostInit
	{
		init="call compile preprocessFileLineNumbers '\BSOSystem\XEH\XEH_postInit.sqf'";
	};
};