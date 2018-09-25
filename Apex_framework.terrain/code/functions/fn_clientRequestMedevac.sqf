/*/
File: fn_clientRequestMedevac.sqf
Author:

	Quiksilver

Last Modified:

	22/10/2017 A3 1.76 by Quiksilver

Description:

	Client Medevac Request
__________________________________________________________/*/

closeDialog 2;
0 spawn {
	uiSleep 0.05;
	_textBody = '- Якщо обрати ОК - респуан та вихід будуть не доступні для вас на 10 хвилин.<br/>- Медики не зможуть оживити вас.<br/>- Щоб вас оживити - інші гравці мають доставити вас точки, що екіпійована для Медичних операцій, до того часу, як ви спливете кров’ю.';
	_textHeader = 'Нагадування про місію Медичної евакуації (Прочитайте, будь ласка)';
	_textOk = 'OK';
	_textCancel = 'Відмінити';
	private _result = [_textBody,_textHeader,_textOk,_textCancel,(findDisplay 46),FALSE,FALSE] call (missionNamespace getVariable 'BIS_fnc_guiMessage');
	if (_result) then {
		if ((!(missionNamespace getVariable ['QS_dynTask_medevac_inProgress',TRUE])) && ((lifeState player) isEqualTo 'INCAPACITATED') && (isNull (objectParent player)) && (isNull (attachedTo player))) then {
			{
				player setVariable _x;
			} forEach [
				['QS_client_medevacRequested',TRUE,FALSE],
				['QS_client_lastMedevacRequest',(diag_tickTime + 60),FALSE],
				['QS_revive_disable',TRUE,TRUE],
				['QS_respawn_disable',(diag_tickTime + 600),FALSE]
			];
			50 cutText ['Запит на Мед.евакуацію','PLAIN DOWN',0.5];
			['systemChat',(format ['%1 запитав мед.евакуацію з квадрата %2',profileName,(mapGridPosition player)])] remoteExec ['QS_fnc_remoteExecCmd',-2,FALSE];
			[77,'MEDEVAC',[player,profileName]] remoteExec ['QS_fnc_remoteExec',2,FALSE];
		} else {
			50 cutText ['Мед.евакуація недоступна','PLAIN DOWN',0.5];
		};
	} else {
		50 cutText ['Запит на Мед.евакуацію скасовано','PLAIN DOWN',0.5];
	};
};
