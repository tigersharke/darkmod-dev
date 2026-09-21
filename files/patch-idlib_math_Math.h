--- idlib/math/Math.h.orig	2026-09-06 10:03:05 UTC
+++ idlib/math/Math.h
@@ -214,6 +214,7 @@ class idMath { (public)
 	static const float			M_SEC2MS;					// seconds to milliseconds multiplier
 	static const float			M_MS2SEC;					// milliseconds to seconds multiplier
 	static const float			INFINITY;					// huge number which should be larger than any valid number used
+	static const float			INF;					// huge number which should be larger than any valid number used
 	static const float			FLT_EPS;					// smallest positive number such that 1.0+FLT_EPSILON != 1.0
 	//anon beign
 	static const float			FLT_SMALLEST_NON_DENORMAL;	// smallest non-denormal 32-bit floating point value
