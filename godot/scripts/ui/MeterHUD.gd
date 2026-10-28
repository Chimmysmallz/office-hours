extends Control
## Mobile-style HUD: a rounded card with colored meter bars, the date, a chunky
## "End time slot" button, and a bright objective banner across the top.

var _bars := {}
var _time_label: Label
var _obj_label: Label
var _task_panel: Panel
var _task_labels := []

var _meters := [
	{"key": "zara",   "name": "Zara",   "color": UITheme.PINK},
	{"key": "priya",  "name": "Priya",  "color": UITheme.CORAL},
	{"key": "rep",    "name": "Rep",    "color": UITheme.GOLD},
	{"key": "career", "name": "Career", "color": UITheme.BLUE},
	{"key": "energy", "name": "Energy", "color": UITheme.GREEN},
]


func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	# --- meter card (top-left) ---
	var card := Panel.new()
	card.add_theme_stylebox_override("panel", UITheme.card(UITheme.CREAM, 22))
	card.position = Vector2(16, 16)
	card.size = Vector2(276, 262)
	card.custom_minimum_size = Vector2(276, 262)
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(card)

	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 16
	v.offset_top = 12
	v.offset_right = -16
	v.offset_bottom = -12
	v.add_theme_constant_override("separation", 7)
	v.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(v)

	_time_label = Label.new()
	_time_label.add_theme_color_override("font_color", UITheme.INK)
	_time_label.add_theme_font_size_override("font_size", 16)
	_time_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	v.add_child(_time_label)

	for m in _meters:
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		row.mouse_filter = Control.MOUSE_FILTER_IGNORE
		v.add_child(row)

		var lbl := Label.new()
		lbl.text = m["name"]
		lbl.custom_minimum_size = Vector2(62, 0)
		lbl.add_theme_color_override("font_color", UITheme.MUTED)
		lbl.add_theme_font_size_override("font_size", 14)
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(lbl)

		var bar := ProgressBar.new()
		bar.custom_minimum_size = Vector2(158, 16)
		bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
		UITheme.style_progress(bar, m["color"])
		row.add_child(bar)
		_bars[m["key"]] = bar

	var btn := Button.new()
	btn.text = "End time slot"
	UITheme.style_button(btn, UITheme.TEAL, Color(1, 1, 1), 17, 9)
	btn.pressed.connect(func(): SceneRouter.advance_slot())
	v.add_child(btn)

	# --- objective banner (top, bright, always says what to do) ---
	var obj := Panel.new()
	obj.add_theme_stylebox_override("panel", UITheme.card(UITheme.CORAL, 20))
	obj.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	obj.offset_left = 308
	obj.offset_right = -20
	obj.offset_top = 18
	obj.offset_bottom = 70
	obj.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(obj)

	_obj_label = Label.new()
	_obj_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_obj_label.offset_left = 16
	_obj_label.offset_right = -16
	_obj_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_obj_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_obj_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_obj_label.add_theme_color_override("font_color", Color(1, 1, 1))
	_obj_label.add_theme_font_size_override("font_size", 17)
	_obj_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	obj.add_child(_obj_label)

	# --- starter task checklist (top-right; ticks off, then hides) ---
	_task_panel = Panel.new()
	_task_panel.add_theme_stylebox_override("panel", UITheme.card(UITheme.CREAM, 18))
	_task_panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	_task_panel.offset_left = -348
	_task_panel.offset_right = -20
	_task_panel.offset_top = 82
	_task_panel.offset_bottom = 300
	_task_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_task_panel)

	var tv := VBoxContainer.new()
	tv.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	tv.offset_left = 14
	tv.offset_top = 10
	tv.offset_right = -14
	tv.offset_bottom = -10
	tv.add_theme_constant_override("separation", 4)
	tv.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_task_panel.add_child(tv)

	var th := Label.new()
	th.text = "GETTING STARTED"
	th.add_theme_font_size_override("font_size", 13)
	th.add_theme_color_override("font_color", UITheme.CORAL)
	th.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tv.add_child(th)

	for i in range(6):
		var l := Label.new()
		l.add_theme_font_size_override("font_size", 14)
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		l.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tv.add_child(l)
		_task_labels.append(l)

	GameState.meter_changed.connect(func(_n, _v): _refresh())
	_refresh()


func _process(_delta: float) -> void:
	_time_label.text = "Week %d   Day %d   %s" % [GameState.week, GameState.day, GameState.slot]
	if _obj_label:
		_obj_label.text = StoryDirector.current_objective()
	_update_tasks()


func _refresh() -> void:
	_bars["zara"].value = GameState.affection["zara"]
	_bars["priya"].value = GameState.affection["priya"]
	_bars["rep"].value = GameState.reputation
	_bars["career"].value = GameState.career
	_bars["energy"].value = GameState.energy
