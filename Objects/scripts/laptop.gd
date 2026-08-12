extends Interactable

signal activate

func _on_collected(_body: Variant) -> void:
	activate.emit()
