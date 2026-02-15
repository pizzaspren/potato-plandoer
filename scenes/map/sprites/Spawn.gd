extends TextureButton


func _ready() -> void:
	var bitmap:BitMap = BitMap.new()
	bitmap.create_from_image_alpha(texture_normal.get_image())
	texture_click_mask = bitmap
