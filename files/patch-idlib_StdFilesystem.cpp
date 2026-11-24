--- idlib/StdFilesystem.cpp.orig	2026-11-23 08:23:28 UTC
+++ idlib/StdFilesystem.cpp
@@ -17,24 +17,28 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 #include "StdFilesystem.h"
 
 #ifdef _MSC_VER
-	#if _MSC_VER < 1910
-		//STL-based implementation for MSVC2013
-		#include <filesystem>
-		namespace stdfsys = std::tr2::sys;
-	#else // MSVC 2017+
-		#if _HAS_CXX17
-			#include <filesystem>
-			namespace stdfsys = std::filesystem;
-		#else
-			#define _SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING
-			#include <experimental/filesystem>
-			namespace stdfsys = std::experimental::filesystem;
-		#endif
-	#endif 
+    #if _MSC_VER < 1910
+        // STL-based implementation for MSVC2013
+        #include <filesystem>
+        namespace stdfsys = std::tr2::sys;
+    #else // MSVC 2017+
+        #if _HAS_CXX17
+            #include <filesystem>
+            namespace stdfsys = std::filesystem;
+        #else
+            #define _SILENCE_EXPERIMENTAL_FILESYSTEM_DEPRECATION_WARNING
+            #include <experimental/filesystem>
+            namespace stdfsys = std::experimental::filesystem;
+        #endif
+    #endif
+#elif defined(__FreeBSD__)
+    // FreeBSD libc++ provides the final C++17 <filesystem>
+    #include <filesystem>
+    namespace stdfsys = std::filesystem;
 #else
-	//it should be here for both GCC and Clang
-	#include <experimental/filesystem>
-	namespace stdfsys = std::experimental::filesystem::v1;
+    // GCC / Clang on other platforms (may still need experimental)
+    #include <experimental/filesystem>
+    namespace stdfsys = std::experimental::filesystem::v1;
 #endif
 
 namespace stdext {
