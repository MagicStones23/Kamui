using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public partial class Library {
    public static Vector3 AngleToDir(float angle) {
        float radiant = Mathf.Deg2Rad * angle;
        float x = Mathf.Cos(radiant);
        float z = Mathf.Sin(radiant);
        Vector3 dir = new Vector3(x, 0, z);
        return dir;
    }
}