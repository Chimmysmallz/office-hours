extends Control
## Mobile-style dialogue: the speaking character's portrait on the left, a
## rounded card with a colored name pill, big readable text, and chunky tappable
## choice cards. Tap the card (or the continue button) to advance a line.

const PORTRAITS := {
	"Zara": "res://assets/sprites/npc-zara.png",
	"Priya": "res://assets/sprites/npc-priya.png",
}

var _speaker_color := {}          # filled in _ready (uses UITheme constants)
var _card: Panel
var _name_pill: Panel
var _name_label: Label
var _text_label: Label
var _content: VBoxContainer
var _choices: VBoxContainer
var _continue: Button
var _portrait: TextureRect
var _awaiting_choice := false


func _ready() -> void:
	_speaker_color = {"Zara": UITheme.TEAL, "Priya": UITheme.CORAL}
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build()
	visible = false
	DialogueManager.line_shown.connect(_on_line)
	DialogueManager.choices_shown.connect(_on_choices)
	DialogueManager.dialogue_ended.connect(_on_ended)


func _build() -> void:
	_portrait = TextureRect.new()
	_portrait.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	_portrait.offset_left = 26
	_portrait.offset_right = 330
	_portrait.offset_top = -520
	_portrait.offset_bottom = -8
	_portrait.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_portrait.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_portrait.visible = false
	add_child(_portrait)

	_card = Panel.new()
	_card.add_theme_stylebox_override("panel", UITheme.card(UITheme.CARD, 26))
	_card.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_card.offset_left = 24
	_card.offset_right = -24
	_card.offset_top = -338
	_card.offset_bottom = -18
	_card.mouse_filter = Control.MOUSE_FILTER_STOP
	_card.gui_input.connect(_on_card_input)
	add_child(_card)

	_name_pill = Panel.new()
	_name_pill.add_theme_stylebox_override("panel", UITheme.pill(UITheme.TEAL, 16))
	_name_pill.position = Vector2(300, -20)
	_name_pill.size = Vector2(150, 42)
	_name_pill.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_card.add_child(_name_pill)

	_name_label = Label.new()
	_name_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_name_label.add_theme_color_override("font_color", Color(1, 1, 1))
	_name_label.add_theme_font_size_override("font_size", 20)
	_name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_name_pill.add_child(_name_label)

	_content = VBoxContainer.new()
	_content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_content.offset_left = 300
	_content.offset_top = 34
	_content.offset_right = -28
	_content.offset_bottom = -22
	_content.add_theme_constant_override("separation", 10)
	_content.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_card.add_child(_content)

	_text_label = Label.new()
	_text_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text_label.custom_minimum_size = Vector2(0, 54)
	_text_label.add_theme_color_override("font_color", UITheme.INK)
	_text_label.add_theme_font_size_override("font_size", 21)
	_text_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_content.add_child(_text_label)

	_choices = VBoxContainer.new()
	_choices.add_theme_constant_override("separation", 8)
	_choices.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_content.add_child(_choices)

	_continue = Button.new()
	_continue.text = "Tap to continue"
	UITheme.style_button(_continue, UITheme.TEAL, Color(1, 1, 1), 16, 9)
	_continue.pressed.connect(_advance)
	_content.add_child(_continue)


func _set_speaker(speaker: String) -> void:
	_name_label.text = speaker
	var col: Color = _speaker_color.get(speaker, UITheme.MUTED)
	_name_pill.add_theme_stylebox_override("panel", UITheme.pill(col, 16))
	_name_pill.visible = speaker != ""
	if PORTRAITS.has(speaker):
		_portrait.texture = load(PORTRAITS[speaker]) as Texture2D
		_portrait.visible = true
		_content.offset_left = 300
	else:
		_portrait.visible = false
		_content.offset_left = 30
	_name_pill.position = Vector2(_content.offset_left, -20)


func _on_line(speaker: String, text: String) -> void:
	visible = true
	_awaiting_choice = false
	_clear_choices()
	_set_speaker(speaker)
	_text_label.text = text
	_continue.visible = true


func _on_choices(choices: Array) -> void:
	visible = true
	_awaiting_choice = true
	_clear_choices()
	_continue.visible = false
	for c in choices:
		var pc := PanelContainer.new()
		pc.add_theme_stylebox_override("panel", UITheme.card(UITheme.CREAM, 16))
		pc.mouse_filter = Control.MOUSE_FILTER_STOP
		pc.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		pc.gui_input.connect(_on_choice_input.bind(c))
		pc.mouse_entered.connect(_hover.bind(pc, true))
		pc.mouse_exited.connect(_hover.bind(pc, false))

		var lbl := Label.new()
		lbl.text = c["text"]
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbl.add_theme_color_override("font_color", UITheme.INK)
		lbl.add_theme_font_size_override("font_size", 17)
		lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pc.add_child(lbl)
		_choices.add_child(pc)


func _hover(pc: PanelContainer, on: bool) -> void:
	var c := Color(0.95, 0.91, 0.83) if on else UITheme.CREAM
	pc.add_theme_stylebox_override("panel", UITheme.card(c, 16))


func _on_choice_input(event: InputEvent, choice: Dictionary) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_pick(choice)


func _pick(choice: Dictionary) -> void:
	_awaiting_choice = false
	_clear_choices()
	DialogueManager.choose(choice)


func _on_ended() -> void:
	visible = false
	_clear_choices()


func _clear_choices() -> void:
	for c in _choices.get_children():
		c.queue_free()


func _advance() -> void:
	if _awaiting_choice:
		return
	DialogueManager.advance()


func _on_card_input(event: InputEvent) -> void:
	if _awaiting_choice:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		DialogueManager.advance()
