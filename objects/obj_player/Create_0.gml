//Velocidade
vel = 1.5;
velh = 0;    
velv = 0;    
dir = 0;    
aceleracao = 0.1;  
pode_mover = true;
estou_movendo = true;
movimento_horizontal = 0
movimento_vertical = 0

//Imagem
yscale = 1;
xscale = 1;
lado = 1;

// Status de dano e escudo
tomei_hit = false;
cooldown_hit = 0;
escudo = false;
cooldown_hit_max = 40;
tempo_flash = 0;

// Configurações de vida e mana
vida = 100;
vida_max = 100;
mana = 100;
mana_max = 100;
mana_regen = 0.05;

// Configurações de dash
can_dash = true;
dash_timer = 10;
dash_coldown = 0;
on_dash = false;
// Status de combate
tempo_sem_bater_em_inimigos = 0;
fora_de_combate = true;


/// @description Movimenta o player com lógica de animação e efeitos.
function mover_player(_velh, _velv) {
   
    movimento_horizontal = _velh;
    movimento_vertical = _velv;

    if (_velh != 0 || _velv != 0) {
        
        estou_movendo = true;
        
        dir = point_direction(0, 0, _velh, _velv);
        velh = lerp(velh, lengthdir_x(vel , dir), aceleracao) * global.game_speed;
        velv = lerp(velv, lengthdir_y(vel , dir), aceleracao) * global.game_speed;

        
        
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

///// @description Efeitos de poeira e áudio de passos.
//function executar_dustwalk() {
//    if (random(4) < 1) {
//        repeat (irandom(estado = "Correndo" ? 3 : 1)) instance_create_layer(x, y + 5, "Camera", obj_dustwalk);
//    }
//}
//function executar_audio_passos() {
//    audio_step--;
//    if (audio_step <= 0) {
//		var _sompasso = choose(Grass_FS_1,Grass_FS_2,Grass_FS_3,Grass_FS_4,Grass_FS_5)
//        audio_sound_pitch(_sompasso,random_range(.8,1.2))
//		saudio_sound_play_at(obj_audio_control.effect_group,_sompasso , x,y,0);
		
//        audio_step = audio_step_max;
//    }
//}