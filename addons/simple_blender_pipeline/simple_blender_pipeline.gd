@tool
extends EditorPlugin
class_name SimpleBlenderPipeline


const SBP_SETTINGS := {
	"disable_addon": {
		"type": TYPE_BOOL,
		"default": false,
		"description": "Completely disables SimpleBlenderPipeline's functionality. Useful for if you want to import a few .blend files with the default import pipeline."
	},
	"print_updates": {
		"type": TYPE_BOOL,
		"default": true,
		"description": "Disables print messages when the addon runs."
	},
	"convert_float_arrays_to_vectors": {
		"type": TYPE_BOOL,
		"default": true,
		"description": "Converts float arrays from Blender into Vectors."
	},
	"use_specular_ior_as_metallic_specular": {
		"type": TYPE_BOOL,
		"default": true,
		"description": "Uses the specular IOR setting on Blender materials as the metallic_specular on Godot materials."
	},
	"auto_recompose_scene": {
		"type": TYPE_BOOL,
		"default": true,
		"description": "If you move unpacked nodes around your scene tree (reparenting them to other nodes) then this will make sure to maintain the scene composition after updating the .blend file. It is not recommended that you turn this setting off as it could break things."
	},
	"disable_project_material_overrides": {
		"type": TYPE_BOOL,
		"default": false,
		"description": "Disables the material override settings from overriding material settings on .blend file update. the material override settings only override if they are changed from thier default settings. So you do not need to disable this if you haven't changed anything in the material override settings tab."
	},
	"clean_up_mesh_instance_sbp_metadata": {
		"type": TYPE_BOOL,
		"default": true,
		"description": "Removes all metadata that is generated from this plugin after .blend file update. The only data that is not removed is the Blender metadata property. This property is used for the recomposition process and cannot be removed without breaking functionality."
	}
}


const SBP_ROOT_PATH := "simple_blender_pipeline/settings"
const ROOT_PATH := "simple_blender_pipeline/material_overrides"

# Exact ordered sections
const SECTIONS := [
	"Transparency", "Shading", "Vertex Color", "Albedo", "Metallic", "Roughness",
	"Emission", "Normal Map", "Bent Normal Map", "Rim", "Clearcoat", "Anisotropy",
	"Ambient Occlusion", "Height", "Subsurface Scatter", "Back Lighting", "Refraction",
	"Detail", "UV1", "UV2", "Sampling", "Shadows", "Billboard", "Grow",
	"Transform", "Proximity Fade", "Distance Fade", "Stencil", "Misc"
]

# Map property name heuristics to sections
const SECTION_KEYS := {
	"transparency": "Transparency",
	"alpha": "Transparency",
	"shading": "Shading",
	"vertex_color": "Vertex Color",
	"albedo": "Albedo",
	"metallic": "Metallic",
	"roughness": "Roughness",
	"emission": "Emission",
	"normal": "Normal Map",
	"bent_normal": "Bent Normal Map",
	"rim": "Rim",
	"clearcoat": "Clearcoat",
	"anisotropy": "Anisotropy",
	"ao": "Ambient Occlusion",
	"height": "Height",
	"subsurf": "Subsurface Scatter",
	"subsurface": "Subsurface Scatter",
	"backlight": "Back Lighting",
	"refraction": "Refraction",
	"detail": "Detail",
	"uv1": "UV1",
	"uv2": "UV2",
	"sampling": "Sampling",
	"shadow": "Shadows",
	"billboard": "Billboard",
	"grow": "Grow",
	"transform": "Transform",
	"proximity": "Proximity Fade",
	"distance_fade": "Distance Fade",
	"stencil": "Stencil"
}

static var MATERIAL_DEFAULTS := {}
static var active_scenes : Array
static var run : bool = false
static var post_import_names : Array

func _enter_tree():
	if not Engine.is_editor_hint(): return
	
	EditorInterface.get_resource_filesystem().resources_reimported.connect(func(resources:PackedStringArray):
		if ProjectSettings.get_setting("simple_blender_pipeline/settings/disable_addon"):
			return
		
		if not run:
			return
		
		run = false
		
		#print("RESOURCES REIMPORTED")
		
		if ProjectSettings.get_setting("simple_blender_pipeline/settings/print_updates"):
			print_addon_header()
		
		for i in range(active_scenes.size() - 1, -1, -1):
			if not is_instance_valid(active_scenes[i]):
				active_scenes.remove_at(i)
		
		var unupdated_scene_names : Array
		
		for i in active_scenes:
			for n in post_import_names:
				if n in i.name:
					
					if not i.is_inside_tree():
						if not unupdated_scene_names.has(i.owner.scene_file_path):
							unupdated_scene_names.append(i.owner.scene_file_path)
						
						if i.get_script() != (load("res://addons/simple_blender_pipeline/blend_file_unupdated.gd")):
							var move_all_origins_to_world_center = i.move_all_origins_to_world_center
							var blend_file = i.blend_file
							var blend_name = i.blend_name
							
							i.set_script(load("res://addons/simple_blender_pipeline/blend_file_unupdated.gd"))
							
							i.move_all_origins_to_world_center = move_all_origins_to_world_center
							i.blend_file = blend_file
							i.blend_name = blend_name
							
							
						continue
					
					i.run()
		
		post_import_names.clear()
		
		if ProjectSettings.get_setting("simple_blender_pipeline/settings/print_updates"):
			for i in unupdated_scene_names:
				print("Not Updated: " + "[" + i + "]")
		)
	
	_register_sbp_settings()
	_register_standard_material_defaults()
	ProjectSettings.save()



static func scan_for_un_updated_nodes():
	for i in range(active_scenes.size() - 1, -1, -1):
		if not is_instance_valid(active_scenes[i]):
			active_scenes.remove_at(i)
	
	var unupdated_scene_names : Array
	
	for i in active_scenes:
		if i.get_script() == (load("res://addons/simple_blender_pipeline/blend_file_unupdated.gd")):
			if not unupdated_scene_names.has(i.owner.scene_file_path):
				unupdated_scene_names.append(i.owner.scene_file_path)
	
	print_addon_header()
	
	if unupdated_scene_names.size() > 0:
		print("All Scenes With Un-Updated Blend Nodes:")
		for i in unupdated_scene_names:
			print("[" + i + "]")
	else:
		print("All Scenes Are Updated!")


static func print_addon_header():
	print(" ")
	print("--- " + "Simple Blender Pipeline " + str(Time.get_time_string_from_system()) + " ---")


func _register_sbp_settings():
	for key in SBP_SETTINGS.keys():
		var setting_path := "%s/%s" % [SBP_ROOT_PATH, key]
		var setting_data = SBP_SETTINGS[key]

		if not ProjectSettings.has_setting(setting_path):
			ProjectSettings.set_setting(setting_path, setting_data.default)
			ProjectSettings.set_initial_value(setting_path, setting_data.default)

		var info := {
			"name": setting_path,
			"type": setting_data.type,
			"description": setting_data.description
		}

		ProjectSettings.add_property_info(info)
		ProjectSettings.set_as_basic(setting_path, true)





func _register_standard_material_defaults():
	var material := StandardMaterial3D.new()
	var properties := material.get_property_list()
	
	MATERIAL_DEFAULTS.clear()
	# Prepare empty lists per section
	var sectioned_props := {}
	for i in range(SECTIONS.size()):
		sectioned_props[SECTIONS[i]] = []

	# Assign each property to a section
	for prop in properties:
		if not (prop.usage & PROPERTY_USAGE_EDITOR):
			continue
		if prop.name in ["resource_name", "resource_path", "script", "resource_local_to_scene", "render_priority", "next_pass"]:
			continue
		
		MATERIAL_DEFAULTS[prop.name] = material.get(prop.name)
		
		var section_name := _find_section_for_property(prop.name)
		sectioned_props[section_name].append(prop)

	# Register properties in ProjectSettings in exact order
	for i in range(SECTIONS.size()):
		var section_name = SECTIONS[i]

		# Numeric prefix ensures alphabetical order matches SECTIONS order
		var section_path := "%s/%02d_%s" % [ROOT_PATH, i, _sanitize(section_name)]

		for prop in sectioned_props[section_name]:
			var setting_path := "%s/%s" % [section_path, prop.name]

			# Only set the default if the setting does not exist yet
			if not ProjectSettings.has_setting(setting_path):
				var default_value = prop.default_value if prop.has("default_value") else material.get(prop.name)
				ProjectSettings.set_setting(setting_path, default_value)
				ProjectSettings.set_initial_value(setting_path, default_value)

			# Property info for UI
			var info := {
				"name": setting_path,
				"type": prop.type
			}
			if prop.has("hint"):
				info.hint = prop.hint
			if prop.has("hint_string"):
				info.hint_string = prop.hint_string

			ProjectSettings.add_property_info(info)
			ProjectSettings.set_as_basic(setting_path, true)



func _find_section_for_property(prop_name: String) -> String:
	var lower := prop_name.to_lower()
	for key in SECTION_KEYS.keys():
		if lower.contains(key):
			return SECTION_KEYS[key]
	
	if "blend_mode" in lower:
		return SECTION_KEYS["transparency"]
	if "cull_mode" in lower:
		return SECTION_KEYS["transparency"]
	if "depth_draw_mode" in lower:
		return SECTION_KEYS["transparency"]
	if "no_depth_test" in lower:
		return SECTION_KEYS["transparency"]
	if "depth_test" in lower:
		return SECTION_KEYS["transparency"]
	if "diffuse_mode" in lower:
		return SECTION_KEYS["shading"]
	if "specular_mode" in lower:
		return SECTION_KEYS["shading"]
	if "disable_ambient_light" in lower:
		return SECTION_KEYS["shading"]
	if "disable_fog" in lower:
		return SECTION_KEYS["shading"]
	if "disable_specular_occlusion" in lower:
		return SECTION_KEYS["shading"]
	if "texture_filter" in lower:
		return SECTION_KEYS["sampling"]
	if "texture_repeat" in lower:
		return SECTION_KEYS["sampling"]
	if "fixed_size" in lower:
		return SECTION_KEYS["transform"]
	if "use_point_size" in lower:
		return SECTION_KEYS["transform"]
	if "use_particle_trails" in lower:
		return SECTION_KEYS["transform"]
	if "use_z_clip_scale" in lower:
		return SECTION_KEYS["transform"]
	if "use_fov_override" in lower:
		return SECTION_KEYS["transform"]
	
	# Always map unmatched properties to the last section in SECTIONS ("Misc")
	return SECTIONS[SECTIONS.size() - 1]


static func _sanitize(name: String) -> String:
	return name.to_lower().replace(" ", "_")

static func get_changed_material_override_properties() -> Array:
	var changed := []

	for prop_name in MATERIAL_DEFAULTS.keys():
		for i in range(SECTIONS.size()):
			var section_prefix := "%02d_%s" % [i, _sanitize(SECTIONS[i])]
			var setting_path := "%s/%s/%s" % [
				ROOT_PATH,
				section_prefix,
				prop_name
			]

			if ProjectSettings.has_setting(setting_path):
				var current_value = ProjectSettings.get_setting(setting_path)
				if current_value != MATERIAL_DEFAULTS[prop_name]:
					changed.append("%s/%s" % [section_prefix, prop_name])
				break

	return changed


static func save_open_scene():
	var editor := EditorPlugin.new()
	var interface := editor.get_editor_interface()
	
	if not interface.has_method("save_scene"):
		return
	
	var root := interface.get_edited_scene_root()
	
	if root == null:
		return
	
	if root.scene_file_path.is_empty():
		return
	
	interface.call_deferred("save_scene")
