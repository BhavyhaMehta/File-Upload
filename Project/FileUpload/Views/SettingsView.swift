import SwiftUI

struct SettingsView: View {
    
    // Accesses settings stored globally
    @EnvironmentObject var settingsStore: SettingsStore
    // Accesses presentation mode environment variable
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            // Form for organizing settings
            Form {
                // Section for account-related settings
                Section(header: Text("Account")) {
                    // Navigation link to account information view
                    NavigationLink(destination: AccountInformation().environmentObject(settingsStore)) {
                        // Text for navigating to account information
                        Text("Account Information")
                            .foregroundColor(.black)
                    }
                }
                .listRowBackground(Color.white.opacity(0.2))
                
                Section(header: Text("Interface")) {
                    // Color picker for selecting background color
                    ColorPicker("Background Colour", selection: $settingsStore.selectedColor)
                }
                .listRowBackground(Color.white.opacity(0.2))
            }
            .scrollContentBackground(.hidden)
            // Setting background color
            .background(settingsStore.selectedColor)
            .navigationTitle("Settings")
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
        // Saves selected color to UserDefaults when changed, settingsStore is used in the other pages to apply the same background colour as what the user has chosen in the colour picker
        .onChange(of: settingsStore.selectedColor) { _ in
            UserDefaults.standard.set(self.settingsStore.selectedColor.description, forKey: "appBackgroundColor")
        }
        // Hides default back button
        .navigationBarBackButtonHidden(true)
    }
}



