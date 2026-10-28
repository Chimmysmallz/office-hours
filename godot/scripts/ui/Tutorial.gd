extends CanvasLayer
## A one-time "quick tips" card the first time you enter the office. Uses a
## GameState flag so it never shows again (even when the room reloads each day).

func _ready() -> void:
	layer = 8
	if GameState.has_flag("tutorial_shown"):
		queue_free()
		return
	GameState.set_flag("tutorial_shown")
	_build()


func _build() -> void:
	var dim := ColorRect.new()
	dim.color = Color(0.06, 0.05, 0.10, 0.62)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)

	var card := Panel.new()
	card.add_theme_stylebox_override("panel", UITheme.card(UITheme.CARD, 26))
	card.custom_minimum_size = Vector2(720, 330)
	center.add_child(card)

	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 30
	v.offset_top = 26
	v.offset_right = -30
	v.offset_bottom = -26
	v.add_theme_constant_override("separation", 14)
	card.add_child(v)

	var h := Label.new()
	h.text = "Welcome to the ninth floor"
	h.add_theme_font_size_override("font_size", 30)
	h.add_theme_color_override("font_color", UITheme.CORAL)
	h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(h)

	var body := Label.new()
	body.text = "Tap a person to walk over and talk - start with Zara or Priya (and keep an eye out for the faded figure in the corner).\n\nThe checklist on the right gives you your first tasks. The banner above it always tells you your next move. Tap Coffee, the Desk, or the Stereo to spend a moment and shift your stats.\n\nHave fun - there are no wrong answers."
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 20)
	body.add_theme_color_override("font_color", UITheme.INK)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(body)

	var b := Button.new()
	b.text = "Got it!"
	UITheme.style_button(b, UITheme.CORAL, Color(1, 1, 1), 20, 12)
	b.pressed.connect(_dismiss)
	v.add_child(b)


func _dismiss() -> void:
	queue_free()
