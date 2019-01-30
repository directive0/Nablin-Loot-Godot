extends Control

onready var timer = $fade_in
var timeleft = 0
var state = 0
var titletext = ""
var goal
var ready = false
var done = false
var touched = false
var playing = false

var warning = ["Don't fail me", "I'll be watching", "You'd better hurry",\
 "Don't layabout", "Get the lead out", "On with it", "Any day now", "Hop to it"]

var praise = ["You are free, little nablin"]

var shame = ["You have failed me"]


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
	# Start the animation timer
	timer.start()
	
	# Set the goals for the intertitle to display, derived from the global singleton
	set_text(goal)

func eval_goals(goals):
	pass
	
	
func set_text(goal):
	
	# need to determine if player has achieved goals.
	# pull goals for this night
	# goal[4-6] is 4) time limit, 5) score required, 6) other requirement.
	var score = ""
	var other = ""
	var complete = 0
	var response
	var outcome

	
	if global.situation["nightswon"] == 3:
		outcome = "Success"
		response = praise[0]
	else:
		outcome = "Failure"
		response = shame[0]
		
	complete = str(global.situation["nightswon"]) + "/3"
	
	$top/night_label.set_text(outcome)
	$objectives/title.set_text(complete)
	#$objectives/VBoxContainer/obj1.set_text(goal[1])
	#$objectives/VBoxContainer/obj2.set_text(goal[2]+score)
	#$objectives/VBoxContainer/obj3.set_text(goal[3]+other)
	$objectives/outcome.set_text(response)
	
func get_time_perc():
	var total = timer.get_wait_time()
	var remaining = timer.get_time_left()
	
	return 1 - (remaining / total)
	
func fade():
	#print(get_time_perc())
	if get_time_perc() < 1:
		$top/night_label.set_modulate(Color(1, 1, 1, get_time_perc()))
	if get_time_perc() == 1:
		if state == 0:
			$title.start()
			state = 1
	
func _input(event):
   # Mouse in viewport coordinates
   if event is InputEventScreenTouch and ready == true:
       touched = true
	
func _process(delta):
	
	fade()
	
	timeleft = timer.get_time_left()
	

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_title_timeout():
	$objectives/title.set_visible(true)
	
	$obj1.start()
	pass # replace with function body

func _on_obj1_timeout():
	$objectives/VBoxContainer/obj1.set_visible(true)
	ready = true
	$outcome.start()


func _on_obj2_timeout():
	$objectives/VBoxContainer/obj2.set_visible(true)
	$obj3.start()


func _on_obj3_timeout():
	$objectives/VBoxContainer/obj3.set_visible(true)

	pass # replace with function body

func play_animation():
	$reminder.set_visible(false)
	$AnimationPlayer.play("shoot")
	playing = true

func _on_AnimationPlayer_animation_finished(anim_name):
	done = true
	ready = false

func _on_outcome_timeout():
	$reminder.set_visible(true)
	
	#if global.situation["state"] == 2:
	$objectives/outcome.set_visible(true)

