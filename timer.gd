extends Node
var remaining
var lasttime
signal timesup
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$gametimer.start()
	lasttime = $gametimer.get_time_left()
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	# get the timers remaining time and default time
	remaining = int($gametimer.get_time_left())
	var was = int($gametimer.get_wait_time())
	
	# holds time (in seconds) converted to string and text to be appended to show time next to hourglass
	var stringforlabel = str(remaining) + " secs"
	
	# gives ratio of remaining to default
	var glassperc = float(remaining) / was
	
	# attempt to regiment particle effects. Abandoned
	#var difference = lasttime - remaining
	#if difference > .0001 and glassperc != 0:
	#	$Particles2D.set_emitting(true)
	#	lasttime = remaining
	
	# write the text to the string.
	$RichTextLabel.set_text(stringforlabel)
	
	if glassperc == 0.8:
		$AnimatedSprite.set_frame(0)
	elif glassperc == 0.6:
		$AnimatedSprite.set_frame(1)
	elif glassperc == 0.4:
		$AnimatedSprite.set_frame(2)
	elif glassperc == 0.2:
		$AnimatedSprite.set_frame(3)
	elif glassperc == 0:
		$AnimatedSprite.set_frame(4)
		$Particles2D.set_emitting(false)
		emit_signal("timesup")

#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
