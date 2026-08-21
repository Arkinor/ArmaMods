params [
    ["_short_name_input", [], [[], ""]],
    ["_pl", objNull, [objNull]]
];

_short_names = if (_short_name_input isEqualType []) then {
    _short_name_input
} else {
    [_short_name_input]
};

_result = _short_names findIf {
    _className = BSO_Cards_HashMap getOrDefault [
        toLower _x,
        ""
    ];

    _className != ""
    && {_className in items player}
} != -1;

_result