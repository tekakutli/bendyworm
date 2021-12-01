extends "res://Scenes/FSM/FSMStateBase.gd"

onready var proxy_target = $TitleProxyTarget # TODO may go wrong if you re-enter the intro state??? (_ready may not be called before enter()???)
# NOTE - you re-enter the intro state after beating the game, right?

var can_press_start = false

func enter():
	.enter()
	
	Music.play("MainSong")
	
	remove_child(proxy_target)
	UI.add_proxy(proxy_target)
	
func _unhandled_input(event):
	if can_press_start:
		proxy_target.on_unhandled_input(event)
	# propagate all your input events to the proxytarget!
	# since nodes in a viewport don't get any input events: see https://github.com/godotengine/godot/issues/17326#issuecomment-431186323 for a potential work around
	
func exit():
	proxy_target.queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	
	match anim_name:
		"TitleScreenAnim":
			can_press_start = true
		"TitleScreenPressStart":
			Globals.main.fsm.switch_to_state("MainGame")
