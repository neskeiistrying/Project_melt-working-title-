extends Resource
class_name Item_Data

@export var name: String = ""
@export var item_id: String = ""
@export_multiline() var description: String = ""
@export var stackable: bool = false
@export var texture: Texture = null

const quantity = 1
