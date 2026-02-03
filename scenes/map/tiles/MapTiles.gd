extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_child_count() == 0:  # Tiles don't exist
		if OS.has_feature("editor"):
			_load_tiles()
		else:
			printerr("No tiles avaiable")

func _load_tiles() -> void:
	for x in range(36):
		for y in range(9):
			var resource_path := "res://assets/tiles/tile-%d_%d.png" % [x, y]
			
			if !ResourceLoader.exists(resource_path):
				continue
			
			var sprite := Sprite2D.new()
			sprite.texture = load(resource_path)
			sprite.name = "Tile-%d-%d" % [x, y]
			sprite.centered = false
			add_child(sprite)
			sprite.set_owner(get_tree().get_edited_scene_root())
			sprite.position = Vector2(x * 512, y * 512)
