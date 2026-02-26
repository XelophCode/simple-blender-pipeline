@tool
@icon("res://addons/simple_blender_pipeline/blend_node_icon.png")
extends Node
class_name BlendFileUnpacker


@export_tool_button("   Reload     ") var force_reload : Callable = run.bind(true)

## This indicates whether the unpack is up to date with the blend file. Press the refresh button to update the unpack. Do not manually update this property.

@export_subgroup("additional_settings")
## If true, this will move all blender nodes to global_position = Vector3.ZERO
@export var move_all_origins_to_world_center : bool = false
@export var delete_blend_unpacker_on_play : bool = false

@export_subgroup("scan for non updated scenes")
@export_tool_button("    Scan    ") var scan : Callable = scan_for_unupdated_nodes

@export_subgroup("addon data")
@export var blend_file : String
@export var blend_name : String

var duplicate_scene: Node
var duplicate_scene_meshes : Array[MeshInstance3D]
var all_materials : Array[StandardMaterial3D]
var return_nodes : Array
var recursive_children : Array
var override_node : MeshInstance3D

func scan_for_unupdated_nodes():
	SimpleBlenderPipeline.scan_for_un_updated_nodes()


func _init() -> void:
	
	if Engine.is_editor_hint():
		if not is_inside_tree():
			return
		
		await get_tree().process_frame
		
		name = blend_name
		
		register_link()
		
		run(true)
		
	

func _ready() -> void:
	if Engine.is_editor_hint():
		register_link()
	else:
		if delete_blend_unpacker_on_play:
			queue_free()


func register_link():
	if not SimpleBlenderPipeline.active_scenes.has(self):
			SimpleBlenderPipeline.active_scenes.append(self)



func run(called_local:bool = false) -> void:
	if ProjectSettings.get_setting("simple_blender_pipeline/settings/disable_addon"):
		return
	
	if ProjectSettings.get_setting("simple_blender_pipeline/settings/print_updates"):
		if called_local:
			SimpleBlenderPipeline.print_addon_header()
		print("Updated: " + "[" + name + "]" + " -> " + "[" + str(EditorInterface.get_edited_scene_root().scene_file_path) + "]")
	
	
	duplicate_blend_scene()
	
	setup_children(duplicate_scene)
	
	remove_skip_nodes()
	
	await get_tree().process_frame
	
	generate_collision_shapes()
	
	clear_arrays()
	
	await get_tree().process_frame
	
	get_duplicate_scene_mesh_instances(duplicate_scene)
	
	get_all_materials()
	
	get_override_node()
	
	setup_blend_mesh_override()
	
	override_mesh_settings()
	
	setup_material_metadata()
	
	setup_blend_mat_override()
	
	remove_override_node()
	
	reset_materials_to_default_SM3D_settings()
	
	metallic_specular_fix()
	
	blender_import_settings()
	
	override_material_with_project_settings()
	
	convert_float_arrays()
	
	discard_collision_meshes()
	
	clean_up_metadata()
	
	tag_all_duplicate_children_with_blender_meta()
	
	recompose_scene()
	
	EditorInterface.mark_scene_as_unsaved()



func duplicate_blend_scene() -> void:
	
	var blend_inst : BlendFileLinker = load(blend_file).instantiate()
	blend_inst.spawned_by_unpacker = true
	
	duplicate_scene = blend_inst.duplicate()
	
	duplicate_scene.show()
	
	duplicate_scene.set_script(null)
	
	var new_name := name + "_unpacked"
	var delete_node: Node = null
	
	
	for i in get_parent().get_children():
		if i.name == new_name:
			delete_node = i
	
	if delete_node:
		get_parent().remove_child(delete_node)
		delete_node.queue_free()
	
	duplicate_scene.scene_file_path = ""
	duplicate_scene.name = new_name
	
	get_parent().add_child(duplicate_scene)
	duplicate_scene.owner = get_tree().edited_scene_root
	duplicate_scene.set_meta("blender_unpacked", 0)


func setup_children(node):
	for child in node.get_children():
		setup_children(child)
	
	if node == duplicate_scene:
		return
	
	node.set_meta("sbp_blender_origin", node.position)
	
	node.owner = get_tree().edited_scene_root
	
	if move_all_origins_to_world_center:
		node.global_position = Vector3.ZERO
	
	if node.has_meta("extras"):
		for i in node.get_meta("extras").keys():
			node.set_meta(i, node.get_meta("extras")[i])
		
		node.remove_meta("extras")



func remove_skip_nodes():
	for child in duplicate_scene.get_children():
		if child.has_meta("sbp_skip"):
			if child.get_meta("sbp_skip"):
				child.queue_free()



func generate_collision_shapes() -> void:
	for i in duplicate_scene.get_children():
		if i is MeshInstance3D:
			if i.has_meta("sbp_collision"):
				var new_CS3D := CollisionShape3D.new()
				i.get_parent().add_child(new_CS3D)
				new_CS3D.owner = owner
				new_CS3D.name = i.name + "_CS3D"
				new_CS3D.global_position = i.global_position
				
				var new_col_shape : Shape3D
				
				match i.get_meta("sbp_collision"):
					"concave": new_col_shape = i.mesh.create_trimesh_shape()
					"convex": new_col_shape = i.mesh.create_convex_shape()
				
				new_CS3D.shape = new_col_shape
				if i.has_meta("sbp_hide_debug"):
					if i.get_meta("sbp_hide_debug"):
						new_CS3D.debug_color = Color(0.0,0.0,0.0,0.0)
				
				for metakey in i.get_meta_list():
					new_CS3D.set_meta(metakey, i.get_meta(metakey))
			
					



func clear_arrays() -> void:
	duplicate_scene_meshes.clear()
	all_materials.clear()







func get_duplicate_scene_mesh_instances(root_node:Node):
	for i in root_node.get_children():
		if i is MeshInstance3D:
			if not duplicate_scene_meshes.has(i):
				duplicate_scene_meshes.append(i)
		if i.get_child_count() > 0:
			get_duplicate_scene_mesh_instances(i)



func get_all_materials():
	for i in duplicate_scene_meshes:
		for ii in i.get_surface_override_material_count():
			
			if not all_materials.has(i.get_active_material(ii)):
				all_materials.append(i.get_active_material(ii))



func get_override_node():
	override_node = null
	
	for child in duplicate_scene.get_children():
		if child.name == "blend_override_sbp":
			override_node = child



func setup_blend_mesh_override():
	if override_node == null:
		return
	
	for child in duplicate_scene.get_children():
		if child == override_node:
			continue
		for metakey in override_node.get_meta_list():
			if not child.has_meta(metakey):
				child.set_meta(metakey, override_node.get_meta(metakey))



func override_mesh_settings():
	for mesh : MeshInstance3D in duplicate_scene_meshes:
		
		if mesh.has_meta("sbp_visibility"):
			mesh.visible = mesh.get_meta("sbp_visibility")
		
		if mesh.has_meta("sbp_cast_shadow"):
			match mesh.get_meta("sbp_cast_shadow"):
				false: mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
				true: mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
		
		if mesh.has_meta("sbp_transparency"):
			mesh.transparency = mesh.get_meta("sbp_transparency")
		
		if mesh.has_meta("sbp_layers_1") and mesh.has_meta("sbp_layers_2"):
			
			var counting : int = 1
			for i in mesh.get_meta("sbp_layers_1"):
				mesh.set_layer_mask_value(counting, i)
				counting += 1
			
			counting = 6
			for i in mesh.get_meta("sbp_layers_2"):
				mesh.set_layer_mask_value(counting, i)
				counting += 1


func setup_material_metadata():
	for mat in all_materials:
		if mat.has_meta("extras"):
			var meta_name : String
			
			meta_name = "sbp_specular_IOR_level"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_coat_tint"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_override_project_settings"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_transparency"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_cull_mode"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_shading_mode"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_diffuse_mode"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_specular_mode"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_texture_filter"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_stencil_mode"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_stencil_thickness"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			meta_name = "sbp_render_priority"
			if mat.get_meta("extras").has(meta_name):
				mat.set_meta(meta_name, mat.get_meta("extras")[meta_name])
			
			mat.remove_meta("extras")



func setup_blend_mat_override():
	if override_node == null:
		return
	
	all_materials.erase(override_node.get_active_material(0))
	
	for mat in all_materials:
		for metakey in override_node.get_active_material(0).get_meta_list():
			if not mat.has_meta(metakey):
				mat.set_meta(metakey, override_node.get_active_material(0).get_meta(metakey))



func remove_override_node():
	if override_node == null:
		return
	
	duplicate_scene_meshes.erase(override_node)
	override_node.free()



func reset_materials_to_default_SM3D_settings() -> void:
	
	
	for mat in all_materials:
		
		for key in SimpleBlenderPipeline.MATERIAL_DEFAULTS.keys():
			if mat.get(key) != SimpleBlenderPipeline.MATERIAL_DEFAULTS[key]:
				continue
			
			mat.set(key, SimpleBlenderPipeline.MATERIAL_DEFAULTS[key])
	



func metallic_specular_fix():
	if not ProjectSettings.get_setting("simple_blender_pipeline/settings/use_specular_ior_as_metallic_specular"):
		return
	
	for mat : StandardMaterial3D in all_materials:
		if mat.has_meta("sbp_specular_IOR_level"):
			mat.metallic_specular = mat.get_meta("sbp_specular_IOR_level")
		else:
			mat.metallic_specular = 0.5



func blender_import_settings():
	
	for mat : StandardMaterial3D in all_materials:
		
		if mat.has_meta("sbp_transparency"):
			match mat.get_meta("sbp_transparency"):
				"disabled": mat.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
				"alpha": mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
				"alpha_scissor": mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_SCISSOR
				"alpha_hash": mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_HASH
				"alpha_depth_pre_pass": mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA_DEPTH_PRE_PASS
		
		if mat.has_meta("sbp_cull_mode"):
			match mat.get_meta("sbp_cull_mode"):
				"back": mat.cull_mode = BaseMaterial3D.CULL_BACK
				"front": mat.cull_mode = BaseMaterial3D.CULL_FRONT
				"disabled": mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		
		if mat.has_meta("sbp_shading_mode"):
			match mat.get_meta("sbp_shading_mode"):
				"unshaded": mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
				"per_pixel": mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
				"per_vertex": mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_VERTEX
		
		if mat.has_meta("sbp_diffuse_mode"):
			match mat.get_meta("sbp_diffuse_mode"):
				"burley": mat.diffuse_mode = BaseMaterial3D.DIFFUSE_BURLEY
				"lambert": mat.diffuse_mode = BaseMaterial3D.DIFFUSE_LAMBERT
				"lambert_wrap": mat.diffuse_mode = BaseMaterial3D.DIFFUSE_LAMBERT_WRAP
				"toon": mat.diffuse_mode = BaseMaterial3D.DIFFUSE_TOON
		
		if mat.has_meta("sbp_specular_mode"):
			match mat.get_meta("sbp_specular_mode"):
				"schlick_ggx": mat.specular_mode = BaseMaterial3D.SPECULAR_SCHLICK_GGX
				"toon": mat.specular_mode = BaseMaterial3D.SPECULAR_TOON
				"disabled": mat.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
		
		if mat.has_meta("sbp_texture_filter"):
			match mat.get_meta("sbp_texture_filter"):
				"nearest": mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
				"linear": mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR
				"nearest_mipmap": mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
				"linear_mipmap": mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
				"nearest_mipmap_anisotropic": mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS_ANISOTROPIC
				"linear_mipmap_anisotropic": mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS_ANISOTROPIC
		
		if mat.has_meta("sbp_stencil_mode"):
			match mat.get_meta("sbp_stencil_mode"):
				"disabled": mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_DISABLED
				"outline": mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_OUTLINE
				"x-ray": mat.stencil_mode = BaseMaterial3D.STENCIL_MODE_XRAY
			
			if mat.get_meta("sbp_stencil_mode") != "disabled":
				mat.stencil_color = Color(mat.get_meta("sbp_coat_tint"))
				mat.stencil_outline_thickness = mat.get_meta("sbp_stencil_thickness")


func override_material_with_project_settings() -> void:
	
	
	for mat in all_materials:
		if mat.has_meta("sbp_override_project_settings"):
			continue
		
		for prop : String in SimpleBlenderPipeline.get_changed_material_override_properties():
			mat.set(prop.split("/")[1], ProjectSettings.get_setting("simple_blender_pipeline/material_overrides/" + prop))



func convert_float_arrays() -> void:
	if not ProjectSettings.get_setting("simple_blender_pipeline/settings/convert_float_arrays_to_vectors"):
		return
	
	for i in get_all_children_recursive(duplicate_scene):
		for gm in i.get_meta_list():
			if i.get_meta(gm) is Array:
				if i.get_meta(gm)[0] is float:
					match i.get_meta(gm).size():
						2: i.set_meta(gm, Vector2(i.get_meta(gm)[0], i.get_meta(gm)[1]))
						3: i.set_meta(gm, Vector3(i.get_meta(gm)[0], i.get_meta(gm)[1], i.get_meta(gm)[2]))
						4: i.set_meta(gm, Vector4(i.get_meta(gm)[0], i.get_meta(gm)[1], i.get_meta(gm)[2], i.get_meta(gm)[3]))



func tag_all_duplicate_children_with_blender_meta():
	for i in get_all_children_recursive(duplicate_scene):
		i.set_meta("blender", duplicate_scene.name)



func discard_collision_meshes():
	for mesh in duplicate_scene_meshes:
		if mesh.has_meta("sbp_discard_mesh"):
			if mesh.get_meta("sbp_discard_mesh"):
				mesh.queue_free()


func clean_up_metadata():
	if not ProjectSettings.get_setting("simple_blender_pipeline/settings/clean_up_mesh_instance_sbp_metadata"):
		return
	
	for child in duplicate_scene.get_children():
		for metakey in child.get_meta_list():
			if metakey == "sbp_blender_origin":
				continue
			
			if "sbp_" in metakey:
				child.remove_meta(metakey)
	
	
	# removing the metadata on materials currently breaks things, this could be fixed by duplicating all materials on import but I'm choosing not to do this at the moment.
	
	#for mat in all_materials:
		#for metakey in mat.get_meta_list():
			#if "sbp_" in metakey:
				#mat.remove_meta(metakey)


func recompose_scene() -> void:
	if not ProjectSettings.get_setting("simple_blender_pipeline/settings/auto_recompose_scene"):
		clean_up_spb_blender_origin()
		return
	
	var matched_originals : Array
	
	for i in duplicate_scene.get_children():
		
		var matching_nodes : Array = get_matching_nodes(i, i.owner)
		
		if matching_nodes.size() > 0:
			matched_originals.append(i)
		
		for mn in matching_nodes:
			var new_inst : Node = i.duplicate()
			var mn_parent : Node = mn.get_parent()
			var new_name : String = mn.name
			var mn_children : Array
			
			for mnc in mn.get_children():
				if not mnc.has_meta("blender"):
					mn_children.append(mnc.duplicate())
			
			
			mn.free()
			
			mn_parent.add_child(new_inst)
			new_inst.owner = duplicate_scene.owner
			
			
			
			if new_inst is Node3D:
				if move_all_origins_to_world_center:
					new_inst.position = Vector3.ZERO
				else:
					new_inst.position = new_inst.get_meta("sbp_blender_origin")
					new_inst.remove_meta("sbp_blender_origin")
			
			if i.get_child_count() > 0:
				var new_inst_children : Array = get_all_children_recursive(new_inst)
				
				for nic in new_inst_children:
					nic.owner = duplicate_scene.owner
			
			
			for mnc in mn_children:
				new_inst.add_child(mnc)
				mnc.owner = duplicate_scene.owner
				
				for mncc in get_all_children_recursive(mnc):
					mncc.owner = duplicate_scene.owner
			
			
			new_inst.name = new_name
		
		
		
	
	
	for i in matched_originals:
		i.free()
	
	clean_up_spb_blender_origin()
	
	if duplicate_scene.get_child_count() == 0:
		duplicate_scene.free()
	



func clean_up_spb_blender_origin() -> void:
	if ProjectSettings.get_setting("simple_blender_pipeline/settings/clean_up_mesh_instance_sbp_metadata"):
		for i in duplicate_scene.get_children():
			if i.has_meta("sbp_blender_origin"):
				i.remove_meta("sbp_blender_origin")



func get_matching_nodes(original_node:Node, search_point:Node, core_loop:bool = true) -> Array:
	if core_loop:
		return_nodes.clear()
	
	if search_point != null:
		for i in search_point.get_children():
			if i.has_meta("blender_unpacked"):
				continue
			
			if original_node.name in i.name:
				if i.get_class() == original_node.get_class():
					if i.has_meta("blender"):
						if i.get_meta("blender") == original_node.get_meta("blender"):
							return_nodes.append(i)
			
			if i.get_child_count() > 0:
				get_matching_nodes(original_node, i, false)
	
	
	
	return return_nodes




func get_all_children_recursive(root_node:Node, core_loop:bool = true) -> Array:
	if core_loop:
		recursive_children.clear()
	
	for i in root_node.get_children():
		recursive_children.append(i)
		
		if i.get_child_count() > 0:
			get_all_children_recursive(i,false)
	
	return recursive_children



func get_all_nodes_recursive_by_meta(root_node:Node,meta:String,core_loop:bool = true) -> Array:
	if core_loop:
		return_nodes.clear()
	
	for i in root_node.get_children():
		if i.has_meta(meta):
			return_nodes.append(i)
		
		if i.get_child_count() > 0:
			get_all_nodes_recursive_by_meta(i,meta,false)
	
	return return_nodes
