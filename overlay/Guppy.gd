extends CharacterBody2D
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _label = $Label

var _username = "2natown"
var _speed = Vector2(0,0)
var _value = Vector2(0,0)
var _direction = Vector2(0,0)
var _moveTime = 0.0
var _waitTime = 0.0
var avatarType = str(randi_range(1,3))
var idleName = "idle_" + avatarType
var walkName = "walk_" + avatarType
var expireName = "expire_" + avatarType
var expirationTimer = 60.0
var expired = false

func keep_alive():
	expirationTimer = 60.0

func init(p_position:Vector2,p_username:String):
	position = p_position
	_username = p_username

func _ready():
	_label.text = _username
	_animated_sprite.play(idleName)

func _process(delta):
	expirationTimer -= delta
	
	if !expired:
		if expirationTimer <= 0:
			expired = true
			_animated_sprite.play(expireName)
			
		if _moveTime <= 0 && _waitTime <= 0:
			randomize_speed_and_direction()
			
			if _direction.x >= 0.0:
				_animated_sprite.flip_h = false
			else:
				_animated_sprite.flip_h = true
			
			_animated_sprite.play(walkName)
		elif _moveTime > 0:
			var pos = position + _direction * _speed * delta
			position.x = clamp(pos.x,32,1888)
			position.y = clamp(pos.y,964,1032)
			_moveTime -= delta
		
			if _moveTime <= 0:
				_waitTime = randf_range(2.0,5.0)
				_animated_sprite.play(idleName)
		else:
			_waitTime -= delta
	elif expirationTimer >= 0:
		expired = true

func randomize_speed_and_direction():
		_speed = randf_range(50, 100)
		
		var x = randf_range(-1, 1)
		var y = randf_range(-0.5,0.5)
		
		_direction = Vector2(x, y).normalized()
		_moveTime = randf_range(0.5,2.0)


func guppy_on_animated_sprite_2d_animation_finished():
	if _animated_sprite.animation == expireName:
		queue_free()
