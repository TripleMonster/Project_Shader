Shader "Custom/2D/Mosaic_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SquareWidth ("Square Width", Range(1, 30)) = 8
        _TexSize ("Texture Size", vector) = (256,256,0,0)
    }
    SubShader
    {
        Tags 
        {
            "RenderType"="Transparent"
            "Queue"="Transparent"
            "IgnoreProjector"="True"
        }
        LOD 100

        Pass
        {
            Cull Off 
            Lighting Off 
            ZWrite Off 
            Fog { Mode Off }
            Offset -1, -1
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert 
            #pragma fragment frag 
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _SquareWidth;
            float4 _TexSize;

            struct a2f 
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                half2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            v2f vert (a2f v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : COLOR
            {
                float pixelX = int(i.uv.x * _TexSize.x / _SquareWidth) * _SquareWidth;
                float pixelY = int(i.uv.y * _TexSize.y / _SquareWidth) * _SquareWidth;
                float2 uv = float2(pixelX / _TexSize.x, pixelY / _TexSize.y);
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }

            ENDCG
        }
    }
}
