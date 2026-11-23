--- idlib/sys/posix/posix_thread.cpp.orig	2026-11-05 14:22:33 UTC
+++ idlib/sys/posix/posix_thread.cpp
@@ -41,10 +41,8 @@ static int Sys_SetThreadName( pthread_t handle, const 
 static int Sys_SetThreadName( pthread_t handle, const char* name )
 {
 	int ret = 0;
-#ifdef __linux__
-	// NOTE: linux only supports threadnames up to 16chars *including* terminating NULL
-	// http://man7.org/linux/man-pages/man3/pthread_setname_np.3.html
-	// on my machine a longer name (eg "JobListProcessor_0") caused an ENOENT error (instead of ERANGE)
+
+	// Both Linux and FreeBSD have short practical limits on thread names
 	char shortName[16];
 	if ( strlen( name ) <= 15 ) {
 		strcpy( shortName, name );
@@ -54,6 +52,7 @@ static int Sys_SetThreadName( pthread_t handle, const 
 		strcpy( shortName + 9, name + strlen(name) - 6 );
 	}
 
+#ifdef __linux__
 	ret = pthread_setname_np( handle, shortName );
 	if( ret != 0 )
 		idLib::common->Printf( "Setting threadname \"%s\" failed, reason: %s (%i)\n", shortName, strerror( errno ), errno );
