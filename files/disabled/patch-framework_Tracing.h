--- framework/Tracing.h.orig	2026-09-21 01:15:02 UTC
+++ framework/Tracing.h
@@ -16,6 +16,17 @@ Project: The Dark Mod (http://www.thedarkmod.com/)
 #pragma once
 
 #include "renderer/backend/qgl/qgl.h"
+
+/* FreeBSD / glad: TracyOpenGL.hpp expects plain gl* names */
+#ifndef glGenQueries
+#define glGenQueries           glad_glGenQueries
+#define glGetInteger64v        glad_glGetInteger64v
+#define glGetQueryiv           glad_glGetQueryiv
+#define glGetQueryObjectiv     glad_glGetQueryObjectiv
+#define glGetQueryObjectui64v  glad_glGetQueryObjectui64v
+#define glQueryCounter         glad_glQueryCounter
+#endif
+
 #include <tracy/TracyOpenGL.hpp>
 #include <common/TracySystem.hpp>
 
