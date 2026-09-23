--- idlib/math/Math.h.orig	2026-09-06 10:03:05 UTC
+++ idlib/math/Math.h
@@ -40,6 +40,7 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 #ifdef INFINITY
 #undef INFINITY
 #endif
+/* system INFINITY restored at end of this header for libc++ */
 
 #define DEG2RAD(a)				( (a) * idMath::M_DEG2RAD )
 #define RAD2DEG(a)				( (a) * idMath::M_RAD2DEG )
@@ -214,6 +215,7 @@ class idMath { (public)
 	static const float			M_SEC2MS;					// seconds to milliseconds multiplier
 	static const float			M_MS2SEC;					// milliseconds to seconds multiplier
 	static const float			INFINITY;					// huge number which should be larger than any valid number used
+	static const float			INF;					// huge number which should be larger than any valid number used
 	static const float			FLT_EPS;					// smallest positive number such that 1.0+FLT_EPSILON != 1.0
 	//anon beign
 	static const float			FLT_SMALLEST_NON_DENORMAL;	// smallest non-denormal 32-bit floating point value
@@ -1003,5 +1005,10 @@ ID_INLINE int idMath::FloatHash( const float *array, c
 	}
 	return hash;
 }
+
+/* Restore C/C++ INFINITY for standard library headers (e.g. libc++ <random>) */
+#ifndef INFINITY
+#  define INFINITY (__builtin_inff())
+#endif
 
 #endif /* !__MATH_MATH_H__ */
