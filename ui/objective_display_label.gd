extends RichTextLabel
## Node that displays text about what the player has to do regarding a certain item

@export var item_key: String
@export var returned_flag: String
@export var find_label: String
@export var return_label: String
@export var search_amount: int

func _ready():
	GlobalState.item_added.connect(_on_item_added)
	GlobalState.flag_raised.connect(_on_flag_raised)
	_update_display()


func _on_item_added(key: String):
	if key != item_key:
		return
	_update_display()


func _on_flag_raised(key: String):
	if key != returned_flag:
		return
	_update_display()


func _update_display():
	if GlobalState.get_flag(returned_flag):
		hide()
		return
	var amount_found := GlobalState.get_item_count(item_key)
	if amount_found >= search_amount:
		text = "[ul]%s[/ul]" % return_label
	else:
		text = "[ul]%s (%d/%d)[/ul]" % [find_label, amount_found, search_amount]
