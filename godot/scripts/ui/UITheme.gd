class_name UITheme
extends RefCounted
## Shared "mobile game" look: rounded cards, chunky colorful buttons, rounded
## meter bars, and name pills. Call the static helpers from any UI script.

const BG    := Color(0.16, 0.15, 0.20)
const CARD  := Color(1, 1, 1)
const CREAM := Color(0.99, 0.97, 0.93)
const INK   := Color(0.18, 0.17, 0.24)
const MUTED := Color(0.48, 0.46, 0.55)
const CORAL := Color(0.93, 0.45, 0.32)
const TEAL  := Color(0.20, 0.66, 0.62)
const PINK  := Color(0.90, 0.36, 0.52)
const GOLD  := Color(0.90, 0.68, 0.20)
const BLUE  := Color(0.32, 0.56, 0.86)
const GREEN := Color(0.36, 0.74, 0.45)


static func chip(bg: Color, radius := 16) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.set_corner_radius_all(radius)
	return s


static func card(bg := CARD, radius := 24) -> StyleBoxFlat:
	var s := chip(bg, radius)
	s.content_margin_left = 18
	s.content_margin_right = 18
	s.content_margin_top = 14
	s.content_margin_bottom = 14
	s.shadow_color = Color(0, 0, 0, 0.28)
	s.shadow_size = 10
	s.shadow_offset = Vector2(0, 5)
	return s


static func pill(bg: Color, radius := 18) -> StyleBoxFlat:
	var s := chip(bg, radius)
	s.content_margin_left = 16
	s.content_margin_right = 16
	s.content_margin_top = 5
	s.content_margin_bottom = 5
	return s


static func _btn(bg: Color, pad: int) -> StyleBoxFlat:
	var s := chip(bg, 16)
	s.content_margin_left = 18
	s.content_margin_right = 18
	s.content_margin_top = pad
	s.content_margin_bottom = pad
	s.shadow_color = Color(0, 0, 0, 0.20)
	s.shadow_size = 5
	s.shadow_offset = Vector2(0, 3)
	return s


static func style_button(b: Button, bg := CORAL, fg := Color(1, 1, 1), font_size := 20, pad := 12) -> void:
	b.add_theme_stylebox_override("normal", _btn(bg, pad))
	b.add_theme_stylebox_override("hover", _btn(bg.lightened(0.10), pad))
	b.add_theme_stylebox_override("pressed", _btn(bg.darkened(0.10), pad))
	b.add_theme_stylebox_override("focus", _btn(bg, pad))
	b.add_theme_color_override("font_color", fg)
	b.add_theme_color_override("font_hover_color", fg)
	b.add_theme_color_override("font_pressed_color", fg)
	b.add_theme_color_override("font_focus_color", fg)
	b.add_theme_font_size_override("font_size", font_size)


static func style_progress(bar: ProgressBar, fill: Color) -> void:
	bar.add_theme_stylebox_override("background", chip(Color(0, 0, 0, 0.12), 9))
	bar.add_theme_stylebox_override("fill", chip(fill, 9))
	bar.show_percentage = false
	bar.min_value = 0
	bar.max_value = 100
