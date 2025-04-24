
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2022 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vTexcoord;
uniform vec2 u_texelSize;

// better, temporally stable box filtering
// [Jimenez14] http://goo.gl/eomGso
void main() {
	vec4 A = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2(-1.0, -1.0));
    vec4 B = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 0.0, -1.0));
    vec4 C = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 1.0, -1.0));
    vec4 D = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2(-0.5, -0.5));
    vec4 E = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 0.5, -0.5));
    vec4 F = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2(-1.0,  0.0));
    vec4 G = texture2D(gm_BaseTexture, v_vTexcoord);
    vec4 H = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 1.0,  0.0));
    vec4 I = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2(-0.5,  0.5));
    vec4 J = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 0.5,  0.5));
    vec4 K = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2(-1.0,  1.0));
    vec4 L = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 0.0,  1.0));
    vec4 M = texture2D(gm_BaseTexture, v_vTexcoord + u_texelSize * vec2( 1.0,  1.0));
	
    vec2 div = 0.25 * vec2(0.5, 0.125); //(1.0 / 4.0)
	
    vec4 col = (D + E + I + J) * div.x;
		col += (A + B + G + F) * div.y;
		col += (B + C + H + G) * div.y;
		col += (F + G + L + K) * div.y;
		col += (G + H + M + L) * div.y;
	
	gl_FragColor = col;
}
