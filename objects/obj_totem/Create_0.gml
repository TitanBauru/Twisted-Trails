// No objeto: obj_shop_base
// Create Event

// No código de criação da loja
// Propriedades básicas...
item_spawned = false;
shop_item = noone;
item_id_to_spawn = -1; // ID do item que será criado

// No início, apenas selecionar o ID do item, sem criar o objeto ainda
randomize();
item_id_to_spawn = 0;

// Adiar a criação do item usando um alarm
alarm[0] = 1; // Esperar 1 frame
// Propriedades básicas
sprite_index = spr_totem; // Sprite do totem (você precisa criar)
image_speed = 0.2;             // Velocidade da animação, se houver

// Propriedades visuais
glow_intensity = 0;            // Intensidade do brilho ao redor do totem
glow_radius = 150;             // Raio do brilho
glow_color = c_aqua;         // Cor do brilho
glow_pulse_speed = 0      // Velocidade da pulsação do brilho

// Propriedades de animação
active = false;                // Totem está ativo (player próximo)
shake_amount = 0;              // Quantidade de tremor/vibração
float_offset = 0;              // Deslocamento para efeito flutuante
float_speed = 0.05;            // Velocidade da flutuação

// Variáveis para o item
item_spawned = false;          // Se o item já foi criado
shop_item = noone;             // Referência ao item na loja
spawn_delay = 30;              // Delay para spawnar o item (em steps)

// Iniciar spawn do item após delay
alarm[0] = spawn_delay;

// Sistema de partículas
particle_system = part_system_create();
part_system_depth(particle_system, depth-5);

// Partícula de brilho
particle_glow = part_type_create();
part_type_shape(particle_glow, pt_shape_disk);
part_type_size(particle_glow, 0.1, 0.2, -0.001, 0);
part_type_scale(particle_glow, .5, .5);
part_type_color3(particle_glow, glow_color, glow_color, glow_color);
part_type_alpha3(particle_glow, 1, 1, 1);
part_type_speed(particle_glow, 0.1, 0.3, 0, 0);
part_type_direction(particle_glow, 0, 359, 0, 0);
part_type_life(particle_glow, 200, 400);
part_type_blend(particle_glow, true);

// Emitter para as partículas
emitter = part_emitter_create(particle_system);
part_emitter_region(particle_system, emitter, x-20, x+20, y-15, y+15, ps_shape_ellipse, ps_distr_gaussian);
part_emitter_stream(particle_system, emitter, particle_glow, -5); // -5 significa ~1 partícula a cada 5 steps