import Foundation
import SwiftData

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
            // Check if user profile already exists
            let descriptor = FetchDescriptor<UserProfile>()
            let existingProfiles = try modelContext.fetch(descriptor)
            
            if let existingProfile = existingProfiles.first {
                // Update existing profile
                existingProfile.name = name
                existingProfile.profileImage = profileImage
                existingProfile.hasCompletedOnboarding = true
            } else {
                // Create new profile
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
}