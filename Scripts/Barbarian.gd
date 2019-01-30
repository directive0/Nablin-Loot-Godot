extends KinematicBody2D

# state holder
var state = "asleep"

# animation counter
var counter = 0

# overall speed.
var speed = 50

#variable to hold the flippable elements of the scene
var body

# variables to hold scene objects
var hero
var stealth
var enemy

# variables to control hit checking
var hit

# variables to hold the target and self object ID for hit detection
var object
var thisobject

var LapList
var listlength
var animtimer = 0

#stores sprite frame info
var animframe

# store enemy and hero vectors
var enemyvect
var herovect

# store barbarian direction to flip or unflip sprite
var wasfacing = "left"
var facing = "left"

# variables to hold thrown item info like collision areas
var default_box_pos 
var current_box_pos = Vector2()

# variables to control various behaviours
var animationtimer = 0
var stuntimertime

# stores player death state (stops animating if player dead)
var dead = false

# stores whether we have hit with axe (so only one hit per swing)
var hitcat

# variable to store which sprite is being used
var cur_sprite

var stand_sprite
var lay_sprite


# signal to notify player of succesful hit.
signal hit

# shadow variables
var barbshadow
var barbshadowsleep
var shadowpos = Vector2(5,48)

#facing direction offsets
var regular = Vector2(0,0)
var flip = Vector2(30,0)

func _ready():
	lay_sprite = $body/layingdown
	stand_sprite = $body/standing
	# connect sprite animators
	cur_sprite = lay_sprite
	stand_sprite.set_visible(false)
	
	# connect our nodes to variables
	barbshadow = load("res://barbshadow.png")
	barbshadowsleep = load("res://barbsleepshadow.png")
	hero = get_tree().get_nodes_in_group("player")[0]
	stealth = get_tree().get_nodes_in_group("stealth")[0]

	# collect the initial setting of our floating hitbox
	default_box_pos = $standcol.get_position()
	
	# identify enemy as ourselves. A vestigial element of copying this out of Nablin code
	enemy = self
	
	# the following is used to make sure the axe hitbox flips to the other side of the barb when he faces right

	pass

func _process(delta):

	if state == "gameover":
		gameover()
		pass

	if state == "magichit":
		cur_sprite._set_playing(false)
		if $stunnedtimer.get_time_left() == 0:
			knockout()

	if state == "stunned":
		cur_sprite._set_playing(false)
		if $stunnedtimer.get_time_left() == 0:
			knockout()
		
	if state == "asleep":
		sleeping()
	
	# if awake
	if state == "woke":
		
		# get the current frame of the animated sprite
		animframe = cur_sprite.get_frame()
		
		# if we are at frame 1 of the startle animation (eyes just opened)
		if animframe < 2:
			# get stealth bar values
			var currentstealth = stealth.get_value()
			# still less than 300 add 1 to the wake up decision counter
			if currentstealth <= 300:
				animtimer += 1
			
			# begin wake up animation.
			wake_up()
		
		# if we are at frame two
		if animframe == 2:
			# if wake up counter (animtimer) has hit 14 counts of nablins being hidden
			# then go back to sleep and reset everything (player has stealthed succesfully)
			if animtimer >= 14:
				state = "asleep"
				animtimer = 0
				counter = 0
			
			# if stealthing not sufficient
			else:
				# if player too close
				if getplayerpos() <= 100:
					# arise
					state = "getup"
					move_up()
		# if we've reached frame 3 of animations
		if animframe >= 3:
			# arise
			state = "getup"
			move_up()
	
	# loop getup
	if state == "getup":
		get_up()
	
	if state == "searching":
		searching()
		if getplayerpos() <= 100:
			state = "aggro"
		
	# aggro loop
	if state == "aggro":
		# reset the counter and head for seek and destroy
		counter = 0
		seek_and_destroy()
		
		if check_for_hit() == true:
			state = "attack"

	if state == "attack":
			swingaxe()

func gameover():
	cur_sprite._set_playing(false) 

func switch_item():
	pass

func searching():

	animationtimer += .2
	cur_sprite._set_playing(false) 
	$body/effect.visible = false
	
	cur_sprite = stand_sprite
	cur_sprite.set_animation("Standing")
	cur_sprite.set_visible(true)
	cur_sprite._set_playing(true)
	lay_sprite.set_visible(false)

	if animationtimer <= 9:
		if facing == "left":
			face_right()
		else:
			face_left()
	
	#cur_sprite.flip_h = true

	if animationtimer >=10:
		#cur_sprite.flip_h = false
		if facing == "left":
			face_left()
		else:
			face_right()
	if animationtimer >=20:
		#cur_sprite.flip_h = true
		if facing == "left":
			face_right()
		else:
			face_left()
	if animationtimer >=30:
		#cur_sprite.flip_h = false
		if facing == "left":
			face_left()
		else:
			face_right()
	if animationtimer >=40:
		#cur_sprite.flip_h = true
		if facing == "left":
			face_right()
		else:
			face_left()
	if animationtimer >= 40:
		#cur_sprite.flip_h = false
		if facing == "left":
			face_left()
		else:
			face_right()
		state = "asleep"
		animationtimer = 0
		#move_down()
	


func dead():
	pass

func getplayerpos():
	enemyvect = enemy.position
	herovect = hero.position
	var distance = herovect.distance_to(enemyvect)
	return distance

func direction_to_target():
	var data = (hero.get_global_position() - self.get_global_position()).normalized()
	return data 

func shadowleft():
	pass
	#shadowpos = Vector2(5,48)
	#shadowpos = Vector2(12,54)
	#$shadow.set_position(shadowpos)

func shadowright():
	pass
	#shadowpos = Vector2(-10,48)
	#$bodyshadow.set_position(shadowpos)
	
func seek_and_destroy():
	# change shadows
	cur_sprite = stand_sprite
	cur_sprite.set_visible(true)
	cur_sprite._set_playing(true)
	lay_sprite.set_visible(false)
	#$shadow.set_position(shadowpos)
	$body/shadow.set_texture(barbshadow)

	# get vector to target
	var direction = direction_to_target()
	
	if direction.x < 0:
		facing = "left"
		#cur_sprite.flip_h = false
		#shadowleft()

	else:
		facing = "right"
		#cur_sprite.flip_h = true
		#shadowright()
		
	if facing == "right" and wasfacing == "left":
		wasfacing = "right"
		face_right()
		#current_box_pos.y = default_box_pos.y
		#current_box_pos.x = -(default_box_pos.x-10)
		#$standcol.set_position(current_box_pos)

	elif facing == "left" and wasfacing == "right":
		wasfacing = "left"
		face_left()
		#$standcol.set_position(default_box_pos)
		
	if getplayerpos() > 200:
		if stealth.get_value() <= 200:
			state = "searching"


	move_and_slide(direction*speed) 

	cur_sprite.set_animation("Walking")
	cur_sprite._set_playing(true) 
	
func face_left():
	$body.set_scale(Vector2(1,1))
	
func face_right():
	$body.set_scale(Vector2(-1,1))
	
func move_up():
	#var oldpos = get_global_position()
	#var newposx = oldpos[0] - 0
	#var newposy = oldpos[1] - 20
	#var newpos = Vector2(newposx,newposy)
	#set_global_position(newpos)
	pass
	
func move_down():
	#var oldpos = get_global_position()
	#var newposx = oldpos[0] - 0
	#var newposy = oldpos[1] + 20
	#var newpos = Vector2(newposx,newposy)
	#set_global_position(newpos)
	pass
	
func sleeping():
	cur_sprite = lay_sprite
	cur_sprite.set_visible(true)
	stand_sprite.set_visible(false)
	#var shadowpos = Vector2(0,0)
	#$body/shadow.set_position(shadowpos)
	$body/shadow.set_texture(barbshadowsleep)
	#cur_sprite.flip_h = false
	cur_sprite.set_animation("Sleeping")
	cur_sprite._set_playing(true) 
	$body/effect.visible = true

func wake_up():
	cur_sprite.set_animation("Awaking")
	cur_sprite._set_playing(true) 
	$body/effect.visible = false
	

func get_up():
	# change animation
	cur_sprite.set_animation("GetUp")
	
	# get our current animation frame
	animframe = cur_sprite.get_frame()

	# if animation just started
	if animframe == 0:
	
		#activate the standing sprite
		cur_sprite = stand_sprite
		cur_sprite.set_visible(true)
		cur_sprite._set_playing(true)
		lay_sprite.set_visible(false)
		
		# change our shadows
			#var shadowpos = Vector2(2,40)
			#$shadow.set_position(shadowpos)
		$body/shadow.set_texture(barbshadow)
	# if animation completed
	if animframe == 2:
		# start the attack mode
		state = "aggro"
	

func check_for_hit():
	
	hit = false
	
	object = hero.find_node("stand")
	thisobject = object.get_instance_id()

	
	
	LapList = $standcol.get_overlapping_areas()
	listlength = LapList.size()

	
	for i in range(listlength):
		if LapList[i].get_instance_id() == thisobject:
			hit = true
			
	return hit

func swingaxe():
	cur_sprite.set_animation("Attack")
	cur_sprite._set_playing(true) 
	animframe = cur_sprite.get_frame()
	
	if animframe == 2:
		if check_for_hit():
			if hitcat == 0:
				emit_signal("hit")
				hitcat = 1

	if animframe == 3:
		hitcat = 0
		state = "aggro"
		
func reset():
	cur_sprite.flip_h = false
	
	
func magicstun():
	state = "stunned"
	$stunnedtimer.start()
	
func hitstun():
	state = "stunned"
	$stunnedtimer.start()

func mushhit():
	state = "mushroomed"
	
	


func knockdown():
	pass
	
func knockout():
	state = "asleep"
	reset()
	move_down()

func _on_stealth_Awake():
	if state == "asleep":
		state = "woke"
	pass # replace with function body


func _on_health_death():
	dead = true



func _on_Player_gameover():
	state = "gameover"



func _on_timer_timesup():
	state = "gameover"
	#pass # Replace with function body.
