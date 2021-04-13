Shader "Custom/2D/Sharpen_Shader"
{
    Properties
    {
        [PerRendererData] _MainTex ("Texture", 2D) = "white" {}
        _TexSize("Texture Size", vector) = (256,256,0,0)
        _BlurOffset("Blur Offset", Range(1, 10)) = 1
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Transparent"
            "IgnoreProjector"="True"
        }
        LOD 200

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

            struct a2v
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
                
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TexSize;
            fixed _BlurOffset;

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            float4 filter(float3x3 filter, sampler2D tex, float2 coord, float2 texSize)
            {
                float4 outCol = float4(0,0,0,0);
                for (int i = 0; i < 3; i++)
                {
                    for (int j = 0; j < 3; j++)
                    {
                        float2 newCoord = float2(coord.x + (i-1)*_BlurOffset, coord.y + (j-1)*_BlurOffset);
                        float2 newUV = float2(newCoord.x / texSize.x, newCoord.y / texSize.y);
                        outCol += tex2D(tex, newUV) * filter[i][j];
                    }
                }
                return outCol;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3x3 laplaceFilter = {
                    -1,-1,-1,
                    -1, 9,-1,
                    -1,-1,-1,
                };
                float2 coord = float2(i.uv.x * _TexSize.x, i.uv.y * _TexSize.y);
                return filter(laplaceFilter, _MainTex, coord, _TexSize);
            }
            ENDCG
        }
    }

    SubShader
    {
        LOD 100

        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        
        Pass
        {
            Cull Off
            Lighting Off
            ZWrite Off
            Fog { Mode Off }
            Offset -1, -1
            ColorMask RGB
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMaterial AmbientAndDiffuse
            
            SetTexture [_MainTex]
            {
                Combine Texture * Primary
            }
        }
    }
}
