import XCTest
@testable import ios_interview_take_home

@MainActor
final class AppContainerTests: XCTestCase {
    
    var appState: AppState!
    var mockChatInteractor: MockChatInteractor!
    var mockUserInteractor: MockUserInteractor!
    var container: AppContainer!
    
    override func setUp() {
        super.setUp()
        appState = AppState()
        mockChatInteractor = MockChatInteractor()
        mockUserInteractor = MockUserInteractor()
        
        let interactors = AppContainer.Interactors(
            chatInteractor: mockChatInteractor,
            userInteractor: mockUserInteractor
        )
        
        container = AppContainer(appState: appState, interactors: interactors)
    }
    
    override func tearDown() {
        container = nil
        mockUserInteractor = nil
        mockChatInteractor = nil
        appState = nil
        super.tearDown()
    }
    
    func testSignOutClearsAllData() async {
        // Given: User has completed onboarding and has data
        appState.userState.hasCompletedOnboarding = true
        appState.userState.hasShownTypewriter = true
        appState.userState.userName = "Test User"
        appState.userState.profileImage = Data([1, 2, 3])
        
        // When: Sign out is called
        await container.signOut()
        
        // Then: All app state is cleared
        XCTAssertFalse(appState.userState.hasCompletedOnboarding)
        XCTAssertFalse(appState.userState.hasShownTypewriter)
        XCTAssertEqual(appState.userState.userName, "")
        XCTAssertNil(appState.userState.profileImage)
        
        // And: Both interactors are called
        XCTAssertTrue(mockUserInteractor.signOutCalled)
        XCTAssertTrue(mockChatInteractor.clearAllDataCalled)
    }
    
    func testSignOutCallsInteractorsInCorrectOrder() async {
        // Given: Fresh container
        mockUserInteractor.signOutCalled = false
        mockChatInteractor.clearAllDataCalled = false
        
        // When: Sign out is called
        await container.signOut()
        
        // Then: Both interactor methods are called
        XCTAssertTrue(mockUserInteractor.signOutCalled)
        XCTAssertTrue(mockChatInteractor.clearAllDataCalled)
    }
}

// MARK: - Mock Interactors for Testing

@MainActor
class MockChatInteractor: ChatInteractorProtocol {
    var clearAllDataCalled = false
    var loadChatsCalled = false
    var sendMessageCalled = false
    var markChatAsReadCalled = false
    
    func loadChats() async {
        loadChatsCalled = true
    }
    
    func sendMessage(_ content: String, to otherUserName: String) async {
        sendMessageCalled = true
    }
    
    func markChatAsRead(_ chat: Chat) async {
        markChatAsReadCalled = true
    }
    
    func clearAllData() async {
        clearAllDataCalled = true
    }
}

@MainActor
class MockUserInteractor: UserInteractorProtocol {
    var signOutCalled = false
    var hasCompletedOnboardingCalled = false
    var completeOnboardingCalled = false
    var getUserProfileCalled = false
    var updateProfileCalled = false
    
    func hasCompletedOnboarding() async -> Bool {
        hasCompletedOnboardingCalled = true
        return false
    }
    
    func completeOnboarding(name: String, profileImage: Data?) async {
        completeOnboardingCalled = true
    }
    
    func getUserProfile() async -> UserProfile? {
        getUserProfileCalled = true
        return nil
    }
    
    func updateProfile(name: String, profileImage: Data?) async {
        updateProfileCalled = true
    }
    
    func signOut() async {
        signOutCalled = true
    }
}