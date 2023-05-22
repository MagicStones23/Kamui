#ifndef Library_Radiant
#define Library_Radiant
	
	float3 AngleToDir(float angle) {
		float radiant = radians(angle);
		float x = cos(radiant);
		float z = sin(radiant);
		float3 dir = float3(x, 0, z);
		return dir;
	}

#endif