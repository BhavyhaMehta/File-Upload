import SwiftUI

struct LoginPage: View {
    
    // State variables for email, password, sign-in status, and error handling
    @State var email: String = ""
    @State var password: String = ""
    @State var signIn: Bool = false
    @State var showError: Bool = false
    @State var errorString: String = ""
    
    // Firebase view model instance is created and environment variables have been called
    @StateObject var firebaseVM = FirebaseViewModel.shared
    @Environment(\.dismiss) var dismiss
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 50) {
                    VStack(spacing: 25) {
                        // Text fields for email and password
                        TextField("Email", text: $email)
                            .padding(.all)
                            .background {
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.gray.opacity(0.2))
                            }
                        SecureField("Password", text: $password)
                            .padding(.all)
                            .background {
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.gray.opacity(0.2))
                            }
                    }
                    // Button for login or sign up
                    Button {
                        if !email.isEmpty && !password.isEmpty {
                            // This section handles the login and sign up with the user entered entered email address and password credentials once the button has been pressed
                            firebaseVM.login(isSignUp: signIn, email: email, password: password) { success, errorString in
                                if success {
                                    dismiss()
                                } else {
                                    self.errorString = errorString ?? "Error occurred"
                                    self.showError.toggle()     // Toggle error alert
                                }
                            }
                        }
                    } label: {
                        Text(signIn ? "Sign Up" : "Login")
                            .foregroundStyle(.white)
                            .padding(.all)
                            .frame(maxWidth: .infinity)
                            .background {
                                RoundedRectangle(cornerRadius: 18)
                                    .foregroundStyle(.blue)
                            }
                    }
                    // This button is used to toggle between login and sign up pages
                    Button {
                        signIn.toggle()
                    } label: {
                        Text(signIn ? "Login" : "Sign Up")
                            .foregroundStyle(.blue)
                    }
                    .padding(.top, 50)
                }
                
                Spacer()
            }
            // Titles and styling for the sign in and login pages
            .navigationTitle(signIn ? "Sign In" : "Login")
            .padding(.horizontal)
            // Alert for displaying errors
            .alert(errorString, isPresented: $showError) {
                Button("Okay") {
                    showError.toggle()     // Dismiss the error alert
                }
            }
            // This button is used to go back to the previous page
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            }
            )
        }
    }
}

