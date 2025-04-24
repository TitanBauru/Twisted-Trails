
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vTexcoord;
uniform float u_threshold;
		
void main() {
	vec4 colTex = texture2D(gm_BaseTexture, v_vTexcoord);
	gl_FragColor = vec4(clamp(colTex.rgb-u_threshold, 0.0, 1.0), 1.0);
}
