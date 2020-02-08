extends Position2D

var velocidad = Vector2()
export (float) var gravedad = 100
export (float) var vel_movimiento = 25
export (float) var vel_salto = 25
var puede_saltar = false
var puede_disparar = true
var esta_en_el_agua = false 
enum estados {idle, agachado, underwater, apuntando_diagarr, apuntando_diagab, apuntando_arr, apuntando_ab,corriendo , muerto }
var estado_actual = estados.idle
var suelo_inferior = false
var puede_agacharse = true
export var arma = 0
export (Vector2) var spawnb_izq
export (Vector2) var spawnb_arr
export (Vector2) var spawnb_izqAR
export (Vector2) var spawnb_izqAB



func _ready():
	spawnb_izq = get_node("cuerpo_j1/spawnbala").position
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		get_node("cuerpo_j1").add_collision_exception_with(player)
	var powerups = get_tree().get_nodes_in_group("powerup")
	for powerup in powerups:for powerup in powerups:
		get_node("cuerpo_j1").add_collision_exception_with(powerup)
	
func _physics_process(delta): #Actualiza el sprite la posicion del jugador		
	#print(estado_actual)
	velocidad.y += gravedad * delta
	if(estado_actual != estados.muerto):
		#Correr para los costados [Movimiento a la izquierda]
		if(Input.is_action_pressed("tecla_a") && estado_actual != estados.agachado && estado_actual != estados.underwater):
			velocidad.x =  -vel_movimiento
			get_node("cuerpo_j1/spr_j1").flip_h = false
			if(Input.is_action_pressed("tecla_w") ):
				if(estado_actual != estados.apuntando_diagarr && (puede_saltar) && !esta_en_el_agua):
					get_node("animacion_j1").play("j1_diagar")
					get_node("cuerpo_j1/spawnbala").position = spawnb_izqAR
					estado_actual = estados.apuntando_diagarr
				elif(estado_actual != estados.apuntando_diagarr &&  !puede_saltar):
					get_node("cuerpo_j1/spawnbala").position = spawnb_izqAR
					estado_actual = estados.apuntando_diagarr	
			elif(Input.is_action_pressed("tecla_s")):
				if(estado_actual != estados.apuntando_diagab && (puede_saltar) && !esta_en_el_agua):
					get_node("animacion_j1").play("j1_diagab")
					get_node("cuerpo_j1/spawnbala").position = spawnb_izqAB
					estado_actual = estados.apuntando_diagab
				elif(!puede_saltar && estado_actual != estados.apuntando_diagab):
					get_node("cuerpo_j1/spawnbala").position = spawnb_izqAB
					estado_actual = estados.apuntando_diagab
			elif(estado_actual != estados.corriendo && (puede_saltar)):
				if (!esta_en_el_agua):#si no estoy en el agua
					get_node("animacion_j1").play("j1_corriendo")
				else: 
					get_node("animacion_j1").play("j1_watermove")
				estado_actual = estados.corriendo
				get_node("cuerpo_j1/spawnbala").position = spawnb_izq
			elif(estado_actual != estados.corriendo &&  !puede_saltar):
				get_node("cuerpo_j1/spawnbala").position = spawnb_izq
		#Si presiono la tecla D [Movimiento a la derecha]
		elif(Input.is_action_pressed("tecla_d") && estado_actual != estados.agachado && estado_actual != estados.underwater):
			velocidad.x = vel_movimiento
			get_node("cuerpo_j1/spr_j1").flip_h = true	
			if(Input.is_action_pressed("tecla_w") ):
				if(estado_actual != estados.apuntando_diagarr && puede_saltar && !esta_en_el_agua):
					get_node("animacion_j1").play("j1_diagar")
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnb_izqAR.x * -0.4 ,spawnb_izqAR.y)
					estado_actual = estados.apuntando_diagarr
				elif(estado_actual != estados.apuntando_diagarr && !puede_saltar):
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnb_izqAR.x * -0.4 ,spawnb_izqAR.y)
					estado_actual = estados.apuntando_diagarr
			elif(Input.is_action_pressed("tecla_s") ):
				if(estado_actual != estados.apuntando_diagab && (puede_saltar) && !esta_en_el_agua):
					get_node("animacion_j1").play("j1_diagab")	
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnb_izqAB.x * -0.4 ,spawnb_izqAB.y)
					estado_actual = estados.apuntando_diagab
				elif(estado_actual != estados.apuntando_diagab  && !puede_saltar):
					get_node("cuerpo_j1/spawnbala").position = Vector2(spawnb_izqAB.x * -0.4 ,spawnb_izqAB.y)
					estado_actual = estados.apuntando_diagab
			elif(estado_actual != estados.corriendo && (puede_saltar)):
				if(!esta_en_el_agua):
					get_node("animacion_j1").play("j1_corriendo")
				else: 
					get_node("animacion_j1").play("j1_watermove")
				estado_actual = estados.corriendo
				get_node("cuerpo_j1/spawnbala").position = Vector2(spawnb_izq.x * -0.4 , spawnb_izq.y)
			elif(estado_actual != estados.corriendo && !puede_saltar):
				get_node("cuerpo_j1/spawnbala").position = Vector2(spawnb_izq.x * -0.4 , spawnb_izq.y)
		#Mirara arriba
		elif(Input.is_action_pressed("tecla_w") && estado_actual != estados.agachado && estado_actual != estados.underwater):	
			if(puede_saltar && !esta_en_el_agua):			
				get_node("animacion_j1").play("j1_haciaarriba")
				get_node("cuerpo_j1/spawnbala").position = spawnb_arr
				estado_actual = estados.apuntando_arr
			elif(!puede_saltar):
				get_node("cuerpo_j1/spawnbala").position = spawnb_arr
				estado_actual = estados.apuntando_arr
			velocidad.x = 0
		#Agachado
		elif(Input.is_action_pressed("tecla_s") && puede_agacharse):	
			if(puede_saltar):
				if(!esta_en_el_agua):#cuerpo a tierra		
					get_node("animacion_j1").play("j1_agachado")
					estado_actual = estados.agachado
				else: #bajo el agua
					get_node("animacion_j1").play("j1_underwater")	
			else:
				get_node("cuerpo_j1/spawnbala").position = Vector2	(spawnb_arr.x , spawnb_arr.y * -1)
				estado_actual = estados.apuntando_ab
			velocidad.x = 0	
		
		else:#Quieto
			velocidad.x = 0
			if(puede_saltar):
				estado_actual= estados.idle
				if(!esta_en_el_agua ):
					get_node("animacion_j1").play("j1_idle")
					if(estado_actual == estados.agachado):
						get_node("cuerpo_j1").global_position -= Vector2 (0,33)
				else:
					get_node("animacion_j1").play("J1_water")
	
		#Salto
		if(Input.is_action_pressed("tecla_space") && (puede_saltar) && estado_actual != estados.underwater):
			#evito el salto doble
			if(estado_actual != estados.agachado):
				velocidad.y= -vel_salto	
				get_node("animacion_j1").play("j1_salto")
				estado_actual = estados.idle	
			elif(!suelo_inferior):#Si no estoy en el suelo inferior  puedo tirarme hacia abajo
				get_node("cuerpo_j1").global_position += Vector2 (0,1)
				estado_actual = estados.idle
				get_node("animacion_j1").play("j1_idle")
			
		#Disparos
		if(Input.is_action_pressed("tecla_m") && (puede_disparar)):#Se creal el disparo
			var newBala = get_tree().get_nodes_in_group("main")[0].seleccionar_bala(arma).instance() #instancio la nueva bala 
			newBala.global_position = get_node("cuerpo_j1/spawnbala").global_position  #para poder darle una nueva posicion
			get_tree().get_nodes_in_group("main")[0].add_child(newBala)
			puede_disparar = false
			get_node("cuerpo_j1/tmr_cooldown").start()
			if(estado_actual == estados.apuntando_arr):
				newBala.velocidad.y = -newBala.potencia
			elif(estado_actual == estados.idle || estado_actual == estados.agachado || estado_actual == estados.corriendo):
				if(get_node("cuerpo_j1/spr_j1").flip_h):
					newBala.velocidad.x = newBala.potencia
				else:
					newBala.velocidad.x = -newBala.potencia
			elif(estado_actual == estados.apuntando_diagarr):
				if(get_node("cuerpo_j1/spr_j1").flip_h):	
					newBala.velocidad = Vector2(newBala.potencia, -newBala.potencia)
				else:
					newBala.velocidad = Vector2(-newBala.potencia, -newBala.potencia)
			elif(estado_actual == estados.apuntando_diagab):
				if(get_node("cuerpo_j1/spr_j1").flip_h):	
					newBala.velocidad = Vector2(newBala.potencia,newBala.potencia)
				else:
					newBala.velocidad = Vector2(-newBala.potencia,newBala.potencia)
			elif(estado_actual == estados.apuntando_ab && !puede_saltar):#Le doy velocidad al disparo
				newBala.velocidad.y= newBala.potencia
			
			
		if(Input.is_action_just_released("tecla_s") && puede_agacharse && puede_saltar):
			puede_agacharse = false
			estado_actual = estados.idle
			get_node("animacion_j1").play("j1_idle")
			global_position.y -= 35
			yield(get_tree().create_timer(0.2) , "timeout")
			puede_agacharse = true
			if(get_node("cuerpo_j1/spr_j1").flip_h):
				get_node("cuerpo_j1/spawnbala").position = -spawnb_izq
			else:
				get_node("cuerpo_j1/spawnbala").position = spawnb_izq
			 #nos va a obtener todos los grupos de un nodo en particular ,es una lista por lo tanto queremos el elemento que necesitamos de ese grupo  [O]
				#Se agrega el nodo hijo que es la nueva bala al objeto main (puse el main e n el grupo main)
				#EL POSITION 2D ME DA LA REFERENCIA DEL PUNTO DONDE VA A SALIR LA BALA 
				#la bala se tiene que mover independependientemente.Agregar la bala algun nodo por que sino no esta en ningun nodo de nuestra escena por eso uso main
				#Hacemos una referencia en el main nombrando una etiqueta en grupo como main
			
			
		var desplazamiento = velocidad * delta
		get_node("cuerpo_j1").move_and_slide(desplazamiento)
		
		#Los collider colisionadores Agrego colision a un cuerpo
		#si el objeto colisiona y existe esa colision
		if(get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1) != null):#si  mi cuerpo esta colisionando detecta si es un suelo
			var obj_colisionado = get_node("cuerpo_j1").get_slide_collision(get_node("cuerpo_j1").get_slide_count()-1).collider	
			#Seleciono la etiqueta para el obj saber a que pertenece ese objeto colisionador
			if(obj_colisionado.is_in_group("suelo")):
				get_tree().get_nodes_in_group("spawn_j")[0].global_position = get_node("cuerpo_j1").global_position
				if(obj_colisionado.is_in_group("suelo_agua")):
					suelo_inferior = true
				else:
					suelo_inferior = false
				if(puede_saltar == false): #SI ESTA TOCANDO EL SUELO
					puede_saltar = true
					get_node("animacion_j1").stop()
					estado_actual = estados.idle
					if(obj_colisionado.is_in_group("agua")): #Y SI ADEMAS ESTA TOCANDO EL AGUA
						esta_en_el_agua = true
					else:#sino esta colisionando 
						esta_en_el_agua = false
				if (obj_colisionado.is_in_group("puente")):
					obj_colisionado.get_parent().explotar()
			elif(obj_colisionado.is_in_group("enemigo") && estado_actual != estados.muerto):
				muerte_player()
			elif(obj_colisionado.is_in_group("powerup_abierto")):
				if(obj_colisionado.id == 6):
					agregar_vida()
				else:#cambia el arma
					arma = obj_colisionado.id
				obj_colisionado.queue_free()	
		elif(puede_saltar):#esta en el aire  se desactiva 
			puede_saltar = false
	else:
		var desplazamiento = velocidad * delta
		get_node("cuerpo_j1").move_and_slide(desplazamiento)				
					
	
	

func _on_tmr_cooldown_timeout():#cuando termina el timer  habilito el disparo en esos 0.2 segundos
	puede_disparar= true # Replace with function body.

func muerte_player():
	velocidad.x = 0
	var enemigos = get_tree().get_nodes_in_group("enemigo")
	#Obtengo todos los enemigos de la escena
	for enemigo in enemigos:
		get_node("cuerpo_j1").add_collision_exception_with(enemigo)
	estado_actual = estados.muerto
	get_node("animacion_j1").play("j1_muerte")
	yield(get_node("animacion_j1"), "animation_finished")
	get_tree().get_nodes_in_group("main")[0].respawn_j1()
	#get_tree().get_nodes_in_group("main")[0].j1_vida -= 1 #Decremento la variable vidas cuando muere
	get_tree().get_nodes_in_group("camara")[0].global_position =  get_node("cuerpo_j1").global_position
	estado_actual = estados.idle
	queue_free()
	
	
#Muerte del Jugador 1  por salir de la pantalla
func _on_VisibilityNotifier2D_screen_exited():
	muerte_player() 

func agregar_vida():
	get_tree().get_nodes_in_group("main")[0].agregar_vida_j1()
	