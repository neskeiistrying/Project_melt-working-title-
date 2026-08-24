extends Node3D
class_name Machine

const PRODUCT = preload("uid://dj2lqy6w2vqdo")

@onready var disp: Label = $"3d_hud/SubViewport/Panel/VBoxContainer/ProgressBar/disp"

@onready var label: Label = $debug/VBoxContainer/Label
@onready var label_2: Label = $debug/VBoxContainer/Label2
@onready var label_3: Label = $debug/VBoxContainer/Label3

@onready var sprite_3d: Sprite3D = %Sprite3D
@onready var timer: Timer = %Timer
@onready var marker_3d: Marker3D = $"processing_and output/Marker3D"
@onready var marker_3d_2: Marker3D = $"processing_and output/Marker3D2"
@onready var progress_bar: ProgressBar = %ProgressBar

@export var item_process_time: float = 5

var input_buffer: Array[Interactable_Object]
var output_buffer: Array[Interactable_Object]
var safety_array: Array[Interactable_Object]

var output_item: Interactable_Object

var item: Interactable_Object
var processing: bool = false
var auto_mode_disabled: bool = false

func _ready() -> void:
	sprite_3d.hide()

func input(body)-> void:
	if body is Interactable_Object:
		if ! input_buffer.has(body):
			input_buffer.append(body)

func remove_object(body: Node3D) -> void:
		if input_buffer.has(body):
			input_buffer.erase(body)

func body_disposal(body: Interactable_Object):
	body.position = Vector3(safety_array.size(), 5, 0)
	body.freeze = true
	safety_array.append(body)

func calculate_time()-> float:
	var t: float = 0
	for i in range(input_buffer.size()):
		t += input_buffer.front().inspection_data.processing_time
	return t

func start_processing() -> void:
	if ! input_buffer.is_empty():
		if ! processing:
			var time = calculate_time()
			progress_bar.max_value = time
			timer.start(time)
			processing = true
			for i in range(input_buffer.size()):
				instance_output(input_buffer.front())
				body_disposal(input_buffer.pop_front())


func _on_processing_finished() -> void:
	processing = false
	for i in range(safety_array.size()):
		safety_array.pop_front().queue_free()
	for i in range(output_buffer.size()):
		output(output_buffer.pop_front())

func instance_output(item_)-> void:
	#item_.queue_free()
	var instance = PRODUCT.instantiate()
	output_buffer.append(instance)

func output(item_):
	item_.position = marker_3d.global_position
	get_tree().get_root().add_child(item_) 

func _on_stopped() -> void:
	if processing and ! safety_array.is_empty():
		timer.stop()
		for i in range(safety_array.size()):
			input_buffer.append(safety_array.front())
			output_buffer.clear()
			var x = safety_array.pop_front()
			x.global_position = marker_3d_2.global_position
			x.freeze = false
			processing = false

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
	if ! input_buffer.is_empty():
		label.text = "\n".join(input_buffer)
	else:
		label.text = "[]"

	if ! output_buffer.is_empty():
		label_2.text = "\n".join(output_buffer)
	else:
		label_2.text = "[]"

	if ! safety_array.is_empty():
		label_3.text = "\n".join(safety_array)
	else:
		label_3.text = "[]"

	if processing: 
		disp.text = "time left : " + str(snappedf(timer.time_left, 0.1)) + "s"

func _process(_delta: float) -> void:
	debug()
	user_interface()
