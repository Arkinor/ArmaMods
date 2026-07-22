#include "BIS_AddonInfo.hpp"


class CfgPatches
{
	class BSO_System_Armor
	{
		addonRootClass = "BSO_System_Armor";
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

	class JLTS_Clone_jumppack_mc;
	class JLTS_Clone_jumppack_JT12;
	// class BSO_Jedi_jump : JLTS_Clone_jumppack_mc
    // {
    //     scope = 2;
    //     displayname = "[BSO] jedi inviz JP";
    //     tf_encryptionCode = "tf_west_radio_code";
    //     tf_subtype = "digital_lr";
    //     tf_range = 1000000;
    //     tf_hasLRradio = 1;
    //     maximumLoad = 300000;
    //     JLTS_isJumppack = 0;
    //     hiddenSelectionsTextures[] =
    //     {
    //         "\BSO_System\clones\1.paa"
    //     };
    //     class rd501_jumppack
    //     {
    //         rechargeRateSecond = 400;
    //         capacity = 800;
    //         allowedJumpTypes[] =
    //         {
    //             "Forward",
    //             "Short",
    //             "Dash",
    //             "Cancel"
    //         };
    //         igniteSound = "RD501_Jumppack\sounds\cdv21Start.ogg";
    //     };
    // };


// 	class BSO_jumppack : JLTS_Clone_jumppack_JT12
// 	{
// 		scope = 2;
// 		picture = "\MRC\JLTS\characters\CloneArmor2\data\ui\Clone_jumppack_jt12_ui_ca.paa";
// 		displayName = "[BSO] jumppack";
// 		model = "\MRC\JLTS\characters\CloneArmor2\CloneJumppackJT12.p3d";
// 		tf_dialog = "JLTS_clone_lr_programmer_radio_dialog";
// 		tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
// 		tf_encryptionCode = "tf_west_radio_code";
// 		tf_subtype = "digital_lr";
// 		tf_range = 35000;
// 		tf_hasLRradio = 1;
// 		maximumLoad = 800;
// 		JLTS_isJumppack = 0;
// 		hiddenSelections[] =
// 		{
// 			"camo1"
// 		};
// 		hiddenSelectionsTextures[] =
// 		{
// 			"\MRC\JLTS\characters\CloneArmor2\data\Clone_jumppack_jt12_co.paa"
// 		};
// 		class rd501_jumppack
// 		{
// 			rechargeRateSecond = 10;
// 			capacity = 400;
// 			allowedJumpTypes[] =
// 			{
// 				"Forward",
// 				"Short",
// 				"Dash",
// 				"Cancel"
// 			};
// 			igniteSound = "RD501_Jumppack\sounds\cdv21Start.ogg";
// 		};
// 	};
};







class CfgWeapons
{		

class VestItem;
//Худ прописываем в шлем  MJOLNIR_isHelmet=1;
//                в жилет MJOLNIR_isArmor=1;  	

//Интерком прописываем  в шлем  mti_katarnOS_isHelmet=1; mti_intercom_hasIntercom=1; 
//					    в форму mti_katarnOS_hasOS=1;

    // Тестовый дубликат одежды.
    // class ZW_Team_Base_Class_Officer_Vest;
    // class ZW_Team_Base_Class_Officer_Vest_HUD: ZW_Team_Base_Class_Officer_Vest
	// {
	// 	displayName = "ARC with HUD";
	// 	MJOLNIR_isArmor=1;
	// };


	//шлем
    class H_Hat_grey;
    class Arkinor_Hud: H_Hat_grey
	{	
		author="Arkinor";
		scope=2;
		displayName = "Arkinor_Hud";
		MJOLNIR_isHelmet=1;
		mti_intercom_hasIntercom = 1;
		mti_katarnOS_isHelmet = 1;
		mti_katarnOS_isHUD = 1;
	};


    class Arkinor_Hud_inv: H_Hat_grey
	{	
		author="Arkinor";
		scope=2;
		displayName = "Arkinor_Hud_inv";
		model = "";
		MJOLNIR_isHelmet=1;
		mti_intercom_hasIntercom = 1;
		mti_katarnOS_isHelmet = 1;
		mti_katarnOS_isHUD = 1;
	};


	// /ЖИЛЕТ
	class SWLB_clone_basic_armor;
    class Arkinor_vest : SWLB_clone_basic_armor
    {
        author="Arkinor";
        scope=2;
		model = "";
        displayName = "Arkinor_vest"; 
        sc_grapplinghook = 1;
        class ItemInfo: VestItem
        {
            containerClass="Supply450";
            vestType = "Rebreather";
            armor = 100; // уровень защиты

        };
        MJOLNIR_isArmor = 1; 
        MJOLNIR_Shield_Off = 1; 
        MJOLNIR_shieldStrength = 50; 
        MJOLNIR_shieldChargeValue=1; 
        MJOLNIR_shieldChargeDelay=0.1;
    };




	//шлем
    // class ARC_Helmet_m10_LT;
    // class Voodoo_Helmet: ARC_Helmet_m10_LT
	// {	
	// 	author="Arkinor";
	// 	scope=2;
	// 	displayName = "Voodoo_Helmet";
	// 	MJOLNIR_isHelmet=1;
	// 	mti_intercom_hasIntercom = 1;
	// 	mti_katarnOS_isHelmet = 1;
	// 	mti_katarnOS_isHUD = 1;
	// };




	
	// /ЖИЛЕТ
	// class SWLB_m10_ct_armor;
    // class Voodoo_vest : SWLB_m10_ct_armor
    // {
    //     author="Arkinor";
    //     scope=2;
    //     displayName = "Voodoo_vest"; 
    //     sc_grapplinghook = 1;
	// 	hiddenSelections[]=
	// 	{
	// 		"camo1"
	// 	};
	// 	hiddenSelectionsTextures[]=
	// 	{
	// 		"Phoenix\m10_LT\Pauldron_ca.paa"
	// 	};
    //     class ItemInfo: VestItem
    //     {	
	// 		hiddenSelections[]=
	// 		{
	// 			"camo1"
	// 		};
	// 		uniformModel="\SWLB_clones\SWLB_clone_officer_armor.p3d";
    //         containerClass="Supply450";
    //         vestType = "Rebreather";
    //         armor = 60; // уровень защиты

    //     };
	// 	mti_pangolin_hasShield=1;
    //     MJOLNIR_isArmor = 1; 
    //     MJOLNIR_Shield_Off = 1; 
    //     MJOLNIR_shieldStrength = 50; 
    //     MJOLNIR_shieldChargeValue=1; 
    //     MJOLNIR_shieldChargeDelay=0.1;
    // };



	//// ШЛЕМ
	// 	class ZW_Katarn_Helmet_Base : 3AS_Katarn_Helmet_Base
	// {
	// 	author = "ZW Team";
	// 	scope = 2;
	// 	weaponPoolAvailable = 1;
	// 	displayName = "[SOB] Zulu Helmet (1)";
	// 	picture = "\3AS\3AS_Characters\Commando\data\Helmet_ca.paa";
	// 	model = "\3AS\3AS_Characters\Commando\3AS_Katarn_Helmet.p3d";
	// 	hiddenSelections[] =
	// 	{
	// 		"camo",
	// 		"camo1"
	// 	};
	// 	hiddenSelectionsTextures[] =
	// 	{
	// 		"\BSO_System\clones\bso\rc\data\Zulu_Helmet_1_co.paa",
	// 		"\BSO_System\clones\bso\rc\data\Acklay_1313_katarn_helmet_standard_co.paa"
	// 	};
	// 	mti_intercom_hasIntercom = 1;
	// 	mti_katarnOS_isHelmet = 1;
	// 	mti_katarnOS_isHUD = 1;
	// 	class ItemInfo : HeadgearItem
	// 	{
	// 		mass = 10;
	// 		uniformModel = "\3AS\3AS_Characters\Commando\3AS_Katarn_Helmet.p3d";
	// 		modelSides[] = {3,1};
	// 		hiddenSelections[] =
	// 		{
	// 			"camo",
	// 			"camo1"
	// 		};
	// 		class HitpointsProtectionInfo
	// 		{
	// 			class Head
	// 			{
	// 				hitpointName = "HitHead";
	// 				armor = 10;
	// 				passThrough = 0.5;
	// 			};
	// 		};
	// 	};
	// 	subItems[] =
	// 	{
	// 		"Integrated_NVG_TI_0_F"
	// 	};
	// 	optreVarietys[] =
	// 	{
	// 		"_dp",
	// 		"",
	// 		"_broken"
	// 	};
	// 	optreHUDStyle = "ODST_1";
	// };


	// //ФОРМА
	// class InfinityBaseCatarnClass : 3AS_U_Rep_Katarn_Armor
	// {
	// 	author = "InfinityStudio";
	// 	displayName = "[SOB] Katarn Uniform";
	// 	tas_is_commando = 1;
	// 	mti_katarnOS_isSuit = 1;
	// 	mti_katarnOS_hasOS = 1;
	// 	mti_katarnOS_hasTaser = 1;
	// 	class ItemInfo : UniformItem
	// 	{
	// 		uniformClass = "InfinityBaseCatarnClass_B";
	// 		armor = 10;
	// 		armorStructural = 3;
	// 		uniformType = "Neopren";
	// 		modelSides[] = { 6 };
	// 	};
	// };




	///ЖИЛЕТ
	// class ZW_Team_Jedi_VestHolster;
	// class ZW_Team_Jedi_VestHolster_HUD : ZW_Team_Jedi_VestHolster
	// {
    //     author="Arkinor";
    //     scope=2;
	// 	displayName = "[BSO] jedi with HUD"; 
	// 	sc_grapplinghook = 1;
    //     class ItemInfo: VestItem
    //     {
    //         containerClass="Supply450";
	// 		vestType = "Rebreather";
	// 		armor = 100-; // уровень защиты
			
    //     };
	// 	MJOLNIR_isArmor = 1; \
	// 	MJOLNIR_Shield_Off = 1; \
	// 	MJOLNIR_shieldStrength = 50; \
	// 	MJOLNIR_shieldChargeValue=1; \
	// 	MJOLNIR_shieldChargeDelay=0.1;
    // };
	
	
};