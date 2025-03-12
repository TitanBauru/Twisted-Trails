// Atualiza posição do player em células
real_px = round(obj_player.x / cell_size);
real_py = round(obj_player.y / cell_size);

// Geração inicial maior
if (inicio)
{
    generate_tiles(obj_player.x, obj_player.y, buffer * 2);
    inicio = false;
}

// Atualiza tiles quando o player se move uma célula
if (real_px != px || real_py != py)
{
    generate_tiles(obj_player.x, obj_player.y, buffer);
    px = real_px;
    py = real_py;
}