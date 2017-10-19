Shader "Custom/WibbleWobble"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
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
			float4 _MainTex_ST;
			
			vertOut vertfunc (vertIn v)
			{
				vertOut o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 fragfunc (vertOut i) : SV_Target
			{
				// sample the texture
				float2 screenMid = float2(0.5, 0.5);
				float2 fragtoMid = screenMid - i.uv;
				float  dist = length(fragtoMid);
				i.uv.x += (sin(dist * 10 + _Time[1])/50) + (cos(dist * 10 + _Time[2]) / 50)*dist;
				i.uv.y += (sin(dist * 10 + _Time[0]) / 50) + (cos(dist * 10 + _Time[3]) / 50)*dist;
				fixed4 col = tex2D(_MainTex, i.uv ) /*+ (dist/3*(sin(_Time[2]))*fragtoMid))*/;
				col = 1-col;
				//col.rgb *= .3 - dist;
				return col; 
			}
			ENDCG
		}
	}
}
