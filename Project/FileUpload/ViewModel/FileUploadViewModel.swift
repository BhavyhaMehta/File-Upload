import Foundation
import SwiftUI
import FirebaseStorage
import FirebaseAuth

class FirebaseViewModel: ObservableObject {
    
    // Published properties for uploaded files and user ID
    @Published var allUploadedFiles: [URL] = []
    @Published var userID: String?
    
    // This stores the user id and email address of the person who has signed in
    @AppStorage("userID") var savedUserID: String = ""
    @AppStorage("savedEmail") var savedEmail: String = ""
    
    // Firebase storage and authentication references
    let storage = Storage.storage().reference()
    let auth = Auth.auth()
    
    // This creates and instance of the Firebase view model
    static let shared = FirebaseViewModel()
    
    private init() {
        loadUser()    // Initilises the user
    }
    
    // Function that loads user data when opening application if the user is logged in 
    func loadUser() {
        if savedUserID != "" {
            DispatchQueue.main.async {
                self.userID = self.savedUserID
                Task {
                    try await self.getAllUploadedFiles()    // Fetch uploaded files
                }
            }
        }
    }
    
    func login(isSignUp: Bool, email: String, password: String, completion: @escaping (Bool, String?) -> ()) {
        // This section of the code is the authorisation process when signing up as a new user
        if isSignUp {
            // Creates a new user with the entered email address and password
            auth.createUser(withEmail: email, password: password) { auth, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                // This part sets the parameters for the new user
                if let auth {
                    DispatchQueue.main.async {
                        self.userID = auth.user.uid
                        self.savedUserID = auth.user.uid
                        self.savedEmail = email
                        self.allUploadedFiles = []     // This is set to empty because the new user has not uploaded any files
                    }
                    completion(true, nil)
                }
            }
        } else {
            // This is the code for logging in as a existing user
            auth.signIn(withEmail: email, password: password) { auth, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                    return
                }
                if let auth {
                    DispatchQueue.main.async {
                        self.userID = auth.user.uid
                        self.savedUserID = auth.user.uid
                        self.savedEmail = email
                        Task {
                            try await self.getAllUploadedFiles()     // Fetches uploaded files of the existing user
                        }
                    }
                    completion(true, nil)
                }
            }
        }
    }
    
    // Function for logging out
    func logout() {
        self.userID = nil
        self.savedUserID = ""
    }
    
    func uploadFile(url: URL) async throws -> URL? {
        guard let user = userID else { return nil }     // Checks if user ID is available
        let path = url.deletingPathExtension().lastPathComponent     // Extracts file name from URL
        let ref = storage.child(user).child(path)     // Reference to storage location
        let returnedMetaData = try await ref.putFileAsync(from: url)     // Uploads selected file to Firebase Storage
        guard let returnedPath = returnedMetaData.path else {     // Checks if upload was successful
            throw URLError(.badServerResponse)     // Throws an error if upload failed
        }
        let filePath = Storage.storage().reference(withPath: returnedPath)     // Reference to uploaded file
        let downloadURL = try await filePath.downloadURL() // Gets download URL of uploaded file
        try await getAllUploadedFiles()     // Refreshes uploaded files page after upload to show the newly uploaded file
        return downloadURL     // Returns the URL of the newly uploaded file
    }

    
    // This function fetches all uploaded files from Firebase Storage for the current user asynchronously
    func getAllUploadedFiles() async throws {
        guard let user = userID else { return }     // This step checks to sse if the user ID already exisits
        DispatchQueue.main.async {
            self.allUploadedFiles = []     // Clears the uploaded files array before fetching new files
        }
        let list = try await storage.child(user).listAll()     // This fetches the list of all files uploaded by the user
        for item in list.items {     // Iterates through each file in the list
            let downloadURL = try await item.downloadURL()     // Gets the download URL of the file
            DispatchQueue.main.async {
                self.allUploadedFiles.append(downloadURL)     // Appends the download URL to the uploaded files array
            }
        }
    }

}

