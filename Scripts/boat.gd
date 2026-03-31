extends StaticBody3D

@onready var wood_carving: MeshInstance3D = $WoodCarving
var bad_ideas := load("res://Assets/Textures/deskcarvings/badideaswoodcarving.png")
var monica := load("res://Assets/Textures/deskcarvings/monicarving.png")
var gorbert := load("res://Assets/Textures/deskcarvings/gorbert.png")
var bob := load("uid://c55gb4likh6xu")
var B_0 := load("uid://dfel6t0y42b5s")
var brooke := load("uid://dcgs5b1k66l8j")
var limp_knight := load("uid://b634yw36eisxo")
var mushroom_kid := load("uid://imw7qge5sfke")
var salesman := load("uid://cmmwwfobvobw7")
var cool_s := load("res://Assets/Textures/deskcarvings/cool s.png")
var volf := load("res://Assets/Textures/deskcarvings/Volf.png")
var cabl := load("res://Assets/Textures/deskcarvings/cablo.png")
var rus := load("res://Assets/Textures/deskcarvings/rus.png")
var midnight := load("res://Assets/Textures/deskcarvings/midnight.png")
var lila := load("res://Assets/Textures/deskcarvings/lila.png")
var cartooneye := load("uid://cxeo6dkk60f0u")
var d6 := load("res://Assets/Textures/deskcarvings/d6.png")
var d20 := load("res://Assets/Textures/deskcarvings/d20.png")
var godork := load("res://Assets/Textures/deskcarvings/godork.png")
var heart := load("res://Assets/Textures/deskcarvings/heart.png")
var infinity := load("res://Assets/Textures/deskcarvings/infinity.png")
var lightbulb := load("res://Assets/Textures/deskcarvings/lightbulb.png")
var lilblock := load("res://Assets/Textures/deskcarvings/lilblock.png")
var minecrap := load("res://Assets/Textures/deskcarvings/minecrap.png")
var opticalillusion := load("res://Assets/Textures/deskcarvings/opticalillusion.png")
var overlydetailedeye := load("res://Assets/Textures/deskcarvings/overlydetailedeye.png")
var saveicon := load("res://Assets/Textures/deskcarvings/saveicon.png")
var shrimps := load("res://Assets/Textures/deskcarvings/shrimps.png")
var star := load("res://Assets/Textures/deskcarvings/star.png")
var funnyorb := load("res://Assets/Textures/deskcarvings/the orb everyone has drawn at least once.png")
var silvia1 := load("res://Assets/Textures/deskcarvings/silviaart1.png")
var silvia2 := load("res://Assets/Textures/deskcarvings/silvia2.png")
var thesog := load("res://Assets/Textures/deskcarvings/thesog.png")
var jonnyboy := load("uid://pa7ius5g80hi")
var eotu := load("res://Assets/Textures/deskcarvings/eyeogtheuniverse.png")
var arie := load("res://Assets/Textures/deskcarvings/foxxarie.png")
var tatertot := load("res://Assets/Textures/deskcarvings/tatertot.png")

var mrbeast := load("res://Assets/Textures/deskcarvings/mr beast.png")
@onready var environment_adjustment: AnimationPlayer = $EnvironmentAdjustment

var random_icon_image : Dictionary = {
	1 : bad_ideas,
	2 : monica,
	3 : gorbert,
	4 : bob,
	5 : B_0,
	6 : brooke,
	7 : limp_knight,
	8 : mushroom_kid,
	9 : salesman,
	10 : cool_s,
	11 : volf,
	12 : cabl,
	13 : rus,
	14 : midnight,
	15 : lila,
	16 : cartooneye,
	17 : d6,
	18 : d20,
	19 : godork,
	20 : heart,
	21 : infinity,
	22 : lightbulb,
	23 : lilblock,
	24 : minecrap,
	25 : opticalillusion,
	26 : overlydetailedeye,
	27 : saveicon,
	28 : shrimps,
	29 : star,
	30 : funnyorb,
	31 : silvia1,
	32 : silvia2,
	33 : thesog,
	34 : jonnyboy,
	35 : eotu,
	36 : arie,
	37 : tatertot
}

var random_icon : int

func _ready() -> void:
	var mystery_man : int = GameManager.rng.randi_range(1, 1000)
	if mystery_man == 666:
		wood_carving.get_active_material(0).albedo_texture = mrbeast
		await get_tree().create_timer(6.66).timeout
	random_icon = GameManager.rng.randi_range(1, random_icon_image.size())
	wood_carving.get_active_material(0).albedo_texture = random_icon_image.get(random_icon)
	if GameManager.jonnymode: 
		wood_carving.get_active_material(0).albedo_texture = jonnyboy
		

func play_environment_shift() -> void:
	environment_adjustment.play("Round" + str(GameManager.current_round))

func play_losing_round() -> void:
	environment_adjustment.play("Round" + str(GameManager.current_round) + "_to_end")
	environment_adjustment.queue("RoundEnd")
