@tool
@icon("res://addons/simple_blender_pipeline/blend_node_icon_warn.png")
extends Node
class_name BlendFileUnupdated

@export_category("This node is not up to date!")

@export_tool_button("   Reload     ") var force_reload : Callable = run


@export_category("Press Reload!")

@export_subgroup("additional_settings")
## If true, this will move all blender nodes to global_position = Vector3.ZERO
@export var move_all_origins_to_world_center : bool = false

@export_subgroup("scan for non updated scenes")
@export_tool_button("    Scan    ") var scan : Callable = scan_for_unupdated_nodes

@export_subgroup("plugin data")
@export var blend_file : String
@export var blend_name : String

func scan_for_unupdated_nodes():
	SimpleBlenderPipeline.scan_for_un_updated_nodes()

func _ready() -> void:
	if Engine.is_editor_hint():
		register_link()
	else:
		queue_free()


func register_link():
	if not SimpleBlenderPipeline.active_scenes.has(self):
			SimpleBlenderPipeline.active_scenes.append(self)


func run():
	name = name + "_sbp_removing"
	
	var blend_unpacker_inst := Node.new()
	owner.add_child(blend_unpacker_inst)
	blend_unpacker_inst.owner = owner
	blend_unpacker_inst.set_script(load("res://addons/simple_blender_pipeline/blend_file_unpacker.gd"))
	
	blend_unpacker_inst.move_all_origins_to_world_center = move_all_origins_to_world_center
	blend_unpacker_inst.blend_file = blend_file
	blend_unpacker_inst.blend_name = blend_name
	
	queue_free()
	
	
	
