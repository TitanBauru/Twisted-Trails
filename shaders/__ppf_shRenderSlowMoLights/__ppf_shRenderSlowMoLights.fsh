
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

#define IS_ADDITIVE // comment this if not

varying vec2 v_vTexcoord;
uniform float u_lightsIntensity;
uniform sampler2D u_lightsTexture;

vec3 Blend(vec3 source, vec3 dest) {
	return source + dest - source * dest;
}

void main() {
	vec4 mainTex = texture2D(gm_BaseTexture, v_vTexcoord);
	vec4 slowmoTex = texture2D(u_lightsTexture, v_vTexcoord);
	#ifdef IS_ADDITIVE
		mainTex.rgb += slowmoTex.rgb * u_lightsIntensity;
	#else
		mainTex.rgb = Blend(mainTex.rgb, slowmoTex.rgb);
	#endif
	gl_FragColor = mainTex;
}
