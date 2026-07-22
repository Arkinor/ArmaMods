/*
	Патч knd_jetpacks: onTimerScript с _unit ломает dedicated (Undefined variable _unit).
	Включается в config.cpp — отдельный CfgPatches не нужен (knd_jetpacks уже в requiredAddons Main).
	Имена классов в config case-insensitive — без дублей вроде KND_gravityThrust / knd_gravityThrust.
*/
class CfgCloudlets
{
	class Default;

	class KND_JetpackThrust: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
	class knd_jetpack_thrust: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
	class KND_JetpackHover: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
	class knd_jetpack_hover: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
	class KND_JetpackGravity: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
	class knd_jetpack_gravity: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
	class knd_gravityThrust: Default { interval = 1e+010; lifeTime = 0; onTimerScript = ""; beforeDestroyScript = ""; };
};
