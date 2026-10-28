extends Node
## Autoload: StoryDirector — sequences each character's route in order.
## Talking to an NPC plays the next unplayed scene in their arc; once the arc is
## complete it plays the ending chosen by how you played. Multi-track: add a new
## love interest by writing their scene array + ending picker and a _track entry.

var _current_id := ""
var _current_track := ""

# --- ZARA (warm route) ---
var ZARA := [
	{"id": "a1_arrival",         "week": 1,  "needs": [],                           "sets": "a1_1"},
	{"id": "a1_tour",            "week": 1,  "needs": ["a1_1"],                     "sets": "a1_2"},
	{"id": "a1_task",            "week": 1,  "needs": ["a1_2"],                     "sets": "a1_3"},
	{"id": "a1_coffee",          "week": 1,  "needs": ["a1_3"],                     "sets": "a1_4"},
	{"id": "a1_priya",           "week": 2,  "needs": ["a1_4"],                     "sets": "a1_5"},
	{"id": "a1_latenight",       "week": 2,  "needs": ["a1_5"],                     "sets": "a1_6"},
	{"id": "a1_lobby",           "week": 2,  "needs": ["a1_6"],                     "sets": "a1_7"},
	{"id": "a1_marcus",          "week": 3,  "needs": ["a1_7"],                     "sets": "a1_8"},
	{"id": "a1_rooftop",         "week": 3,  "needs": ["a1_8"],                     "sets": "a1_9"},
	{"id": "a1_afterwork",       "week": 3,  "needs": ["a1_9"],                     "sets": "a1_10"},
	{"id": "a1_monday",          "week": 4,  "needs": ["a1_10"],                    "sets": "a1_done"},

	{"id": "a2_allhands",        "week": 4,  "needs": ["a1_done"],                  "sets": "a2_1"},
	{"id": "a2_aftermath",       "week": 4,  "needs": ["a2_1"],                     "sets": "a2_2"},
	{"id": "a2_priya",           "week": 4,  "needs": ["a2_2"],                     "sets": "a2_3"},
	{"id": "a2_distance",        "week": 5,  "needs": ["a2_3"],                     "sets": "a2_4"},
	{"id": "a2_reach",           "week": 5,  "needs": ["a2_4"],                     "sets": "a2_5"},
	{"id": "a2_vaughn",          "week": 6,  "needs": ["a2_5"],                     "sets": "a2_6"},
	{"id": "a2_fallout_cover",   "week": 6,  "needs": ["a2_6", "zara_integrity"],   "sets": "a2_7"},
	{"id": "a2_fallout_deal",    "week": 6,  "needs": ["a2_6", "took_vaughn_deal"], "sets": "a2_7"},
	{"id": "a2_fallout_neutral", "week": 6,  "needs": ["a2_6"],                     "sets": "a2_7"},
	{"id": "a2_honest",          "week": 7,  "needs": ["a2_7"],                     "sets": "a2_8"},
	{"id": "a2_breather",        "week": 7,  "needs": ["a2_8"],                     "sets": "a2_9"},
	{"id": "a2_trip",            "week": 8,  "needs": ["a2_9"],                     "sets": "a2_10"},
	{"id": "a2_balcony",         "week": 8,  "needs": ["a2_10"],                    "sets": "a2_done"},

	{"id": "a3_looms",           "week": 9,  "needs": ["a2_done"],                  "sets": "a3_1"},
	{"id": "a3_priya_final",     "week": 9,  "needs": ["a3_1"],                     "sets": "a3_2"},
	{"id": "a3_offer",           "week": 10, "needs": ["a3_2"],                     "sets": "a3_3"},
	{"id": "a3_reaction_coleads","week": 10, "needs": ["a3_3", "co_leads"],         "sets": "a3_4"},
	{"id": "a3_reaction_took",   "week": 10, "needs": ["a3_3", "took_lead"],        "sets": "a3_4"},
	{"id": "a3_reaction_aside",  "week": 10, "needs": ["a3_3", "stepped_aside"],    "sets": "a3_4"},
	{"id": "a3_marcus_final",    "week": 10, "needs": ["a3_4"],                     "sets": "a3_5"},
	{"id": "a3_before",          "week": 11, "needs": ["a3_5"],                     "sets": "a3_6"},
	{"id": "a3_prep",            "week": 11, "needs": ["a3_6"],                     "sets": "z11"},
]

# --- PRIYA (enemies-to-lovers route). p_a2_fallout and p_a3_react use in-scene
#     "variants" to rewrite their lines based on your earlier fork choice. ---
var PRIYA := [
	{"id": "p_a1_clash",    "week": 1,  "needs": [],        "sets": "p1"},
	{"id": "p_a1_test",     "week": 2,  "needs": ["p1"],    "sets": "p2"},
	{"id": "p_a1_crack",    "week": 3,  "needs": ["p2"],    "sets": "p3"},
	{"id": "p_a2_announce", "week": 4,  "needs": ["p3"],    "sets": "p4"},
	{"id": "p_a2_fork",     "week": 6,  "needs": ["p4"],    "sets": "p5"},
	{"id": "p_a2_fallout",  "week": 6,  "needs": ["p5"],    "sets": "p6"},
	{"id": "p_a2_wall",     "week": 7,  "needs": ["p6"],    "sets": "p7"},
	{"id": "p_a2_night",    "week": 8,  "needs": ["p7"],    "sets": "p8"},
	{"id": "p_a3_looms",    "week": 9,  "needs": ["p8"],    "sets": "p9"},
	{"id": "p_a3_offer",    "week": 10, "needs": ["p9"],    "sets": "p10"},
	{"id": "p_a3_react",    "week": 10, "needs": ["p10"],   "sets": "p11"},
	{"id": "p_a3_before",   "week": 11, "needs": ["p11"],   "sets": "p_final"},
]

# --- NOAH (hidden slow-burn). Unlocks by noticing him. n_a2_fallout and
#     n_a3_react rewrite their lines from your earlier choice. ---
var NOAH := [
	{"id": "n_a1_notice",     "week": 1,  "needs": [],            "sets": "noah_s1"},
	{"id": "n_a1_data",       "week": 2,  "needs": ["noah_s1"],   "sets": "noah_s2"},
	{"id": "n_a1_lunch",      "week": 3,  "needs": ["noah_s2"],   "sets": "noah_s3"},
	{"id": "n_a2_overlooked", "week": 4,  "needs": ["noah_s3"],   "sets": "noah_s4"},
	{"id": "n_a2_open",       "week": 5,  "needs": ["noah_s4"],   "sets": "noah_s5"},
	{"id": "n_a2_fallout",    "week": 6,  "needs": ["noah_s5"],   "sets": "noah_s6"},
	{"id": "n_a2_confide",    "week": 7,  "needs": ["noah_s6"],   "sets": "noah_s7"},
	{"id": "n_a2_rain",       "week": 8,  "needs": ["noah_s7"],   "sets": "noah_s8"},
	{"id": "n_a3_choice",     "week": 10, "needs": ["noah_s8"],   "sets": "noah_s9"},
	{"id": "n_a3_react",      "week": 10, "needs": ["noah_s9"],   "sets": "noah_s10"},
	{"id": "n_a3_before",     "week": 11, "needs": ["noah_s10"],  "sets": "noah_final"},
]


func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _track(track: String) -> Dictionary:
	match track:
		"zara":  return {"scenes": ZARA,  "gate": "z11",     "finished": "zara_finished",  "filler": "zara_filler",  "after": "zara_after"}
		"priya": return {"scenes": PRIYA, "gate": "p_final", "finished": "priya_finished", "filler": "priya_filler", "after": "priya_after"}
		"noah":  return {"scenes": NOAH,  "gate": "noah_final", "finished": "noah_finished", "filler": "noah_filler", "after": "noah_after"}
	return {}


func talk(track: String) -> void:
	var cfg := _track(track)
	if cfg.is_empty():
		return
	if GameState.has_flag(cfg["finished"]):
		_current_track = track
		_current_id = cfg["after"]
		DialogueManager.start(cfg["after"])
		return
	# Arc complete → play the ending picked from meters + choices.
	if GameState.has_flag(cfg["gate"]):
		var ending := ""
		match track:
			"zara":  ending = _pick_ending_zara()
			"priya": ending = _pick_ending_priya()
			"noah":  ending = _pick_ending_noah()
		_current_track = track
		_current_id = ending
		GameState.week = 12
		DialogueManager.start(ending)
		return
	var s := _next_scene(cfg["scenes"])
	if s.is_empty():
		_current_track = track
		_current_id = ""
		DialogueManager.start(cfg["filler"])
		return
	_current_track = track
	_current_id = s["id"]
	GameState.week = s["week"]
	DialogueManager.start(s["id"])


func _next_scene(scenes: Array) -> Dictionary:
	for s in scenes:
		if GameState.has_flag(s["sets"]):
			continue
		var ok := true
		for f in s["needs"]:
			if not GameState.has_flag(f):
				ok = false
				break
		if ok:
			return s
	return {}


func _on_dialogue_ended() -> void:
	if _current_id == "":
		return
	if _current_id.begins_with("zara_end"):
		GameState.set_flag("zara_finished")
	elif _current_id.begins_with("priya_end"):
		GameState.set_flag("priya_finished")
	elif _current_id.begins_with("noah_end"):
		GameState.set_flag("noah_finished")
	else:
		var cfg := _track(_current_track)
		if not cfg.is_empty():
			for s in cfg["scenes"]:
				if s["id"] == _current_id:
					GameState.set_flag(s["sets"])
					break
	_current_id = ""
	_current_track = ""


func _pick_ending_zara() -> String:
	var a: int = GameState.affection["zara"]
	var wall: bool = GameState.has_flag("zara_wall_revealed")
	var integrity: bool = GameState.has_flag("zara_integrity")
	if a >= 70 and wall and integrity:
		return "zara_end_both"
	if a >= 55 and wall:
		return "zara_end_longway"
	if GameState.career >= 60 and a < 55:
		return "zara_end_corner"
	return "zara_end_colleagues"


func _pick_ending_priya() -> String:
	var a: int = GameState.affection["priya"]
	var wall: bool = GameState.has_flag("priya_wall")
	var respect: bool = GameState.has_flag("priya_respect")
	if a >= 70 and wall and respect:
		return "priya_end_partners"
	if a >= 55 and wall:
		return "priya_end_spark"
	if respect and a < 55:
		return "priya_end_rivals"
	return "priya_end_burned"


func _pick_ending_noah() -> String:
	var a: int = GameState.affection["noah"]
	var wall: bool = GameState.has_flag("noah_wall")
	var bond: bool = GameState.has_flag("noah_bond")
	if a >= 70 and wall and bond:
		return "noah_end_seen"
	if a >= 55 and wall:
		return "noah_end_quiet"
	if a >= 35:
		return "noah_end_friends"
	return "noah_end_faded"


## Starter tasks shown as a checklist so a new player always knows what to try.
func onboarding_tasks() -> Array:
	return [
		{"text": "Tap Zara to say hello", "done": GameState.has_flag("a1_1")},
		{"text": "Meet Priya, your rival", "done": GameState.has_flag("p1")},
		{"text": "Grab a Coffee (Energy)", "done": GameState.has_flag("used_coffee")},
		{"text": "Do work at the Desk (Career)", "done": GameState.has_flag("used_desk")},
		{"text": "Try the Stereo - a Dance-off", "done": GameState.has_flag("danced")},
		{"text": "Notice the faded one in the corner", "done": GameState.has_flag("noticed_noah")},
	]


func onboarding_complete() -> bool:
	for t in onboarding_tasks():
		if not t["done"]:
			return false
	return true


## Returns a short "what to do next" hint shown in the HUD objective banner.
func current_objective() -> String:
	if GameState.energy < 25:
		return "Low energy - visit the Coffee machine to recharge."
	if _in_progress("zara"):
		return "Continue Zara's story - go talk to Zara."
	if _in_progress("priya"):
		return "Continue Priya's story - go talk to Priya."
	var z_done: bool = GameState.has_flag("zara_finished")
	var p_done: bool = GameState.has_flag("priya_finished")
	if not z_done and not p_done:
		return "Walk up to Zara or Priya and talk to begin a story."
	if z_done and not p_done:
		return "Zara's route done! Talk to Priya, or hit the Stereo for a dance-off."
	if p_done and not z_done:
		return "Priya's route done! Talk to Zara, or hit the Stereo for a dance-off."
	return "Both routes done! Replay from the title, or dance at the Stereo."


func _in_progress(track: String) -> bool:
	var cfg := _track(track)
	if cfg.is_empty():
		return false
	if GameState.has_flag(cfg["finished"]):
		return false
	for s in cfg["scenes"]:
		if GameState.has_flag(s["sets"]):
			return true
	return false
