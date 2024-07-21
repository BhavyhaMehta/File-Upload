import SwiftUI

// This defines a class to store the colour that the user picks, conforming to ObservableObject for SwiftUI updates
class SettingsStore: ObservableObject {
    // Published property allows for the tracking of the selected color, which is set to white by default
    @Published var selectedColor: Color = .white
}
