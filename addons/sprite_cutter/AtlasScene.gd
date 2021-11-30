tool
extends Node
class_name AtlasScene

export(String, DIR) var destination_path
export(String) var animation_name
export(NodePath) var anim_destination_path
export(bool) var convert_nodes=false setget rename_nodes
export(bool) onready var add_anim_sprite=false setget create_anim_sprite

func create_anim_sprite(_val):
	if animation_name.empty():
		return
	
	var anim=AnimatedSprite.new()
	anim.name=animation_name
	anim.frames=SpriteFrames.new()
	for child in get_children():
		if child.name!="":
			remove_child(child)
		if child.visible:
			if child is Node2D:
				AtlasAnimation.get_anim(anim.frames, child)
			
				print(child.name)
			if child.name!="idle":
				remove_child(child)
	anim.visible=true
	print_debug(anim.frames)
	var n=Node2D.new()
	n.visible=true
	n.name="hhh"
	n.add_child(anim)
	add_child(n)

func rename_nodes(_val):
	var regex = RegEx.new()
	regex.compile("_\\d+")
	var children=get_children()
	for child in children:
		if child.visible:
			var nodes=child.get_children()
			for node in nodes:
				if node.visible:
					var result=regex.search(node.name)
					if result:
						var name=child.name+result.get_string()
						node.name=name
						print_debug("Renamed %s with %s" % [node.name, name])
					else:
						printerr("Could not get a result")
