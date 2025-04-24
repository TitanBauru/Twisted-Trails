
/*------------------------------------------------------------------
You cannot redistribute this pixel shader source code anywhere.
Only compiled binary executables. Don't remove this notice, please.
Copyright (C) 2025 Mozart Junior (FoxyOfJungle). Kazan Games Ltd.
Website: https://foxyofjungle.itch.io/ | Discord: @foxyofjungle
-------------------------------------------------------------------*/

varying vec2 v_vTexcoord;
varying vec2 v_vTexelSize;
varying vec4 v_vFragPosition;

uniform float u_strength;

// >> effect
// Original shader by Timothy Lottes, NVIDIA
// https://developer.download.nvidia.com/assets/gamedev/files/sdk/11/FXAA_WhitePaper.pdf

#define FXAA_REDUCE_MIN (1.0 / 128.0)
#define FXAA_REDUCE_MUL (1.0 / 8.0)

void main() {
	vec3 baseNW = texture2D(gm_BaseTexture, v_vFragPosition.zw).rgb;
	vec3 baseNE = texture2D(gm_BaseTexture, v_vFragPosition.zw + vec2(1.0, 0.0) * v_vTexelSize).rgb;
	vec3 baseSW = texture2D(gm_BaseTexture, v_vFragPosition.zw + vec2(0.0, 1.0) * v_vTexelSize).rgb;
	vec3 baseSE = texture2D(gm_BaseTexture, v_vFragPosition.zw + vec2(1.0, 1.0) * v_vTexelSize).rgb;
	vec3 col_tex = texture2D(gm_BaseTexture, v_vFragPosition.xy).rgb;
	
	vec3 lum = vec3(0.299, 0.587, 0.114);
	float lumNW = dot(baseNW, lum);
	float lumNE = dot(baseNE, lum);
	float lumSW = dot(baseSW, lum);
	float lumSE = dot(baseSE, lum);
	float lumCol = dot(col_tex, lum);
	
	float lumMin = min(lumCol, min(min(lumNW, lumNE), min(lumSW, lumSE)));
	float lumMax = max(lumCol, max(max(lumNW, lumNE), max(lumSW, lumSE)));
	
	vec2 dir = vec2(-((lumNW + lumNE) - (lumSW + lumSE)), ((lumNW + lumSW) - (lumNE + lumSE)));
	
	float dirReduce = max((lumNW + lumNE + lumSW + lumSE) * FXAA_REDUCE_MUL * 0.25, FXAA_REDUCE_MIN);
	float dirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
	dir = min(vec2(u_strength), max(vec2(-u_strength), dir * dirMin)) * v_vTexelSize; // SPAN MAX
	
	vec4 resultA = 0.5 * (texture2D(gm_BaseTexture, v_vFragPosition.xy + dir * -0.166667) +
							texture2D(gm_BaseTexture, v_vFragPosition.xy + dir * 0.166667));
	vec4 resultB = resultA * 0.5 + 0.25 * (texture2D(gm_BaseTexture, v_vFragPosition.xy + dir * -0.5) +
											texture2D(gm_BaseTexture, v_vFragPosition.xy + dir * 0.5));
	float lumB = dot(resultB.rgb, lum);
	gl_FragColor = (lumB < lumMin || lumB > lumMax) ? resultA : resultB;
}
