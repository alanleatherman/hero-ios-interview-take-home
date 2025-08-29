import Foundation

class UserPreviewRepository: UserRepositoryProtocol {
    private var mockUserProfile: UserProfile?
    
    init() {
        setupMockData()
    }
    
    // MARK: - UserRepositoryProtocol Implementation
    
    func hasCompletedOnboarding() async throws -> Bool {
        try? await Task.sleep(for: .milliseconds(50))
        return mockUserProfile?.hasCompletedOnboarding ?? false
    }
    
    func saveUserProfile(name: String, profileImage: Data?) async throws {
        try? await Task.sleep(for: .milliseconds(100))
        
        if mockUserProfile != nil {
            mockUserProfile?.name = name
            mockUserProfile?.profileImage = profileImage
            mockUserProfile?.hasCompletedOnboarding = true
        } else {
            mockUserProfile = UserProfile(
                name: name,
                profileImage: profileImage,
                hasCompletedOnboarding: true
            )
        }
    }
    
    func getUserProfile() async throws -> UserProfile? {
        try? await Task.sleep(for: .milliseconds(50))
        return mockUserProfile
    }
    
    func clearUserProfile() async throws {
        try? await Task.sleep(for: .milliseconds(100))
        mockUserProfile = nil
    }
    
    // MARK: - Preview Configuration Methods
    
    /// Configure the repository for onboarding preview (user hasn't completed onboarding)
    func configureForOnboardingPreview() {
        mockUserProfile = nil
    }
    
    /// Configure the repository for main app preview (user has completed onboarding)
    func configureForMainAppPreview() {
        mockUserProfile = UserProfile(
            name: "Preview User",
            profileImage: nil,
            hasCompletedOnboarding: true
        )
    }
    
    // MARK: - Private Methods
    
    private func setupMockData() {
        // Default to onboarding not completed for testing onboarding flow
        mockUserProfile = nil
    }
}

// MARK: - Preview Helpers
extension UserPreviewRepository {
    static var onboardingNotCompleted: UserPreviewRepository {
        let repo = UserPreviewRepository()
        repo.configureForOnboardingPreview()
        return repo
    }
    
    static var onboardingCompleted: UserPreviewRepository {
        let repo = UserPreviewRepository()
        repo.configureForMainAppPreview()
        return repo
    }
}
