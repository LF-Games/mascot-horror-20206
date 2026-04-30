@tool
extends Button


func _ready():
	pressed.connect(_on_button_pressed)
	EditorInterface.get_selection().selection_changed.connect(_update_visibility)
	_update_visibility()


func _on_button_pressed():
	var sprites := _get_selected_sprites()
	if !sprites or sprites.is_empty():
		return
	var undo := EditorInterface.get_editor_undo_redo()
	undo.create_action("Generate StaticBody2D")
	undo.add_do_method(self , "_do_generate", sprites)
	undo.add_undo_method(self , "_undo_generate", sprites)
	undo.commit_action()

	
func _do_generate(sprites: Array[Sprite2D]):
	var last_generated_collision_shape: CollisionShape2D
	for sprite in sprites:
		var scale := sprite.scale
		if !sprite.texture:
			continue
		var texture_size := sprite.texture.get_size()
		var static_body := StaticBody2D.new()
		sprite.add_child(static_body)
		static_body.name = "StaticBody2D"
		static_body.owner = get_tree().edited_scene_root
		static_body.position = Vector2.ZERO
		var collision_shape = CollisionShape2D.new()
		static_body.add_child(collision_shape)
		collision_shape.name = "CollisionShape"
		collision_shape.owner = get_tree().edited_scene_root
		collision_shape.position = Vector2.ZERO
		var shape := RectangleShape2D.new()
		collision_shape.shape = shape
		shape.size.x = texture_size.x * scale.x
		shape.size.y = texture_size.y * scale.y
		last_generated_collision_shape = collision_shape
	EditorInterface.get_selection().clear()
	EditorInterface.get_selection().add_node(last_generated_collision_shape)
	

func _undo_generate(sprites: Array[Sprite2D]):
	for sprite in sprites:
		if !sprite.texture:
			continue
		sprite.get_node("StaticBody2D").queue_free()

func _update_visibility():
	var sprites = _get_selected_sprites()
	disabled = sprites.is_empty()


func _get_selected_sprites() -> Array[Sprite2D]:
	var selection := EditorInterface.get_selection()
	var sprites: Array[Sprite2D] = []
	if !selection:
		return sprites
	for node in selection.get_selected_nodes():
		if node is Sprite2D:
			sprites.append(node)
	return sprites
