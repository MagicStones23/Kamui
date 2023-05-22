using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public partial class Library {
    public static Vector3 GetHelixFromToPos(float t, float radiusMin, float radiusMax, float angleOffset, float angleMax, Vector3 fromPos, Vector3 toPos) {
        float loopT = t * 2;
        loopT = loopT > 1 ? 2 - loopT : loopT;
        loopT = Mathf.SmoothStep(0, 1, loopT);

        float angle = Mathf.Lerp(angleOffset, angleOffset + angleMax, t);
        float radius = Mathf.Lerp(radiusMin, radiusMax, loopT);

        Vector3 center = Vector3.Lerp(fromPos, toPos, t);
        Vector3 forward = toPos - fromPos;
        Vector3 right = Vector3.Cross(forward, Vector3.up);
        Vector3 up = Vector3.Cross(forward, right);

        right = Vector3.Normalize(right);
        up = Vector3.Normalize(up);

        Vector3 dir = AngleToDir(angle) * radius;

        Vector3 pos = center + dir.x * right + dir.z * up;
        return pos;
    }
}