/// END STEP EVENT - Colisões e ajuste final da posição

// Função para resetar o dash ao colidir
var reset_dash = function() {
    if (on_dash) {
        on_dash = false;
        dash_cooldown = dash_timer;
    }
}

var _colisores = [obj_colisor, obj_prop_solid]

// Colisão Horizontal
if (velh != 0) {
    if (place_meeting(x + velh, y, _colisores)) {
        // Ajusta a posição para colar na parede
        while (!place_meeting(x + sign(velh), y, _colisores) && abs(velh) > 0) {
            x += sign(velh);
        }
        velh = 0; // Para o movimento horizontal
        reset_dash(); // Reseta o dash se colidir
        
        // Reduz knockback ao colidir com parede
        if (on_knockback) {
            knockback_strenght *= 0.5; // Reduz a força do knockback pela metade
        }
    } else {
        x += velh; // Move normalmente
    }
}

// Colisão Vertical
if (velv != 0) {
    if (place_meeting(x, y + velv, _colisores)) {
        // Ajusta a posição para colar na parede
        while (!place_meeting(x, y + sign(velv), _colisores) && abs(velv) > 0) {
            y += sign(velv);
        }
        velv = 0; // Para o movimento vertical
        reset_dash(); // Reseta o dash se colidir
        
        // Reduz knockback ao colidir com parede
        if (on_knockback) {
            knockback_strenght *= 0.5; // Reduz a força do knockback pela metade
        }
    } else {
        y += velv; // Move normalmente
    }
}

// Verificação de colisão diagonal (deslizamento ao longo da parede)
if (velh != 0 && velv != 0) {
    // Se colidiu em ambas as direções (canto), tenta deslizar
    if (place_meeting(x + velh, y + velv, _colisores)) {
        // Tenta mover apenas horizontalmente
        if (!place_meeting(x + velh, y, _colisores)) {
            x += velh;
        }
        // Tenta mover apenas verticalmente
        else if (!place_meeting(x, y + velv, _colisores)) {
            y += velv;
        }
    }
}