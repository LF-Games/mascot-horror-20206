extends Node
## Classe responsavel por manter registros de estado ao longo do jogo, incluindo itens no inventário.
##
## Utilize set_flag(key) e get_flag(key) para registrar/acessar dados booleanos.

signal item_added(key: String)
signal flag_raised(key: String)

var _flags: Dictionary[StringName, bool] = {}
var _inventory_items: Dictionary[StringName, int] = {}

func set_flag(key: StringName, value := true) -> bool:
	_flags[key] = value
	
	if value:
		flag_raised.emit(key)
	return value


func get_flag(key: StringName) -> bool:
	return _flags.get(key, false)


func add_inventory_item(key: StringName) -> void:
	if not _inventory_items.has(key):
		_inventory_items[key] = 1
	else:
		_inventory_items[key] += 1
	item_added.emit(key)


func remove_intentory_item(key: StringName, value := 1) -> void:
	if not _inventory_items.has(key):
		return
	else:
		_inventory_items[key] -= value
		if _inventory_items[key] <= 0:
			_inventory_items.erase(key)


func has_inventory_item(key: StringName) -> bool:
	return _inventory_items.has(key)


func get_item_count(key: StringName) -> int:
	if !_inventory_items.has(key):
		return 0
	return _inventory_items[key]


## Returns an array of dictionaries with keys "key" and "amount"
func get_inventory_list() -> Array[Dictionary]:
	var result_array: Array[Dictionary] = []
	for key in _inventory_items.keys():
		result_array.append({"key": key, "amount": _inventory_items[key]})
	return result_array


func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F2:
			print("Inventory items:")
			for i in get_inventory_list():
				print("%s x%s" % [i.key, i.amount])
