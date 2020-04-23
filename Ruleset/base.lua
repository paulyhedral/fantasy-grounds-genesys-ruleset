--
-- Please see the license.html file included with this distribution for
-- attribution and copyright information.
--

new_basicskilldata = {
	["Alchemy (Int)"] = {
			characteristic = "IN",
			description = "<p>T</p>"
		},
	["Astrocartography (Int)"] = {
			characteristic = "IN",
			description = "<p>T</p>"
		},
	["Athletics (Br)"] = {
			characteristic = "BR"
		},
	["Charm (Pr)"] = {
			characteristic = "PR"
		},
	["Coercion (Will)"] = {
			characteristic = "WI"
		},
	["Computers (Int)"] = {
			characteristic = "IN"
		},
	["Cool (Pr)"] = {
			characteristic = "PR"
		},
	["Coordination (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>"
		},
	["Deception (Cun)"] = {
			characteristic = "CU",
			description = "<p></p>"
		},
	["Discipline (Will)"] = {
			characteristic = "WI",
			description = "<p></p>"
		},
	["Driving (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>"
		},
	["Leadership (Pr)"] = {
			characteristic = "PR",
			description = "<p></p>"
		},
	["Mechanics (Int)"] = {
			characteristic = "IN",
			description = "<p></p>"
		},
	["Medicine (Int)"] = {
			characteristic = "IN",
			description = "<p></p>"
		},
	["Negotiation (Pr)"] = {
			characteristic = "PR",
			description = "<p></p>"
		},
	["Operating (Int)"] = {
			characteristic = "IN",
			description = "<p></p>"
		},
	["Perception (Cun)"] = {
			characteristic = "CU",
			description = "<p></p>"
		},
	["Piloting (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>"
		},
	["Resilience (Br)"] = {
			characteristic = "BR",
			description = "<p></p>"
		},
	["Riding (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>"
		},
	["Skulduggery (Cun)"] = {
			characteristic = "CU",
			description = "<p></p>"
		},
	["Stealth (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>"
		},
	["Streetwise (Cun)"] = {
			characteristic = "CU",
			description = "<p></p>"
		},
	["Survival (Cun)"] = {
			characteristic = "CU",
			description = "<p></p>"
		},
	["Vigilance (Will)"] = {
			characteristic = "WI",
			description = "<p></p>"
		},
	["Arcana (Int)"] = {
			characteristic = "IN",
			description = "<p></p>"
		},
	["Divine (Will)"] = {
			characteristic = "WI",
			description = "<p></p>"
		},
	["Primal (Cun)"] = {
			characteristic = "CU",
			description = "<p></p>"
		}
};

new_knowledgeskilldata = {
	["Knowledge (Int)"] = {
			characteristic = "IN",
			description = "<p>Knowledge of the culture, planets and systems of the Core Worlds.</p>",
			knowledge = 1,
		}
};

new_combatskilldata = {
	["Brawl (Br)"] = {
			characteristic = "BR",
			description = "<p></p>",
			advanced = 1,
		},
	["Gunnery (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>",
			advanced = 1,
		},
	["Melee (Br)"] = {
			characteristic = "BR",
			description = "<p></p>",
			advanced = 1,
		},
	["Melee-Heavy (Br)"] = {
			characteristic = "BR",
			description = "<p></p>",
			advanced = 1,
		},
	["Melee-Light (Br)"] = {
			characteristic = "BR",
			description = "<p></p>",
			advanced = 1,
		},
	["Ranged (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>",
			advanced = 1,
		},
	["Ranged-Heavy (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>",
			advanced = 1,
		},
	["Ranged-Light (Ag)"] = {
			characteristic = "AG",
			description = "<p></p>",
			advanced = 1,
		}
};

function onInit()

	-- show the splash screen
	--Interface.openWindow("splash", "");

	DataCommon.basicskilldata = new_basicskilldata;
	DataCommon.knowledgeskilldata = new_knowledgeskilldata;
	DataCommon.combatskilldata = new_combatskilldata;

end
