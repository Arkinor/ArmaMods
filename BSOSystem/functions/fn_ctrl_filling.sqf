params [
    ["_expectedText", "", [""]],
    ["_text", "", [""]]
];

_basePath = "\BSOSystem\data\";

_normalizeTexture = {
    params ["_texture"];

    if (_texture isEqualTo "") exitWith {
        ""
    };

    if (
        (_texture find "\") >= 0 ||
        (_texture find "/") >= 0
    ) exitWith {
        _texture
    };

    _result = _texture;

    _startIndex = ((count _result) - 4) max 0;
    _extension = toLower (
        _result select [_startIndex, 4]
    );

    if !(_extension isEqualTo ".paa") then {
        _result = _result + ".paa";
    };

    _basePath + _result
};


_expectedText = [_expectedText] call _normalizeTexture;
_text = [_text] call _normalizeTexture;

_display = uiNamespace getVariable "RscDisplay_BSO_System";

_BSO_System_CTRL_Array = [];

if !(isNull _display) then {
    {
        if !(isNull _x) then {
            _BSO_System_CTRL_Array pushBackUnique _x;
        };
    } forEach allControls _display;
};

_textures = [];

{
    _currentTexture = ctrlText _x;

    if !(_currentTexture isEqualTo "") then {
        if ((_textures find _currentTexture) isEqualTo -1) then {
            _textures pushBack _currentTexture;
        };
    };
} forEach _BSO_System_CTRL_Array;

if !(_expectedText isEqualTo "") then {
    if ((_textures find _expectedText) isEqualTo -1) then {
        _textures pushBack _expectedText;
    };
};

if !(_text isEqualTo "") then {
    _textures = _textures select {
        !(_x isEqualTo _text)
    };
};

{
    _x ctrlSetText "";
    _x ctrlCommit 0;
} forEach _BSO_System_CTRL_Array;

{
    _index = _forEachIndex;

    if (_index < count _BSO_System_CTRL_Array) then {
        _ctrl = _BSO_System_CTRL_Array select _index;

        _ctrl ctrlSetText _x;
        _ctrl ctrlCommit 0;
    };
} forEach _textures;