Shader "Custom/WibbleWobbleVerts"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_randomTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags{ "RenderType" = "Opaque" }
		LOD 100

		Pass
	{
		CGPROGRAM
#pragma vertex vertfunc
#pragma fragment fragfunc

#include "UnityCG.cginc"

		struct vertIn
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct vertOut
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};

	sampler2D _MainTex;
	sampler2D _randomTex;
	float4 _MainTex_ST;

	vertOut vertfunc(vertIn v)
	{
		vertOut o;
		float4 funcInput = (v.uv, 0, 0);
		fixed4 rand = tex2Dlod(_randomTex, funcInput);
		float4 worldcenta = (0, 0, 0, 0);
		float4 posToCenter = v.vertex - worldcenta;
		float dist = length(posToCenter);
		v.vertex.x += sin(_Time[2] + dist + rand.x)/3;
		v.vertex.y += sin(_Time[1] + dist + rand.y)/3;
		v.vertex.z += sin(_Time[3] + dist + rand.z) / 3;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}

	fixed4 fragfunc(vertOut i) : SV_Target
	{// nothin special on frags this time

		// sample the texture
		//float2 screenMid = float2(0.5, 0.5);
		//float2 fragtoMid = screenMid - i.uv;
		//float  dist = length(fragtoMid);
		//i.uv.x += (sin(dist * 10 + _Time[1]) / 50) + (cos(dist * 10 + _Time[2]) / 50)*dist;
		//i.uv.y += (sin(dist * 10 + _Time[0]) / 50) + (cos(dist * 10 + _Time[3]) / 50)*dist;
		//fixed4 col = tex2D(_MainTex, i.uv) /*+ (dist/3*(sin(_Time[2]))*fragtoMid))*/;
		//col = 1 - col;
		//col.rgb *= .3 - dist;
		fixed4 col = tex2D(_MainTex, i.uv);
			return 1-col;
	}
		ENDCG
	}
	}
}