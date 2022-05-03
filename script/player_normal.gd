extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var player_appearance=0# 人物体型判定 0为正常 1为偏瘦 2为过胖
var max_speed=300.0 # 最高速度
var player_transform=Vector2.ZERO #人物初始运动向量
var Time=0#时间计算-大多用于计算加速度
var health_bars=100
const GRAVITY=400 #自定义下落速度

onready var player_anim=$AnimationPlayer#获取场景树中的动画器
onready var player=$player# 获取场景树中的人物对象

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _physics_process(delta):
	move_and_slide(player_transform,Vector2.UP)
	

func _process(delta):
	#重力部分
	Time+=0.1
	player_transform.y+=GRAVITY*delta*Time# 每帧向下移动，模仿重力
	player_move(delta)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func player_move(delta):
	#人物移动部分
	var move_direction=Input.get_action_strength("player_right")-Input.get_action_strength("player_left")
	player_transform.x=move_toward(player_transform.x,move_direction*max_speed,(max_speed/0.2)*delta)
	if(move_direction==0):
		player_anim.play("player_stand")
	else:
		player_anim.play("player_run")
		$"Texture-0".flip_h=move_direction<0
