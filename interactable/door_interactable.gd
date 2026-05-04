class_name DoorInteractable
extends Interactable
## Interactable that can open a door

@export var closed_timeline := ""
@export var open_timeline := ""
@export var tilemap_layer: TileMapLayer
@export var map_coords: Vector2i
@export var tileset_source_id := 0
@export var tileset_atlas_coord: Vector2i
@export var key_inventory_item := ""
@export var noise: AudioStreamPlayer


func interact():
	if GlobalState.has_inventory_item(key_inventory_item):
		Dialogic.start(open_timeline)
		await Dialogic.timeline_ended
		tilemap_layer.set_cell(map_coords, tileset_source_id, tileset_atlas_coord)
		queue_free()
		noise.play()
	else:
		Dialogic.start(closed_timeline)
