import SwiftUI

struct AccountInformation: View {
    
    // Accesses settings stored globally
    @EnvironmentObject var settingsStore: SettingsStore
    
    // Accesses presentation mode environment variable
    @Environment(\.presentationMode) var presentationMode
    
    // Stores user ID and email using AppStorage
    @AppStorage("userID") var savedUserID: String = ""
    @AppStorage("savedEmail") var savedEmail: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                // Sets background color based on selected color in settings
                settingsStore.selectedColor.edgesIgnoringSafeArea(.all)
                // Form for displaying account information
                Form {
                    // Displays user ID/bucketID (shown on the Firebase console)
                    Section(header: Text("Bucket ID")){
                        Text(savedUserID)
                    }
                    .listRowBackground(Color.white.opacity(0.2))
                    
                    // Displays email of logged in user
                    Section(header: Text("Email")) {
                        Text(savedEmail)
                    }
                    .listRowBackground(Color.white.opacity(0.2))
                }
                .scrollContentBackground(.hidden)
                // Sets background colour based on the colour in settingsStore
                .background(settingsStore.selectedColor)
                // Sets page title
                .navigationTitle("Account Information")
            }
            // Back button customisation
            .navigationBarItems(leading:
                Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                // Displays the back button icon
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
            )
        }
        // Hides default back button
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
