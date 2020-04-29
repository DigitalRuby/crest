// Crest Ocean System

// This file is subject to the MIT License as seen in the root of this folder structure (LICENSE)

// GLOBALs - we're allowed to use these anywhere. TODO should all be prefixed by "Crest"!

#ifndef CREST_OCEAN_GLOBALS_H
#define CREST_OCEAN_GLOBALS_H

SamplerState LODData_linear_clamp_sampler;
SamplerState LODData_point_clamp_sampler;
SamplerState sampler_Crest_linear_repeat;

CBUFFER_START(CrestPerFrame)
float _CrestTime;
float _TexelsPerWave;
float3 _OceanCenterPosWorld;
float _SliceCount;
float _MeshScaleLerp;
float _CrestLodAlphaBlackPointFade;
float _CrestLodAlphaBlackPointWhitePointFade;

float3 _PrimaryLightDirection;
float3 _PrimaryLightIntensity;
CBUFFER_END

#define USE_EXTERNAL_SHADERS

#if defined(USE_EXTERNAL_SHADERS)

#include "../../../WeatherMaker/Prefab/Shaders/WeatherMakerFogExternalShaderInclude.cginc"

fixed OceanExternalShadow(float3 worldPos, float shadowValue)
{
	return ComputeWeatherMakerShadows(worldPos, shadowValue, false); // true to sample shadow details, higher res shadow
}

fixed3 OceanExternalFog(fixed3 col, float3 worldPos)
{
	return col;

	// does not look right at all, TODO: investigate
	//fixed4 fog = ComputeWeatherMakerFog(fixed4(col, 1.0), worldPos, false); // false for non-volumetric lighted fog
	//return fog.rgb;
}

fixed3 OceanLightColor()
{
	return _WeatherMakerDirLightColor[0].rgb * _WeatherMakerDirLightColor[0].a;
}

float3 OceanLightDir(float3 worldPos)
{
	return _WeatherMakerDirLightPosition[0].xyz;
}

#else

float3 OceanLightDir(float3 worldPos)
{
	float3 lightDir = _WorldSpaceLightPos0.xyz;
	if (_WorldSpaceLightPos0.w > 0.)
	{
		// non-directional light - this is a position, not a direction
		lightDir = normalize(lightDir - worldPos.xyz);
	}
	return lightDir;

}

fixed3 OceanLightColor()
{
	return _LightColor0;
}

#endif

#endif
