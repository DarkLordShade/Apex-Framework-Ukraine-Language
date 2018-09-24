/*
File: fn_clientInteractDrag.sqf
Author:

	Quiksilver

Last Modified:

	24/04/2017 A3 1.68 by Quiksilver

Description:

	-
_____________________________________________________________*/

private _t = cursorTarget;
if (!isNull (attachedTo _t)) exitWith {};
if (!isNull (objectParent _t)) exitWith {};
if ((!(_t isKindOf 'Man')) && (!([0,_t,objNull] call (missionNamespace getVariable 'QS_fnc_getCustomCargoParams'))) && (!(_t getVariable ['QS_RD_draggable',FALSE]))) exitWith {};
if (!alive _t) exitWith {};
if ((_t isKindOf 'StaticWeapon') && (!(((crew _t) findIf {(alive _x)}) isEqualTo -1))) exitWith {};
if (_t getVariable ['QS_interaction_disabled',FALSE]) exitWith {
	50 cutText ['Взаємодію з цим об’єктом вимкнено','PLAIN',0.3];
};
if (_t getVariable ['QS_unit_needsStabilise',FALSE]) exitWith {
	50 cutText ['Одиниця потребує стабілізації','PLAIN',0.3];
};
disableUserInput TRUE;
[0.5] spawn (missionNamespace getVariable 'QS_fnc_clientDisableUserInput');
if (_t isKindOf 'Man') exitWith {
	_t setVariable ['QS_RD_storedAnim',(animationState _t),TRUE];
	_t setPosWorld ((getPosWorld player) vectorAdd ((vectorDir player) vectorMultiply 1.5));
	for '_x' from 0 to 1 step 1 do {
		_t setVariable ['QS_RD_dragged',TRUE,TRUE];
		_t setVariable ['QS_RD_interacting',TRUE,TRUE];
		player setVariable ['QS_RD_interacting',TRUE,TRUE];
		player setVariable ['QS_RD_dragging',TRUE,TRUE];
	};
	_t attachTo [player,[0,1.1,0.092]];
	[6,_t,180,'AinjPpneMrunSnonWnonDb_grab'] remoteExec ['QS_fnc_remoteExec',0,FALSE];
	50 cutText [(format ['Перетягування %1',(name _t)]),'PLAIN DOWN',0.3];
	0 spawn {
		player setVariable ['QS_RD_interaction_busy',TRUE,FALSE];
		uiSleep 2;
		player setVariable ['QS_RD_interaction_busy',FALSE,FALSE];
	};
	player playActionNow 'grabDrag';
};
if (!local _t) then {
	[66,TRUE,_t,clientOwner] remoteExec ['QS_fnc_remoteExec',2,FALSE];
};
_pos = ((getPosATL player) vectorAdd ((vectorDir player) vectorMultiply 1.5));
_pos set [2,((_pos select 2) + 0.2)];
_t setPosATL _pos;
[_t,player,TRUE] call (missionNamespace getVariable 'BIS_fnc_attachToRelative');
//comment '_t attachTo [player];';
player playActionNow 'grabDrag';
_text = format ['Перетягування %1',(_t getVariable ['QS_ST_customDN',(getText (configFile >> 'CfgVehicles' >> (typeOf _t) >> 'displayName'))])];
50 cutText [_text,'PLAIN DOWN',0.75];
if ((uiNamespace getVariable ['QS_dragStuckMsg',-1]) isEqualTo -1) then {
	uiNamespace setVariable ['QS_dragStuckMsg',0];
	(missionNamespace getVariable 'QS_managed_hints') pushBack [5,TRUE,10,-1,'Застрягли ноги? Натисніть [C] або двічі [C], або [W]+[S]',[],-1,TRUE,'Help',TRUE];
};
TRUE;
