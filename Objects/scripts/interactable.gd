extends RigidBody3D
class_name Interactable

###################################

signal collected(body)
signal picked_up(body)
signal holding(body)
signal dropped(body)
signal used(body)
signal threw(body)
signal inspect(body)

###################################

@export var prompt_l1: String = "LMB: collect  RMB: pickup, release to drop"
@export var prompt_l2: String = "Q: throw  E: use"
@export var prompt_l3: String = "ALT: inspect"

@export var interaction_disabled: bool

###################################

func item_collect(body):
	collected.emit(body)

func item_pickup(body):
	picked_up.emit(body)

func item_hold(body):
	holding.emit(body)

func item_drop(body):
	dropped.emit(body)

func item_use(body):
	used.emit(body)

func item_throw(body):
	threw.emit(body)

func item_inspect(body):
	inspect.emit(body)
