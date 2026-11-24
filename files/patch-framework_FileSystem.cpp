--- framework/FileSystem.cpp.orig	2026-03-21 18:56:14 UTC
+++ framework/FileSystem.cpp
@@ -14,6 +14,8 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 ******************************************************************************/
 
 #include "precompiled.h"
+#include <random>
+#include <algorithm> 
 #pragma hdrstop
 
 
@@ -1876,7 +1878,9 @@ void idFileSystemLocal::TestThreads_f( const idCmdArgs
 	common->Printf( "Testing %d files\n", testFiles.Num() );
 	auto testFileFunc = [&] {
 		auto fileList = testFiles;
-		std::random_shuffle(fileList.begin(), fileList.end());
+		std::random_device rd;
+		std::mt19937 g(rd());
+		std::shuffle(fileList.begin(), fileList.end(), g);
 		for ( auto & testFile : fileList ) {
 			auto f = fileSystemLocal.OpenFileRead( testFile.name );
 			if ( !f ) {
