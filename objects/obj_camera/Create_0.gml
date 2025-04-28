/// @description Configurações de câmera para diferentes sistemas operacionais e criação de câmera com limite e movimento suave.

// Inicialização de variáveis de largura (_w) e altura (_h) da janela.
var _w = 960, _h = 540;

// Verificação do tipo de sistema operacional.
switch (os_type) {
    case os_android: // Se for Android:
        _w = display_get_width();  // Obtém a largura da tela do dispositivo.
        _h = display_get_height(); // Obtém a altura da tela do dispositivo.
    
        // Comentei a linha abaixo porque redimensionar o surface não é necessário para Android.
        // surface_resize(application_surface, _w, _h);

        window_set_size(_w, _h); // Define o tamanho da janela para a largura e altura da tela.
    
        // Define o tamanho da interface gráfica (GUI) como metade da largura e altura da tela.
        display_set_gui_size(_w * 0.5, _h * 0.5);
        
        // Define o tamanho da porta de visão (view port) como um quarto da largura e altura da tela.
        view_wport[0] = _w * 0.25;
        view_hport[0] = _h * 0.25;
        break;
    default: // Para outros sistemas operacionais (PC, etc.):
        surface_resize(application_surface, 1920, 1080); // Redimensiona a surface da aplicação para 1920x1080.
        
        window_set_size(960, 540); // Define o tamanho da janela para 960x540.
        window_center();
        // Define o tamanho da interface gráfica (GUI) como dois terços da largura e altura da janela.
        display_set_gui_size(_w/2, _h/2);
        
        // Define o tamanho da porta de visão (view port) como metade da largura e altura da janela.
        view_wport[0] = _w / 2;
        view_hport[0] = _h / 2;
        break;
}

// Criação do objeto de câmera associado ao objeto obj_camera.
camera = new Camera(0, 0, 0);

// Faz a câmera seguir o jogador (obj_player).

//camera.follow(obj_cursor) add essa feature depois

camera.follow(obj_player);

// Define o modo de movimento da câmera como "Damped" (movimento suave).
camera.setModeDamped();

// Define os limites da câmera para não ultrapassar os limites da sala.
camera.limit(0, 0, room_width, room_height);

// Variável de controle para travar ou destravar a câmera.
cameraLocked = false;
