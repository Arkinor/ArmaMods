class CfgPatches
{
	class BSO_System_Main
	{
		units[]={};
		weapons[]={
			"BSO_System_ids_SOB",                  		//0
			"BSO_System_ids_RC",                    	//1
    		"BSO_System_ids_ARF",                       //2
    		"BSO_System_ids_ARC",                       //3 
			"BSO_System_General_Zey",                   //4
		};
		requiredVersion=0.1;
		requiredAddons[]={
			"JLTS_C_IDs"
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
			"\BSO_System\sounds\armor_TakingBattery.ogg",
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
			"\BSO_System\sounds\medkit.ogg",
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
			"\BSO_System\sounds\medkit_open.ogg",
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
		BSO_System_Gest_Heal[]=
		{
			"BSO_System_Gest_Heal",
			"Gesture"
		};
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
			file="\BSO_System\anims\Exo_Gest_Heal.rtm";
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
	class CAManBase: Man
	{
		class UserActions
		{
			
			class BSO_System_Hyper_Stimulator
				{
				displayName="Использовать стимулятор";
				displayNameDefault="Использовать Стимулятор";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'cooldownArmorArc' == 0) && (gestureState this != 'BSO_System_Gest_Heal') && ((BSO_Cards_Array select 3 in items player) or (BSO_Cards_Array select 4 in items player))";
				statement="[this, 600] spawn BSO_System_AdvancedArmour_Heal;";			
				};

			class BSO_System_Auto_Heal_Activ
				{
				displayName="Активировать Автохил";
				displayNameDefault="Активировать Автохил";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'BSO_System_Auto_Heal_Active' == false) && ((BSO_Cards_Array select 1 in items player) or (BSO_Cards_Array select 4 in items player))";
				statement=" player setVariable ['BSO_System_Auto_Heal_Active', true]; [] spawn BSO_System_fnc_Auto_Heal_Act;";				
				};	
			class BSO_System_Auto_Heal_Deactiv
				{
				displayName="Выключить Автохил";
				displayNameDefault="Выключить Автохил";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'BSO_System_Auto_Heal_Active' == true) && ((BSO_Cards_Array select 1 in items player) or (BSO_Cards_Array select 4 in items player))";
				statement="player setVariable ['BSO_System_Auto_Heal_Active', false];";
				};	
				
			class BSO_System_fnc_BSO_Meditatia_Act
				{
				displayName="Сосредоточиться и успокоится на минуту";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'Meditatia' == false) && (BSO_Cards_Array select 2 in items player)";
				statement="[] spawn fnc_BSO_Meditatia_Act;";
				};		
			
					
			class BSO_System_SpeedUp
				{
				displayName="<t color='#80ff00'>Скорость бега</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'bigspeed' == false) && ((BSO_Cards_Array select 2 in items player) or (BSO_Cards_Array select 1 in items player))";
				statement="[] spawn fnc_BSO_Speed_Act;";				
				};	
			class BSO_System_SpeedDown
				{
				displayName="<t color='#ff4d4d'>Скорость бега</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable  'bigspeed' == true) && ((BSO_Cards_Array select 2 in items player) or (BSO_Cards_Array select 1 in items player))";
				statement="[] spawn fnc_BSO_Speed_Act;";			
				};




			class BSO_System_Invisible
				{
				displayName="<t color='#80ff00'>Активировать Маскировку</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (alive player) && (vehicle player == player) && ([player] call tts_cloak_fnc_hasCloak) && (!(player getVariable ['tts_cloak_isCloaked',false])) && (tts_cloak_cooldown <= 0) && (!(player getVariable ['tts_cloak_cloakDisabled',false])) && (BSO_Cards_Array select 4 in items player)";
				statement="if (tts_cloak_requireHolstered) then {player action ['SWITCHWEAPON',player,player,-1];};[player] spawn tts_cloak_fnc_startCloak;";			
				};	
			class BSO_System_Visible
				{
				displayName="<t color='#ff4d4d'>Деактивировать Маскировку</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (alive player) && (player getVariable ['tts_cloak_isCloaked',false]) && (BSO_Cards_Array select 4 in items player)";
				statement="player setVariable ['tts_cloak_isCloaked', false, true];";			
				};	
			
			
																					
		};
        class ACE_SelfActions
        {
			class BSO_System_ACE_Action
			{
				displayName="БСО";
				condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
				icon = "\BSO_System\data\bso.paa";
				insertChildren = "_this call BSO_System_fnc_Vehicle_Defender";
			
				class BSO_System_Drones
				{
					displayName = "Дроны";
					condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
					exceptions[] = {};
                    icon = "";					
				
					class BSO_System_Razved_Dron
					{
						displayName = "Собрать разведовательный дрон";
						condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "['mti_armoury_drones_prowler_1500'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";					
					};
					class BSO_System_Mouse_Dron
					{
						displayName = "Собрать дрон мышь";
						condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "['mti_armoury_drones_mse_Spyro'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";					
					};
					class BSO_System_Turel_Dron
					{
						displayName = "Собрать противопехотную турель";
						condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "['mti_armoury_drones_blasterturret_base'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";					
					};
					class BSO_System_aa_Turel_Dron
					{
						displayName = "Собрать противовоздушную турель";
						condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "['mti_armoury_drones_paap_aa'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";					
					};
					class BSO_System_at_Turel_Dron
					{
						displayName = "Собрать Противотанковую турель";
						condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "['mti_armoury_drones_paap_at'] spawn BSO_System_fnc_Vehicle_spawn;";
						icon = "";					
					};
				};


				class Open_Vehicle
					{
						displayName = "Открыть технику";
						condition = "(BSO_Cards_Array select 0 in items player)";
						exceptions[] = {};
						statement = "[] spawn BSO_System_fnc_Open_Vehicle;";
						icon = "";
					};	

				class Close_Vehicle
					{
						displayName = "Закрыть технику";
						condition = "(BSO_Cards_Array select 0 in items player)";
						exceptions[] = {};
						statement = "[] spawn BSO_System_fnc_Close_Vehicle;";
						icon = "";
					};	

				class BSO_System_Mashalat
				{
					displayName = "Маскхалаты";
					condition = "(BSO_Cards_Array select 4 in items player)";
                    icon = "";
					class BSO_System_Mashalat_dust
					{
						displayName = "Пустынный Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[1] spawn BSO_System_fnc_Mashalat;";
						icon = "";
					};
					class BSO_System_Mashalat_swamp
					{
						displayName = "Болотный Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[2] spawn BSO_System_fnc_Mashalat;";
						icon = "";
					};		
					class BSO_System_Mashalat_half_dust
					{
						displayName = "Полузасушлевый Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[3] spawn BSO_System_fnc_Mashalat;";
						icon = "";
					};	
					class BSO_System_Mashalat_jungle
					{
						displayName = "Джунгли Маскхалат";
						condition = "true";
						exceptions[] = {};
						statement = "[4] spawn BSO_System_fnc_Mashalat;";
						icon = "";
					};	
					class BSO_System_Mashalat_disable
					{
						displayName = "Снять Маскхалат";
						condition = "!(isNil { player getVariable 'BSO_System_Uniform'})";
						exceptions[] = {};
						statement = "[5] spawn BSO_System_fnc_Mashalat;";
						icon = "";
					};																	
				};	

				class BSO_System_changePlayerSide
				{
					displayName = "Сменить сторону Синяя/Фиолетовая";
					condition = "(BSO_Cards_Array select 0 in items player)";
					exceptions[] = {};
					statement = "[] spawn BSO_System_fnc_changePlayerSide;";
                    icon = "";				
				};

				class BSO_System_vehicle_ACE_act
				{
					displayName = "Вызов техники";
					condition = "((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
                    icon = "\BSO_System\data\laat_ui_black.paa";	
					insertChildren = "_this call BSO_System_fnc_Vehicle_jedi_card_act;";	
					class BSO_System_Laat_Evac
					{
						displayName = "Вызвать эвакуационный LAAT";
						condition = "(player getVariable 'BSO_System_LAAT_Act_Active' == true) && ((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "[player, 1, 'mti_armoury_vehicles_laati_mk2'] spawn BSO_System_fnc_Laat";
						icon = "";					
					};
					class BSO_System_Var_Drone
					{
						displayName = "Вызвать боевой дрон";
						condition = "(player getVariable 'BSO_System_LAAT_Act_Active' == true) && ((BSO_Cards_Array select 0 in items player) or (BSO_Cards_Array select 4 in items player))";
						exceptions[] = {};
						statement = "[player, 0,'mti_armoury_drones_prowler_sniper'] spawn BSO_System_fnc_Laat;";
						icon = "";					
					};


					class BSO_System_delete_vehicle
					{
						displayName = "Удалить технику";
						condition = " (BSO_Cards_Array select 4 in items player)";
						exceptions[] = {};
						statement = "[] spawn BSO_System_fnc_delete_vehicle;";
						icon = "";
					};	
					class BSO_System_repair_vehicle
					{
						displayName = "Починить технику";
						condition = "(BSO_Cards_Array select 4 in items player)";
						exceptions[] = {};
						statement = "[] spawn BSO_System_fnc_repair_vehicle;";
						icon = "";
					};	
					class BSO_System_remove_crew
						{
						displayName = "Выгнать экипаж из техники";
						condition = "(BSO_Cards_Array select 4 in items player)";
						exceptions[] = {};
						statement = "[] spawn BSO_System_fnc_remove_crew;";
						icon = "";
						};	
					

					
				};

				class BSO_System_Change_Uniform
				{
					displayName = "Комплект одежды";
					condition = "(BSO_Cards_Array select 0 in items player) ";
                    icon = "";
					class BSO_System_Change_Save_Uniform
					{
						displayName = "Поменять одежду";
						condition = "(!(player getVariable ['tts_cloak_isCloaked',false])) && (player getVariable ['shadowCamo', false] == false) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[1] spawn BSO_System_fnc_Change_Uniform;";
						icon = "";
					};
					class BSO_System_Change_Save_Uniform_2
					{
						displayName = "Поменять одежду";
						condition = "(!(player getVariable ['tts_cloak_isCloaked',false])) && (player getVariable ['shadowCamo', false] == true) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[2] spawn BSO_System_fnc_Change_Uniform;";
						icon = "";
					};					
					class BSO_System_Save_Uniform
					{
						displayName = "Сохранить одежду";
						condition = "(player getVariable ['shadowCamo', false] == false) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[0] spawn BSO_System_fnc_Change_Uniform;";
						icon = "";
					};
				};
				class BSO_System_Personality_Scaner
				{
					displayName = "Сканировать личность";
					condition = "(player getVariable ['BSO_System_Personality_Scaner_Activ', true]) && (BSO_Cards_Array select 0 in items player)";
					exceptions[] = {};
					statement = "[] spawn BSO_System_fnc_Personality_Scaner;";
                    icon = "";					
				};	
			};
		
		class BSO_System_vehicle_ACE_act
				{
					displayName = "Маскировочные фортификации";
					condition = "('ACE_Fortify' in items player)";
                    icon = "\BSO_System\data\bacta_ui_green.paa";	
					insertChildren = "_this call BSO_System_fnc_spawner_items_act;";
					
					class BSO_System_Remove_Tent
					{
						displayName = "Удалить палатку";
						condition = "('ACE_Fortify' in items player)";
						exceptions[] = {};
						statement = "[] spawn BSO_System_fnc_Remove_Tent;";
						icon = "";
					};	


				};	

        };			
	};

};


class CfgWeapons 
{
	class JLTS_ids_gar_army;
	
	// };	
	class BSO_System_ids_SOB: JLTS_ids_gar_army
	{
		displayName="BSO_System_ids_SOB";
	};	
	class BSO_System_ids_RC: JLTS_ids_gar_army
	{
		displayName="BSO_System_ids_RC";
	};	

	class BSO_System_ids_ARF: JLTS_ids_gar_army
	{
		displayName="BSO_System_ids_ARF";
	};

	class BSO_System_ids_ARC: JLTS_ids_gar_army
	{
		displayName="BSO_System_ids_ARC";
	};
	class BSO_System_General_Zey: JLTS_ids_gar_army
	{
		displayName="BSO_System_General_Zey";
	};

};

class Extended_PreInit_EventHandlers
{
	class BSO_System_PreInit
	{
		init="call compile preprocessFileLineNumbers '\BSO_System\XEH_preInit.sqf'";
	};
};

class Extended_PostInit_EventHandlers
{
	class BSO_System_PostInit
	{
		init="call compile preprocessFileLineNumbers '\BSO_System\XEH_postInit.sqf'";
	};
};