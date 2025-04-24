
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2022 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vTexcoord;
uniform vec2 u_texelSize;

// standard box filtering
void main() {
	vec4 d = u_texelSize.xyxy * vec2(-0.5, 0.5).xxyy; // delta
	vec4 col;
	col =  (texture2D(gm_BaseTexture, v_vTexcoord + d.xy));
	col += (texture2D(gm_BaseTexture, v_vTexcoord + d.zy));
	col += (texture2D(gm_BaseTexture, v_vTexcoord + d.xw));
	col += (texture2D(gm_BaseTexture, v_vTexcoord + d.zw));
	gl_FragColor = col * 0.25; // (1.0 / 4.0)
}
