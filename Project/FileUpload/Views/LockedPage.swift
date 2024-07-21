import LocalAuthentication
import SwiftUI

struct LockedPage: View {
    
    // State variable to track whether the device is unlocked
    @State private var isUnlocked = false
    
    var body: some View {
        NavigationStack {
            VStack {
                // Text indicating that authentication is being requested
                Text("Requesting Authentication...")
                // Button to retry authentication
                Button("Retry") {
                    authenticate()
                }
            }
            // Navigates to ContentView if the device is unlocked
            .navigationDestination(isPresented: $isUnlocked) {
                ContentView()
                    .navigationBarBackButtonHidden()
            }
            // Authentices as soon as the application launches (FaceID)
            .onAppear(perform: authenticate)
        }
    }
    
    // Function to perform biometric authentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Checks if the device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            let reason = "Authentication Required"

            // Attempts biometric authentication
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    // Updates state variable on successful authentication
                    DispatchQueue.main.async {
                        isUnlocked = true
                    }
                } else {
                    // Handlesauthentication failure
                    print("Authentication failed")
                }
            }
        } else {
            // Informs that biometric authentication is unavailable
            print("Biometric authentication unavailable")
        }
    }
}
