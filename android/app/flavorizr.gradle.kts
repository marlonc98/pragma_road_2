import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("mock") {
            dimension = "flavor-type"
            applicationId = "com.example.portal_remoto.mock"
            resValue(type = "string", name = "app_name", value = "[MOCK] Portal Remoto")
        }
        create("dev") {
            dimension = "flavor-type"
            applicationId = "com.example.portal_remoto.dev"
            resValue(type = "string", name = "app_name", value = "[DEV] Portal Remoto")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "com.example.portal_remoto"
            resValue(type = "string", name = "app_name", value = "Portal Remoto")
        }
    }

    buildFeatures.resValues = true
}