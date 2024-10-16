extends CharacterBody2D

enum STATES {IDLE, WALK, JUMP}

@export var walkSpeed: int
@export var jumpStrength: int

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var currentState: STATES = STATES.IDLE
var direction: int = 0
var waitTimer: Timer = Timer.new()

func _ready() -> void:
	add_child(waitTimer)
	waitTimer.autostart = true
	waitTimer.one_shot = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		handle_state_transition()  

	# Move character
	direction = Input.get_axis("left", "right")
	velocity.x = walkSpeed * direction
	move_and_slide()

	animate()

func handle_state_transition() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		change_state(STATES.JUMP)
	elif direction != 0 and is_on_floor():
		change_state(STATES.WALK)
	elif direction == 0 and is_on_floor():
		
		change_state(STATES.IDLE)

func change_state(new_state: STATES) -> void:
	currentState = new_state
	match currentState:
		STATES.JUMP:
			velocity.y = -jumpStrength
		STATES.WALK:
			if waitTimer.is_stopped():
				waitTimer.stop()
				waitTimer.start(6)
		_:
			pass

func animate():
	match currentState:
		STATES.IDLE:
			sprite_2d.play("idle" if !waitTimer.is_stopped() else "idle2")
		STATES.WALK:
			flip_h()
			sprite_2d.play("run")
		STATES.JUMP:
			sprite_2d.play("jump")

func flip_h():
	if direction < 0:
		sprite_2d.flip_h = true
	elif direction > 0:
		sprite_2d.flip_h = false
