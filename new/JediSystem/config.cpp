#include "compat\knd_jetpack_override.cpp"

class CfgPatches
{
	class Main
	{
		units[]={};
		weapons[]={
		"Jedis",				//0
		"Jedi_Tutaminis",		//1
		"Jedi_Stun",			//2 
		"Jedi_DeathTelekinez",	//3
		"Jedi_ioniz",			//4
		"Jedi_Delete_weapon",	//5 
		"Jedi_MiliKill",		//6
		"Jedi_SpeedUp",			//7 
		"Jedi_vehicle",			//8
		"Jedi_Heal",			//9
		"Jedi_Clone",			//10
		"Jedi_IonizShtorm",		//11 НЕТУ
		"Jedi_Exterminatus",	//12 
		"Jedi_fullMana",		//13 
		"Jedi_CheckMana",		//14 
		"Jedi_Ave_Arkinor",		//15
		"Jedi_ChangePlayerSide",//16
		"Jedi_Mili_battle",		//17
		"Jedi_Piro",			//18 
		"Jedi_IH",				//19
		"Jedi_Telekinez"        //20


		};
		requiredVersion=0.1;
		requiredAddons[]={
			"JLTS_C_IDs",
			"knd_jetpacks"
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
			class Jedi_Telekinez_up
				{
				displayName="<t color='#80ff00'>Взять предмет</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'telekinez' == false) && (Cards_Array select 20 in items player)";
				statement="[] spawn Jedi_fnc_Telekinez;";				
				};	
			class Jedi_Telekinez_down
				{
				displayName="<t color='#ff4d4d'>Отпустить предмет</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable  'telekinez' == true) && (Cards_Array select 20 in items player)";
				statement="player setVariable ['telekinez',false,true];";			
				};

			class Jedi_Upheaval_up
				{
				displayName="<t color='#80ff00'>Повернуть предмет</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'Upheaval' == false) && (Cards_Array select 20 in items player)";
				statement="[] spawn Jedi_fnc_Upheaval;";				
				};	
			class Jedi_Upheaval_down
				{
				displayName="<t color='#ff4d4d'>Прекратить поворачивать предмет</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable  'Upheaval' == true) && (Cards_Array select 20 in items player)";
				statement="player setVariable ['Upheaval',false,true];";			
				};


			class Jedi_Tutaminis
				{
				displayName="<t color='#c9d37e'>Тутаминис на 5 минут</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 1 in items player) && (player getVariable 'UpTutaminis' == false)";
				statement="[] spawn fnc_JediTutaminis;";				
				};
						
			class Jedi_SpeedUp
				{
				displayName="<t color='#80ff00'>Скорость силы</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable 'speedofforce' == false) && (Cards_Array select 7 in items player)";
				statement="[] spawn fnc_Speedfocer_Act;";				
				};	
			class Jedi_SpeedDown
				{
				displayName="<t color='#ff4d4d'>Скорость силы</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=1;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (player getVariable  'speedofforce' == true) && (Cards_Array select 7 in items player)";
				statement="[] spawn fnc_Speedfocer_Act;";			
				};


			class Jedi_ioniz
				{
				displayName="<t color='#4480f8'>Ионизация</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 4 in items player)";
				statement="[] spawn Jedi_fnc_ioniz;";				
				};
			class Jedi_push
				{ 
				displayName="<t color='#9585d5'>Отталкивание силы</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 20 in items player)";
				statement="[] spawn Jedi_fnc_push;";				
				};

			class Jedi_IH
				{
				displayName="<t color='#80ff00'>Активировать модуль скелет</t>";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 19 in items player) && (player getVariable 'ihscript' == true)";
				statement="[] spawn Jedi_fnc_IH_Run;";				
				};
			class Jedi_Stun
				{
				displayName="Оглушение силы";
				displayNameDefault="Оглушение силы";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 2 in items player)";
				statement="[] spawn fnc_JediStun;";				
				};

			class Jedi_DeathTelekinez
				{
				displayName="Смертельный телекинез";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 3 in items player)";
				statement="[] spawn Jedi_fnc_DeathTelekinez;";				
				};

			class Jedi_Fire
				{
				displayName="Огненный луч";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 18 in items player) && (player getVariable 'firefire' == false)";
				statement="[] spawn Jedi_fnc_Fire;";				
				};
			
	

			class Jedi_Delete_weapon
				{
					displayName="Разрушение материи";
					priority=0;
					radius=5;
					position="";
					showWindow=0;
					hideOnUse=0;
					onlyForPlayer=0;
					shortcut="";
					condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 5 in items player)";
					statement="[] spawn Jedi_fnc_Delete_weapon;";	
				};

			class Jedi_MiliKill
				{
				displayName="Скрытое убийство";
				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && ((Cards_Array select 6 in items player))";
				statement="[] spawn Jedi_fnc_MiliKill;";	
				};


			class Jedi_Mili_battle
				{
				displayName="Ближний бой";

				priority=0;
				radius=5;
				position="";
				showWindow=0;
				hideOnUse=0;
				onlyForPlayer=0;
				shortcut="";
				condition="(missionNamespace getVariable['bis_fnc_moduleRemoteControl_unit', player] == this) && (alive player) && (Cards_Array select 17 in items player)";
				statement="[] spawn fnc_Chapalax;";	
				};

																					
		};
        class ACE_SelfActions
        {
			class ACE_Action
			{
				displayName="Путь джедая";
				condition = "(Cards_Array select 0 in items player)";
				icon = "";
				insertChildren = "_this call fnc_Vehicle_Defender";
	
				class vehicle_ACE_act
					{
					displayName = "Вызов техники";
					condition = "(Cards_Array select 8 in items player)";
                    icon = "";	
					insertChildren = "_this call fnc_Vehicle_jedi_card_act;";	
					};
			
				class do_vehicle_ACE_act
					{
					displayName = "Действия с техникой";
					condition = "(Cards_Array select 8 in items player)";
                    icon = "";	
					insertChildren = "";	
					
					class Jedi_delete_vehicle
						{
						displayName = "Удалить технику";
						condition = " (Cards_Array select 8 in items player)";
						exceptions[] = {};
						statement = "[] spawn fnc_delete_vehicle;";
						icon = "";
						};	
					class Jedi_repair_vehicle
						{
						displayName = "Починить технику";
						condition = "(Cards_Array select 8 in items player)";
						exceptions[] = {};
						statement = "[] spawn fnc_repair_vehicle;";
						icon = "";
						};	

					class Jedi_remove_crew
						{
						displayName = "Выгнать экипаж из техники";
						condition = "(Cards_Array select 8 in items player)";
						exceptions[] = {};
						statement = "[] spawn fnc_remove_crew;";
						icon = "";
						};	

					class Jedi_Open_Vehicle
						{
							displayName = "Открыть технику";
							condition = "(Cards_Array select 8 in items player)";
							exceptions[] = {};
							statement = "[] spawn fnc_Open_Vehicle;";
							icon = "";
						};	

					class Jedi_Close_Vehicle
						{
							displayName = "Закрыть технику";
							condition = "(Cards_Array select 8 in items player)";
							exceptions[] = {};
							statement = "[] spawn fnc_Close_Vehicle;";
							icon = "";
						};	


					// class flip_vehicle
					// 	{
					// 	displayName = "Перевернуть технику";
					// 	condition = "(Cards_Array select 8 in items player)";
					// 	exceptions[] = {};
					// 	statement = "[] spawn fnc_flip_vehicle;";
					// 	icon = "";
					// 	};	

					};

				class Change_Uniform
					{
					displayName = "Комплект одежды";
					condition = "(Cards_Array select 1 in items player) or (Cards_Array select 9 in items player)";
                    icon = "";
					class Change_Save_Uniform
					{
						displayName = "Поменять одежду";
						condition = "(!(player getVariable ['tts_cloak_isCloaked',false])) && (player getVariable ['shadowCamo', false] == false) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[1] spawn fnc_Change_Uniform;";
						icon = "";
					};
					class Change_Save_Uniform_2
					{
						displayName = "Поменять одежду";
						condition = "(!(player getVariable ['tts_cloak_isCloaked',false])) && (player getVariable ['shadowCamo', false] == true) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[2] spawn fnc_Change_Uniform;";
						icon = "";
					};					
					class Save_Uniform
					{
						displayName = "Сохранить одежду";
						condition = "(player getVariable ['shadowCamo', false] == false) && ('JLTS_intel_briefcase' in items player)";
						exceptions[] = {};
						statement = "[0] spawn fnc_Change_Uniform;";
						icon = "";
					};
					};

			class Jedi_ACE_Action
			{
				displayName="Способности силы";
				condition = "(Cards_Array select 0 in items player)";
				icon = "";
				insertChildren = "";

				class Jedi_Heal
					{
					displayName= "Исцеление силы";
					condition="(Cards_Array select 9 in items player)";
					exceptions[] = {};
					statement="[] spawn fnc_JediHeal;";
					icon = "";				
					};

				class Jedi_Clone
					{
					displayName="Создание своего дубликата";
					condition="(Cards_Array select 10 in items player)";
					exceptions[] = {};
					statement="[] spawn fnc_JediClone;";
					icon = "";					
					};


				class Exterminatus
					{
					displayName="Екстерминатус";
					condition="(Cards_Array select 12 in items player)";
					exceptions[] = {};
					statement="[] spawn Jedi_fnc_Exterminatus;";	
					icon = "";
					};	

				class fullMana
					{
					displayName="Восстановить концентрацию";
					condition="(Cards_Array select 13 in items player)";
					exceptions[] = {};
					statement="[] spawn Jedi_fnc_fullMana;";	
					icon = "";
					};
				class CheckMana
					{
					displayName="Проверить концентрацию";
					condition="(Cards_Array select 14 in items player)";
					exceptions[] = {};
					statement="[] spawn Jedi_fnc_CheckMana;";	
					icon = "";
					};
				class Ave_Arkinor
					{
					displayName="Убеждение силы М+";
					condition="(Cards_Array select 15 in items player)";
					exceptions[] = {};
					statement="[] spawn fnc_Ave_Arkinor;";	
					icon = "";
					};
				class changePlayerSide
					{
					displayName = "Сменить сторону Синяя/Фиолетовая";
					condition = "(Cards_Array select 16 in items player)";
					exceptions[] = {};
					statement = "[] spawn fnc_changePlayerSide;";
                    icon = "";				
					};


			};


			};
			



        };			
	};
};

class CfgWeapons 
{
	class JLTS_ids_gar_army;

	class Jedis: JLTS_ids_gar_army
	{
		displayName="Jedis";
	};
	class Jedi_Tutaminis: JLTS_ids_gar_army
	{
		displayName="Jedi_Tutaminis";
	};
	class Jedi_Stun: JLTS_ids_gar_army
	{
		displayName="Jedi_Stun";
	};
	class Jedi_DeathTelekinez: JLTS_ids_gar_army
	{
		displayName="Jedi_DeathTelekinez";
	};
	class Jedi_ioniz: JLTS_ids_gar_army
	{
		displayName="Jedi_ioniz";
	};
	class Jedi_Delete_weapon: JLTS_ids_gar_army
	{
		displayName="Jedi_Delete_weapon";
	};
	class Jedi_MiliKill: JLTS_ids_gar_army
	{
		displayName="Jedi_MiliKill";
	};
	class Jedi_SpeedUp: JLTS_ids_gar_army
	{
		displayName="Jedi_SpeedUp";
	};
	class Jedi_vehicle: JLTS_ids_gar_army
	{
		displayName="Jedi_vehicle";
	};
	class Jedi_Heal: JLTS_ids_gar_army
	{
		displayName="Jedi_Heal";
	};
	class Jedi_Clone: JLTS_ids_gar_army
	{
		displayName="Jedi_Clone";
	};
	class Jedi_Exterminatus: JLTS_ids_gar_army
	{
		displayName="Jedi_Exterminatus";
	};
	class Jedi_fullMana: JLTS_ids_gar_army
	{
		displayName="Jedi_fullMana";
	};	
	class Jedi_CheckMana: JLTS_ids_gar_army
	{
		displayName="Jedi_CheckMana";
	};
	class Jedi_Ave_Arkinor: JLTS_ids_gar_army
	{
		displayName="Jedi_Ave_Arkinor";
	};
	class Jedi_ChangePlayerSide: JLTS_ids_gar_army
	{
		displayName="Jedi_ChangePlayerSide";
	};
	class Jedi_Mili_battle: JLTS_ids_gar_army
	{
		displayName="Jedi_Mili_battle";
	};
	class Jedi_Piro: JLTS_ids_gar_army
	{
		displayName="Jedi_Piro";
	};
	class Jedi_IH: JLTS_ids_gar_army
	{
		displayName="Jedi_IH";
	};
	class Jedi_Telekinez: JLTS_ids_gar_army
	{
		displayName="Jedi_Telekinez";
	};


};

class Extended_PreInit_EventHandlers
{
	class PreInit
	{
		init="call compile preprocessFileLineNumbers '\JediSystem\XEH_preInit.sqf'";
	};
};

class Extended_PostInit_EventHandlers
{
	class PostInit
	{
		init="call compile preprocessFileLineNumbers '\JediSystem\XEH_postInit.sqf'";
	};
};