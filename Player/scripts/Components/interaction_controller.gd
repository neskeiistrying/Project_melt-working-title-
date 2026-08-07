extends Node
class_name Interaction_Controller

signal inspection_data(data)

###################################

@onready var label_1: Label = %Label1
@onready var label_2: Label = %Label2
@onready var label_3: Label = %Label3
@onready var label_4: Label = %Label4
@onready var label_5: Label = %Label5
@onready var label_6: Label = %Label6
@onready var label_7: Label = %Label7

###################################

var trying_to_hold: bool = false

@export var raycast: RayCast3D
@export var marker: Marker3D

@onready var target_ray: RayCast3D = %target_ray
@onready var mark: Marker3D = %mark
@onready var default_mark: Marker3D = %default_mark

###################################

var interaction_enabled: bool

###################################

var collider: Node3D

var prompt_l1: String
var prompt_l2: String
var prompt_l3: String

###################################

func collision():
	if raycast.is_colliding():
		collider = raycast.get_collider()
		if collider is Interactable:
			prompting()

			if not collider.interaction_disabled:
				interaction_enabled = true
			else:
				interaction_enabled = false
		else:
			interaction_enabled = false
	else : return

###################################

# idk.. i didnt want all these to be clogging the collision function
func interaction():
	if collider:
		if interaction_enabled:
			item_collection()
			item_inspect()
			item_pickup()
			item_throw()
			item_use()

###################################

func item_collection():
	if ! trying_to_hold:
		if Input.is_action_just_pressed("item_collect"):
			collider.item_collect(owner)

###################################

func item_inspect():
	if collider is Interactable:
		var data: Inspection_Data = collider.inspection_data
		inspection_data.emit(data)

###################################

func item_pickup():
	if collider and trying_to_hold:
			collider.item_pickup(owner)

###################################

# checks if raycast is colliding with interactables when "item_input" is pressed
# "trying to hold" true if yes, false if no
# collider stores the item, after interaction, 
# so it has to detect when raycast is colliding
# I tried to make the collider null, when raycast doesnt interact, in general. 
# didnt work
# maybe different raycasts for different functions is a way !?

func hold_mgmt():
	if raycast.is_colliding():
		if Input.is_action_pressed("item_pickup"):
			trying_to_hold = true
			raycast.collide_with_bodies = false
	if ! Input.is_action_pressed("item_pickup"):
		trying_to_hold = false
		raycast.collide_with_bodies = true
		if ! raycast.is_colliding():
			collider = null
			return

# Issues
# I dont like that the player cant interact with anything else, 
# when holding something
# if this isnt so, items held gets replaced by tems being looked at
# and throw doesnt work (switching hand position solves this, but I dont like it)
# dunno how else to solve this

# I just realized that I am not checking if the object type is Interactable
# I have only checked for it for debug functions
# code still works?!?? ... Im questioning my existence

###################################

func item_throw():
	if trying_to_hold:
		if Input.is_action_just_pressed("item_throw"):
			collider.item_throw(owner)
			trying_to_hold = false
			collider = null
			return

###################################

func item_use():
	if Input.is_action_just_pressed("item_use"):
		collider.item_use(owner)

###################################

# if target ray is hitting something, point it hits is the target
# else, the target is the end of target rays range

func targetting():
	if target_ray.is_colliding():
		var intended_pos: Vector3 = target_ray.get_collision_point()
		mark.global_transform.origin = intended_pos
	else:
		mark.global_transform.origin = default_mark.global_transform.origin

###################################

func debug():
	if raycast.is_colliding():
		label_1.text = str(collider)
		if collider is Interactable and ! trying_to_hold:
			label_2.text = str(collider.get_script().get_global_name()) + " ("+ str(collider.get_class()) + ")"
			label_3.text = str(prompt_l1)
			label_4.text = str(prompt_l2)
			label_5.text = str(prompt_l3)
		else:
			label_2.text = ""
			label_3.text = ""
			label_4.text = ""
			label_5.text = ""
	else:
		label_1.text = ""
		label_2.text = ""
		label_3.text = ""
		label_4.text = ""
		label_5.text = ""

###################################

func _unhandled_input(event: InputEvent) -> void:
	if event:
		if event is InputEventMouse:
			label_6.text = str(event.as_text())
		else: label_6.text = " "
		if event is InputEventKey:
			label_7.text = str(event.as_text())
		else: label_7.text = " "

	else:
		label_6.text = " "
		label_7.text = " "

###################################

func prompting():
	prompt_l1 = collider.prompt_l1
	prompt_l2 = collider.prompt_l2
	prompt_l3 = collider.prompt_l3

###################################

func _process(_delta: float) -> void:
	targetting()
	collision()
	interaction()
	hold_mgmt()
	debug()
