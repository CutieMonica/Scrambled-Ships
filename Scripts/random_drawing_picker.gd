extends Node

var bad_ideas := preload("res://Assets/Textures/deskcarvings/badideaswoodcarving.png")
var monica := preload("res://Assets/Textures/deskcarvings/monicarving.png")
var gorbert := preload("res://Assets/Textures/deskcarvings/gorbert.png")
var bob := preload("uid://c55gb4likh6xu")
var B_0 := preload("uid://dfel6t0y42b5s")
var brooke := preload("uid://dcgs5b1k66l8j")
var limp_knight := preload("uid://b634yw36eisxo")
var mushroom_kid := preload("uid://imw7qge5sfke")
var salesman := preload("uid://cmmwwfobvobw7")
var cool_s := preload("res://Assets/Textures/deskcarvings/cool s.png")
var volf := preload("res://Assets/Textures/deskcarvings/Volf.png")
var cabl := preload("res://Assets/Textures/deskcarvings/cablo.png")
var rus := preload("res://Assets/Textures/deskcarvings/rus.png")
var midnight := preload("res://Assets/Textures/deskcarvings/midnight.png")
var lila := preload("res://Assets/Textures/deskcarvings/lila.png")
var cartooneye := preload("uid://cxeo6dkk60f0u")
var d6 := preload("res://Assets/Textures/deskcarvings/d6.png")
var d20 := preload("res://Assets/Textures/deskcarvings/d20.png")
var godork := preload("res://Assets/Textures/deskcarvings/godork.png")
var heart := preload("res://Assets/Textures/deskcarvings/heart.png")
var infinity := preload("res://Assets/Textures/deskcarvings/infinity.png")
var lightbulb := preload("res://Assets/Textures/deskcarvings/lightbulb.png")
var lilblock := preload("res://Assets/Textures/deskcarvings/lilblock.png")
var minecrap := preload("res://Assets/Textures/deskcarvings/minecrap.png")
var opticalillusion := preload("res://Assets/Textures/deskcarvings/opticalillusion.png")
var overlydetailedeye := preload("res://Assets/Textures/deskcarvings/overlydetailedeye.png")
var saveicon := preload("res://Assets/Textures/deskcarvings/saveicon.png")
var shrimps := preload("res://Assets/Textures/deskcarvings/shrimps.png")
var star := preload("res://Assets/Textures/deskcarvings/star.png")
var funnyorb := preload("res://Assets/Textures/deskcarvings/the orb everyone has drawn at least once.png")
var silvia1 := preload("res://Assets/Textures/deskcarvings/silviaart1.png")
var silvia2 := preload("res://Assets/Textures/deskcarvings/silvia2.png")
var thesog := preload("res://Assets/Textures/deskcarvings/thesog.png")
var jonnyboy := preload("uid://pa7ius5g80hi")
var eotu := preload("res://Assets/Textures/deskcarvings/eyeogtheuniverse.png")
var arie := preload("res://Assets/Textures/deskcarvings/foxxarie.png")
var tatertot := preload("res://Assets/Textures/deskcarvings/tatertot.png")
var kila := preload("res://Assets/Textures/deskcarvings/kila.png")
var mrbeast := preload("res://Assets/Textures/deskcarvings/mr beast.png")
var fred := preload("uid://chxysni74pjv5")
var autism := preload("res://Assets/Textures/deskcarvings/autism.png")
var wub := preload("uid://ify02bv56od2")
var delta := preload("uid://cj6lyke0pelu7")
var tank := preload("uid://brqb7hnlmv35p")
var soup := preload("uid://dny3v5jgapcqw")
var somethingpretty := preload("uid://3648jhabylhg")
var sockable := preload("uid://rqn5ryj3kn7q")
var paige := preload("uid://kwx4wcsphmmv")
var nullenemy := preload("uid://djjrmalqayh0n")
var marcus := preload("uid://c5vqnnyec4y54")
var hypotheticals := preload("uid://viy5e47alnao")
var glorp := preload("uid://rdye3cv4lkrr")
var gamebox := preload("uid://bbsrr2xhxvcc8")
var dreamer := preload("uid://b34k07xat2ynx")
var caltrops := preload("uid://dl6242maj0l2q")
var boxes := preload("uid://m7qfiuykioq4")
var box := preload("uid://dnhx46kr084y3")
var bangbang := preload("uid://b356te7lasbwb")
var eightox := preload("uid://d2ix1a588egat")
var snatched := preload("uid://cw8yrfc34s18n")
var stardrop := preload("uid://cktssfkov4ux3")
var burgie := preload("res://Assets/Textures/deskcarvings/burgie.png")



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
