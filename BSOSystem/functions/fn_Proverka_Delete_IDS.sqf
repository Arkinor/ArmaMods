_pl = _this;

if ((name _pl find 'ARF' != -1)
or (name _pl find 'ARC' != -1)
or (name _pl find 'RC' != -1)
or (name _pl find 'SOB' != -1)
or (name _pl find 'DARK' != -1)
or (name _pl find 'HENKER' != -1)
or (name _pl find 'Kosiposha' != -1)
) exitwith {};

{
    if (_x in BSO_Cards_Array && {
        _x != "BSO_System_ids_Henker"
    }) then {
        private _card = _x;
        private _n = {
            _x == _card
        } count (items _pl);
        for "_i" from 1 to _n do {
            _pl removeItem _card
        };
    };
} forEach (items _pl);