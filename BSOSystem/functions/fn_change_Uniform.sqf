params ["_value"];
switch (true) do {
    case (_value == 0): {
        profileNamespace setVariable ["Shadow_saved_headgear", headgear player];
        profileNamespace setVariable ["Shadow_saved_uniform", uniform player];
        profileNamespace setVariable ["Shadow_saved_vest", vest player];
        profileNamespace setVariable ["Shadow_saved_backpack", backpack player];
        saveProfileNamespace;
    };
    case (_value == 1): {
        oldHelm = headgear player;
        oldUni = uniform player;
        oldvest = vest player;
        oldbackpack = backpack player;
        oldUniitems = uniformItems player;
        oldvestItems = vestItems player;
        oldbackpackitems = backpackitems player;
        
        player setVariable ["saved_headgear", headgear player];
        player setVariable ["saved_uniform", uniform player];
        player setVariable ["saved_vest", vest player];
        player setVariable ["saved_backpack", backpack player];
        
        player setVariable ["shadowCamo", true];
        _saved_headgear = (profileNamespace getVariable "Shadow_saved_headgear");
        if (typeName _saved_headgear == "strinG") then {
            player addheadgear _saved_headgear
        };
        _saved_uniform = (profileNamespace getVariable "Shadow_saved_uniform");
        if (typeName _saved_uniform == "strinG") then {
            player forceAdduniform _saved_uniform;
            {
                player addItemtouniform _x
            } forEach oldUniitems;
        };
        _saved_vest = (profileNamespace getVariable "Shadow_saved_vest");
        if (typeName _saved_vest == "strinG") then {
            player addvest _saved_vest;
            {
                player addItemtovest _x
            } forEach oldvestItems;
        };
        _saved_backpack = (profileNamespace getVariable "Shadow_saved_backpack");
        if (typeName _saved_backpack == "strinG") then {
            removeBackpack player;
            player addbackpack _saved_backpack;
            {
                player addItemtobackpack _x
            } forEach oldbackpackitems;
        };
    };
    case (_value == 2): {
        newUniitems = uniformItems player;
        newvestItems = vestItems player;
        newbackpackitems = backpackitems player;
        
        removeHeadgear player;
        removeuniform player;
        removevest player;
        removeBackpack player;
        
        player addheadgear oldHelm;
        player forceAdduniform oldUni;
        player addvest oldvest;
        player addbackpack oldbackpack;
        
        {
            player addItemtouniform _x
        } forEach newUniitems;
        {
            player addItemtovest _x
        } forEach newvestItems;
        {
            player addItemtobackpack _x
        } forEach newbackpackitems;
        
        player removeAction oldaction;
        player setVariable ["shadowCamo", false];
    };
};