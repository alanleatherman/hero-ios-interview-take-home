import Foundation
import SwiftData

enum UserError: LocalizedError {
    case onboardingDataMissing
    case profileSaveFailure(Error)
    case profileLoadFailure(Error)
    
    var errorDescription: String? {
        switch self {
        case .onboardingDataMissing:
            return "Onboarding data is missing or corrupted"
        case .profileSaveFailure:
            return "Failed to save user profile"
        case .profileLoadFailure:
            return "Failed to load user profile"
        }
    }
}

@MainActor
class UserWebRepository: UserRepositoryProtocol {
    private var modelContext: ModelContext?
    
    init(modelContext: ModelContext? = nil) {
        self.modelContext = modelContext
    }
    
    // MARK: - UserRepositoryProtocol Implementation
    
    func hasCompletedOnboarding() async throws -> Bool {
        guard let modelContext = modelContext else {
            return false
        }
        
        do {
            let descriptor = FetchDescriptor<UserProfile>()
            let profiles = try modelContext.fetch(descriptor)
            return profiles.first?.hasCompletedOnboarding ?? false
        } catch {
            throw UserError.profileLoadFailure(error)
        }
    }
    
    func saveUserProfile(name: String, profileImage: Data?) async throws {
        guard let modelContext = modelContext else {
            throw UserError.profileSaveFailure(NSError(domain: "UserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Model context not available"]))
        }
        
        do {
            let descriptor = FetchDescriptor<UserProfile>()
            let existingProfiles = try modelContext.fetch(descriptor)
            
            if let existingProfile = existingProfiles.first {
                existingProfile.name = name
                existingProfile.profileImage = profileImage
                existingProfile.hasCompletedOnboarding = true
            } else {
                let newProfile = UserProfile(
                    name: name,
                    profileImage: profileImage,
                    hasCompletedOnboarding: true
                )
                modelContext.insert(newProfile)
            }
            
            try modelContext.save()
        } catch {
            throw UserError.profileSaveFailure(error)
        }
    }
    
    func getUserProfile() async throws -> UserProfile? {
        guard let modelContext = modelContext else {
            return nil
        }
        
        do {
            let descriptor = FetchDescriptor<UserProfile>()
            let profiles = try modelContext.fetch(descriptor)
            return profiles.first
        } catch {
            throw UserError.profileLoadFailure(error)
        }
    }
    
    func clearUserProfile() async throws {
        guard let modelContext = modelContext else {
            throw UserError.profileSaveFailure(NSError(domain: "UserRepository", code: 1, userInfo: [NSLocalizedDescriptionKey: "Model context not available"]))
        }
        
        do {
            let descriptor = FetchDescriptor<UserProfile>()
            let profiles = try modelContext.fetch(descriptor)
            
            for profile in profiles {
                modelContext.delete(profile)
            }
            
            try modelContext.save()
        } catch {
            throw UserError.profileSaveFailure(error)
        }
    }
}
