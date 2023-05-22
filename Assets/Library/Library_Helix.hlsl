#ifndef Library_Helix
#define Library_Helix
	
    #include "Assets/Library/Library_Radiant.hlsl"

    float3 GetHelixFromToPos(float t, float radiusMin, float radiusMax, float angleOffset, float angleMax, float3 fromPos, float3 toPos) {
        float loopT = t * 2;
        loopT = loopT > 1 ? 2 - loopT : loopT;
        loopT = smoothstep(0, 1, loopT);

        float angle = lerp(angleOffset, angleOffset + angleMax, t);
        float radius = lerp(radiusMin, radiusMax, loopT);

        float3 center = lerp(fromPos, toPos, t);
        float3 forward = toPos - fromPos;
        float3 right = cross(forward, float3(0, 1, 0));
        float3 up = cross(forward, right);

        right = normalize(right);
        up = normalize(up);

        float3 dir = AngleToDir(angle) * radius;

        float3 pos = center + dir.x * right + dir.z * up;
        return pos;
    }

#endif