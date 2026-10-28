extends CanvasLayer
## A "dance-off" mini-game with a mobile look. Watch the sequence of moves light
## up, then tap them back in order. Each round adds a move; clear 5 rounds to win.
## Emits finished(score) - the caller turns score into a reward. Touch-friendly.

signal finished(score)

const LABELS := ["<", "^", "v", ">"]
var BASE := [Color(0.86, 0.38, 0.4), Color(0.38, 0.66, 0.9), Color(0.5, 0.82, 0.5), Color(0.92, 0.78, 0.36)]
const MAX_ROUNDS := 5

var _seq: Array = []
var _pos := 0
var _round := 0
var _score := 0
var _accepting := false
var _buttons: Array = []
var _status: Label


func _ready() -> void:
	layer = 10
	_build_ui()
	_start()


func _build_ui() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.09, 0.09, 0.13, 0.85)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var card := Panel.new()
	card.add_theme_stylebox_override("panel", UITheme.card(UITheme.CREAM, 28))
	card.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	card.offset_left = -360
	card.offset_right = 360
	card.offset_top = -220
	card.offset_bottom = 220
	dim.add_child(card)

	var title := Label.new()
	title.text = "DANCE-OFF"
	title.add_theme_font_size_override("font_size", 40)
	title.add_theme_color_override("font_color", UITheme.CORAL)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 26
	card.add_child(title)

	_status = Label.new()
	_status.add_theme_font_size_override("font_size", 22)
	_status.add_theme_color_override("font_color", UITheme.INK)
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_status.offset_top = 88
	card.add_child(_status)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	center.offset_top = 40
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(center)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 20)
	center.add_child(row)
	for i in range(4):
		var b := Button.new()
		b.text = LABELS[i]
		b.add_theme_font_size_override("font_size", 50)
		b.add_theme_color_override("font_color", UITheme.INK)
		b.custom_minimum_size = Vector2(120, 120)
		b.add_theme_stylebox_override("normal", UITheme.chip(Color(1, 1, 1), 24))
		b.add_theme_stylebox_override("hover", UITheme.chip(Color(1, 1, 1), 24))
		b.add_theme_stylebox_override("pressed", UITheme.chip(Color(0.9, 0.9, 0.9), 24))
		b.add_theme_stylebox_override("focus", UITheme.chip(Color(1, 1, 1), 24))
		b.modulate = BASE[i]
		b.pressed.connect(_on_press.bind(i))
		row.add_child(b)
		_buttons.append(b)

	var leave := Button.new()
	leave.text = "Leave the dance floor"
	UITheme.style_button(leave, UITheme.CORAL, Color(1, 1, 1), 17, 10)
	leave.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	leave.offset_left = 120
	leave.offset_right = -120
	leave.offset_top = -74
	leave.offset_bottom = -26
	leave.pressed.connect(_finish)
	card.add_child(leave)


func _start() -> void:
	_seq.clear()
	_round = 0
	_score = 0
	_next_round()


func _next_round() -> void:
	_round += 1
	if _round > MAX_ROUNDS:
		_status.text = "You crushed it!   Score: %d" % _score
		await get_tree().create_timer(1.0).timeout
		_finish()
		return
	_reset_colors()
	_seq.append(randi() % 4)
	_pos = 0
	_accepting = false
	_status.text = "Round %d - watch..." % _round
	await _show_sequence()
	_accepting = true
	_status.text = "Your turn!"


func _show_sequence() -> void:
	await get_tree().create_timer(0.55).timeout
	for m in _seq:
		_buttons[m].modulate = Color(1, 1, 1)
		await get_tree().create_timer(0.42).timeout
		_buttons[m].modulate = BASE[m]
		await get_tree().create_timer(0.16).timeout


func _on_press(i: int) -> void:
	if not _accepting:
		return
	if i == _seq[_pos]:
		_buttons[i].modulate = Color(0.55, 1.0, 0.55)
		_pos += 1
		if _pos >= _seq.size():
			_score += _round
			_accepting = false
			_status.text = "Nice!   +%d" % _round
			await get_tree().create_timer(0.6).timeout
			_next_round()
	else:
		_buttons[i].modulate = Color(1.0, 0.3, 0.3)
		_accepting = false
		_status.text = "Missed!   Score: %d" % _score
		await get_tree().create_timer(1.1).timeout
		_finish()


func _reset_colors() -> void:
	for i in range(_buttons.size()):
		_buttons[i].modulate = BASE[i]


func _finish() -> void:
	finished.emit(_score)
	queue_free()
