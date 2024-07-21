import SwiftUI
import FirebaseCore     // Imports Firebase because it will be used for the uploading files function

@main
struct FileUploadApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // Initial view to be displayed when the app launches
            LockedPage()
        }
    }
}

// Custom AppDelegate class to configure Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Configures Firebase when the app finishes launching
        FirebaseApp.configure()
        
        return true
    }
}
