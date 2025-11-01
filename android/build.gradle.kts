allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// FIXED: Removed custom build directory configuration to avoid path conflicts
// This was causing: "this and base files have different roots" error
// The default build directory structure will be used instead

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}