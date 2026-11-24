--- idlib/sys/posix/posix_thread.cpp.orig	2026-11-24 11:02:11 UTC
+++ idlib/sys/posix/posix_thread.cpp
@@ -62,7 +62,7 @@ static int Sys_SetThreadName( pthread_t handle, const 
 #elif defined(__FreeBSD__)
 	// according to http://www.freebsd.org/cgi/man.cgi?query=pthread_set_name_np&sektion=3
 	// the interface is void pthread_set_name_np(pthread_t tid, const char *name);
-	pthread_set_name_np( handle, shortName ); // doesn't return anything
+	pthread_set_name_np( handle, name ); // doesn't return anything
 #endif
 	/* TODO: OSX:
 		// according to http://stackoverflow.com/a/7989973
