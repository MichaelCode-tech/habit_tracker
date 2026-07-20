allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    if (project.name != "app") {
        project.evaluationDependsOn(":app")
    }
}

subprojects {
    val configureAndroid: () -> Unit = {
        if (project.extensions.findByName("android") != null) {
            val android = project.extensions.getByName("android")

            // Try to set namespace if missing
            try {
                val getNamespace = android.javaClass.getMethod("getNamespace")
                val setNamespace = android.javaClass.getMethod("setNamespace", String::class.java)
                if (getNamespace.invoke(android) == null) {
                    setNamespace.invoke(android, "com.habit_tracker.${name.replace("-", "_")}")
                }
            } catch (e: Exception) {
                // Ignore
            }

            // Force compileSdk to 35
            try {
                val setCompileSdk = android.javaClass.getMethod("setCompileSdk", Int::class.javaPrimitiveType)
                setCompileSdk.invoke(android, 35)
            } catch (e: Exception) {
                try {
                    val setCompileSdkVersion = android.javaClass.getMethod("setCompileSdkVersion", Int::class.javaPrimitiveType)
                    setCompileSdkVersion.invoke(android, 35)
                } catch (e2: Exception) {
                    // Ignore
                }
            }

            // Fix the AndroidManifest.xml if it contains the 'package' attribute
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val content = manifestFile.readText()
                if (content.contains("package=\"")) {
                    val newContent = content.replace(Regex("package=\"[^\"]*\""), "")
                    manifestFile.writeText(newContent)
                }
            }
        }
    }

    if (project.state.executed) {
        configureAndroid()
    } else {
        project.afterEvaluate {
            configureAndroid()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
