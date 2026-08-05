extends Node3D

@onready var world_item_dictionary: Item_Dictionary = $world_item_dictionary

@onready var player: Player = $Player
@onready var inventory_interface: Control = $UI/Inventory_interface

signal toggle_inventory()

func _ready() -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data)

	for node in get_tree().get_nodes_in_group("external_inventories"):
		node.toggle_inventory.connect(_on_toggle_inventory)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory_open"):
		toggle_inventory.emit()

	if event.is_action_pressed("debug_quit"):
		get_tree().quit()

func _on_toggle_inventory(external_inventory_owner = null) -> void:
	inventory_interface.visible = ! inventory_interface.visible

	if inventory_interface.visible == true:
		GlobalVars.inventory_toggled = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		GlobalVars.inventory_toggled = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory_owner(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory_owner()

func _on_inventory_interface_drop_slot_data(slot_data: Slot_Data) -> void:
	var item_id = slot_data.item_data.item_id
	var hand: Marker3D = player.hand
	var item_key = world_item_dictionary.ITEM_ID.get(item_id)
	var item = world_item_dictionary.ITEM_DATA.get(item_key)
	var item_path = item.item_path
	var instance = item_path.instantiate()
	instance.position = hand.global_position
	add_child(instance)
