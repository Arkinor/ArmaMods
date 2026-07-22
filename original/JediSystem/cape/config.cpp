#include "BIS_AddonInfo.hpp"

class CfgPatches
{
	class Jedi_Jump1
	{
		addonRootClass = "Jedi_Jumpr1";
		requiredAddons[] =
		{
		};
		requiredVersion = 0.1;
		units[] =
		{
		
		};
		weapons[] =
		{
			
		};
	};
};

class cfgWeapons
{
	class SOB_Base_RC_Team_Leader_Vest;
	class VestItem;
	class Arki_MandoClasCape_armor: SOB_Base_RC_Team_Leader_Vest
	{
		author="Emil";
		scope=2;
		side=3;
		displayName="[Arkinor] Classic cape";
		MJOLNIR_Shield_Off = 1;
		MJOLNIR_shieldStrength = 50;  
		picture="";
		model="JediSystem\cape\Boba_cape.p3d";
		hiddenSelections[]=
		{
			"Camo1",
			"Camo2"
		};
		hiddenSelectionsTextures[]=
		{
			"JediSystem\cape\data\jango_clo_co.paa",
			"JediSystem\cape\data\st_cape_co.paa"
		};
		class ItemInfo: VestItem
		{
			uniformModel="JediSystem\cape\Boba_cape.p3d";
			containerClass="Supply400";
			mass=20;
			modelsides[]={6};
			hiddenSelections[]=
			{
				"Camo1",
				"Camo2"
			};
			class HitpointsProtectionInfo
			{
				class Head
				{
					hitpointName="HitHead";
					armor=20;
					passThrough=0.1;
				};
				class Diaphragm
				{
					hitpointName="HitDiaphragm";
					armor=45;
					passThrough=0.40000001;
				};
				class Chest
				{
					hitpointName="HitChest";
					armor=50;
					passThrough=0.40000001;
				};
				class Abdomen
				{
					hitpointName="HitAbdomen";
					armor=35;
					passThrough=0.40000001;
				};
				class Pelvis
				{
					hitpointName="HitPelvis";
					armor=40;
					passThrough=0.40000001;
				};
				class Neck
				{
					hitpointName="HitNeck";
					armor=20;
					passThrough=0.2;
				};
				class Arms
				{
					hitpointName="HitArms";
					armor=35;
					passThrough=0.2;
				};
				class Body
				{
					hitpointName="HitBody";
					passThrough=0.40000001;
				};
			};
		};
	};

};