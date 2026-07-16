extends StaticBody3D

@onready var cpu_particles_3d: CPUParticles3D = $CPUParticles3D
@onready var cpu_particles_3d_2: CPUParticles3D = $CPUParticles3D2
@onready var cpu_particles_3d_3: CPUParticles3D = $CPUParticles3D3

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
var kila := load("res://Assets/Textures/deskcarvings/kila.png")
var mrbeast := load("res://Assets/Textures/deskcarvings/mr beast.png")
var fred := load("uid://chxysni74pjv5")
var autism := load("res://Assets/Textures/deskcarvings/autism.png")
var wub := load("uid://ify02bv56od2")
var delta := load("uid://cj6lyke0pelu7")
var tank := load("uid://brqb7hnlmv35p")
var soup := load("uid://dny3v5jgapcqw")
var somethingpretty := load("uid://3648jhabylhg")
var sockable := load("uid://rqn5ryj3kn7q")
var paige := load("uid://kwx4wcsphmmv")
var nullenemy := load("uid://djjrmalqayh0n")
var marcus := load("uid://c5vqnnyec4y54")
var hypotheticals := load("uid://viy5e47alnao")
var glorp := load("uid://rdye3cv4lkrr")
var gamebox := load("uid://bbsrr2xhxvcc8")
var dreamer := load("uid://b34k07xat2ynx")
var caltrops := load("uid://dl6242maj0l2q")
var boxes := load("uid://m7qfiuykioq4")
var box := load("uid://dnhx46kr084y3")
var bangbang := load("uid://b356te7lasbwb")
var eightox := load("uid://d2ix1a588egat")
var snatched := load("uid://cw8yrfc34s18n")
var stardrop := load("uid://cktssfkov4ux3")
var burgie := load("res://Assets/Textures/deskcarvings/burgie.png")

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
	37 : tatertot,
	38 : kila,
	39 : fred,
	40 : autism,
	41 : wub,
	42 : delta,
	43 : tank,
	44 : soup,
	45 : somethingpretty,
	46 : sockable,
	47 : paige,
	48 : nullenemy,
	49 : marcus,
	50 : hypotheticals,
	51 : glorp,
	52 : gamebox,
	53 : dreamer,
	54 : caltrops,
	55 : boxes,
	56 : box,
	57 : bangbang,
	58 : eightox,
	59 : snatched,
	60 : stardrop,
	61 : burgie
}

var random_icon : int

func _ready() -> void:
	performance_switch()
	var mystery_man : int = GameManager.rng.randi_range(1, 1000)
	print(str(random_icon_image.size()) + " icon size")
	if mystery_man == 666:
		wood_carving.get_active_material(0).albedo_texture = mrbeast
		await get_tree().create_timer(6.66).timeout
		
	var _arbitrary_rng_call : int = GameManager.rng.randi_range(1, 2)
	random_icon = GameManager.rng.randi_range(61, random_icon_image.size())
	wood_carving.get_active_material(0).albedo_texture = random_icon_image.get(random_icon)
	
	if GameManager.fredmode:
		wood_carving.get_active_material(0).albedo_texture = fred
	if GameManager.jonnymode: 
		wood_carving.get_active_material(0).albedo_texture = jonnyboy
		

func play_environment_shift() -> void:
	environment_adjustment.play("Round" + str(GameManager.current_round))

func play_losing_round() -> void:
	environment_adjustment.play("Round" + str(GameManager.current_round) + "_to_end")
	environment_adjustment.queue("RoundEnd")

func performance_switch() -> void:
	cpu_particles_3d.visible = !GameManager.performance_mode
	cpu_particles_3d_2.visible = !GameManager.performance_mode
	cpu_particles_3d_3.visible = !GameManager.performance_mode
