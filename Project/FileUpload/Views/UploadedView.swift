import SwiftUI

struct UploadedView: View {
    
    @StateObject var firebaseVM = FirebaseViewModel.shared   // Creates an instance of the FirebaseViewModel from the FileUploadViewModel page
    
    @Environment(\.presentationMode) var presentationMode    // Gets the presentation mode environment variable
    
    var body: some View {
        NavigationStack {
            VStack {
                // Checks if there are no uploaded files, the appUploadedFiles list is called from the FirebaseViewModel seen in the FileUploadViewModel page
                if firebaseVM.allUploadedFiles.isEmpty {
                    VStack(spacing: 25) {
                        // Displays an iCloud icon if no files are uploaded
                        Image(systemName: "icloud.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75)
                            .foregroundStyle(.gray)
                        // Displays a message if no files are uploaded
                        Text("No Files Uploaded")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.black)
                            .opacity(0.8)
                    }
                  // If there are uploaded files
                } else {
                    // Displays a list of uploaded files
                    List {
                        // Loops through each uploaded file URL/
                        ForEach(firebaseVM.allUploadedFiles, id: \.self) { url in
                            // This creates a button to open the file URL when tapped
                            Button {
                                UIApplication.shared.open(url)
                            } label: {
                                // Displaying the URL description as the button label
                                Text(url.description)
                            }
                        }
                    }
                }
            }
            // Sets the title of the page
            .navigationTitle("Files")
            // Hides the original navigation bar back button
            .navigationBarBackButtonHidden()
            .toolbar {
                // Places the button in the top bar leading position
                ToolbarItem(placement: .topBarLeading) {
                    // Creates a custom button that will be used as a back button
                    Button {
                        // This is the main function of the button which is to go back to the previous page
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        // Displays a icon which will be used as a back button
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
}

