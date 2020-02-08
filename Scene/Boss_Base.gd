extends Position2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

enum estados {completo, arma_1, corazon, destruido}
var estado_actual = estados.completo
var puede_disparar = true
export var vida_armas = 1
export var vida_corazon = 1
var vida_arma1
var vida_arma2
var life_corazon
export var puntos = 0

func _ready():
	vida_arma1 = vida_armas
	vida_arma2 = vida_armas
	life_corazon = vida_corazon

func _physics_process(delta):
	if((estado_actual == estados.completo || estado_actual == estados.arma_1) && puede_disparar):
		disparar()


func disparar():
	puede_disparar = false
	var newBala = get_tree().get_nodes_in_group("main")[0].bala_boss1.instance()
	get_tree().get_nodes_in_group("nivel")[0].add_child(newBala)
	if(estado_actual == estados.completo):
		newBala.global_position = get_node("Boss_Arma1/spawn").global_position
	elif(estado_actual == estados.arma_1):
		newBala.global_position = get_node("Boss_Arma2/spawn").global_position
	newBala.velocidad.x -= newBala.potencia
	get_node("cooldown").start()

func _on_cooldown_timeout():
	puede_disparar = true
	
func recibir_golpe(var id):
	if(estado_actual == estados.completo):
		vida_arma1 -= 1
		if(vida_arma1 < 1):
			cambiar_estado()
			if(id == 1):
				game_handler.puntaje_j1 += puntos
			else:
				game_handler.puntaje_j2 += puntos
		else:
			get_node("sfx_golpe").play()
	elif(estado_actual == estados.arma_1):
		vida_arma2 -= 1
		if(vida_arma2 < 1):
			cambiar_estado()
			if(id == 1):
				game_handler.puntaje_j1 += puntos
			else:
				game_handler.puntaje_j2 += puntos
		else:
			get_node("sfx_golpe").play()
	elif(estado_actual == estados.corazon):
		life_corazon -= 1
		if(life_corazon < 1):
			cambiar_estado()
			if(id == 1):
				game_handler.puntaje_j1 += puntos
			else:
				game_handler.puntaje_j2 += puntos
		else:
			get_node("sfx_golpe").play()
		
func cambiar_estado():
	if(estado_actual == estados.completo):
		#get_node("sfx_muerte").play()
		estado_actual = estados.arma_1
		get_node("AnimationPlayer").play("explosion_arma1")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("Boss_Arma1").queue_free()
		get_node("Boss_Arma2/CollisionShape2D").disabled = false
	elif(estado_actual == estados.arma_1):
		#get_node("sfx_muerte").play()
		estado_actual = estados.corazon
		get_node("AnimationPlayer").play("explosion_arma2")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("Boss_Arma2").queue_free()
		get_node("Base_Vida/CollisionShape2D").disabled = false
	elif(estado_actual == estados.corazon):
		#get_node("sfx_final").play()
		estado_actual = estados.destruido
		get_node("AnimationPlayer").play("explosion_base")
		yield(get_node("AnimationPlayer"), "animation_finished")
		get_node("Base_Vida").queue_free()
		game_handler.gano = true
		yield(get_tree().create_timer(2.0),"timeout")
		var main = get_tree().get_nodes_in_group("main")[0]
		get_tree().change_scene_to(main.scn_gameover)

