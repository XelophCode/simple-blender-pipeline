@tool
extends EditorScenePostImport


func _post_import(blend_scene):
	
	blend_scene.set_script(load("res://addons/simple_blender_pipeline/blend_file_linker.gd"))
	
	SimpleBlenderPipeline.run = true
	
	SimpleBlenderPipeline.post_import_names.append(blend_scene.name)
	
	EditorInterface.save_scene()
	
	return blend_scene
