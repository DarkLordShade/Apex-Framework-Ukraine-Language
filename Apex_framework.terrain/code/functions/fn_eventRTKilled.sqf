/*
File: fn_eventRTKilled.sqf
Author:

	Quiksilver

Last modified:

	9/06/2016 A3 1.61 by Quiksilver

Description:

	Event Radio Tower Killed
__________________________________________________*/

private ['_object','_killer','_name'];
_object = _this select 0;
_killer = _this select 1;
missionNamespace setVariable ['radioTowerAlive',FALSE,FALSE];
{
	_x setMarkerAlpha 0;
	_x setMarkerPos [-5000,-5000,0];
} forEach ['QS_marker_radioMarker','QS_marker_radioCircle'];
_radioTowerDownText = parseText "<t align='center' size='2.2'>Радіовежу</t><br/><t size='1.5' color='#08b000' align='center'>ЗНИЩЕНО</t><br/>____________________<br/>Ворожу радіовежу знищено! Неперевершена робота, хлопці!<br/><br/><t size='1.2' color='#08b000' align='center'> Тепер ворог не зможе викликати підкріплення!</t><br/>";
//['hint',_radioTowerDownText] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
['QS_IA_TASK_AO_1'] call (missionNamespace getVariable 'BIS_fnc_deleteTask');
['CompletedSub',['Ворожу радіовежу знищено!']] remoteExec ['QS_fnc_showNotification',-2,FALSE];
if (!isNull _killer) then {
	if (isPlayer _killer) then {
		_name = name _killer;
		if ((random 1) > 0.5) then {
			['sideChat',[WEST,'HQ'],(format ['%1 знищив радіовежу! Good work soldiers!',_name])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
		} else {
			['sideChat',[WEST,'HQ'],(format ['%1 зніс вежу! Неперевершена робота, хлопці!',_name])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
		};
		if (!((toLower (typeOf _killer)) in ['b_pilot_f','b_helipilot_f','b_soldier_uav_f','b_fighter_pilot_f'])) then {
			0 = QS_leaderboards_session_queue pushBack ['TOWER',(getPlayerUID _killer),(name _killer),1];
		};
	};
};
