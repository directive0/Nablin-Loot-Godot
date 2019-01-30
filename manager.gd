extends Node

# Manager switches between intertitles and the level.
var levelsong = load("res://sounds/Constance.ogg")
var titlesong = load("res://sounds/Faceoff.ogg")
onready var titleframe = load("res://intertitle.tscn")
onready var level = load("res://level.tscn")
onready var endframe = load("res://endofgame.tscn")
var current_frame
var goal
var touched = false
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	global.situation["state"] = 0
	print("manager start values = ", global.situation)
	# When first loaded load a title
	add_title()


func add_level():
	$AudioStreamPlayer.set_stream(levelsong)
	$AudioStreamPlayer.play()
	current_frame = level.instance()
	current_frame.set_parameters(global.goal)
	add_child(current_frame)
	
func remove_level():
	var target = get_node("Root")
	remove_child(target)
			
func add_title():
	$AudioStreamPlayer.set_stream(titlesong)
	$AudioStreamPlayer.play()
	current_frame = titleframe.instance()
	add_child(current_frame)

func add_gameover():
	current_frame = endframe.instance()
	add_child(current_frame)

func returntotitle():
	global.reset()
	global.situation["state"] == 0
	get_tree().change_scene("res://open.tscn")

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventScreenTouch:
		if event.pressed == true:
			touched = true
			print("touched = true")
		else:
			touched = false

func remove_title():
	var target = get_node("intertitle")
	remove_child(target)
			
func _process(delta):
	
	# global states: 0 is title, 1 is in game, 2 is end of game debrief, 3 is end of game outcome screen
	#print("night = ", global.situation["night"])
	
	if global.situation["state"] == 0:
		var title = get_node("intertitle")
		# show title info and wait for loot command
		if title.done == true:
			# copy the current goals to the variable so the level objcet can request it
			global.goal = title.goal
			# once pressed remove the intertitle and add a level
			remove_title()
			add_level()
			
			# change the state to signify we are now in game
			global.situation["state"] = 1
			
		if touched == true and title.ready == true and title.playing == false:
			title.play_animation()

	
	# while in game
	if global.situation["state"] == 1:
		# wait for the game to end
		if current_frame.endoflevel == true:
			# set the global state to debriefing
			global.situation["state"] = 2
			# remove level and load up an intertitle
			
			remove_level()
			add_title()
	
	# when in debrief mode
	if global.situation["state"] == 2:

		if touched == true and get_node("intertitle").ready == true:
			# once pressed remove the intertitle
			remove_title()
			
			#if we are not on the last night
			if global.situation["night"] <= 1:
				
				# increment the night counter
				global.situation["night"] += 1
				
				# change the state to signify we are now in a game state
				global.situation["state"] = 0
				
				#update the final tally for the scorepage
				global.tally()
				add_title()
			else:
				# if this is the last night.
				global.situation["state"] = 3
				add_gameover()

	if global.situation["state"] == 3:
		
		var title = get_node("intertitle")
		# show title info and wait for loot command
		if title.done == true:
			# copy the current goals to the variable so the level objcet can request it
			global.goal = title.goal
			# once pressed remove the intertitle and add a level
			remove_title()
			returntotitle()
			
			# change the state to signify we are now in game
			global.situation["state"] = 1
			
		if touched == true and title.ready == true and title.playing == false:
			title.play_animation()