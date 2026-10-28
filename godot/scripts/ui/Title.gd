extends Control
## Home screen + intro + how-to-play. This is the game's starting scene; it hands
## off to the office (Main.tscn) once the player has read the intro.

const INTRO := [
	"It's your first day at Meridian.",
	"The whole company is racing toward Project Lighthouse - its biggest launch of the year. Twelve weeks. One make-or-break quarter. And you're the newest face on the ninth floor.",
	"You'll meet the people who define it: a warm desk neighbour, a razor-sharp rival, and someone quiet enough that most people walk right past them. One of them might become more than a colleague.",
	"Every choice shifts your reputation, your career, and your heart. There are no wrong answers - only your story. Ready?",
]

var _content: Control
var _page := 0


func _ready() -> void:
	var bg := TextureRect.new()
	bg.texture = load("res://assets/sprites/office-background.png") as Texture2D
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	var scrim := ColorRect.new()
	scrim.color = Color(0.06, 0.05, 0.10, 0.62)
	scrim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	scrim.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(scrim)

	_content = Control.new()
	_content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_content)
	_show_menu()


func _clear() -> void:
	for c in _content.get_children():
		c.queue_free()


func _center() -> CenterContainer:
	var c := CenterContainer.new()
	c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_content.add_child(c)
	return c


func _card(w: int, h: int, parent: CenterContainer) -> VBoxContainer:
	var card := Panel.new()
	card.add_theme_stylebox_override("panel", UITheme.card(UITheme.CARD, 26))
	card.custom_minimum_size = Vector2(w, h)
	parent.add_child(card)
	var v := VBoxContainer.new()
	v.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	v.offset_left = 30
	v.offset_top = 26
	v.offset_right = -30
	v.offset_bottom = -26
	v.add_theme_constant_override("separation", 16)
	card.add_child(v)
	return v


func _show_menu() -> void:
	_clear()
	var box := VBoxContainer.new()
	box.custom_minimum_size = Vector2(380, 0)
	box.add_theme_constant_override("separation", 14)
	_center().add_child(box)

	var t := Label.new()
	t.text = "Office Hours"
	t.add_theme_font_size_override("font_size", 66)
	t.add_theme_color_override("font_color", Color(1, 1, 1))
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(t)

	var s := Label.new()
	s.text = "A workplace romance"
	s.add_theme_font_size_override("font_size", 22)
	s.add_theme_color_override("font_color", Color(1, 1, 1, 0.85))
	s.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	box.add_child(s)

	var gap := Control.new()
	gap.custom_minimum_size = Vector2(0, 24)
	box.add_child(gap)

	var b1 := Button.new()
	b1.text = "New Game"
	UITheme.style_button(b1, UITheme.CORAL, Color(1, 1, 1), 24, 14)
	b1.pressed.connect(_start_intro)
	box.add_child(b1)

	var b2 := Button.new()
	b2.text = "How to Play"
	UITheme.style_button(b2, UITheme.TEAL, Color(1, 1, 1), 20, 12)
	b2.pressed.connect(_show_help)
	box.add_child(b2)


func _start_intro() -> void:
	_page = 0
	_show_intro()


func _show_intro() -> void:
	_clear()
	var v := _card(760, 320, _center())
	var txt := Label.new()
	txt.text = INTRO[_page]
	txt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	txt.add_theme_font_size_override("font_size", 23)
	txt.add_theme_color_override("font_color", UITheme.INK)
	txt.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	txt.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(txt)

	var last := _page >= INTRO.size() - 1
	var b := Button.new()
	b.text = "Step into the office" if last else "Continue"
	UITheme.style_button(b, UITheme.CORAL if last else UITheme.TEAL, Color(1, 1, 1), 20, 12)
	b.pressed.connect(_intro_next)
	v.add_child(b)


func _intro_next() -> void:
	_page += 1
	if _page >= INTRO.size():
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
	else:
		_show_intro()


func _show_help() -> void:
	_clear()
	var v := _card(820, 440, _center())
	var h := Label.new()
	h.text = "How to Play"
	h.add_theme_font_size_override("font_size", 34)
	h.add_theme_color_override("font_color", UITheme.CORAL)
	h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	v.add_child(h)

	var body := Label.new()
	body.text = "- Walk up to a person and tap them to talk: Zara, Priya, or the quiet one faded in the corner.\n- Your dialogue choices change how they feel about you, plus your Reputation and Career.\n- Tap the Coffee to recharge Energy, the Desk to build Career, and the Stereo for a Dance-off.\n- The checklist and banner at the top always tell you what to do next.\n- Play through the 12-week quarter to reach one of each person's endings.\n- Tip: someone on this floor is easy to overlook. Notice them."
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_theme_font_size_override("font_size", 19)
	body.add_theme_color_override("font_color", UITheme.INK)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(body)

	var b := Button.new()
	b.text = "Back"
	UITheme.style_button(b, UITheme.TEAL, Color(1, 1, 1), 20, 12)
	b.pressed.connect(_show_menu)
	v.add_child(b)
