extends Area2D

signal show_dialogue()


func _ready() -> void:
	var __ = connect("show_dialogue", get_parent().get_parent().get_parent(), "_show_pre_final_battle_dialogue")


func _on_PlayerDetectorPreFinalBattleDialogue_body_entered(_player: KinematicBody2D) -> void:
	if not SavedData.pre_final_battle_dialogue_watched:
		SavedData.pre_final_battle_dialogue_watched = true
		emit_signal("show_dialogue")
