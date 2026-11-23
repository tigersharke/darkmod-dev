--- idlib/sys/sys_defines.h.orig	2026-10-31 20:16:10 UTC
+++ idlib/sys/sys_defines.h
@@ -160,13 +160,16 @@ Defines and macros usable in all code
 ================================================================================================
 */
 
-#define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) - ( ( (x) + (a) - 1 ) % (a) ) )
-//#define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) & ~((a)-1) )
+// FreeBSD: system <machine/param.h> defines a 1-arg ALIGN(p). Rename ours.
+#define ID_ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) - ( ( (x) + (a) - 1 ) % (a) ) )
+//#define ID_ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) & ~((a)-1) )
 
 // RB: changed UINT_PTR to uintptr_t
-#define _alloca16( x )					((void *)ALIGN( (uintptr_t)_alloca( ALIGN( x, 16 ) + 16 ), 16 ) )
-#define _alloca128( x )					((void *)ALIGN( (uintptr_t)_alloca( ALIGN( x, 128 ) + 128 ), 128 ) )
+    #define _alloca16( x ) ((void *)ID_ALIGN( (uintptr_t)_alloca( ID_ALIGN( x, 16 ) + 16 ), 16 ))
+    #define _alloca128( x ) ((void *)ID_ALIGN( (uintptr_t)_alloca( ID_ALIGN( x, 128 ) + 128 ), 128 ))
 // RB end
+
+// End FreeBSD change area
 
 #define likely( x )	( x )
 #define unlikely( x )	( x )
@@ -283,4 +286,4 @@ extern volatile int ignoredReturnValue;
 
 #endif // ifdef _MSV_VER
 
-#define ID_LITTLE_ENDIAN
\ No newline at end of file
+#define ID_LITTLE_ENDIAN
