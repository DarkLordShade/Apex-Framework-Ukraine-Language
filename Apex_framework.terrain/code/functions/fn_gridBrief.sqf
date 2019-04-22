/*/
File: fn_gridBrief.sqf
Author:

	Quiksilver

Last Modified:

	9/12/2017 A3 1.78 by Quiksilver

Description:

	Grid (De)Briefing
____________________________________________________________________________/*/

params ['_type','_usedObjectives','_gridMarkers'];
if (_type isEqualTo 0) exitWith {
	//comment 'Debrief';
	['QS_TASK_GRID_0'] call (missionNamespace getVariable 'BIS_fnc_deleteTask');
	['GRID_BRIEF',['Area Of Operations','Завдання виконано']] remoteExec ['QS_fnc_showNotification',-2,FALSE];
	{
		_x setMarkerAlpha 0;
	} forEach [
		'QS_marker_grid_IGmkr',
		'QS_marker_grid_IGcircle',
		'QS_marker_grid_IDAPloc',
		'QS_marker_grid_IDAPmkr',
		'QS_marker_grid_IDAPcircle',
		'QS_marker_grid_mtrMkr',
		'QS_marker_grid_mtrCircle'
	];
	0 spawn {
		uiSleep 5;
		{
			_x setMarkerAlpha 0;
		} forEach [
			'QS_marker_grid_capState',
			'QS_marker_grid_rspState',
			'QS_marker_grid_civState'
		];
	};
};
if (_type isEqualTo 1) exitWith {
	//comment 'Brief';
	private _text = '';
	{
		_x setMarkerAlpha 0.75;
	} forEach _aoGridMarkers;
	_centroid = missionNamespace getVariable 'QS_grid_aoCentroid';
	{
		_x setMarkerPos _centroid;
	} forEach [
		'QS_marker_aoMarker',
		'QS_marker_aoCircle'
	];
	if (!((missionNamespace getVariable ['QS_missionConfig_playableOPFOR',0]) isEqualTo 0)) then {
		[objNull,_centroid] remoteExec ['QS_fnc_respawnOPFOR',[EAST,RESISTANCE],FALSE];
	};
	_centroidOffset = [
		((_centroid select 0) + 1000),
		((_centroid select 1) + 300),
		(_centroid select 2)
	];
	'QS_marker_grid_civState' setMarkerText (format ['%1Жодних жертв серед цивільних',(toString [32,32,32])]);
	'QS_marker_grid_civState' setMarkerColor 'ColorCIVILIAN';
	'QS_marker_grid_civState' setMarkerPos _centroidOffset;
	'QS_marker_grid_civState' setMarkerAlpha 0.75;
	'QS_marker_grid_capState' setMarkerAlpha 0.75;
	_text = 'Objectives<br/><br/>- (Додатково) Жодних жертв серед цивільних осіб.<br/>- (Обовязково) Перетворіть потрібну кількість квадратів сітки на зелені.<br/>- (Обовязково) Знищіть ворожі колодязі через які пролазить ворог.<br/>';
	{
		if (_x isEqualTo 'SITE_TUNNEL') then {
			'QS_marker_grid_rspState' setMarkerAlpha 0.75;
		};
		if (_x isEqualTo 'SITE_IG') then {
			'QS_marker_grid_IGmkr' setMarkerAlpha 0.75;
			'QS_marker_grid_IGcircle' setMarkerAlpha 0.75;
			_text = _text + '- (Додатково) Вбити або захопити командира противника.<br/>';
			_text = _text + '- (Додатково) Захопити та утримувати ворожий штаб.<br/>';
		};
		if (_x isEqualTo 'SITE_IDAP') then {
			'QS_marker_grid_IDAPloc' setMarkerAlpha 0.75;
			'QS_marker_grid_IDAPmkr' setMarkerAlpha 0.75;
			'QS_marker_grid_IDAPcircle' setMarkerAlpha 0.75;
			_text = _text + '- (Додатково) Допоможіть IDAP, очистивши поле від мін на мінних полях (UXO).<br/>';
		};
	} forEach _usedObjectives;
	_text = _text + '<br/><br/>Шукайте розвід данні в будівлях та спорудах в цьому районі, щоб знайти виходи з ворожих тунелів.<br/><br/>Входи до тунелів виглядають як колодязі з кришкою.';
	[
		'QS_TASK_GRID_0',
		TRUE,
		[
			_text,
			'Область завдання',
			'Область завдання'
		],
		_centroid,
		'CREATED',
		5,
		FALSE,
		TRUE,
		'X',
		TRUE
	] call (missionNamespace getVariable 'BIS_fnc_setTask');
	['GRID_BRIEF',['Area Of Operations','Всі цілі завершені']] remoteExec ['QS_fnc_showNotification',-2,FALSE];
	// yes do it again, the marker network propagation can be ... unstable ...
	{
		_x setMarkerAlpha 0.75;
	} forEach _aoGridMarkers;
};
