import Foundation

// MARK: - User Interactor

@MainActor
@Observable
class UserInteractor: UserInteractorProtocol {
    private let repository: UserRepositoryProtocol
    
    var isLoading = false
    var error: Error?
    var currentUserProfile: UserProfile?
    
    init(repository: UserRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - UserInteractorProtocol Implementation
    
    nonisolated func hasCompletedOnboarding() async -> Bool {
        do {
            let completed = try await repository.hasCompletedOnboarding()
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
    
    func completeOnboarding(name: String, profileImage: Data?) async {
        isLoading = true
        error = nil
        
        do {
            try await repository.saveUserProfile(name: name, profileImage: profileImage)
            await loadUserProfile()
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Failed to complete onboarding: \(error.localizedDescription)")
        }
    }
    
    nonisolated func getUserProfile() async -> UserProfile? {
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
    
    func clearError() {
        error = nil
    }
    
    // MARK: - Validation Methods
    
    nonisolated func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedName.isEmpty && trimmedName.count >= 2
    }
    
    nonisolated func validateOnboardingData(name: String) -> String? {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            return "Please enter your name"
        }
        
        if trimmedName.count < 2 {
            return "Name must be at least 2 characters long"
        }
        
        return nil
    }
    
    func signOut() async {
        isLoading = true
        error = nil
        
        do {
            try await repository.clearUserProfile()
            currentUserProfile = nil
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
            print("Failed to sign out: \(error.localizedDescription)")
        }
    }
}

// MARK: - Stub

class StubUserInteractor: UserInteractorProtocol {
    func hasCompletedOnboarding() async -> Bool { return false }
    func completeOnboarding(name: String, profileImage: Data?) async {}
    func getUserProfile() async -> UserProfile? { return nil }
    func updateProfile(name: String, profileImage: Data?) async {}
    func signOut() async {}
}
