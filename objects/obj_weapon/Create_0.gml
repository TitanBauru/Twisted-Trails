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
	raridade = -1;
	
}

// Instanciando diferentes armas com os novos parâmetros
//espada = new weapon("Espada Afiada", "sheesh", 30, 30, [spr_sword], 4, -1, 0, 0, 3, 1, false, 0, noone, 0,8); // Arma corpo-a-corpo sem projétil



dreifach = new weapon("Dreifach Unheil", "piu piu", 8, 45, [spr_pistol_dreifach,spr_pistol_dreifach,spr_pistol_dreifach], 2, 8, 120, 2, 15, 3, false, 10, obj_bullet,1,0); // Arma automática, perfura 2 alvos
dreifach.sound = sfx_pistol;
dreifach.bullet_sprite = spr_pistol_bullet
dreifach.raridade = "Raro"

malenkiy = new weapon("Malenkiy", "piu piu", 4, 24, [spr_malenkiy,spr_malenkiy,spr_malenkiy], 1, 12, 90, 2, 10, 1, true, 15, obj_bullet,0,-6); // Arma automática, perfura 2 alvos
malenkiy.sound = sfx_pistol;
malenkiy.bullet_sprite = spr_pistol_bullet
malenkiy.raridade = "Comum"

flinten = new weapon("Flinten", "piu piu", 30, 1, [spr_flintlock,spr_flintlock,spr_flintlock], 10, 1, 200, 15, 0, 1, false, 40, obj_bullet,3,0); // Arma automática, perfura 2 alvos
flinten.sound = sfx_pistol;
flinten.bullet_sprite = spr_pistol_bullet
flinten.raridade = "Épica"

arma_ativa = flinten;

weapon_name = {
	"Flinten" : "flinten",
	"Dreifach Unheil" : "dreifach",
	"Malenkiy" : "malenkiy",
	"Espada Afiada" : "espada",
	"Pistolão" : "pistola",
	"Fuzil"  : "fuzil"
}



cooldown = 0;

amp = 2

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