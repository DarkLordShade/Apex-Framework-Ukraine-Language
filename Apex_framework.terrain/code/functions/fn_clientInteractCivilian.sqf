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
		(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цей цивільний більше не зацікавлений спілкуватися з вами.',[],-1,TRUE,'Civilian',TRUE];
	} else {
		if ((random 1) > 0.5) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'В цього цивільного більше нема чого сказати вам.',[],-1,TRUE,'Civilian',TRUE];
		} else {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Ви гаєте час. В цього цивільного більше нема чого вам сказати.',[],-1,TRUE,'Civilian',TRUE];
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
				(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цей цивільний звузив вам коло пошуку полоненого на мапі.',[],-1,TRUE,'Civilian',TRUE];
			} else {
				_text = format ['%1 підвищив точність маркера місії на мапі',name _t];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
			};
		} else {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цивільний більше не може вам допомогти.',[],-1,TRUE,'Civilian',TRUE];
		};
	} else {
		if ((random 1) > 0.5) then {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цивільний не знає нічого корисного',[],-1,TRUE,'Civilian',TRUE];
		} else {
			if ((random 1) > 0.5) then {
				_text = format ['%1 не розмовляв шість років, чому тобі здається що він зробить виключення бля тебе?',(name _t)];
				(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
			} else {
				if ((random 1) > 0.25) then {
					(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цивільний щось тихо пробуркотів та пішов собі далі',[],-1,TRUE,'Civilian',TRUE];
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
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,10,-1,'Родина цього цивільного загинула від бомбардування NATO минулого тижня. Він не скаже нічого корисного',[],-1,TRUE,'Civilian',TRUE];
		} else {
			_text = format ['%1 не буде допомогати NATO і хоче щоб ви забрались геть з %2.',name _t,worldName];
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
		};
	} else {
		if ((random 1) > 0.5) then {
			_text = format ['%1, здається, має намір повідомити ворогу',name _t];
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,_text,[],-1,TRUE,'Civilian',TRUE];
			_t setVariable ['QS_civilian_alertingEnemy',TRUE,TRUE];
		} else {
			(missionNamespace getVariable 'QS_managed_hints') pushBack [2,TRUE,7.5,-1,'Цей цивільний буде радий бачити вас мертвим',[],-1,TRUE,'Civilian',TRUE];
		};
	};
};
true;
