extends StaticBody3D
class_name Interactable_SB

###################################

signal collected(body)
signal used(body)
signal inspect(body)

###################################

@export var prompt_l1: String = "LMB: collect  RMB: pickup, release to drop"
@export var prompt_l2: String = "Q: throw  E: use"
@export var prompt_l3: String = "ALT: inspect"

@export var collectable: bool
@export var interaction_enabled: bool

###################################

func item_collect(body):
	collected.emit(body)

func item_use(body):
	used.emit(body)

func item_inspect(body):
	inspect.emit(body)

#region invalid functions

func item_pickup(_body):
	return

func item_hold(_body):
	return

func item_drop(_body):
	return

func item_throw(_body):
	return
#endregion
