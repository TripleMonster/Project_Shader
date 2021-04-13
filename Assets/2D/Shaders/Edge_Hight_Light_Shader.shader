// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/2D/Edge_Hight_Light_Shader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Texture", 2D) = "white" {}
		_LineWidth("LineWidth", Range(0,10)) = 1
        _LineColor("LineColor", Color)=(1,1,1,1)
    }
    SubShader
    {
        Tags { "Queue"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct a2f
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				fixed2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
			float4 _MainTex_TexelSize;
            float _LineWidth;
            float4 _LineColor;
    
            v2f vert(a2f v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                // 采样周围4个点
                float2 up_uv = i.uv + float2(0,1) * _LineWidth * _MainTex_TexelSize.xy;
                float2 down_uv = i.uv + float2(0,-1) * _LineWidth * _MainTex_TexelSize.xy;
                float2 left_uv = i.uv + float2(-1,0) * _LineWidth * _MainTex_TexelSize.xy;
                float2 right_uv = i.uv + float2(1,0) * _LineWidth * _MainTex_TexelSize.xy;
                // 如果有一个点透明度为0 说明是边缘
                float w = tex2D(_MainTex,up_uv).a * tex2D(_MainTex,down_uv).a * tex2D(_MainTex,left_uv).a * tex2D(_MainTex,right_uv).a;
                col.rgb = lerp(_LineColor,col.rgb,w);
                return col;
            }
            ENDCG
        }
    }
}
