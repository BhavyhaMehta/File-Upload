import SwiftUI

struct ContentView: View {
    
    // State variables to manage UI states
    @State private var selectedFile: URL?
    @State var showingFilePicker: Bool = false
    @State var showLoader: Bool = false
    @State var showError: Bool = false
    @State var errorString: String = ""
    
    // State variable to manage signin view state
    @State var showSignin: Bool = false
    
    // Creates instances of StateObjects for settings and FirebaseViewModel
    @StateObject var settingStore = SettingsStore()
    @StateObject var firebaseVM = FirebaseViewModel.shared
    
    // State variable to hold the file URL
    @State var fileURL: URL?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Sets the background color based on selected color in settings
                settingStore.selectedColor.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Checks if user is signed in
                    if let _ = firebaseVM.userID {
                        VStack {
                            // Main interface is designed here
                            Text("Please Upload Your Files Below")
                                .padding()
                                .bold()
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            VStack {
                                ZStack {
                                    if !showLoader {
                                        // Button to trigger file picker
                                        Button {
                                            showingFilePicker.toggle()
                                        } label: {
                                            VStack {
                                                Image(systemName: "arrow.up.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 20, height: 20)
                                                Text("Select File")
                                            }
                                            .foregroundColor(.black)
                                        }
                                    } else {
                                        // Shows the loading animation while uploading
                                        ProgressView()
                                    }
                                }
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 2)
                                        .frame(width: 120, height: 80)
                                )
                                // File picker
                                .fileImporter(isPresented: $showingFilePicker, allowedContentTypes: [.image, .pdf]) { result in
                                    uploadFile(result)
                                }
                            }
                            
                            Spacer()
                            
                            // A navigation link acts like a button but allows the user move to a different page in the application
                            NavigationLink {
                                UploadedView()
                            } label: {
                                Text("Uploaded Files")
                                    .padding()
                                    .bold()
                                    .foregroundColor(.black)
                            }
                            .padding(.bottom)
                            
                            // This is a standard button which allows the user to logout of their signed in account
                            Button("Log out") {
                                // Calls the logout function from the FirebaseViewModel seen in the FileUploadViewModel page
                                firebaseVM.logout()
                            }
                            .foregroundStyle(.red)
                            .padding(.vertical)
                            
                            // Navigation link to settings view
                            HStack(alignment: .center, spacing: 10) {
                                NavigationLink {
                                    SettingsView()
                                        .environmentObject(settingStore)
                                } label: {
                                    Text("Settings")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    } else {
                        // Shows sign in button if user is not signed in
                        Spacer()
                        Button {
                            showSignin.toggle()
                        } label: {
                            Text("Sign In")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                   
                }
                .padding()
                // Shows error alert if there's an error
                .alert(errorString, isPresented: $showError) {
                    Button("Okay") {
                        showError.toggle()
                    }
                }
                // Full screen cover for sign in view
                .fullScreenCover(isPresented: $showSignin) {
                    LoginPage()
                }
            }
        }
    }
    
    // This function handles how files are being uploaded to Firebase Storage, the function for uploading files is written in the FileUploadViewModel page
    func uploadFile(_ result: Result<URL, any Error>) {
        do {
            self.showLoader = true
            self.fileURL = nil
            let selectedURL = try result.get()
            self.selectedFile = selectedURL
            Task {
                do {
                    // Calls the upload function from the FirebaseViewModel
                    let url = try await firebaseVM.uploadFile(url: selectedURL)
                    DispatchQueue.main.async {
                        self.fileURL = url
                        self.showLoader = false
                    }
                } catch {
                    print(error.localizedDescription)
                    self.showLoader = false
                    self.errorString = "Something went wrong when uploading file"
                    self.showError = true
                }
            }
        } catch {
            self.showLoader = false
            self.errorString = "Something went wrong when loading file"
            self.showError = true
        }
    }
}
