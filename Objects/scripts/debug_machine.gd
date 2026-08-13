extends Node3D

@onready var label_2: Label = %Label2
@onready var label: Label = %Label
@onready var label_3: Label = %Label3

const PRODUCT = preload("uid://dj2lqy6w2vqdo")
@onready var marker_3d: Marker3D = $Marker3D

@onready var timer: Timer = $Timer
@onready var progress_bar: ProgressBar = %ProgressBar
@onready var sprite_3d: Sprite3D = $Sprite3D

var item: Interactable_Object

@export var wait_time: float

var auto_on: bool = false

var output_quality: int
var quality_bonus: int
var quantity_bonus: int = 0

var processing: bool
var new_body

var body_buffer: Array[Interactable_Object]

@onready var auto: Switch = $auto

func _ready() -> void:
	sprite_3d.hide()
	timer.wait_time = wait_time
	progress_bar.max_value = wait_time

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Interactable_Object:
		if ! body == item and ! body_buffer.has(body):
			body_buffer.append(body)

func process_item(body: Node3D):
	if ! processing:
		if body is Interactable_Object:
			quality_control(body)
			item = body
			body_buffer.erase(body)
			timer.start()
			processing = true

func _on_timer_timeout() -> void:
	instance()
	processing = false
	if auto_on:
		if ! body_buffer.is_empty():
			process_item(body_buffer.pop_front())
		if body_buffer.is_empty():
			auto_on = false
			auto.toggle_off()

func calculate_quality_bonus(body: Interactable_Object)-> int:
	var tier_bonus
	if body.was_thrown:
		var player = get_tree().get_first_node_in_group("player")
		var player_dis = (self.global_position - player.global_position).length()
		
		tier_bonus = round(player_dis/4)

		label_2.text = "tier_bonus = " + str(tier_bonus) + "dis =" + str(player_dis)
		return tier_bonus

	else:
		tier_bonus = randi_range(0, 1)
		label_2.text = "tier_bonus = " + str(tier_bonus) 
		return tier_bonus

func quality_control(body: Interactable_Object):
	var input_quality = GlobalVars.Quality_Levels.find_key(body.inspection_data.quality)
	var input_tier = GlobalVars.quality_tiers.find(str(input_quality))
	var tier_bonus: int = calculate_quality_bonus(body)
	var output_tier_value = input_tier + tier_bonus
	var array_size = GlobalVars.quality_tiers.size()
	if output_tier_value < array_size:
		var output_tier = GlobalVars.quality_tiers[output_tier_value] 
		output_quality  = GlobalVars.Quality_Levels.get(output_tier)
	else:
		output_quality = GlobalVars.Quality_Levels.Pure

	label.text =  " input_quality = " + str(input_quality) \
		+ " output_quality = " + str(output_quality) \
		+ " input_tier + tier_bonus = " + str(input_tier + tier_bonus) \
		+ " input_tier = " + str(input_tier) \
		+ " tier_bonus = " + str(tier_bonus)

func instance():
	item.queue_free()
	var instance_ = PRODUCT.instantiate()
	instance_.position = marker_3d.global_position
	var new_data = instance_.inspection_data.duplicate_deep()
	new_data.quality = output_quality
	instance_.inspection_data = new_data
	get_tree().get_root().add_child(instance_)

func _process(_delta: float) -> void:
	label_3.text = str(body_buffer)
	if ! timer.is_stopped():
		sprite_3d.show()
		progress_bar.value = timer.wait_time - timer.time_left
	else:
		sprite_3d.hide()
		progress_bar.value = 0

func _on_area_3d_body_exited(body: Node3D) -> void:
	if processing and body == item:
		stop_processing()
	if body_buffer.has(body) and body != item:
		body_buffer.erase(body)

func stop_processing():
	if ! timer.is_stopped():
			timer.stop()
			progress_bar.value = 0
			processing = false
			body_buffer.push_front(item)
			if auto.toggled_on:
				auto.toggle_off()

func _on_switch_toggled() -> void:
	auto_on = ! auto_on

func _on_button_pressed() -> void:
	if ! processing :
		if ! body_buffer.is_empty():
			process_item(body_buffer.pop_front())
	if processing:
		return

func _on_button_2_pressed() -> void:
	stop_processing()
