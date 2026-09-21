--- idlib/math/Math.h.orig	2026-09-21 01:46:17 UTC
+++ idlib/math/Math.h
@@ -17,6 +17,13 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 #define __MATH_MATH_H__
 
 #include <cmath>
+#ifndef INFINITY
+#ifdef HUGE_VAL
+#define INFINITY ((float)HUGE_VAL)
+#else
+#define INFINITY (1e30f)
+#endif
+#endif
 
 #ifdef __SSE__
 #include <xmmintrin.h>
