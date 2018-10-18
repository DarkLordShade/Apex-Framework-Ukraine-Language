/*
File: fn_clientInteractRespawnVehicle.sqf
Author:

	Quiksilver

Last Modified:

	12/08/2016 A3 1.62 by Quiksilver

Description:

	- Client can respawn a vehicle via action menu
_____________________________________________________________*/

private ['_t','_text'];
_t = cursorTarget;
if (isNil {_t getVariable 'QS_RD_vehicleRespawnable'}) exitWith {};
if (!(_t getVariable 'QS_RD_vehicleRespawnable')) exitWith {};
if ((!(_t isKindOf 'LandVehicle')) && (!(_t isKindOf 'Air')) && (!(_t isKindOf 'Ship'))) exitWith {};
if (!(((crew _t) findIf {(alive _x)}) isEqualTo -1)) exitWith {};
if (!simulationEnabled _t) exitWith {};
if ((isMultiplayer) && (!(local _t))) exitWith {};
if (((vectorMagnitude (velocity _t)) * 3.6) > 1) exitWith {};
if (diag_tickTime < (player getVariable ['QS_RD_canRespawnVehicle',-1])) exitWith {};
if (!((getVehicleCargo _t) isEqualTo [])) exitWith {
	50 cutText ['Автомобіль має вантаж всередині.','PLAIN',0.3];
};
if (!isNull (getSlingLoad _t)) exitWith {
	50 cutText ['Автомобіль має тент.','PLAIN',0.3];
};
if (!((ropes _t) isEqualTo [])) exitWith {
	50 cutText ['Автомобіль причеплений тросами.','PLAIN',0.3];
};
if (!(isNull (attachedTo _t))) exitWith {
	50 cutText ['Автомобіль прикріплений до чогось.','PLAIN',0.3];
};
private _result = [(format ['Ви впевнені, що хочете відновити цей %1',(getText (configFile >> 'CfgVehicles' >> (typeOf _t) >> 'displayName'))]),'Попередження','Відновлення транспорту','Відмінити',(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
if (_result) then {
	player setVariable ['QS_RD_canRespawnVehicle',(diag_tickTime + 120),FALSE];
	player playAction 'PutDown';
	playSound 'ClickSoft';
	50 cutText ['Респаун транспорту','PLAIN DOWN',0.5];
	if ((_t distance2D (markerPos 'QS_marker_base_marker')) >= 1000) then {
		_text = format ['%1 відновив %2 на базі %3',profileName,(getText (configFile >> 'CfgVehicles' >> (typeOf _t) >> 'displayName')),(mapGridPosition (getPosWorld player))];
		['systemChat',_text] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
	};
	if (!isNil {player getVariable 'QS_client_createdBoat'}) then {
		if (!isNull (player getVariable 'QS_client_createdBoat')) then {
			if (alive (player getVariable 'QS_client_createdBoat')) then {
				if (_t isEqualTo (player getVariable 'QS_client_createdBoat')) then {
					if (!((backpack player) isEqualTo '')) then {
						if (player canAddItemToBackpack ['ToolKit',1]) then {
							player addItemToBackpack 'ToolKit';
							50 cutText [(format ['%1 розміщено, інструментарій додано',(getText (configFile >> 'CfgVehicles' >> (typeOf _t) >> 'displayName'))]),'PLAIN DOWN'];
						};
					};
				};
			};
		};
	};
	if ((_t distance (markerPos 'QS_marker_base_marker')) > 1000) then {
		[46,[player,2]] remoteExec ['QS_fnc_remoteExec',2,FALSE];
		['ScoreBonus',[(format ['Очищення %1',worldName]),'2']] call (missionNamespace getVariable 'QS_fnc_showNotification');
	};
	[17,_t] remoteExec ['QS_fnc_remoteExec',2,FALSE];
} else {
	50 cutText ['Відміна','PLAIN',0.3];
};
