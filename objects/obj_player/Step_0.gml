/// STEP EVENT - Sistema de Movimentação Revisado

// Captura input do jogador
var axis_h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var axis_v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Determina velocidade desejada com base no input
var move_h = axis_h;
var move_v = axis_v;

// Atualiza movimento apenas se não estiver em dash ou knockback
if (!on_dash && !on_knockback) {
    // Normaliza a velocidade para manter consistência (inclusive na diagonal)
    if (move_h != 0 || move_v != 0) {
        // Normalização para movimento diagonal consistente
        if (move_h != 0 && move_v != 0) {
            var magnitude = sqrt(move_h * move_h + move_v * move_v);
            move_h = (move_h / magnitude);
            move_v = (move_v / magnitude);
        }
        
        // Aplica a velocidade máxima após normalização
        move_h *= max_speed;
        move_v *= max_speed;
    }
    
    // Passa as velocidades desejadas para a função de movimento
    mover_player(move_h, move_v);
}

// Atualiza estado de movimento e animações
if (estou_movendo) {
   // Ajusta o image_speed com base na direção do movimento e do lado

    // Verifica se a direção do movimento (velh) é oposta à direção que o player está olhando (lado)
    if ((velh > 0 && lado < 0) || (velh < 0 && lado > 0)) {
        // Se o movimento é oposto ao lado, inverte o image_speed para evitar moonwalk
        sprite_index = spr_player_move_back; // Inverte a animação
       
    } else {
        // Caso contrário, usa a direção normal do movimento
        sprite_index = spr_player_move;
       
    }
    executar_dustwalk();
} else {
    // Desacelera gradualmente se não está se movendo
    velh = abs(velh) <= 0.2 ? 0 : lerp(velh, 0, desaceleracao);
    velv = abs(velv) <= 0.2 ? 0 : lerp(velv, 0, desaceleracao);
    sprite_index = spr_player_idle;
}

// Gerencia a capacidade de usar dash
if (pode_dash_player >= 10) {
    pode_dash_player = 0;
    can_dash = true;
}

// Tenta executar o dash se o jogador pressionar espaço
executar_dash();

// Ajusta visual baseado no estado atual
ajustar_estado_visual();

// Gerencia o dash ativo
if (on_dash) {
    // Aplica o movimento de dash
    velh = lengthdir_x(velocidade_dash * upgrade_velocidade_dash, dash_dir);
    velv = lengthdir_y(velocidade_dash * upgrade_velocidade_dash, dash_dir);
    
    // Verifica se atingiu a distância máxima do dash
    if (point_distance(x, y, posicao_inicial_dash.x, posicao_inicial_dash.y) > distancia_dash * upgrade_distancia_dash) {
        on_dash = false;
        dash_cooldown = dash_timer;
    }
} else {
    // Reduz o cooldown do dash
    dash_cooldown = max(0, dash_cooldown - 1);
}

// Gerencia o knockback ativo
if (on_knockback) {
    // Cancela o dash se estiver em knockback
    on_dash = false;
    
    // Aplica o movimento de knockback
    velh = lengthdir_x(knockback_strenght, knockback_dir);
    velv = lengthdir_y(knockback_strenght, knockback_dir);
    
    // Reduz a força do knockback gradualmente
    knockback_strenght = abs(knockback_strenght) <= 0.2 ? 0 : lerp(knockback_strenght, 0, desaceleracao);
    
    // Finaliza o knockback quando a força é muito pequena
    if (knockback_strenght <= 0) {
        on_knockback = false;
        estou_movendo = false;
    }
}

// Atualiza elementos visuais relacionados ao jogador
depth = -bbox_bottom;
shadow.x = x;
shadow.y = y;
light.depth = depth;