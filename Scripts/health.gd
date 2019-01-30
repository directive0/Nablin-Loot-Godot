extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var healthval = 6.0
var heartlist = []
signal death

func _ready():
	heartlist.append($heart1)
	heartlist.append($heart2)
	heartlist.append($heart3)
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func restore():
	healthval += 1
	
func hit():
	healthval -= 1

func _process(delta):
	
	var nohearts = healthval / 2.0
	#print("nohearts = ", nohearts)
	
	for i in range(3):
		#print(nohearts)
		# checks the hearts value is greater than 1 each time through the loop. If it is isn't it will draw a half heart. If the number is zero no heart is drawn.
		if nohearts >= 1.0:
			heartlist[i].visible = true
			heartlist[i].set_texture(load("res://heart.png"))
		if nohearts == 0.5:
			heartlist[i].visible = true
			heartlist[i].set_texture(load("res://halfheart.png"))
		if nohearts <= 0.0:
			heartlist[i].visible = false
		nohearts -= 1
	if healthval == 0:
		emit_signal("death")
		
	global.situation["health"] = healthval
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
