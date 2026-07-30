#include "BIS_AddonInfo.hpp"
class cfgPatches
{
	class Laat_unit_I
	{
		addonRootClass = "Laat_unit_I";
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
class CfgVehicles
{
	class mti_armoury_vehicles_laati_mk2;
	class ARK_LAATi_Base : mti_armoury_vehicles_laati_mk2
	{
		scope = 2;
		scopeCurator = 2;
		armor=1000;
		displayname = "[BSO] LAAT/I Mk.1 (Arkinor)";
		faction = "7th_main_SOB";
		editorSubcategory = "7th_aptol_gar";
		vehicleClass = "BSO_laat";
		side = 1;
		crew = "3AS_Clone_P2_Pilot";
		
	};
};