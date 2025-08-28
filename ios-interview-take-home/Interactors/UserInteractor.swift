import Foundation

// MARK: - User Interactor

@Observable
class UserInteractor: UserInteractorProtocol {
    private let repository: UserRepositoryProtocol
    
    // Observable properties for UI binding
    var isLoading = false
    var error: Error?
    var currentUserProfile: UserProfile?
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - UserInteractorProtocol Implementation
    
    func hasCompletedOnboarding() async -> Bool {
        do {
            let completed = try await repository.hasCompletedOnboarding()
            
            // Also load the user profile if onboarding is completed
            if completed {
                await loadUserProfile()
            }
            
            return completed
        } catch {
            print("Failed to check onboarding status: \(error.localizedDescription)")
            await MainActor.run {
                self.error = error
            }
            return false
        }
    }
    
    @MainActor
    func completeOnboarding(name: String, profileImage: Data?) async {
        isLoading = true
        error = nil
        
        do {
            try await repository.saveUserProfile(name: name, profileImage: profileImage)
            
            // Load the saved profile
            await loadUserProfile()
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Failed to complete onboarding: \(error.localizedDescription)")
        }
    }
    
    func getUserProfile() async -> UserProfile? {
        do {
            let profile = try await repository.getUserProfile()
            await MainActor.run {
                self.currentUserProfile = profile
            }
            return profile
        } catch {
            print("Failed to get user profile: \(error.localizedDescription)")
            await MainActor.run {
                self.error = error
            }
            return nil
        }
    }
    
    // MARK: - Additional Helper Methods
    
    @MainActor
    func loadUserProfile() async {
        isLoading = true
        error = nil
        
        do {
            let profile = try await repository.getUserProfile()
            self.currentUserProfile = profile
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Failed to load user profile: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func updateProfile(name: String, profileImage: Data?) async {
        isLoading = true
        error = nil
        
        do {
            try await repository.saveUserProfile(name: name, profileImage: profileImage)
            await loadUserProfile()
        } catch {
            self.error = error
            isLoading = false
            print("Failed to update profile: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func clearError() {
        error = nil
    }
    
    // MARK: - Validation Methods
    
    func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty && trimmedName.count >= 2
    }
    
    func validateOnboardingData(name: String) -> String? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            return "Please enter your name"
        }
        
        if trimmedName.count < 2 {
            return "Name must be at least 2 characters long"
        }
        
        return nil // No validation errors
    }
}

// MARK: - Stub

class StubUserInteractor: UserInteractorProtocol {
    func hasCompletedOnboarding() async -> Bool { return false }
    func completeOnboarding(name: String, profileImage: Data?) async {}
    func getUserProfile() async -> UserProfile? { return nil }
}
