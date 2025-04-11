/// @description Insert description here
// You can write your code in this editor
vida = 100000
vida_max = vida

flash_white = 0
estado = "Idle"

escudo = false

velv = 0 
velh = 0

xscale = 1
yscale = 1 

cooldown_hit = 0; // Tempo de cooldown atual para quando o inimigo é atingido.
cooldown_hit_max = 0; // Tempo máximo de cooldown entre hits.
tempo_flash = 0; // Duração do flash quando o inimigo é atingido.
tomei_hit = false; // Indica se o inimigo foi atingido recentemente.

lado = 1

dummy_total_damage = 0
dummy_start_time = 0
dummy_dps = 0
dummy_is_active = false


damage_events = ds_list_create();

shadow = new Crystal_Shadow(id, CRYSTAL_SHADOW.DYNAMIC);
shadow.AddMesh(new Crystal_ShadowMesh().FromSpriteBBoxEllipse(spr_dummy_idle));
shadow.shadowLength = 3
shadow.Apply();

function apply_damage(amount) {
    ds_list_add(damage_events, [amount, current_time]);
    dummy_total_damage += amount;
}
function aplicar_squish_and_stretch() {
    tomei_hit = true;
    xscale = 1.2*lado;
    yscale = 0.8;
    tempo_flash -= 0.5;
	flash_white = 1
}

function resetar_escala() {
    xscale = lerp(xscale, lado, 0.1);
    yscale = lerp(yscale, 1, 0.1);
}

function ajustar_direcao_para_target(target_x)
{
    
         if (target_x < x && lado != 1)
        {
            lado = 1;
            xscale = lado;
        }
        else if (target_x >= x && lado != -1)
        {
            lado = -1;
            xscale = lado;
        }
    
}
