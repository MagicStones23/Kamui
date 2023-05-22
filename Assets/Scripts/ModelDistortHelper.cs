using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ModelDistortHelper : MonoBehaviour {
    public Transform centerTrans;
    public Material material;

    private void Update() {
        Vector3 distortCenter = Camera.main.WorldToScreenPoint(centerTrans.position);
        material.SetVector("_DistortCenter", distortCenter);
    }
}