using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class TLMaterialFloatData : MonoBehaviour {
    public float from;
    public float to;
    public string field;
    public Renderer target;
    public float duration;
    public AnimationCurve curve;
    public bool setToWhenPaused;
}