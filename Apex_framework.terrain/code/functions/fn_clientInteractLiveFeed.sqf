/*
File: fn_clientInteractLiveFeed.sqf
Author:

	Quiksilver

Last Modified:

	18/09/2015 ArmA 3 1.50 by Quiksilver

Description:

	Live Feed toggle
__________________________________________________________*/

private _onOrOff = player getVariable 'QS_RD_client_liveFeed';
if (_onOrOff) then {
	player setVariable ['QS_RD_client_liveFeed',FALSE,FALSE];
	playSound 'clickSoft';
	(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'Трансляцію наживо ВИМКНЕНО',[],-1];
	player playAction 'Putdown';
	if (!isNil {missionNamespace getVariable 'QS_RD_CSH_TV_1'}) then {
		(missionNamespace getVariable 'QS_RD_CSH_TV_1') setObjectTexture [0,(getMissionConfigValue 'QS_RD_liveFeed_noSignal')];
		/*/(missionNamespace getVariable 'QS_RD_CSH_TV_1') setObjectTexture [0,(getText (missionConfigFile >> 'QS_RD_liveFeed_noSignal'))];/*/
	};
} else {
	if (!(isPipEnabled)) exitWith {
		_text = parseText 'PiP не ввімкнено.<br/> Esc >> Configure >> Video >> PiP.';
		(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,_text,[],-1];
	};
	player setVariable ['QS_RD_client_liveFeed',TRUE,FALSE];
	playSound 'clickSoft';
	(missionNamespace getVariable 'QS_managed_hints') pushBack [5,FALSE,5,-1,'Трансляцію наживо УВІМКНЕНО, зачекайте.',[],-1];
	player playAction 'Putdown';
	if (!isNil {missionNamespace getVariable 'QS_RD_CSH_TV_1'}) then {
		(missionNamespace getVariable 'QS_RD_CSH_TV_1') setObjectTexture [0,'#(argb,512,512,1)r2t(QS_RD_LFE,1)'];
	};
};
