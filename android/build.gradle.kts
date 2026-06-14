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
    plugins.withId("com.android.library") {
        extensions.findByName("android")?.let { androidExtension ->
            val currentNamespace = runCatching {
                androidExtension.javaClass.getMethod("getNamespace").invoke(androidExtension) as? String
            }.getOrNull()

            if (currentNamespace.isNullOrBlank()) {
                val fallbackNamespace = when (project.name) {
                    "flutter_paystack" -> "co.paystack.flutterpaystack"
                    else -> "com.example.${project.name.replace('-', '_')}"
                }

                runCatching {
                    androidExtension.javaClass
                        .getMethod("setNamespace", String::class.java)
                        .invoke(androidExtension, fallbackNamespace)
                }.getOrThrow()
            }
        }
    }
}
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
