extends Resource
class_name Inventory_Data

signal inventory_interact(inventory_data: Inventory_Data, index: int, button:int)
signal inventory_updated(inventory_data: Inventory_Data)

@export var slot_datas: Array[Slot_Data]

func grab_slot_data(index: int)-> Slot_Data:
	var slot_data = slot_datas[index]
	
	if slot_data:
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null

func drop_slot_data(grabbed_slot_data: Slot_Data, index: int)-> Slot_Data:
	var slot_data = slot_datas[index]
	
	var return_slot_data: Slot_Data
	if slot_data and slot_data.can_merge_with(grabbed_slot_data):
		slot_data.merge()

	else:
		slot_datas[index] = grabbed_slot_data
		return_slot_data = slot_data
	
	inventory_updated.emit(self)
	return return_slot_data

func drop_single_slot_data(grabbed_slot_data: Slot_Data, index: int)-> Slot_Data:
	var slot_data = slot_datas[index]

	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()

	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())

	inventory_updated.emit(self)

	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null

func pick_up_slot_data(slot_data: Slot_Data)-> bool:
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true
	
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	return false

func on_slot_clicked(index: int, button:int):
	inventory_interact.emit(self, index,button)
