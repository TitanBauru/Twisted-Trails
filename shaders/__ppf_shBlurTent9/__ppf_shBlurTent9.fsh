
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2022 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vTexcoord;
uniform vec2 u_texelSize;

// 9-tap bilinear upsampler (tent filter)
void main() {
	vec4 d = u_texelSize.xyxy * vec4(1.0, 1.0, -1.0, 0.0);
	vec4 col;
	col =  texture2D(gm_BaseTexture, v_vTexcoord - d.xy);
	col += texture2D(gm_BaseTexture, v_vTexcoord - d.wy) * 2.0;
	col += texture2D(gm_BaseTexture, v_vTexcoord - d.zy);
	
	col += texture2D(gm_BaseTexture, v_vTexcoord + d.zw) * 2.0;
	col += texture2D(gm_BaseTexture, v_vTexcoord) * 4.0;
	col += texture2D(gm_BaseTexture, v_vTexcoord + d.xw) * 2.0;
	
	col += texture2D(gm_BaseTexture, v_vTexcoord + d.zy);
	col += texture2D(gm_BaseTexture, v_vTexcoord + d.wy) * 2.0;
	col += texture2D(gm_BaseTexture, v_vTexcoord + d.xy);
	
	gl_FragColor = clamp(col * 0.0625, 0.0, 1.0); // ((1.0 / 16.0))
}
