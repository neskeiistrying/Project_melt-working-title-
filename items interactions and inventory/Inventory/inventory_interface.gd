extends Control

signal drop_slot_data(slot_data: Slot_Data)

var grabbed_slot_data: Slot_Data

var external_inventory_owner

@onready var player_inventory: PanelContainer = %player_inventory
@onready var grabbed_slot: PanelContainer = $Slot
@onready var external_inventory: PanelContainer = %external_inventory

func _physics_process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(5,5)

func set_player_inventory_data(inventory_data: Inventory_Data):
	inventory_data.inventory_interact.connect(inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_external_inventory_owner(_external_inventory_owner)-> void:
	external_inventory_owner = _external_inventory_owner
	var inventory_data = external_inventory_owner.inventory_data

	inventory_data.inventory_interact.connect(inventory_interact)
	external_inventory.set_inventory_data(inventory_data)

	external_inventory.show()

func clear_external_inventory_owner()-> void:
	if external_inventory_owner:
		var inventory_data = external_inventory_owner.inventory_data

		inventory_data.inventory_interact.disconnect(inventory_interact)
		external_inventory.clear_inventory_data(inventory_data)

		external_inventory.hide()
		external_inventory_owner = null

func inventory_interact(inventory_data: Inventory_Data, index: int, button:int):
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
		[null, MOUSE_BUTTON_RIGHT]:
			pass
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)

	update_grabbed_slot()

func update_grabbed_slot():
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and grabbed_slot_data and event.is_pressed():
		if grabbed_slot_data.quantity > 0:
				match event.button_index:
					MOUSE_BUTTON_LEFT:
						
						for i in range(grabbed_slot_data.quantity):
							drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
						grabbed_slot_data = null

					MOUSE_BUTTON_RIGHT:
						drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
						if grabbed_slot_data.quantity < 1:
							grabbed_slot_data = null 
			
				update_grabbed_slot()

func _on_visibility_changed() -> void:
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
	update_grabbed_slot()
