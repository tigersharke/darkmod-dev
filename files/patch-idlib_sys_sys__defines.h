--- idlib/sys/sys_defines.h.orig	2026-09-14 21:10:25 UTC
+++ idlib/sys/sys_defines.h
@@ -160,6 +160,12 @@ Defines and macros usable in all code
 ================================================================================================
 */
 
+#ifdef __FreeBSD__
+#ifdef ALIGN
+#undef ALIGN
+#endif
+#endif
+
 #define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) - ( ( (x) + (a) - 1 ) % (a) ) )
 //#define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) & ~((a)-1) )
 
@@ -283,4 +289,4 @@ extern volatile int ignoredReturnValue;
 
 #endif // ifdef _MSV_VER
 
-#define ID_LITTLE_ENDIAN
\ No newline at end of file
+#define ID_LITTLE_ENDIAN
