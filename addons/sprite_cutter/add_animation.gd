extends Node

class_name AtlasAnimation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

static func get_anim(frames, node:Node2D)->SpriteFrames:
	var name=node.name
	frames.add_animation(name)
	var children=node.get_children()
	for child in children:
		var texture:StreamTexture=child.texture
		frames.add_frame(name, texture)
	return frames
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
