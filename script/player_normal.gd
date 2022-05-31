extends KinematicBody2D



var max_speed=300.0 # 最高速度
var old_speed# 保存标准速度，以便速度发生修改时使用
var player_transform=Vector2.ZERO #人物初始运动向量
var Time=0#时间计算-大多用于计算加速度
var health_bars=100
const GRAVITY=400 #自定义下落速度
var is_jumping=false# 跳跃判定
var move_direction=0

onready var player_anim=$AnimationPlayer#获取场景树中的动画器
onready var player=$player# 获取场景树中的人物对象

# Called when the node enters the scene tree for the first time.
func _ready():
	# 初始化游戏
	old_speed=max_speed
	health_bars=100
	player_anim.play("player_stand")
	pass # Replace with function body.
	
func _physics_process(delta):
	move_and_slide(player_transform,Vector2.UP)
	

func _process(delta):
	var speed_control=Input.get_action_strength("player_squat")+Input.get_action_strength("player_jump")+Input.get_action_strength("player_Flying")
	if speed_control==0:
		max_speed=old_speed
	#重力部分
	Time+=0.1
	player_transform.y+=GRAVITY*delta*Time# 每帧向下移动，模仿重力
	player_move(delta)
	player_jump(delta)
	animation_control()
	#print(player_transform.y)
	print(max_speed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func player_move(delta):
	#人物移动部分
	move_direction=Input.get_action_strength("player_right")-Input.get_action_strength("player_left")
	player_transform.x=move_toward(player_transform.x,move_direction*max_speed,(max_speed/0.2)*delta)
	
	
func player_jump(delta):
	# 跳跃
	if Input.is_action_pressed("player_jump") and is_jumping==false:
		player_transform.y=-GRAVITY
		is_jumping=true
	elif is_on_floor():
		player_transform.y=0
		Time=0
		is_jumping=false

func animation_control():
	# 动画控制
	if move_direction!=0 and is_on_floor():
		if Input.is_action_pressed("player_squat"):
			max_speed=old_speed/2
			player_anim.play("player_squat_walk")#蹲着行走
		elif Input.is_action_just_pressed("player_Flying"):
			max_speed=1000
		else:
			player_anim.play("player_run")# 播放奔跑动画
	elif player_transform.y<0 and not is_on_floor():
		player_anim.play("player_jump_up")# 播放跳跃上升动画
	elif player_transform.y>0 and not is_on_floor():
		player_anim.play("player_jump_down")# 播放跳跃下降动画
		max_speed+=5
		if max_speed>=1000:
			max_speed=1000
	elif Input.is_action_pressed("player_squat"):
		player_anim.play("player_squat")# 蹲着
	else:
		player_anim.play("player_stand")# 播放站立等待动画
	if move_direction!=0:
		$"Texture-0".flip_h=move_direction<0# 设置动画方向
