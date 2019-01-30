extends KinematicBody2D

var motion = Vector2()
var MoveSpeed = 200

# Create a list to store the motion information.
var actionlist = []
var stealth = 0
signal moving

var itemframe

# array holds our items
var itemsprites

#boolean to allow other objects to query if we are doing something that makes a noise
var ismoving = false

# stores location of the two character
var enemy
var hero

# stores location to latest attacker
var direction

#state machine holder
var state 

var knockcounter = 0
var health
var facing = "right"
var wasfacing = "right"
var default_box_pos 
var default_item_box
var current_box_pos = Vector2()
var timer
var knocking = false
var dead = false
var fire
signal gameover

func _ready():
	state = "idle"
	hero = self
	itemframe = get_node("/root/Root/itemframe")
	itemsprites = itemframe.get_itemsprites()
	enemy = get_node("/root/Root/YSort/Barbarian")
	health = get_node("/root/Root/health")
	timer = get_node("/root/Root/gentimer")
	fire = get_node("/root/Root/YSort/Fire")
	
	default_box_pos = $lootcol.get_position()
	default_item_box = $item.get_position()
	
	

func _physics_process(delta):
	keycheck()
	if state == "knockback":
		knocking_back()
	else:
		
		# check if dead, if not then check if looting, if not move around.
		if dead == false:
			if state == "loot":
				loot()
			else:
				moveplayer()
		else:
			dead()
	
		updatehitboxes()

func dead():
	$AnimatedSprite.set_animation("Death")
	$AnimatedSprite.playing = true
	emit_signal("gameover")

func knocking_back():
	$AnimatedSprite.set_animation("Knockback")
	if knockcounter < 10:
		if direction.x < 0.0:
			motion.x = 600
		else:
			motion.x = -600
		knockcounter += 1
	else:
		if dead == true:
			$AnimatedSprite.set_animation("Dead")
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
	if Input.is_action_pressed("loot"):
		actionlist.append("loot")

		

	
func moveplayer():
	
	if not actionlist.has("loot"):
		
		$AnimatedSprite.set_animation("default")
		
		if actionlist.has("left"):
			facing = "left"
			motion.x = -MoveSpeed
			ismoving = true
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.playing = true
			
		elif actionlist.has("right"):
			facing = "right"
			ismoving = true
			motion.x = MoveSpeed
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.playing = true
		
		if not actionlist.has("up") and not actionlist.has("down"):
			motion.y = 0
		
		if actionlist.has("up"):
			ismoving = true
			motion.y = -MoveSpeed
			$AnimatedSprite.playing = true
			
		elif actionlist.has("down"):
			ismoving = true
			$AnimatedSprite.playing = true
			motion.y = MoveSpeed
			
		if actionlist.size() == 0:
			ismoving = false
			motion.x = 0
			motion.y = 0
			$AnimatedSprite.playing = false
			$AnimatedSprite.frame = 1
		
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
		
		var current_item_pos = Vector2()
		
		current_item_pos.y = default_item_box.y
		current_item_pos.x = default_item_box.x
		current_box_pos.y = default_box_pos.y
		current_box_pos.x = -default_box_pos.x

		$lootcol.set_position(current_box_pos)
	elif facing == "left" and wasfacing == "right":

		wasfacing = "left"
		$item.set_por
		$lootcol.set_position(default_box_pos)

func use():
	$item.use()
	

func loot():

	emit_signal("moving")
	$AnimatedSprite.set_animation("Loot")
	$AnimatedSprite.playing = true
	
	var LapList = $stand.get_overlapping_areas()
	var hero
	var object
	var thisobject
	var listlength
	var hit = false

	if $AnimatedSprite.get_frame() == 1:

		object = enemy.find_node("sleepcol")
		thisobject = object.get_instance_id()

		LapList = $lootcol.get_overlapping_areas()

		listlength = LapList.size()
		for i in range(listlength):
			
			if LapList[i].get_instance_id() == thisobject:
				
				#register a succesful loot internally for the item bubble
				hit = true
				
				#tell the item controller that a new item was looted.
				itemframe.newitem()
				var itemgot = itemframe.get_item()
				$itembubble.get_item(itemgot[3])
				
				
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.set_animation("default")
		state = "idle"



func _checkstealth():
	stealth = get_node("Root/UI/stealth")
	#stealth._setlev(20)


func _on_Barbarian_hit():
	health.hit()
	state = "knockback"

	direction = distance_to_target(enemy)

func _on_gentimer_timeout():
	pass # replace with function body


func _on_health_death():
	dead = true
	pass # replace with function body

func get_state():
	return state

func _on_Fire_firehit():
	if state != "knockback":
		health.hit()
		state = "knockback"
		direction = distance_to_target(fire)

