--- idlib/math/Math.h.orig	2026-03-21 18:56:16 UTC
+++ idlib/math/Math.h
@@ -37,9 +37,8 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 ===============================================================================
 */
 
-#ifdef INFINITY
-#undef INFINITY
-#endif
+/* FreeBSD: do not restore system INFINITY. The member is renamed to INF
+   below and must remain a plain identifier. */
 
 #define DEG2RAD(a)				( (a) * idMath::M_DEG2RAD )
 #define RAD2DEG(a)				( (a) * idMath::M_RAD2DEG )
@@ -213,7 +212,7 @@ class idMath { (public)
 	static const float			M_RAD2DEG;					// radians to degrees multiplier
 	static const float			M_SEC2MS;					// seconds to milliseconds multiplier
 	static const float			M_MS2SEC;					// milliseconds to seconds multiplier
-	static const float			INFINITY;					// huge number which should be larger than any valid number used
+	static const float			INF;						// huge number which should be larger than any valid number used
 	static const float			FLT_EPS;					// smallest positive number such that 1.0+FLT_EPSILON != 1.0
 	//anon beign
 	static const float			FLT_SMALLEST_NON_DENORMAL;	// smallest non-denormal 32-bit floating point value
