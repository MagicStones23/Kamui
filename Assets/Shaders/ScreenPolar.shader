Shader "Tutorial/ScreenPolar"
{
    Properties
    {
        [NoScaleOffset] _MainTex ("MainTex", 2D) = "white" {}
        [HDR] _MainColor ("MainColor", Color) = (1, 1, 1, 1)
        _MainScaleAndOffset ("MainScaleAndOffset", Vector) = (1, 1, 0, 0)
        _MainSpeed ("MainSpeed", Vector) = (0, 0, 0, 0)

        _FixedMask ("FixedMask", 2D) = "white" {}

        _PolarPower ("PolarPower", Float) = 0
        _PolarRotate ("PolarRotate", Range(0, 360)) = 0
        
        _AlphaPower ("AlphaPower", Float) = 1
    }
    SubShader
    {
        Tags { "RenderPipeline"="UniversalPipeline" "Queue"="Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha
        ZTest Always
        ZWrite Off

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainColor;
            float4 _MainScaleAndOffset;
            float4 _MainSpeed;

            sampler2D _FixedMask;
            float4 _FixedMask_ST;

            float _PolarPower;
            float _PolarRotate;

            float _AlphaPower;

            v2f vert (appdata v)
            {
                v2f o;
                float4 vertex = float4(v.uv, 0, 1);
                #if UNITY_UV_STARTS_AT_TOP
                vertex.y = 1 - vertex.y;
                #endif
                vertex.xy = (vertex.xy * 2) - float2(1, 1);
                o.vertex = vertex;

                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 color = i.color;
                color *= _MainColor;

                float2 uv = i.uv;

                uv = uv - float2(0.5, 0.5);
				float rotateRadians = radians(_PolarRotate * (1 - length(uv)));
				float2x2 rotateMatrix = {cos(rotateRadians), -sin(rotateRadians), sin(rotateRadians), cos(rotateRadians)};
				uv = mul(rotateMatrix, uv);
				uv += float2(0.5, 0.5);

                uv = uv * 2 - 1;
                float newX = length(uv);
                newX = pow(newX, exp2(_PolarPower));
                float newY = atan2(uv.y, uv.x);
                newY = newY / (PI * 2) + 0.5;

                float2 newUV = float2(newX, newY);

                float2 mainUV = (newUV + _MainScaleAndOffset.zw + _MainSpeed.xy * _Time.y) * _MainScaleAndOffset.xy;
                color *= tex2D(_MainTex, mainUV);

                float fixedMask = tex2D(_FixedMask, i.uv * _FixedMask_ST.xy + _FixedMask_ST.zw);
                color.a *= fixedMask;

                color.a = pow(abs(color.a), _AlphaPower);
                return color;
            }
            ENDHLSL
        }
    }
}