extends Node2D

var difficulty
var luck
onready var new_bush = load("res://Bush.tscn")

var testloc = Vector2(200,200)
var lock = 0
var endoflevel = false
var gameover = false
var outtatime = false
var goal


func set_parameters(goaldata):
	goal = goaldata
	$timer/gametimer.set_wait_time(goal[4])

func add_bush(location):
	var bush = new_bush.instance()
	bush.set_position(location)
	$YSort.add_child(bush)

func _on_Player_gameover():
	if lock == 0:
		$controls.queue_free()
		lock = 1
	gameover = true
	$Control2/Label/reminder.set_visible(true)
	#grab the score from the level

	global.situation["health"] = $health.healthval
	

func _on_timer_timesup():
	outtatime = true
	
func plant_shrooms():
	pass

func _on_Area2D_input_event(viewport, event, shape_idx):
	print("hit")
	endoflevel = true
	pass # Replace with function body.


func _on_TouchScreenButton_pressed():
	global.situation["score"] += $score.score
	global.lastnight["score"] = $score.score
	if gameover == true:
		global.highscore()
		get_tree().change_scene("res://open.tscn")
		
	else:

		endoflevel = true
