Shader "Custom/3D/Shield_Basic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightTex ("Light Texture", 2D) = "white" {}
        _SpeedX ("Speed X", float) = 0.9
        _SpeedY ("Speed Y", float) = 0.5
        _LightCol ("Light Color", Color) = (1,1,1,1)
        _GradientTex ("Gradient Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "ForceNoShadowCasting"="True"
        }
        Blend SrcAlpha OneMinusSrcAlpha

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
                float4 vertex : SV_POSITION;
                float2 gradientUV : TEXCOORD1;
            };

            sampler2D _MainTex, _LightTex;
            float4 _MainTex_ST;
            float _SpeedX;
            float _SpeedY;
            half4 _LightCol;
            sampler2D _GradientTex;
            float4 _GradientTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // uv延x轴做一个移动动画
                o.uv += float2(_Time.x * _SpeedX, 0);
                // 对 梯度图进行采样
                o.gradientUV = TRANSFORM_TEX(v.uv, _GradientTex);
                // 对梯度图在y轴做一个uv动画
                o.gradientUV += float2(0, _Time.y * _SpeedY);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                half4 light = tex2D(_LightTex, i.uv);
                light.rgb = light.r * _LightCol.rgb;
                col.rgb += light.rgb;
                fixed4 gradient = tex2D(_GradientTex, i.gradientUV);
                col.rgb += gradient.rgb;
                return col;
            }
            ENDCG
        }
    }
}
