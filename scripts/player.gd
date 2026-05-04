extends CharacterBody2D
class_name Player

@export var speed : float = 300.0
@export var jump_velocity : float = -400.0

# A anotação @onready permite a inicialização direta de variáveis, mesmo as que
#precisam acessar nós pelos seus nomes.
@onready var sprite := $Sprite as Sprite2D
@onready var animation := $AnimationPlayer as AnimationPlayer

@onready var score_label = get_tree().current_scene.get_node("CanvasLayer/ScoreLabel")
var score : float = 0.0
var score_speed : float = 100.0

@onready var coin_label = get_tree().current_scene.get_node("CanvasLayer/CoinLabel")
var coins : int = 0

var jump_count := 0 
var max_jumps := 2

# A função _ready é chamada no início da execução.
func _ready() -> void:
	# Com o método connect, conectamos um sinal a uma função.
	CoinManager.coin_collected.connect(_on_coin)

func _process(delta):
	score += score_speed * delta
	score_label.text = "Score: " + str(int(score))

# Como conectamos o sinal collected à função _on_coin, ela será invocada sempre
#que uma moeda for coletada, exibindo o seu valor no console.
func _on_coin(value : int) -> void:
	coins += value
	coin_label.text = "Moedas: " + str(coins)
	print("MOEDA COLETADA, VALOR: " + str(value))


func _physics_process(delta: float) -> void:
	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta * 0.8
		
	if is_on_floor():
		jump_count = 0

	# Pulo, atribuição direta de velocidade vertical
	if Input.is_action_just_pressed("player_jump") and jump_count < max_jumps:
		if jump_count == 1:
			velocity.y = 0
		velocity.y = jump_velocity
		jump_count += 1
	

	# Leitura de direção do input (esquerda/direita)
	var direction := Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * (speed * 1.5)
		# se estiver se movendo para a direita, espelhamos o visual
		sprite.flip_h = direction > 0.0
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	# Lógica de animação do personagem
	if is_on_floor():# No chão(correndo/parado)
		if velocity.x:
			animation.play("run")
		else:
			animation.play("idle")
	else:# No ar(pulando/caindo)
		if velocity.y < 0.0:
			animation.play("jump")
		if velocity.y > 0.0:
			animation.play("fall")

	if is_on_floor():
		velocity.x -= Global.platform_speed/2

	move_and_slide()
