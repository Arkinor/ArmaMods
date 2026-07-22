
class CfgPatches
{
	class Jedi_Jump
	{
		addonRootClass = "Jedi_Jumpr";
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
#pragma region  Общее наследование 

	class B_Kitbag_rgr;
	class BSO_Jedi_jump : B_Kitbag_rgr
    {
        scope = 2;
        displayname = "Arkinor JP";
		model="";
       	tf_dialog = "JLTS_clone_lr_programmer_radio_dialog";
        tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
        tf_encryptionCode = "tf_west_radio_code";
        tf_subtype = "digital_lr";
        tf_range = 50000;
        tf_hasLRradio = 1;
        maximumLoad = 300000;
		knd_isJetpack=1;
		knd_jetpack_acceleration=1.8;
		knd_jetpack_resistance=4;
		knd_jetpack_fuelCoef=1.5;
		knd_jetpack_heatCoef=1.1;
		knd_jetpack_coolCoef=1;
		knd_jetpack_ascensionCoef=1;
		knd_jetpack_jumpCoef=1;
		knd_jetpack_fuelCapacity=400;
		knd_jetpack_strafeCoef=0.30000001;
    };

};



