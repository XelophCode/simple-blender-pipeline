@tool
extends Node3D
class_name BlendFileLinker

var unpacker_script : Script = preload("res://addons/simple_blender_pipeline/blend_file_unpacker.gd")
var spawned_by_unpacker : bool = false


func _ready():
	if ProjectSettings.get_setting("simple_blender_pipeline/settings/disable_addon"):
		set_script(null)
		return
	
	if Engine.is_editor_hint():
		
		await get_tree().process_frame
		
		if owner == null:
			return
		
		if spawned_by_unpacker:
			return
		
		var unpacker := Node.new()
		owner.add_child(unpacker)
		unpacker.owner = owner
		
		unpacker.set_script(unpacker_script)
		unpacker.blend_file = ResourceUID.path_to_uid(scene_file_path)
		
		unpacker.blend_name = name
		
		
		queue_free()
