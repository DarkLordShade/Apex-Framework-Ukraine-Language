/*/
File: fn_clientInteractCivilian.sqf
Author:

	Quiksilver

Last Modified:

	13/06/2018 ArmA 3 1.82

Description:

	-
________________________________________________/*/

_t = cursorTarget;
private _c = FALSE;
if (isNull (objectParent _t)) then {
	if ((side _t) isEqualTo CIVILIAN) then {
		if (alive _t) then {
			if (!isNil {_t getVariable 'QS_civilian_interactable'}) then {
				if (_t getVariable 'QS_civilian_interactable') then {
					_c = TRUE;
				};
			};
		};
	};
};
if (!(_c)) exitWith {false;};
private _text = '';
_QS_interacted = _t getVariable 'QS_civilian_interacted';
if (_QS_interacted) exitWith {
	if ((random 1) > 0.5) then {
		(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цей цивiльний бiльше не зацiкавлений спiлкуватися з вами.',[],-1,TRUE,'Civilian',TRUE];
	} else {
		if ((random 1) > 0.5) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'В цього цивiльного бiльше нема чого сказати вам.',[],-1,TRUE,'Civilian',TRUE];
		} else {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Ви гаєте час. В цього цивiльного бiльше нема чого вам сказати.',[],-1,TRUE,'Civilian',TRUE];
		};
	};
};
_QS_responseNeutrality = _t getVariable 'QS_civilian_neutrality';
if (_QS_responseNeutrality isEqualTo 0) then {
	_t setVariable ['QS_civilian_interacted',TRUE,TRUE];
	if ((random 1) > 0.40) then {
		if ((missionNamespace getVariable 'QS_sideMission_POW_civIntel_quality') < 3) then {
			missionNamespace setVariable ['QS_sideMission_POW_civIntel_quality',((missionNamespace getVariable 'QS_sideMission_POW_civIntel_quality') + 1),TRUE];
			if ((random 1) > 0.5) then {
				(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цей цивiльний звузив вам коло пошуку полоненого на мапi.',[],-1,TRUE,'Civilian',TRUE];
			} else {
				_text = format ['%1 пiдвищив точнiсть маркера мiсiї на мапi',name _t];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
			};
		} else {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цивiльний бiльше не може вам допомогти.',[],-1,TRUE,'Civilian',TRUE];
		};
	} else {
		if ((random 1) > 0.5) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цивiльний не знає нiчого корисного',[],-1,TRUE,'Civilian',TRUE];
		} else {
			if ((random 1) > 0.5) then {
				_text = format ['%1 не розмовляв шiсть рокiв, чому тобi здається що вiн зробить виключення бля тебе?',(name _t)];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
			} else {
				if ((random 1) > 0.25) then {
					(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цивiльний щось тихо пробуркотiв та пiшов собi далi',[],-1,TRUE,'Civilian',TRUE];
				} else {
					_t setVariable ['QS_civilian_suicideBomber',TRUE,TRUE];
				};
			};
		};
	};

};
if (_QS_responseNeutrality isEqualTo -1) then {
	_t setVariable ['QS_civilian_interacted',TRUE,TRUE];
	if ((random 1) > 0.25) then {
		if ((random 1) > 0.5) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,10,-1,'Родина цього цивiльного загинула вiд бомбардування NATO минулого тижня. Вiн не скаже нiчого корисного',[],-1,TRUE,'Civilian',TRUE];
		} else {
			_text = format ['%1 не буде допомогати NATO i хоче щоб ви забрались геть з %2.',name _t,worldName];
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
		};
	} else {
		if ((random 1) > 0.5) then {
			_text = format ['%1, здається, має намiр повiдомити ворогу',name _t];
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
			_t setVariable ['QS_civilian_alertingEnemy',TRUE,TRUE];
		} else {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цей цивiльний буде радий бачити вас мертвим',[],-1,TRUE,'Civilian',TRUE];
		};
	};
};
true;
