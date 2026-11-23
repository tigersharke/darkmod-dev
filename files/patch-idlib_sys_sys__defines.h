--- idlib/sys/sys_defines.h.orig	2026-11-23 07:34:16 UTC
+++ idlib/sys/sys_defines.h
@@ -160,8 +160,8 @@ Defines and macros usable in all code
 ================================================================================================
 */
 
-#define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) - ( ( (x) + (a) - 1 ) % (a) ) )
-//#define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) & ~((a)-1) )
+/* FreeBSD: rename to avoid conflict with system ALIGN */
+#define ID_ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) - ( ( (x) + (a) - 1 ) % (a) ) )
 
 // RB: changed UINT_PTR to uintptr_t
 #define _alloca16( x ) ((void *)ID_ALIGN( (uintptr_t)_alloca( ID_ALIGN( x, 16 ) + 16 ), 16 ))
@@ -283,4 +283,4 @@ extern volatile int ignoredReturnValue;
 
 #endif // ifdef _MSV_VER
 
-#define ID_LITTLE_ENDIAN
\ No newline at end of file
+#define ID_LITTLE_ENDIAN
