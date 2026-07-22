params
[
	["_unitToPlay", objNull],
	["_sound", "WBK_exo_take"],
	["_radius", 8.0],
	["_positionToPlay", "pelvis"]
];
if (!(isNil {_unitToPlay getVariable "IMS_SoundObject"})) exitWith {
_soundCache = _unitToPlay getVariable "IMS_SoundObject";
if (isNull _soundCache) exitWith {
_soundCache = "#particlesource" createVehicle position _unitToPlay;
_unitToPlay setVariable ["IMS_SoundObject",_soundCache,true];
if (_unitToPlay isKindOf "MAN") then {
_soundCache attachTo [_unitToPlay, [0, 0, 0.2], _positionToPlay]; 
}else{
_soundCache attachTo [_unitToPlay, [0, 0, 0]]; 
};
[_soundCache, _sound, _radius] call CBA_fnc_globalSay3d;
waitUntil {
    sleep 0.2;
	if (isNull _soundCache) exitWith { true }; // has to return true to continue
	isNull _unitToPlay;
};
deleteVehicle _soundCache;
};
[_soundCache, _sound, _radius] call CBA_fnc_globalSay3d;
};
_soundCache = "#particlesource" createVehicle position _unitToPlay;
_unitToPlay setVariable ["IMS_SoundObject",_soundCache,true];
if (_unitToPlay isKindOf "MAN") then {
_soundCache attachTo [_unitToPlay, [0, 0, 0.2], _positionToPlay]; 
}else{
_soundCache attachTo [_unitToPlay, [0, 0, 0]]; 
};
[_soundCache, _sound, _radius] call CBA_fnc_globalSay3d;
waitUntil {
    sleep 0.2;
	if (isNull _soundCache) exitWith { true }; // has to return true to continue
	isNull _unitToPlay;
};
deleteVehicle _soundCache;