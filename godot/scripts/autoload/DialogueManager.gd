extends Node
## Autoload: DialogueManager — reads dialogue graphs from JSON and steps through them.
## The engine never knows what the story says; it just walks the node graph.

signal line_shown(speaker: String, text: String)
signal choices_shown(choices: Array)
signal dialogue_ended()

var _scenes := {}
var _current_scene := {}
var _current_node := ""


func _ready() -> void:
	_load_all("res://data/story/")


func _load_all(dir_path: String) -> void:
	var dir := DirAccess.open(dir_path)
	if dir == null:
		push_warning("No story folder at %s" % dir_path)
		return
	for file in dir.get_files():
		if file.ends_with(".json"):
			var text := FileAccess.get_file_as_string(dir_path + file)
			var parsed = JSON.parse_string(text)
			if typeof(parsed) == TYPE_DICTIONARY:
				_scenes.merge(parsed, true)   # each top-level key = one scene id


func start(scene_id: String) -> void:
	if not _scenes.has(scene_id):
		push_warning("Unknown dialogue scene: %s" % scene_id)
		return
	_current_scene = _scenes[scene_id]
	_go_to(_current_scene.get("start", ""))


func _go_to(node_id: String) -> void:
	_current_node = node_id
	var node: Dictionary = _resolve_variants(_current_scene["nodes"][node_id])

	if node.get("terminal", false):
		dialogue_ended.emit()
		return

	if node.has("effects"):
		GameState.apply_effects(node["effects"])

	if node.has("choices"):
		# Hide choices whose flag requirement isn't met.
		var visible: Array = []
		for c in node["choices"]:
			if not c.has("requires_flag") or GameState.has_flag(c["requires_flag"]):
				visible.append(c)
		choices_shown.emit(visible)
	else:
		line_shown.emit(node.get("speaker", ""), node.get("text", ""))


## Called by the UI when the player clicks to continue a line.
func advance() -> void:
	var node: Dictionary = _current_scene["nodes"][_current_node]
	if node.has("next"):
		_go_to(node["next"])


## Called by the UI when the player picks a choice.
func choose(choice: Dictionary) -> void:
	if choice.has("effects"):
		GameState.apply_effects(choice["effects"])
	_go_to(choice["next"])


## MEMORY: if a node has "variants", pick the first whose condition holds and
## merge it over the base node. This lets a scene rewrite its own lines (or even
## branch differently) based on flags set by earlier choices. A variant with no
## "if" acts as the default fallback.
func _resolve_variants(node: Dictionary) -> Dictionary:
	if not node.has("variants"):
		return node
	for v in node["variants"]:
		if _cond_ok(v.get("if", "")):
			var merged := node.duplicate()
			merged.erase("variants")
			for k in v:
				if k != "if":
					merged[k] = v[k]
			return merged
	return node


## Condition: "" = always true; "flag" = that flag is set; "!flag" = NOT set;
## an array = every condition must hold.
func _cond_ok(cond) -> bool:
	if typeof(cond) == TYPE_STRING and cond == "":
		return true
	var tokens: Array = cond if typeof(cond) == TYPE_ARRAY else [cond]
	for t in tokens:
		var s := String(t)
		if s.begins_with("!"):
			if GameState.has_flag(s.substr(1)):
				return false
		elif not GameState.has_flag(s):
			return false
	return true
