extends KinematicBody2D

var motion = Vector2()
var MoveSpeed = 200

# Create a list to store the motion information.
var actionlist = []
var stealth = 0
signal moving

var last_loot = Vector2()

var item
var itemframe
var itemsprites

var ismoving = false
var enemy
var hero
var direction

# object to hold the location of the main sprite
var mainsprite

# state keeper.
var state 

# ticks for knockback. This should just be a timer object prolly
var knockcounter = 0
var health

# facing variables to monitor and control facing
var facing = "right"
var wasfacing = "right"

var default_box_pos 
var current_box_pos = Vector2()

var timer

# Specific variables for some actions outside of the state keeper
var knocking = false
var dead = false
var timesup = false

var fire
signal gameover

func _ready():
	state = "idle"
	hero = self
	itemframe = get_tree().get_nodes_in_group("itemframe")[0]
	itemsprites = itemframe.get_itemsprites()
	enemy = get_tree().get_nodes_in_group("enemy")[0]
	health = get_tree().get_nodes_in_group("health")[0]
	timer = get_tree().get_nodes_in_group("timer")[0]
	fire = get_tree().get_nodes_in_group("fire")[0]
	
	item = $body/item
	mainsprite = $body/AnimatedSprite
	default_box_pos = $body/lootcol.get_position()
	

func _physics_process(delta):
	keycheck()
	if state == "knockback":
		knocking_back()
	else:
		# check if dead, if not then check if looting, if not move around.
		if dead == false:
			if timesup == false:
				if state == "loot":
					loot()
				else:
					moveplayer()
		else:
			dead()
	
		updatehitboxes()

func dead():
	mainsprite.set_animation("Death")
	mainsprite.playing = true
	emit_signal("gameover")

func knocking_back():
	mainsprite.set_animation("Knockback")
	if knockcounter < 10:
		if direction.x < 0.0:
			face_left()
			motion.x = 600
		else:
			face_right()
			motion.x = -600
		knockcounter += 1
	else:
		if dead == true:
			mainsprite.set_animation("Dead")
		motion.x = 0
		motion.y = 0
		knockcounter = 0
		state = "idle"
	
	move_and_slide(motion)

func isdead():
	return dead
	
func keycheck():
	#_checkstealth()
	actionlist = []

	
	if Input.is_action_pressed("ui_right"):
		actionlist.append("right")
	if Input.is_action_pressed("ui_left"):
		actionlist.append("left")
	if Input.is_action_pressed("ui_up"):
		actionlist.append("up")
	if Input.is_action_pressed("ui_down"):
		actionlist.append("down")
	if Input.is_action_pressed("ui_down"):
		actionlist.append("down")
	if Input.is_action_pressed("ui_up_right"):
		actionlist.append("up")
		actionlist.append("right")
	if Input.is_action_pressed("ui_up_left"):
		actionlist.append("up")
		actionlist.append("left")
	if Input.is_action_pressed("ui_down_left"):
		actionlist.append("down")
		actionlist.append("left")
	if Input.is_action_pressed("ui_down_right"):
		actionlist.append("down")
		actionlist.append("right")
	if Input.is_action_just_pressed("loot"):
		actionlist.append("loot")
	if Input.is_action_just_pressed("use_item"):
		actionlist.append("item")
	if Input.is_action_just_released("item_left"):
		#itemframe.item_left()
		timesup = true
	if Input.is_action_just_released("item_right"):
		itemframe.item_right()

func face_left():
	$body.set_scale(Vector2(-1,1))
	
func face_right():
	$body.set_scale(Vector2(1,1))

func moveplayer():
	#print(actionlist)
	if not actionlist.has("loot"):
		
		mainsprite.set_animation("default")
		if actionlist.has("item"):
			item()
			
		if actionlist.has("left"):
			if facing == "right":
				face_left()
			facing = "left"
			motion.x = -MoveSpeed
			ismoving = true
			#mainsprite.flip_h = true
			
			mainsprite.playing = true
			
		elif actionlist.has("right"):
			if facing == "left":
				face_right()
			facing = "right"
			ismoving = true
			motion.x = MoveSpeed
			#mainsprite.flip_h = false

			mainsprite.playing = true
		
		if not actionlist.has("up") and not actionlist.has("down"):
			motion.y = 0
		
		if actionlist.has("up"):
			ismoving = true
			motion.y = -MoveSpeed
			mainsprite.playing = true
			
		elif actionlist.has("down"):
			ismoving = true
			mainsprite.playing = true
			motion.y = MoveSpeed
		
		if actionlist.size() == 0:
			ismoving = false
			motion.x = 0
			motion.y = 0
			mainsprite.playing = false
			mainsprite.frame = 1
		
		if ismoving:
			emit_signal("moving")
			
		move_and_slide(motion)
	else:
		state = "loot"
		
func distance_to_target(target):
	var data = (target.get_global_position() - self.get_global_position()).normalized()
	return data 

func updatehitboxes():
	if facing == "right" and wasfacing == "left":
		wasfacing = "right"

		#current_box_pos.y = default_box_pos.y
		#current_box_pos.x = -default_box_pos.x

		#$lootcol.set_position(current_box_pos)
	#elif facing == "left" and wasfacing == "right":

		#wasfacing = "left"
		#$lootcol.set_position(default_box_pos)

func item():
	item.use()
	
func loot():
	var this_loot = get_global_transform().origin
	
	
	emit_signal("moving")
	mainsprite.set_animation("Loot")
	mainsprite.playing = true
	
	var LapList = $stand.get_overlapping_areas()
	var hero
	var object
	var thisobject
	var listlength
	var hit = false

	if mainsprite.get_frame() == 1:

		object = enemy.find_node("sleepcol")
		thisobject = object.get_instance_id()

		LapList = $body/lootcol.get_overlapping_areas()

		listlength = LapList.size()
		for i in range(listlength):
			
			if LapList[i].get_instance_id() == thisobject:
				
				#register a succesful loot internally for the item bubble
				hit = true
				$get._set_playing(true) 
				#tell the item controller that a new item was looted.
				itemframe.newitem()
				var itemgot = itemframe.get_item()
				# Send the item sprite to the item bubble
				if typeof(itemgot) == TYPE_ARRAY:
					# gives the itembubble a copy of the sprite for the item
					$body/itembubble.get_item(itemgot[3])
				
				
		mainsprite.set_frame(0)
		mainsprite.set_animation("default")
		state = "idle"



func _on_Barbarian_hit():
	health.hit()
	state = "knockback"

	direction = distance_to_target(enemy)

func _on_health_death():
	dead = true

func get_facing():
	return facing
	
func get_state():
	return state

func _on_Fire_firehit():
	if state != "knockback":
		health.hit()
		state = "knockback"
		direction = distance_to_target(fire)

func _on_timer_timesup():
	timesup = true


