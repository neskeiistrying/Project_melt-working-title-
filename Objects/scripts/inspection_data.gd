extends Resource
class_name Inspection_Data

enum Item_Type{
	debug,
	lootable,
	pickable,
	pushable,
	usable,
	collectable,
	inspectable
}

@export var name: String = ""
@export var item_type: Item_Type
@export_multiline() var description: String = ""
@export var texture: Texture = null
@export var processing_time: float = 2.5

@export var quality: GlobalVars.Quality_Levels
