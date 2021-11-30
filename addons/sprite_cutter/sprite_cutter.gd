tool
extends EditorPlugin
var destination_path:String
func _enter_tree():
	add_custom_type("AtlasScene", "Node", preload("AtlasScene.gd"), preload("icon.svg") )
	add_tool_menu_item("Sprite Cutter: Export Atlas Textures", self, "export_sprites")
	pass


func _exit_tree():
	remove_custom_type("AtlasScene")
	remove_tool_menu_item("Sprite Cutter: Export Atlas Textures")
	pass
func create_dir_recurs(destination_path:String)->Directory:
	var dir = Directory.new()
	if not dir.dir_exists(destination_path):
		print("Destination Path '%s' doesn't exist. Creating.." % destination_path)
		dir.make_dir_recursive(destination_path)
		return dir
	return dir

func _get_sprites_recurse(root:Node):
	var sprites = {"_default":[]}
	#Get queue
	var temp=root.get_children()
	var child=temp.pop_front()
	while child:
		if child.visible:
			if child is Node2D:
				sprites[child.name]=child.get_children()
			elif child is Sprite:
				sprites["_default"].append(child)
			else:
				temp.append_array(child.get_children())
func get_sprites_with_names(scene:AtlasScene)->Dictionary:
	var sprites = {"_default":[]}
	var temp=scene.get_children()
	var child=temp.pop_front()
	while child:
		if child.visible==true:
			if child is Node2D:
				sprites[child.name]=child.get_children()
			elif child is Sprite:
				sprites["_default"].append(child)
			else:
				temp.append_array(child.get_children())
		child=temp.pop_front()

	return sprites
func create_atlas(sprite:Sprite)->AtlasTexture:
	var tex := AtlasTexture.new()
	tex.atlas = sprite.texture
	tex.region = sprite.region_rect
	return tex
func save_sprite(destination_path:String, sprite:Sprite, tex:AtlasTexture):
	var fullpath = destination_path + "/" + sprite.name + ".atlastex"
	var error=ResourceSaver.save(fullpath, tex)
	if error==OK:
		print("(Re)exported %s" % fullpath)
	else:
		printerr("Error %d" % error)
func export_sprites(_ud):
	var scene = get_editor_interface().get_edited_scene_root()
	if not is_instance_valid(scene) or not scene is AtlasScene:
		printerr("Invalid scene")
		return
	destination_path = scene.get("destination_path")
	if typeof(destination_path) != TYPE_STRING:
		printerr("Destination Path should be a string")
		return
	if destination_path.empty():
		printerr("Destination Path is empty")
		return
	var dir = create_dir_recurs(destination_path)

	#Returns a dictionary
	var items = get_sprites_with_names(scene)
	# If the list is empty return an error
	if items.empty():
		print("Nothing to do. No sprites nodes found")
		return
	for name in items:
		var sprites = items[name]
		for sprite in sprites:
			sprite = sprite as Sprite
			var tex := create_atlas(sprite)
			if name=="_default":
				save_sprite(destination_path, sprite, tex)
			else:
				var directory=create_dir_recurs(destination_path+"/"+name)
				save_sprite(destination_path+"/"+name, sprite, tex)
	# Create an atlas texture for each sprite
	# using the node name and the texture region
	#for sprite in sprites:
	#	sprite = sprite as Sprite
	#	var tex := create_atlas(sprite)
	#	save_sprite(destination_path, sprite, tex)
