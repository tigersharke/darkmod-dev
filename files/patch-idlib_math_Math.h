--- idlib/math/Math.h.orig	2026-11-23 05:13:50 UTC
+++ idlib/math/Math.h
@@ -40,6 +40,10 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 #ifdef INFINITY
 #undef INFINITY
 #endif
+/* Do not restore system INFINITY here.  idMath::INFINITY must remain a
+   plain identifier for the duration of any translation unit that includes
+   this header.  libc++ headers that truly need the macro can re-define it
+   after including Math.h if required. */
 
 #define DEG2RAD(a)				( (a) * idMath::M_DEG2RAD )
 #define RAD2DEG(a)				( (a) * idMath::M_RAD2DEG )
@@ -214,6 +218,7 @@ class idMath { (public)
 	static const float			M_SEC2MS;					// seconds to milliseconds multiplier
 	static const float			M_MS2SEC;					// milliseconds to seconds multiplier
 	static const float			INFINITY;					// huge number which should be larger than any valid number used
+	static const float			INF;			/* alias kept for future */
 	static const float			FLT_EPS;					// smallest positive number such that 1.0+FLT_EPSILON != 1.0
 	//anon beign
 	static const float			FLT_SMALLEST_NON_DENORMAL;	// smallest non-denormal 32-bit floating point value
