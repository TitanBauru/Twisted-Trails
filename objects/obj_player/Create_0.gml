//Armas
arma_atual = "Pistola"
pode_dash_player = 0
dano_armas = 1
cadencia_armas = 1
//instance_create_layer(x,y,"vacuo",obj_shadow_tile_controller)
instance_create_layer(x,y,"vacuo",obj_weapon)
if !(instance_exists(obj_camera)) instance_create_layer(x,y,layer,obj_camera)
light = instance_create_layer(x,y,"vacuo",obj_player_luz)

alarm[0] = 10
bullet_number = 0;

//Velocidade
vel = 2.4;
velh = 0;    
velv = 0;    
dir = 0;    
aceleracao = .6;  
desaceleracao = .2;
pode_mover = true;
estou_movendo = true;
movimento_horizontal = 0
movimento_vertical = 0

max_speed = 2.4

//Imagem
yscale = 1;
xscale = 1;
lado = 1;

shadow = new Crystal_Shadow(id, CRYSTAL_SHADOW.DYNAMIC);
shadow.AddMesh(new Crystal_ShadowMesh().FromSpriteBBoxEllipse(spr_player_idle));
shadow.shadowLength = 3
shadow.Apply();

// Status de dano e escudo
tomei_hit = false;
cooldown_hit = 0;
escudo = false;
cooldown_hit_max = 40;
tempo_flash = 0;

// Configurações de vida e mana
vida = 100;
vida_max = 100;
mana = 10000;
mana_max = 10000;
mana_regen = 0.05;

// Configurações de dash
can_dash = true;
dash_qty = 0; // quantidade de dash disponivel sem gastar mana
upgrade_velocidade_dash = 1; // multiplicador pra velocidade do dash
upgrade_distancia_dash = 1; // multiplicador pra distancia do dash
velocidade_dash = 8;
distancia_dash = 64;
posicao_inicial_dash = {x : 0, y : 0}; // Posição da onde o dash partiu pra começar a contar a distancia
dash_timer = 10;
dash_cooldown = 0;
on_dash = false;
dash_dir = 0;

//Camera
zoom_punch = 1

// Configurações Knockback
on_knockback = false;
knockback_dir = 0;
knoback_strenght = 0;

/// @description Executa o dash com parametros dos upgrades
/// @function executar_dash()
/// @description Executa a mecânica de dash com base em mana ou quantidade de dashes disponíveis.
function executar_dash() {
    var _mana_necessaria = 20;
    var _posso_executar_dash = false;
    
    if (keyboard_check_pressed(vk_space) && !on_dash && dash_cooldown <= 0 && can_dash) {
        repeat(10) { instance_create_layer(x, y, "Trail", obj_particle_dash); }
        
        if (dash_qty >= 1) { // Caso eu possa dar o dash sem gastar mana
            _posso_executar_dash = true;
            dash_qty -= 1;
        } else { // Gasto mana para dar o dash
            if (mana - _mana_necessaria >= 0) {
                mana -= _mana_necessaria;
                _posso_executar_dash = true;
            }
        }
    }
    
    if (_posso_executar_dash) {
        can_dash = false;
        
        // Rodar SFX de dash
        shockwave_instance_create(obj_player.x, obj_player.y, "Trail", 0, .75, 0.01, __ppf_objShockwave);
        
        on_dash = true;
        
        // Calcula a direção do dash
        if (abs(velh + velv) > 0) {
            dash_dir = point_direction(0, 0, velh, velv); // Baseado no movimento atual
        } else {
            dash_dir = point_direction(x, y, mouse_x, mouse_y); // Baseado no mouse
        }
        
        posicao_inicial_dash = { x: x, y: y };
        
        // Aplica a velocidade do dash
        var dash_speed = 8; // Defina a velocidade do dash aqui
        velh = lengthdir_x(dash_speed, dash_dir);
        velv = lengthdir_y(dash_speed, dash_dir);
    }
}


// Status de combate
tempo_sem_bater_em_inimigos = 0;
fora_de_combate = true;


/// @desc Create Event do obj_player
// Alinha a posição ao grid (opcional, para ficar mais "bonito")
x = round(x / 32) * 32;
y = round(y / 32) * 32;

// Limpa uma área 3x3 ao redor do player
for (var i = -1; i <= 1; i += 1)
{
    for (var j = -1; j <= 1; j += 1)
    {
        var vacuo = instance_position(x + (i * 32), y + (j * 32), obj_vacuo);
        if (vacuo != noone)
        {
            instance_destroy(vacuo);
            instance_create_layer(x + (i * 32), y + (j * 32), "chao", obj_floor); // Adiciona chão no lugar
        }
    }
}

/// @description Movimenta o player com lógica de animação e efeitos.
/// @param {real} _velh Velocidade horizontal desejada
/// @param {real} _velv Velocidade vertical desejada
function mover_player(_velh, _velv) {
    // Armazena os valores para referência
    movimento_horizontal = _velh;
    movimento_vertical = _velv;

    // Verifica se há movimento
    if (_velh != 0 || _velv != 0) {
        estou_movendo = true;
        
        // Calcula a direção do movimento
        dir = point_direction(0, 0, _velh, _velv);
        
        // Aplica aceleração suave para movimento mais fluido
        velh = lerp(velh, _velh, aceleracao) * global.game_speed;
        velv = lerp(velv, _velv, aceleracao) * global.game_speed;
        
       
    } else {
        if (estou_movendo) {
            estou_movendo = false;
        }
    }
}

/// @description Ajusta escala e verifica hit flash.
function ajustar_estado_visual() {
	if (tempo_flash > 0) {
		xscale = 1.2;
		yscale = 0.8;
		tempo_flash--;
	} else {
		xscale = lerp(xscale, 1, 0.15);
		yscale = lerp(yscale, 1, 0.15);
	}
}

///// @description Regenera mana e clampa vida/mana.
//function regenerar_mana() {
//    mana = clamp(mana + mana_regen, 0, mana_max);
//}

///// @description Verifica se o player está em combate.
//function verificar_combate() {
//    tempo_sem_bater_em_inimigos++;
//    fora_de_combate = tempo_sem_bater_em_inimigos >= 300;
//}

///// @description Mantém a vida e mana do player dentro de seus valores máximos.
//function clampar_vida_mana() {
//    vida = clamp(vida, 0, vida_max);
//    mana = clamp(mana, 0, mana_max);
//}


///// @description Atualiza todas as funcionalidades do player.
//function update_player() {
//    ajustar_estado_visual();
//    clampar_vida_mana();
//    regenerar_mana();
//    verificar_combate();
//}
/// @description Aplica knockback ao jogador
/// @param {real} force Força do knockback
/// @param {real} dir Direção do knockback em graus
take_knockback = function(force, dir) {
    // Ativa o sistema de knockback
    on_knockback = true;
    
    // Define a direção e força do knockback
    knockback_dir = dir;
    knockback_strenght = force;
    
    // Desativa o dash caso esteja ativo
    on_dash = false;
    
    // Opcional: Adiciona efeito visual de impacto
    tempo_flash = 10; // Flash visual ao receber knockback
    
    // Criar partículas ou efeitos de impacto se desejar
    // repeat(5) instance_create_layer(x, y, "Trail", obj_particle_impact);
}

/// @description Aplica knockback ao atirar (recuo da arma)
/// @param {real} forca_recuo Força do recuo
/// @param {real} direcao_tiro Direção do tiro em graus
aplicar_recuo_arma = function(forca_recuo, direcao_tiro) {
    // Calcula direção contrária ao tiro
    var direcao_knockback = (direcao_tiro + 180) % 360;
    
    // Aplica knockback mais suave que o de dano
    take_knockback(forca_recuo, direcao_knockback);
    
    // Definir um tempo de knockback mais curto para o recuo da arma
    // (isso é processado no Step Event)
}
///// @description Efeitos de poeira e áudio de passos.
function executar_dustwalk() {
    if (random(4) < 1) {
        repeat (irandom(estou_movendo ? 3 : 1)) instance_create_layer(x, y + 5, "chao", obj_dustwalk);
    }
}
//function executar_audio_passos() {
//    audio_step--;
//    if (audio_step <= 0) {
//		var _sompasso = choose(Grass_FS_1,Grass_FS_2,Grass_FS_3,Grass_FS_4,Grass_FS_5)
//        audio_sound_pitch(_sompasso,random_range(.8,1.2))
//		saudio_sound_play_at(obj_audio_control.effect_group,_sompasso , x,y,0);
		
//        audio_step = audio_step_max;
//    }
//}