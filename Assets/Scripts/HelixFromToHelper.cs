using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class HelixFromToHelper : MonoBehaviour {
    public float radiusMin;
    public float radiusMax;
    public float angleOffset;
    public float angleMax;
    public Transform fromTrans;
    public Transform toTrans;
    public Renderer targetRenderer;

    [Range(0, 1)] public float absorbLerp;
    public string curveField0;
    public AnimationCurve curve0;
    public string curveField1;
    public AnimationCurve curve1;
    
    private void Update() {
        float curve0 = this.curve0.Evaluate(absorbLerp);
        float curve1 = this.curve1.Evaluate(absorbLerp);
        targetRenderer.sharedMaterial.SetFloat(curveField0, curve0);
        targetRenderer.sharedMaterial.SetFloat(curveField1, curve1);

        targetRenderer.sharedMaterial.SetFloat("_HelixRadiusMin", radiusMin);
        targetRenderer.sharedMaterial.SetFloat("_HelixRadiusMax", radiusMax);
        targetRenderer.sharedMaterial.SetFloat("_HelixAngleOffset", angleOffset);
        targetRenderer.sharedMaterial.SetFloat("_HelixAngleMax", angleMax);
        targetRenderer.sharedMaterial.SetVector("_HelixFromPos", fromTrans.position);
        targetRenderer.sharedMaterial.SetVector("_HelixToPos", toTrans.position);

        List<Vector3> points = new List<Vector3>();

        for (int i = 0; i < 100; i++) {
            float t = i / (100 - 1f);
            Vector3 pos = Library.GetHelixFromToPos(t, radiusMin, radiusMax, angleOffset, angleMax, fromTrans.position, toTrans.position);
            points.Add(pos);
        }

        for (int i = 0; i < points.Count - 1; i++) {
            int index0 = i;
            int index1 = i + 1;
            Vector3 pos0 = points[index0];
            Vector3 pos1 = points[index1];
            Debug.DrawLine(pos0, pos1, Color.red);
        }
    }
}