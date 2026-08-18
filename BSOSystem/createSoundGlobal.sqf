params
[
	["_unitToPlay", objNull],
	["_sound", "WBK_exo_take"],
	["_radius", 8.0],
	["_positionToPlay", "pelvis"]
];

if (isDedicated) exitWith {};

private _fnc_attachAndPlay = {
	params ["_unit", "_soundCache", "_sound", "_radius", "_positionToPlay"];
	if (_unit isKindOf "MAN") then {
		_soundCache attachTo [_unit, [0, 0, 0.2], _positionToPlay];
	} else {
		_soundCache attachTo [_unit, [0, 0, 0]];
	};
	[_soundCache, _sound, _radius] call CBA_fnc_globalSay3d;
	waitUntil {
		sleep 0.2;
		if (isNull _soundCache) exitWith { true };
		isNull _unit;
	};
	deleteVehicle _soundCache;
};

if (!(isNil {_unitToPlay getVariable "IMS_SoundObject"})) exitWith {
	private _soundCache = _unitToPlay getVariable "IMS_SoundObject";
	if (isNull _soundCache) exitWith {
		private _newCache = if (hasInterface) then {
			"#particlesource" createVehicleLocal (getPosATL _unitToPlay)
		} else {
			"#particlesource" createVehicle (getPosATL _unitToPlay)
		};
		_unitToPlay setVariable ["IMS_SoundObject", _newCache, true];
		[_unitToPlay, _newCache, _sound, _radius, _positionToPlay] call _fnc_attachAndPlay;
	};
	[_soundCache, _sound, _radius] call CBA_fnc_globalSay3d;
};

private _soundCache = if (hasInterface) then {
	"#particlesource" createVehicleLocal (getPosATL _unitToPlay)
} else {
	"#particlesource" createVehicle (getPosATL _unitToPlay)
};
_unitToPlay setVariable ["IMS_SoundObject", _soundCache, true];
[_unitToPlay, _soundCache, _sound, _radius, _positionToPlay] call _fnc_attachAndPlay;
