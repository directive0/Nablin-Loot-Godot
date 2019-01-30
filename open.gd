extends Node
var timeleft
var fade_done = false
var d_opened = false
var touched = false
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	print("Welcome to Nablin Loot v1.0")
	print("By: D0 and Diz")
	print("loading global values")
	#playerstats = {"health": 6, "speed": 200, "stealth": 10}

	#OS.set_window_fullscreen(true) 
	#OS.set_window_maximized(true) 
	
	$Timer.start()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if fade_done == false:
		timeleft = 1 - ($Timer.get_time_left() / $Timer.get_wait_time())
		var modulation = Color(timeleft,timeleft,timeleft)
		$Sprite.set_modulate(modulation)
		$info.set_modulate(modulation)
		$reminder.set_modulate(modulation)
		
	var actionlist = keycheck()

	if actionlist.has("space"):
		get_tree().change_scene("res://manager.tscn")
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
   # Mouse in viewport coordinates
   if event is InputEventScreenTouch:
       touched = true
	
func keycheck():
	#_checkstealth()
	var actionlist = []

	if Input.is_action_pressed("loot"):
		actionlist.append("space")
	return actionlist
		
func fade_check():
	return fade_done
	
func _on_Timer_timeout():
	$Timer2.start()
	fade_done = true
	var modulation = Color(1,1,1)
	$Sprite.set_modulate(modulation)


func _on_AcceptDialog_confirmed():
	get_tree().change_scene("res://manager.tscn")
	pass # replace with function body


func _on_AcceptDialog_focus_entered():
	d_opened = true

func _on_TouchScreenButton_pressed():
	$WindowDialog.popup()
	$start.set_visible(false)
	pass # Replace with function body.


func _on_TouchScreenButton2_pressed():
	get_tree().change_scene("res://manager.tscn")
	pass # Replace with function body.


func _on_WindowDialog_popup_hide():
	$start.set_visible(true)
	pass # Replace with function body.
