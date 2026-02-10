extends Control

@onready var v_box_container:VBoxContainer = $VBoxContainer

var attribute_display_packed_scene:PackedScene = preload("res://source/attributes_display/attribute_display.tscn")

var name_list:PackedStringArray = [
	"vigor",
	"strength",
	"dexterity",
	"intelligence",
	"mind",
	"faith"
]

func _ready() -> void:
	var scene_manager:Node3D = get_tree().root.get_node("SceneManager")
	var player:CharacterBody3D = scene_manager.get_node("Player")
	var attributes:Attributes = player.get_node("Attributes")
	for attribute_name in name_list:
		var attribute_number:int = attributes.get(attribute_name)
		var attribute_display_instance:Control = attribute_display_packed_scene.instantiate()
		v_box_container.add_child(attribute_display_instance)
		attribute_display_instance.name = attribute_name
		attribute_display_instance.get_node("NameLabel").text = str(attribute_name)
		attribute_display_instance.get_node("NumberLabel").text = str(attribute_number)
		
