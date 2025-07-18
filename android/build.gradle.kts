import org.gradle.api.tasks.Delete
import org.gradle.api.file.Directory

// ✅ Required for Firebase Plugin
buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Google Services plugin (Firebase)
        classpath("com.google.gms:google-services:4.4.0")
    }
}

// ✅ Root-level repository configuration
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Optional: Custom build directory configuration
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// ✅ Ensure all modules depend on :app
subprojects {
    project.evaluationDependsOn(":app")
}

// ✅ Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
