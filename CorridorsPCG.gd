extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rand_seed(2)
	pass # Replace with function body.

const Norte = 1
const Sur = 2
const Este = 3
const Oeste = 4

var dir = Este
var giro_dir = Este
var tipo = 0
var llave_codigo = 0

var angulos = {
	Norte: 270,
	Sur: 90,
	Este: 0,
	Oeste: 180,
}

var tiles = {
	0: "pasillo.png",
	1: "pasillo-1hab.png",
	2: "pasillo-2hab.png",
	3: "pasillo-trampa.png",
	4: "esquina.png",
	}

var tile_res = preload("res://Tile.tscn")
var pos = Vector2(1,10)
const escala = 2
var total = 400
func generar():
	var tile = tile_res.instance()
	
	cambiar_tipo()
	
	tile.texture = load("res://Map/"+tiles[tipo])
	tile.scale = Vector2(escala, escala)
	if tipo == 4:
		tile.rotate( deg2rad(angulos[giro_dir]) )
	elif tipo == 1:
		tile.rotate( deg2rad(angulos[dir] + (180 if (randpcg() < 0.5) else 0)) )
	else:
		tile.rotate( deg2rad(angulos[dir]) )
	tile.position = pos * 7 * escala;
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(tile)
	avanzar()

var recto = 3
func cambiar_tipo():
	if recto > 0:
		if (llave_codigo != 0) and (randpcg() < 0.25):
			tipo = 3
			llave_codigo = 0
		else:
			tipo = int (randpcg()*2.5)
		
		if (llave_codigo == 0) and ((tipo == 1) or (tipo == 2)) and (randpcg() < 0.25):
			llave_codigo = int( rand_range(1111, 9999) )
			
		recto -= 1
	else:
		girar()
		tipo = 4
		recto = int ( 0 + randpcg()*5 )

func girar():
	match dir:
		Norte:
			dir = Este
			giro_dir = Norte
		Sur:
			dir = Este
			giro_dir = Oeste
		Este:
			dir = Sur if (randpcg() < 0.50) else Norte
			if dir == Sur:
				giro_dir = Este
			else:
				giro_dir = Sur

func avanzar():
	match dir:
		Norte:
			pos.y -= 1
		Sur: 
			pos.y += 1
		Este:
			pos.x += 1
		Oeste:
			pos.x -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
var time = 0
func _process(delta):
	time -= delta
	if time <= 0:
		time = 0.1
		if total > 0:
			total -= 1
			generar()



# Implementamos una función de random propia
# Esto es así para poder generar el mismo nivel
# con el mismo valor de inicialización (rand_w)
var rand_x = 123456789
var rand_y = 362436069
var rand_z = 521288629
var rand_w = 88675123 # Se inicializa con este valor
func randpcg():
	var t = rand_x ^ ((rand_x << 11) & 0xFFFFFFFF)  # 32bit
	rand_x = rand_y
	rand_y = rand_z
	rand_z = rand_w
	rand_w = (rand_w ^ (rand_w >> 19)) ^ (t ^ (t >> 8))
	return float(rand_w) / float(4294967295)
