Shader "Custom/2D/Gaussian_Blur_Shader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Blur("Blur",Range(0,1)) = 0.01
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
    }
    SubShader
    {
        Tags
        { 
            "Queue"="Transparent" 
            "IgnoreProjector"="True" 
            "RenderType"="Transparent" 
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }
 
        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ PIXELSNAP_ON
            #include "UnityCG.cginc"
 
            struct a2v
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };
 
            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float2 texcoord  : TEXCOORD0;
            };
 
            v2f vert(a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                o.color = v.color;
                #ifdef PIXELSNAP_ON
                o.vertex = UnityPixelSnap (v.vertex);
                #endif
 
                return o;
            }
 
            sampler2D _MainTex;
            sampler2D _AlphaTex;
            float _AlphaSplitEnabled;
            float _Blur;
 
            fixed4 SampleSpriteTexture (float2 uv)
            {
                // 1 / 16
                float distance = _Blur * 0.0625f;
 
                fixed4 color = tex2D (_MainTex, uv);
                fixed4 leftColor = tex2D(_MainTex,float2(uv.x - distance,uv.y));
                fixed4 rightColor = tex2D(_MainTex,float2(uv.x + distance,uv.y));
                fixed4 topColor = tex2D(_MainTex,float2(uv.x,uv.y + distance));
                fixed4 bottomColor = tex2D(_MainTex,float2(uv.x,uv.y - distance));
 
                color = color * 4 + leftColor + rightColor + topColor + bottomColor;
                color = color * 0.125;
 
#if UNITY_TEXTURE_ALPHASPLIT_ALLOWED
                if (_AlphaSplitEnabled)
                    color.a = tex2D (_AlphaTex, uv).r;
#endif //UNITY_TEXTURE_ALPHASPLIT_ALLOWED
 
                return color;
            }
 
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = SampleSpriteTexture (i.texcoord) * i.color;
                c.rgb *= c.a;
                return c;
            }
            ENDCG
        }
    }
}
