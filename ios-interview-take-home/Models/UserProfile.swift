import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var profileImage: Data?
    var hasCompletedOnboarding: Bool
    
    init(id: UUID = UUID(), name: String, profileImage: Data? = nil, hasCompletedOnboarding: Bool = false) {
        self.id = id
        self.name = name
        self.profileImage = profileImage
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}

// MARK: - Sample Data

extension UserProfile {
    static let sample = UserProfile(
        name: "John Doe",
        profileImage: nil,
        hasCompletedOnboarding: true
    )
}
