import Testing
import Foundation
@testable import ios_interview_take_home

@MainActor
struct UserInteractorTests {
    
    @Test func hasCompletedOnboardingTrue() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.userProfile = UserProfile(name: "Test", profileImage: nil, hasCompletedOnboarding: true)
        
        // When
        let result = await userInteractor.hasCompletedOnboarding()
        
        // Then
        #expect(result == true)
    }
    
    @Test func hasCompletedOnboardingFalse() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.userProfile = nil
        
        // When
        let result = await userInteractor.hasCompletedOnboarding()
        
        // Then
        #expect(result == false)
    }
    
    @Test func hasCompletedOnboardingError() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        let result = await userInteractor.hasCompletedOnboarding()
        
        // Then
        #expect(result == false) // Should return false on error
    }
    
    @Test func completeOnboardingSuccess() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        let name = "Test User"
        let profileImage = Data()
        
        // When
        await userInteractor.completeOnboarding(name: name, profileImage: profileImage)
        
        // Then
        #expect(mockRepository.userProfile != nil)
        #expect(mockRepository.userProfile?.name == name)
        #expect(mockRepository.userProfile?.profileImage == profileImage)
        #expect(mockRepository.userProfile?.hasCompletedOnboarding == true)
        
        // Check interactor state is updated
        #expect(userInteractor.currentUserProfile?.name == name)
        #expect(userInteractor.currentUserProfile?.profileImage == profileImage)
        #expect(userInteractor.currentUserProfile?.hasCompletedOnboarding == true)
    }
    
    @Test func completeOnboardingError() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.shouldThrowError = true
        let name = "Test User"
        
        // When
        await userInteractor.completeOnboarding(name: name, profileImage: nil)
        
        // Then
        #expect(mockRepository.userProfile == nil)
        // Interactor state should not be updated on error
        #expect(userInteractor.currentUserProfile == nil)
        #expect(userInteractor.error != nil)
    }
    
    @Test func getUserProfileSuccess() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        let testProfile = UserProfile(name: "Test", profileImage: nil, hasCompletedOnboarding: true)
        mockRepository.userProfile = testProfile
        
        // When
        let result = await userInteractor.getUserProfile()
        
        // Then
        #expect(result != nil)
        #expect(result?.name == "Test")
        #expect(result?.hasCompletedOnboarding == true)
        #expect(userInteractor.currentUserProfile?.name == "Test")
    }
    
    @Test func getUserProfileNotFound() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.userProfile = nil
        
        // When
        let result = await userInteractor.getUserProfile()
        
        // Then
        #expect(result == nil)
        #expect(userInteractor.currentUserProfile == nil)
    }
    
    @Test func getUserProfileError() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.shouldThrowError = true
        
        // When
        let result = await userInteractor.getUserProfile()
        
        // Then
        #expect(result == nil)
        #expect(userInteractor.error != nil)
    }
    
    @Test func signOutSuccess() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.userProfile = UserProfile(name: "Test", profileImage: nil, hasCompletedOnboarding: true)
        userInteractor.currentUserProfile = UserProfile(name: "Test", profileImage: nil, hasCompletedOnboarding: true)
        
        // When
        await userInteractor.signOut()
        
        // Then
        #expect(mockRepository.userProfile == nil)
        #expect(userInteractor.currentUserProfile == nil)
    }
    
    @Test func signOutError() async {
        // Setup
        let mockRepository = MockUserRepository()
        let userInteractor = UserInteractor(repository: mockRepository)
        
        // Given
        mockRepository.shouldThrowError = true
        mockRepository.userProfile = UserProfile(name: "Test", profileImage: nil, hasCompletedOnboarding: true)
        userInteractor.currentUserProfile = UserProfile(name: "Test", profileImage: nil, hasCompletedOnboarding: true)
        
        // When
        await userInteractor.signOut()
        
        // Then
        // Profile should still exist due to error
        #expect(mockRepository.userProfile != nil)
        // Interactor state should NOT be cleared on error (matches actual implementation)
        #expect(userInteractor.currentUserProfile != nil)
        #expect(userInteractor.error != nil)
    }
}