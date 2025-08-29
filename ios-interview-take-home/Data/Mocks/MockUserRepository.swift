import Foundation

// MARK: - Mock User Repository for Testing

@MainActor
class MockUserRepository: UserRepositoryProtocol {
    var userProfile: UserProfile?
    var shouldThrowError = false
    var errorToThrow: Error = NSError(domain: "TestError", code: 1, userInfo: nil)
    
    func hasCompletedOnboarding() async throws -> Bool {
        if shouldThrowError {
            throw errorToThrow
        }
        return userProfile?.hasCompletedOnboarding ?? false
    }
    
    func saveUserProfile(name: String, profileImage: Data?) async throws {
        if shouldThrowError {
            throw errorToThrow
        }
        userProfile = UserProfile(name: name, profileImage: profileImage, hasCompletedOnboarding: true)
    }
    
    func getUserProfile() async throws -> UserProfile? {
        if shouldThrowError {
            throw errorToThrow
        }
        return userProfile
    }
    
    func clearUserProfile() async throws {
        if shouldThrowError {
            throw errorToThrow
        }
        userProfile = nil
    }
}
