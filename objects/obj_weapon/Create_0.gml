/// @description Configuração de armas com parâmetros adicionais.
botao_atirar = mouse_check_button(mb_left)
lado = 1;
criou_slash = false;
dir = 0
estado_da_arma = 0
atacando = 0;
/// @function weapon(_nome, _desc, _damage, _atkspd, _sprite, _knock, _municao, _tempo_reload, _recoil, _precisao, _num_projectiles, _automatico, _projetil_speed, _projetil, _perfuracao,_length)
/// @description Constructor para criar uma nova arma com parâmetros adicionais.
function weapon(_nome, _desc, _damage, _atkspd, _sprite, _knock, _municao, _tempo_reload, _recoil, _precisao, _num_projectiles, _automatico, _projetil_speed, _projetil, _perfuracao,_length) constructor {
    nome = _nome;
    descricao = _desc;
    dano = _damage;
    atk_speed = _atkspd;
    sprite = _sprite; 
    knockback = _knock;
    ammo = _municao; // Quantidade de munição disponível
	ammo_max = ammo
    cd_reload = _tempo_reload; // Tempo necessário para recarregar
    recoil_amount = _recoil; // Recuo aplicado ao player ao disparar a arma
    precisao = _precisao; // Precisão da arma, influenciando a dispersão dos projéteis
    num_projectiles = _num_projectiles; // Número de projéteis disparados por uso da arma
    automatico = _automatico; // Define se a arma é automática ou semi-automática
    projetil_speed = _projetil_speed; // Velocidade dos projéteis disparados pela arma
    projetil = _projetil; // Tipo de projétil que a arma dispara
	projetil_sprite = undefined
    perfuracao = _perfuracao; // Define quantos alvos o projétil pode perfurar
	dist = _length;
	sound = undefined;
	raridade = "";
	
}

// Instanciando diferentes armas com os novos parâmetros
//espada = new weapon("Espada Afiada", "sheesh", 30, 30, [spr_sword], 4, -1, 0, 0, 3, 1, false, 0, noone, 0,8); // Arma corpo-a-corpo sem projétil

#region Pistolas

dreifach = new weapon("Triple Trouble", "piu piu", 10, 45, [spr_pistol_dreifach,spr_pistol_dreifach,spr_pistol_dreifach], 2, 8, 120, 2, 15, 3, false, 10, obj_bullet,1,0); // Arma automática, perfura 2 alvos
dreifach.sound = sfx_pistol_2;
dreifach.bullet_sprite = spr_pistol_bullet
dreifach.raridade = "Rara"

malenkiy = new weapon("MiniPistol", "piu piu", 5, 28, [spr_malenkiy,spr_malenkiy,spr_malenkiy], 1, 16, 90, 2, 10, 1, true, 15, obj_bullet,0,-6); // Arma automática, perfura 2 alvos
malenkiy.sound = sfx_pistol_2;
malenkiy.bullet_sprite = spr_pistol_bullet
malenkiy.raridade = "Comum"

flinten = new weapon("Flintlock", "piu piu", 75, 1, [spr_flintlock,spr_flintlock,spr_flintlock], 10, 1, 200, 15, 0, 1, false, 40, obj_bullet,3,0); // Arma automática, perfura 2 alvos
flinten.sound = sfx_pistol_2;
flinten.bullet_sprite = spr_pistol_bullet
flinten.raridade = "Épica"

#endregion

#region Subs
flugelmann = new weapon("Wingman", "piu piu", 10, 12, [spr_wingman,spr_wingman,spr_wingman], 0.5, 48, 100, 3, 20, 2, true, 15, obj_bullet,0,0); // Arma automática, perfura 2 alvos
flugelmann.sound = Rifle_Shot;
flugelmann.bullet_sprite = spr_pistol_bullet
flugelmann.raridade = "Lendária"

seifenblock = new weapon("Soap", "piu piu", 10, 16, [spr_seifenblock,spr_seifenblock,spr_seifenblock], 1, 30, 80, 2, 15, 1, true, 12, obj_bullet,0,0); // Arma automática, perfura 2 alvos
seifenblock.sound = Rifle_Shot;
seifenblock.bullet_sprite = spr_pistol_bullet
seifenblock.raridade = "Épica"

beinahe = new weapon("Almost UZI", "piu piu", 5, 10, [spr_beinahe,spr_beinahe,spr_beinahe], 1, 20, 100, 1, 20, 1, true, 10, obj_bullet,0,0); // Arma automática, perfura 2 alvos
beinahe.sound = Rifle_Shot;
beinahe.bullet_sprite = spr_pistol_bullet
beinahe.raridade = "Rara"

okaopuh = new weapon("OkaoOpuh", "piu piu", 15, 15, [spr_OkaOpuh,spr_OkaOpuh,spr_OkaOpuh], 1, 16, 90, 1, 17, 1, true, 6, obj_bullet,0,0); // Arma automática, perfura 2 alvos
okaopuh.sound = Rifle_Shot;
okaopuh.bullet_sprite = spr_pistol_bullet
okaopuh.raridade = "Comum"

lichtgewehr = new weapon("Light Rifle", "piu piu", 10, 15, [spr_lichtgewehr,spr_lichtgewehr,spr_lichtgewehr], 1, 15, 100, 1, 17, 1, true, 14, obj_bullet,1,0); // Arma automática, perfura 2 alvos
lichtgewehr.sound = Rifle_Shot;
lichtgewehr.bullet_sprite = spr_pistol_bullet
lichtgewehr.raridade = "Comum"

#endregion

#region Fuzil

malchik = new weapon("Lil Tommy", "piu piu", 15, 12, [spr_malchik,spr_malchik,spr_malchik], 0.4, 50, 85, 2, 10, 1, true, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
malchik.sound = Rifle_Shot;
malchik.bullet_sprite = spr_rifle_bullet;
malchik.raridade = "Lendária";

x78 = new weapon("X-78", "piu piu", 25, 20, [spr_x78,spr_x78,spr_x78], 0.6, 24, 90, 1.7, 16, 1, true, 24, obj_bullet,4,0); // Arma automática, perfura 2 alvos
x78.sound = Rifle_Shot;
x78.bullet_sprite = spr_rifle_bullet;
x78.raridade = "Épica";	

midov = new weapon("Midas", "piu piu", 25, 26, [spr_midov,spr_midov,spr_midov], 0.8, 30, 160, 1.25, 8, 1, true, 36, obj_bullet,2,0); // Arma automática, perfura 2 alvos
midov.sound = Rifle_Shot;
midov.bullet_sprite = spr_rifle_bullet;
midov.raridade = "Rara";

anglergewehr = new weapon("Anglers", "piupiu", 16, 30, [spr_anglergewehr,spr_anglergewehr,spr_anglergewehr], 0.8, 32, 180, 1.25, 11, 1, true, 30, obj_bullet,2,0); // Arma automática, perfura 2 alvos
anglergewehr.sound = Rifle_Shot;
anglergewehr.bullet_sprite = spr_rifle_bullet;
anglergewehr.raridade = "Rara";

makita = new weapon("Makita", "piu piu", 5, 9, [spr_makita,spr_makita,spr_makita], 0.2, 70, 140, 1, 6, 1, true, 30, obj_bullet,1,0); // Arma automática, perfura 2 alvos
makita.sound = Rifle_Shot;
makita.bullet_sprite = spr_rifle_bullet;
makita.raridade = "Comum";

sturmer = new weapon("Baguga", "piu piu", 12, 30, [spr_sturmer,spr_sturmer,spr_sturmer], 0.8, 16, 100, 1.25, 16, 1, true, 20, obj_bullet,2,0); // Arma automática, perfura 2 alvos
sturmer.sound = Rifle_Shot;
sturmer.bullet_sprite = spr_rifle_bullet;
sturmer.raridade = "Comum";

okogewehr = new weapon("Ecofriendly", "piu piu", 75, 55, [spr_okogewehr,spr_okogewehr,spr_okogewehr], 0.8, 6, 110, 1.25, 15, 1, true, 20, obj_bullet,2,0); // Arma automática, perfura 2 alvos
okogewehr.sound = Rifle_Shot;
okogewehr.bullet_sprite = spr_rifle_bullet;
okogewehr.raridade = "Comum";
			
#endregion

#region Shotguns

vanderlei = new weapon("Vanderlei Tambores", "piu piu", 30, 40, [spr_vanderlei,spr_vanderlei,spr_vanderlei], 2, 1, 60, 2, 3, 3, true, 7, obj_bullet,6,0); // Arma automática, perfura 2 alvos
vanderlei.sound = Rifle_Shot;
vanderlei.bullet_sprite = spr_rifle_bullet;
vanderlei.raridade = "Lendária";

kinder = new weapon("Kinder", "piu piu", 10, 12, [spr_kinder,spr_kinder,spr_kinder], 0.4, 30, 70, 2, 10, 1, false, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
kinder.sound = Rifle_Shot;
kinder.bullet_sprite = spr_rifle_bullet;
kinder.raridade = "Comum";

verbum = new weapon("Recruiter's Buckshot", "piu piu", 15, 50, [spr_verbum,spr_verbum,spr_verbum], 0.4, 5, 85, 2, 10, 3, false, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
verbum.sound = Rifle_Shot;
verbum.bullet_sprite = spr_rifle_bullet;
verbum.raridade = "Comum";

adler = new weapon("Adler", "piu piu", 5, 25, [spr_addler,spr_addler,spr_addler], 0.4, 7, 70, 2, 15, 5, false, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
adler.sound = Rifle_Shot;
adler.bullet_sprite = spr_rifle_bullet;
adler.raridade = "Comum";

sonnen = new weapon("Sun Revenge", "piu piu", 30, 50, [spr_sonnen,spr_sonnen,spr_sonnen], 0.4, 6, 70, 2, 10, 2, false, 5, obj_bullet,3,0); // Arma automática, perfura 2 alvos
sonnen.sound = Rifle_Shot;
sonnen.bullet_sprite = spr_rifle_bullet;
sonnen.raridade = "Épica";

six_shots = new weapon("Six Shots", "piu piu", 10, 6, [spr_sixshots,spr_sixshots,spr_sixshots], 0.4, 6, 70, 2, 10, 3, true, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
six_shots.sound = Rifle_Shot;
six_shots.bullet_sprite = spr_rifle_bullet;
six_shots.raridade = "Épica";

#endregion

#region Snipers

strelok = new weapon("Toxic Waste", "piu piu", 70, 80, [spr_strelok,spr_strelok,spr_strelok], 0.4, 4, 70, 2, 0, 1, false, 40, obj_bullet,30,0); // Arma automática, perfura 2 alvos
strelok.sound = Rifle_Shot;
strelok.bullet_sprite = spr_rifle_bullet;
strelok.raridade = "Lendária";


schnarcher = new weapon("Snoiper ", "piu piu", 60, 90, [spr_schnarcher,spr_schnarcher,spr_schnarcher], 0.4, 10, 70, 2, 10, 1, true, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
schnarcher.sound = Rifle_Shot;
schnarcher.bullet_sprite = spr_rifle_bullet;
schnarcher.raridade = "Rara";


elitaren = new weapon("Elite Beschutzer", "piu piu", 100, 110, [spr_elitaren,spr_elitaren,spr_elitaren], 0.4, 8, 120, 2, 10, 1, true, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
elitaren.sound = Rifle_Shot;
elitaren.bullet_sprite = spr_rifle_bullet;
elitaren.raridade = "Épica";

#endregion

#region Heavy
kraseukolv = new weapon("Kraseukolv", "piu piu", 18, 9, [spr_kraseukolv,spr_kraseukolv,spr_kraseukolv], 0.4, 32, 70, 2, 10, 1, true, 14, obj_bullet,3,0); // Arma automática, perfura 2 alvos
kraseukolv.sound = Rifle_Shot;
kraseukolv.bullet_sprite = spr_rifle_bullet;
kraseukolv.raridade = "Lendária";

titan = new weapon("Titanische", "piu piu", 5, 5, [spr_titan,spr_titan,spr_titan], 0.1, 130, 400, 0.5, 30, 3, true, 10, obj_bullet,1,0); // Arma automática, perfura 2 alvos
titan.sound = Rifle_Shot;
titan.bullet_sprite = spr_rifle_bullet;
titan.raridade = "Titan";

aleo = new weapon("ALEO Stormer", "piu piu", 30, 9, [spr_aleo,spr_aleo,spr_aleo], 0.4, 12, 50, 2, 2, 1, true, 12, obj_bullet,3,0); // Arma automática, perfura 2 alvos
aleo.sound = Rifle_Shot;
aleo.bullet_sprite = spr_rifle_bullet;
aleo.raridade = "Titan";

dokrl = new weapon("Dokrl.mp4 - SixShooter", "piu piu", 70, 60, [spr_dokrl,spr_dokrl,spr_dokrl], 0.4, 6, 45, 2, 0, 1, true, 21, obj_bullet,3,0); // Arma automática, perfura 2 alvos
dokrl.sound = Rifle_Shot;
dokrl.bullet_sprite = spr_rifle_bullet;
dokrl.raridade = "Titan";
#endregion

arma_ativa = dreifach;

weapon_name = {
    // Pistolas
    "Triple Trouble": "dreifach",
    "MiniPistol": "malenkiy",
    "Flintlock": "flinten",

    // Subs
    "Wingman": "flugelmann",
    "Soap": "seifenblock",
    "Almost UZI": "beinahe",
    "OkaoOpuh": "okaopuh",
    "Light Rifle": "lichtgewehr",

    // Fuzis
    "Lil Tommy": "malchik",
    "X-78": "x78",
    "Midas": "midov",
    "Anglers": "anglergewehr",
    "Makita": "makita",
    "Baguga": "sturmer",
    "Ecofriendly": "okogewehr",

    // Shotguns
    "Vanderlei Tambores": "vanderlei",
    "Kinder": "kinder",
    "Recruiter's Buckshot": "verbum",
    "Adler": "adler",
    "Sun Revenge": "sonnen",
    "Six Shots": "six_shots",

    // Snipers
    "Toxic Waste": "strelok",
    "Snoiper ": "schnarcher",
    "Elite Beschutzer": "elitaren",

    // Heavy
    "Kraseukolv": "kraseukolv",
    "Titanische": "titan",
    "ALEO Stormer": "aleo",
    "Dokrl.mp4 - SixShooter": "dokrl"
};

// Pegamos todas as chaves da struct
weapon_list = variable_struct_get_names(weapon_name);
// Índice da arma atual
current_weapon_index = 0;


cooldown = 0;

amp = random_range(.7,1.2)

precisao_inicial = 0
precisao_incremento = 5
precisao_decay_constant = .06
precisao_decay_percent = .02

sep_vfx_x = 0
sep_vfx_y = 0
_projX = 0
_projY = 0

reload = false
recoil = 0;
///@desc Iniciando a arma
estou_usando = false;
target = obj_player;
cria_efeito_pickup = true;
//raio = obj_player.pickup_radius;
cooldown = 0;

_x = x
angle = image_angle

curvePos = 0;
curveSpd = 0;

//Sprite Infos
xscale = 1;
yscale = 1;
angle = 0;
alpha = 1;
cor = c_white;

sombra_y = sin(4 * get_timer()/1000000)/12;
sombra_xscale = 1;
sombra_yscale = 1;

// Variáveis para o sistema de reload
tempo_recarga_max = 60; // Tempo total de recarga em frames (1 segundo = 60 frames)
tempo_recarga_atual = 0; // Contador atual de recarga
recarregando = false; // Status de recarregamento

//som_tiro = snd_tiro1;
function arma_solo()
{
	
	xscale = 1;
	yscale = 1;
	//angle = 0;
	cria_efeito_pickup = true;
	
	depth = bbox_bottom;	
}
function arrumar_lado_arma()
{
	if(mouse_x < target.x){ yscale = -1;}
	else if(mouse_x > target.x){ yscale = 1;}	
}
function arrumar_lado_arma_controle()
{
	if(gamepad_axis_value(global.controle, gp_axisrh) < 0){ yscale = -1;}
	else if(gamepad_axis_value(global.controle, gp_axisrh) > 0){ yscale = 1;}
	
	if gamepad_axis_value(global.controle, gp_axisrh) = 0 
	{
		if (dir = 0) yscale = 1
		if (dir = 180) yscale = -1
	}
}
function criar_projetil(x, y, dir) {
    var proj = instance_create_layer(x, y, "Instances", arma_ativa.projetil, 
	{
		damage : arma_ativa.dano,
		knockback: arma_ativa.knockback});
    //proj.speed = arma_ativa.projetil_speed SPEED;
    proj.direction = dir + irandom_range(-precisao_inicial, precisao_inicial);
    proj.image_angle = proj.direction;
    proj.image_xscale = max(2, arma_ativa.projetil_speed / proj.sprite_width);
	proj.sprite_index = arma_ativa.bullet_sprite
	proj.speed = arma_ativa.projetil_speed
	return proj;
}
function criar_slash(_lado_da_espada) {
    // Certifique-se de que _lado_da_espada foi corretamente passado ou definido antes
    _posicao_da_espada = obj_player.x - 12 * _lado_da_espada + obj_player.velh + lengthdir_x(12, direction);
    _atraso_da_espada = 1;
    angle = 0;

    // Criação do objeto slash
    var slash = instance_create_layer(obj_player.x + obj_player.velh * 10, obj_player.y - 8 - obj_player.velv * -10, "Bloom", obj_slash);
    slash.image_xscale = 1;
    slash.direction = direction;
    slash.image_angle = slash.direction;
    slash.speed = 2;
    slash.friction = 0.1;
}
#region methods
	reload = function(){
		if (arma_ativa.ammo < arma_ativa.ammo_max && !recarregando) { // Verifica se a arma não está cheia e se não está recarregando
	        recarregando = true; // Define o status de recarregamento para verdadeiro
	        tempo_recarga_atual = arma_ativa.cd_reload; // Inicializa o contador de recarga
	        //sprite_index = arma_ativa.sprite[2]; // Troca para o sprite de recarga, supondo que [2] seja o índice do sprite de recarga
	        //audio_play_sound(snd_reload, 1, false,,,random_range(.8,1.2)); // Toca o som de recarga (opcional)
			
		}
	}
	//swap = function(){
	//	var temp = arma_ativa;
	//	arma_ativa = arma_secundaria;
	//	arma_secundaria = temp;
	//	var name = weapon_name[$ arma_ativa.nome];		
	//	var temp = obj_player.primary_weapon;	
	//	obj_player.primary_weapon = obj_player.secondary_weapon;
	//	obj_player.secondary_weapon = temp;
				
	//}
	weapon_shoot = function(){
		// Calcula a posição de criação do projétil
        var _projX = lengthdir_x(arma_ativa.dist, dir);  
        var _projY = lengthdir_y(arma_ativa.dist, dir);  
		
		var bullet_list = []        
        for (var i = 0; i < arma_ativa.num_projectiles; i++) {  
            var __dir = i == 0 ? 0 : -15 + (i * 15);
			//instance_create_layer(target.x,y,"Instances",obj_bullet,{dir})
            array_push(bullet_list, criar_projetil(x + _projX, y + _projY, dir + __dir));
        }        
		arma_ativa.ammo--; // Reduz a munição da arma
				
	}
#endregion