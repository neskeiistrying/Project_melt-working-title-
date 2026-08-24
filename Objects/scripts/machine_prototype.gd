extends Node3D
class_name Machine
const PRODUCT = preload("uid://dj2lqy6w2vqdo")

#debug
@onready var label: Label = %Label
@onready var label_2: Label = %Label2
@onready var label_3: Label = %Label3

#3d UI
@onready var _3d_ui: Sprite3D = %"3D_UI"
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var disp: Label = %disp
@onready var deb: ProgressBar = %deb

#positions
@onready var input_marker: Marker3D = %input
@onready var storage_marker: Marker3D = %storage
@onready var output_marker: Marker3D = %output

#timers
@onready var p_timer: Timer = %p_timer
@onready var r_timer: Timer = %r_timer

#arrays
var input_buffer: Array[Interactable_Object] = []
var output_buffer: Array[Interactable_Object] = []
var safety_buffer: Array[Interactable_Object] = []

#items
var input_item: Interactable_Object
var current_item: Interactable_Object
var output_item: Interactable_Object

#bools
var processing: bool = false

#misc
var world: Node3D

func _ready() -> void:
	_3d_ui.hide()
	world = get_tree().get_first_node_in_group("main")

#region item placing and removal

func on_item_placed(body: Node3D) -> void:
	if body is Interactable_Object:
		if ! input_buffer.has(body):
			input_buffer.append(body)

func on_item_removed(body: Node3D) -> void:
		if input_buffer.has(body):
			input_buffer.erase(body)
#endregion

#temporarily stores/hides the items from view and player reach
func item_storage(body: Interactable_Object):
	body.position = storage_marker.global_position
	body.freeze = true
	safety_buffer.append(body)

#simply adds the processing time of all objects in the input buffer
func calculate_total_time()-> float:
	var t: float = 0.0
	for i in range(input_buffer.size()):
		t += input_buffer.front().inspection_data.processing_time
	return t

func start_button_pressed():
	if ! processing and ! input_buffer.is_empty():
		processing = true
		p_timer.start(calculate_total_time())
		progress_bar.max_value = calculate_total_time()
		for i in range(input_buffer.size()):
			item_storage(input_buffer.pop_front())
		process_item()
	else:
		return

func process_item():
	if ! safety_buffer.is_empty():
		r_timer.start(safety_buffer.front().inspection_data.processing_time)
		deb.max_value = safety_buffer.front().inspection_data.processing_time
	else :
		print("start")
		p_timer_timeout()


func r_timer_timeout():
	if ! safety_buffer.is_empty():
		instance_output(safety_buffer.front())
		safety_buffer.pop_front().queue_free()
		process_item()

# when timer runs out and finishes processing
# empty out everything in the output buffer into the output tray
func p_timer_timeout() -> void:
	processing = false
	for i in range(output_buffer.size()):
		var item = output_buffer.pop_front()
		item.position = output_marker.global_position
		world.add_child(item)

# when processing is stopped by player using the button
# produces the items that havent been processed
# produces the results of items that has been processed
# destroys the currently processing item
# returns product with quantity based on the processing time
func stop_button_pressed() -> void:
	pass


#region output functions
# simply creates an instance of the template
# stores the instance in anticipation of timer timeout
# called seperately so that instances are preloaded
func instance_output(_item_)-> void:
	var instance = PRODUCT.instantiate()
	output_buffer.append(instance)

# adds all the features to the item instance
# adds the instance as the child of the scene tree
func produce_output(item_):
	item_.position = output_marker.global_position
	get_tree().get_root().add_child(item_) 
#endregion


func user_interface():
	if ! p_timer.is_stopped():
		_3d_ui.show()
		progress_bar.value = p_timer.wait_time - p_timer.time_left
		deb.value = r_timer.wait_time - r_timer.time_left
	else:
		_3d_ui.hide()
		progress_bar.value = 0
		deb.value = 0

func debug():
	if ! input_buffer.is_empty():
		label.text = "input_buffer: " + "\n" + "\n".join(input_buffer)
	else:
		label.text = "[]"

	if ! output_buffer.is_empty():
		label_2.text = "output_buffer: " + "\n" + "\n".join(output_buffer)
	else:
		label_2.text = "[]"

	if ! safety_buffer.is_empty():
		label_3.text = "safety_buffer: " + "\n" + "\n".join(safety_buffer)
	else:
		label_3.text = "[]"

	if processing: 
		disp.text = "time left : " + str(snappedf(p_timer.time_left, 0.1)) + "s"

func _process(_delta: float) -> void:
	user_interface()
	debug()
