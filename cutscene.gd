extends Control

@onready var cutscene_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	cutscene_player.play("Intro")

func _on_cutscene_finished(anim_name: StringName) -> void:
	match anim_name:
		"Intro":
			cutscene_player.play("Menu")
			
