import Foundation

class UserPreviewRepository: UserRepositoryProtocol {
    private var mockUserProfile: UserProfile?
    
    init() {
        // For previews, we can start with either completed or not completed onboarding
        // This allows us to test both states in previews
        setupMockData()
    }
    
    // MARK: - UserRepositoryProtocol Implementation
    
    func hasCompletedOnboarding() async throws -> Bool {
        // Simulate slight delay for realistic preview behavior
        try? await Task.sleep(for: .milliseconds(50))
        return mockUserProfile?.hasCompletedOnboarding ?? false
    }
    
    func saveUserProfile(name: String, profileImage: Data?) async throws {
        // Simulate save delay
        try? await Task.sleep(for: .milliseconds(100))
        
        if mockUserProfile != nil {
            // Update existing profile
            mockUserProfile?.name = name
            mockUserProfile?.profileImage = profileImage
            mockUserProfile?.hasCompletedOnboarding = true
        } else {
            // Create new profile
            mockUserProfile = UserProfile(
                name: name,
                profileImage: profileImage,
                hasCompletedOnboarding: true
            )
        }
    }
    
    func getUserProfile() async throws -> UserProfile? {
        // Simulate slight delay
        try? await Task.sleep(for: .milliseconds(50))
        return mockUserProfile
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