extends CharacterBody3D
class_name Player

signal inspect_this(data)
###################################

@onready var hand: Marker3D = %hand

###################################

func _physics_process(_delta: float) -> void:
	move_and_slide()


func _on_interaction_controller_inspection_data(data: Variant) -> void:
	inspect_this.emit(data)
