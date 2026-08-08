params ["_pl"];

_currentside = side _pl;

[_pl] joinSilent grpNull;

_newside = if (_currentside == civilian) then {
    west
} else {
    civilian
};

_newgroup = creategroup _newside;
[_pl] joinSilent _newgroup;

hint format ["Вы теперь на стороне: %1", side _pl];