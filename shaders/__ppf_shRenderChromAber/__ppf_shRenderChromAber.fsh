
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

precision highp float;

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec2 v_vPosition;

uniform vec2 u_resolution;

// quality (low number = more performance)
#ifdef _YY_HLSL11_
#define ITERATIONS 16.0 // windows
#else
#define ITERATIONS 8.0 // others (android, operagx...)
#endif

uniform float u_intensity;
uniform vec2 u_dirVector;
uniform float u_centerRadius;
uniform float u_inner;
uniform float u_blurEnable;
uniform sampler2D u_prismaLUTtexture;
uniform vec4 u_prismaLutUVs;

const float ITERATIONS_RECIPROCAL = 1.0/ITERATIONS;

void main() {
	vec2 uv = v_vTexcoord;
	vec2 uv2 = uv * 2.0-1.0;
	float mask = dot(uv2, uv2) * pow(length(uv - 0.5), u_centerRadius) * 2.0;
	vec2 weight = mix(vec2(u_intensity), -uv2*mask*u_intensity, u_inner) / 3.0;
	vec2 offset = vec2(weight * u_dirVector);
	offset /= (u_resolution / min(u_resolution.x, u_resolution.y));
	vec4 mainTex;
	if (u_blurEnable < 0.5) {
		vec2 uvLa = mix(u_prismaLutUVs.xy, u_prismaLutUVs.zw, vec2(0.5/3.0, 0.0));
		vec2 uvLb = mix(u_prismaLutUVs.xy, u_prismaLutUVs.zw, vec2(1.5/3.0, 0.0));
		vec2 uvLc = mix(u_prismaLutUVs.xy, u_prismaLutUVs.zw, vec2(2.5/3.0, 0.0));
		vec4 colLutA = texture2D(u_prismaLUTtexture, uvLa);
		vec4 colLutB = texture2D(u_prismaLUTtexture, uvLb);
		vec4 colLutC = texture2D(u_prismaLUTtexture, uvLc);
		vec4 colTexA = texture2D(gm_BaseTexture, uv + offset);
		vec4 colTexB = texture2D(gm_BaseTexture, uv);
		vec4 colTexC = texture2D(gm_BaseTexture, uv - offset);
		vec4 chroma = colTexA*colLutA + colTexB*colLutB + colTexC*colLutC;
		vec4 prisma = (colLutA + colLutB + colLutC);
		mainTex = chroma / prisma;
	} else {
		float move;
		vec4 chroma;
		vec4 prisma;
		for(float i = 0.0; i < ITERATIONS; ++i) {
			move = i * ITERATIONS_RECIPROCAL;
			vec4 lut = texture2D(u_prismaLUTtexture, mix(u_prismaLutUVs.xy, u_prismaLutUVs.zw, vec2(move, 0.0)));
			chroma += texture2D(gm_BaseTexture, uv - (move*2.0-1.0) * offset) * lut;
			prisma += lut;
		}
		mainTex = chroma / prisma;
	}
	gl_FragColor = mainTex;
}
