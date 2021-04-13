Shader "Custom/2D/Grey_Button_Shader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "CanUserSpriteAtlas"="True"
        }
        
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            sampler2D _MainTex;
            fixed4 _Color;

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord = v.texcoord;
                o.color = v.color * (0,0,0,1);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half4 color = tex2D(_MainTex, i.texcoord) * i.color;
                float gray = dot(color.rgb, fixed3(0.22, 0.707, 0.071));
                return half4(gray, gray, gray, color.a);
            }
            ENDCG
        }
    }
}
