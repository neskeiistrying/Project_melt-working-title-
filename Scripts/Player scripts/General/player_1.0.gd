extends CharacterBody3D
class_name Player

###################################

@export var inventory_data: Inventory_Data
@onready var hand: Marker3D = %hand

###################################

func _physics_process(_delta: float) -> void:
	move_and_slide()
