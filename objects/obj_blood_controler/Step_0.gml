/// @description Inserir descrição aqui
// Você pode escrever seu código neste editor
if (!surface_exists(global.surface_blood)) {
    global.surface_blood = surface_create(room_width, room_height);
}
if (!surface_exists(global.surf_debri)) {
    global.surf_debri = surface_create(room_width, room_height);
}