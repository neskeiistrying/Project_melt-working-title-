extends PanelContainer

const SLOT = preload("uid://xbrgf2tldsdv")

@onready var item_grid: GridContainer = $"MarginContainer/item grid"

func set_inventory_data(inventory_data: Inventory_Data)-> void:
	inventory_data.inventory_updated.connect(populate_item_grid)
	populate_item_grid(inventory_data)

func clear_inventory_data(inventory_data: Inventory_Data)-> void:
	inventory_data.inventory_updated.disconnect(populate_item_grid)

func populate_item_grid(inventory_data: Inventory_Data)-> void:
	for child in item_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var  slot = SLOT.instantiate()
		item_grid.add_child(slot)

		slot.slot_clicked.connect(inventory_data.on_slot_clicked)
	
		if slot_data != null:
			slot.set_slot_data(slot_data)
