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

var praise = ["Very good", "Well done", "Impressive", "Sufficient", "That will do", "Continue",\
 "Good enough", "You get to live"]

var shame = ["Pathetic", "Worthless", "You dissapoint me", "Sad!", "You disgust me",\
 "I'm apalled", "Failure", "Insufficient"]

var quips = ["Elves man, they weird me out.", "Sucker", "Guess its time for a wiz", "Abraca-doofus!", "Heh, still got it", "Now to relax","Boom, magic!", "Better bring me back some 'shrooms"]

# create an array with a number of titles
var nights = ["First", "Second", "Last"]
var objectives = [["Just a Quick Nab", "In 1 Minute", "Get 5,000 points","Take no damage", 60, 5000, 6],\
["A Little Harder", "In 45 seconds", "Get 10,000 points","Use a potion", 45, 10000, 1],\
["Nab As a Hatter", "In 30 seconds", "Get 10,000 points","Find the orb", 30, 10000, 1]]


# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$quip.set_visible(false)
	# Start the animation timer
	timer.start()
	
	# Set the goals for the intertitle to display, derived from the global singleton
	if global.situation["night"] <= 2:
		goal = objectives[global.situation["night"]]
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
	var outcome = "default"
	var quip
	
	randomize()
	var rando = randi() % 8
	if global.situation["state"] == 2:
		
		if global.situation["night"] == 0:
			#for the first night:
			if global.situation["score"] < goal[5]:
				score = " - Failed"
				complete += -1
			else:
				complete += 1
				score = " - Succeeded"
				
			
			if global.situation["health"] < goal[6]:
				complete += -1
				other = " - Failed"
			else:
				complete += 1
				other = " - Succeeded"
		
		if global.situation["night"] == 1:
			#for the first night:
			if global.lastnight["score"] < goal[5]:
				score = " - Failed"
				complete += -1
			else:
				complete += 1
				score = " - Succeeded"
				
			
			if global.lastnight["flaskused"] < goal[6]:
				complete += -1
				other = " - Failed"
			else:
				complete += 1
				other = " - Succeeded"
				
		if global.situation["night"] == 2:
			#for the first night:
			if global.situation["score"] < goal[5]:
				score = " - Failed"
				complete += -1
			else:
				complete += 1
				score = " - Succeeded"
				
			
			if global.lastnight["orbfound"] == true:
				complete += 1
				other = " - Succeeded"
			else:
				complete += -1
				other = " - Failed"

		
		print(complete)
		if complete < 2:
			response = shame
		else:
			response = praise
			global.situation["nightswon"] += 1
		outcome = response[rando]
		
	if global.situation["state"] == 0:
		outcome = warning[rando]
	
	quip = quips[rando]

	
	$top/night_label.set_text(nights[global.situation["night"]] + " Night")
	$objectives/title.set_text(goal[0])
	$objectives/VBoxContainer/obj1.set_text(goal[1])
	$objectives/VBoxContainer/obj2.set_text(goal[2]+score)
	$objectives/VBoxContainer/obj3.set_text(goal[3]+other)
	print("intertitle - set outcome after reset ", global.situation)
	$outcome2.set_text(outcome)
	$quip.set_text(quip)
	
func get_time_perc():
	var total = timer.get_wait_time()
	var remaining = timer.get_time_left()
	
	return 1 - (remaining / total)
	
func fade():
	#print(get_time_perc())
	if get_time_perc() < 1:
		#$top/night_label.set_modulate(Color(1, 1, 1, get_time_perc()))
		pass
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
	
	#timeleft = timer.get_time_left()
	

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass


func _on_title_timeout():
	$objectives/title.set_visible(true)

	$obj1.start()
	pass # replace with function body

func _on_obj1_timeout():
	$objectives/VBoxContainer/obj1.set_visible(true)
	$obj2.start()
	pass # replace with function body

func _on_obj2_timeout():
	$objectives/VBoxContainer/obj2.set_visible(true)
	$obj3.start()
	pass # replace with function body

func _on_obj3_timeout():
	$objectives/VBoxContainer/obj3.set_visible(true)
	ready = true
	$outcome.start()
	pass # replace with function body

func play_animation():
	$objectives.set_visible(false)
	$reminder.set_visible(false)
	$outcome2.set_visible(false)
	$AnimationPlayer.play("shoot")
	playing = true

func _on_AnimationPlayer_animation_finished(anim_name):
	done = true
	ready = false

func _on_outcome_timeout():
	if global.situation["state"] == 2:
		$outcome2.set_visible(true)
	$reminder.set_visible(true)
	$outcome2.set_visible(true)
	
	#if global.situation["state"] == 2:


