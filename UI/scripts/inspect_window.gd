extends CanvasLayer

@onready var label_4: Label = %Label4

@onready var description: Label = %description
@onready var object_name: Label = %object_name
@onready var texture_rect: TextureRect = %TextureRect

@onready var quality_window: Panel = $inspect_window_/quality_window

@onready var quality_bar: ProgressBar = $inspect_window_/quality_window/Control/Panel4/VBoxContainer/quality_bar
@onready var quality_label: Label = $inspect_window_/quality_window/Control/Panel4/VBoxContainer/quality_bar/quality_label

@onready var fill_bar = StyleBoxFlat.new()

var current_node: Node

var col_dic: Dictionary = {
	Debug = Color.DARK_GRAY,
	Vile = Color.GOLDENROD,
	Trash = Color.DARK_OLIVE_GREEN,
	Meh = Color.LIGHT_BLUE,
	Mid = Color.CHARTREUSE,
	Nice = Color.DEEP_SKY_BLUE,
	Esquicite = Color.WEB_PURPLE,
	Pure = Color.GOLD
}

func _ready() -> void:
	fill_bar.set_corner_radius_all(8)
	quality_window.hide()
	visible = false

func _on_player_inspect_this(data) -> void:
	if data:
		current_node = data
	if ! data:
		current_node = null

func match_quality(data):
	if data and data.quality:
		var quality = GlobalVars.Quality_Levels.find_key(data.quality)
		quality_label.text = str(quality)
		quality_bar.value = data.quality
		var match_col: Color = col_dic[quality]
		fill_bar.bg_color = match_col
		quality_bar.add_theme_stylebox_override("fill", fill_bar)

func inspection():
	if current_node:
		object_name.text = str(current_node.name)
	else:
		object_name.text = ""

func _process(_delta: float) -> void:
	inspection()
