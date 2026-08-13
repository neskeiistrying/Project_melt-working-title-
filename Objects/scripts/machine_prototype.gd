extends Node3D
class_name Machine

const PRODUCT = preload("uid://dj2lqy6w2vqdo")

@onready var sprite_3d: Sprite3D = %Sprite3D
@onready var timer: Timer = %Timer
@onready var label: Label = $debug/VBoxContainer/Label
@onready var marker_3d: Marker3D = $"processing_and output/Marker3D"
@onready var progress_bar: ProgressBar = %ProgressBar

@onready var auto_mode_switch: Switch = $control_panel/auto

@export var item_process_time: float = 5

var body_buffer: Array[Interactable_Object]
var item: Interactable_Object
var processing: bool = false
var auto_mode_disabled: bool = false

func _ready() -> void:
	progress_bar.max_value = item_process_time
	sprite_3d.hide()

func input(body)-> void:
	if body is Interactable_Object:
		if ! body_buffer.has(body):
			body_buffer.append(body)

func remove_object(body: Node3D) -> void:
		if body_buffer.has(body):
			body_buffer.erase(body)

func body_disposal(body: Interactable_Object):
	body.position = Vector3(0, 5, 0)
	body.freeze = true

func start_processing() -> void:
	if ! body_buffer.is_empty():
		body_disposal(body_buffer.front())
		process_item(body_buffer.pop_front())

func process_item(body: Interactable_Object)-> void:
	if ! processing:
		item = body
		timer.start(item_process_time)
		processing = true

func _on_processing_finished() -> void:
	processing = false
	output()
	auto_mode()

func output()-> void:
	item.queue_free()
	var output_item = PRODUCT.instantiate()
	output_item.position = marker_3d.global_position
	get_tree().get_root().add_child(output_item) 

func _on_auto_mode_changed() -> void:
	auto_mode_disabled = ! auto_mode_disabled

func auto_mode():
	if auto_mode_disabled:
		auto_mode_switch.toggle_off()
		auto_mode_disabled = false
	elif ! auto_mode_disabled:
		start_processing()

func bonus_calculation()-> void:
	pass

func output_data()-> void:
	pass

func upgrades()-> void:
	pass

func user_interface():
	if ! timer.is_stopped():
		sprite_3d.show()
		progress_bar.value = timer.wait_time - timer.time_left
	else:
		sprite_3d.hide()
		progress_bar.value = 0

func debug():
	if ! body_buffer.is_empty():
		label.text = "\n".join(body_buffer)
	else:
		label.text = " "

func _process(_delta: float) -> void:
	debug()
	user_interface()
