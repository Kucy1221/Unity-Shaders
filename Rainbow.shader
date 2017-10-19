//Iterates a texture over the object's verts and extrudes the verts depending on their current color

Shader "Custom/Rainbow"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_RandTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		cull Off
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 color: COLOR;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			sampler2D _RandTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v, float3 normal : NORMAL)
			{
				v2f o;
				float4 coord = float4(v.uv.x * _Time[0] / 9, v.uv.y*_Time[0]/3.78 / 10, 0, 0); // numbers are random, this line is what iterates over the texture.
				float4 col = tex2Dlod(_RandTex, coord);
				v.vertex.xyz += normalize(normal) * col.r * .5; // pop out if the vert is red
				v.vertex.xyz -= normalize(normal) * col.b * .5; // retract if the vert is blue
				o.color = col;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = i.color;
				return col;
			}
			ENDCG
		}
	}
}
