# iOS Messaging App - Take Home Interview

A modern iOS messaging application built with SwiftUI and SwiftData, featuring real-time messaging simulation, persistent data storage, and a clean architecture pattern.

## Features

### Core Functionality
- **Chat List**: View all conversations with unread message indicators
- **Individual Chat**: Send and receive messages with automatic bot responses
- **Message Persistence**: Messages persist across app sessions using SwiftData
- **Read Status Tracking**: Messages are automatically marked as read when viewed
- **User Onboarding**: First-time user setup with name and profile image
- **Real-time UI Updates**: Automatic scrolling and message count updates

### Technical Highlights
- **SwiftUI + SwiftData**: Modern iOS development stack
- **Clean Architecture**: Separation of concerns with Interactors, Repositories, and Models
- **Dependency Injection**: Environment-based dependency management
- **Async/Await**: Modern concurrency for network operations
- **Error Handling**: Comprehensive error handling with fallback mechanisms
- **Responsive Design**: Adaptive UI that works across different screen sizes

## Architecture

### Design Patterns
- **Repository Pattern**: Abstracted data layer with protocol-based interfaces
- **Interactor Pattern**: Business logic separation from UI components
- **Environment Pattern**: SwiftUI environment for dependency injection
- **Observable Pattern**: SwiftUI's @Observable for state management

### Project Structure
```
ios-interview-take-home/
├── App/                    # App lifecycle and configuration
├── Models/                 # Core data models (Chat, Message, Profile, UserProfile)
├── Screens/               # Main UI screens (ChatList, ChatScreen, Onboarding)
├── Subviews/              # Reusable UI components
├── Interactors/           # Business logic layer
├── Data/                  # Repository implementations and protocols
├── Environment/           # Dependency injection and app state
├── Helpers/               # Utilities and extensions
└── SwiftUI/              # Main content view and app entry point
```

### Key Components

#### Data Layer
- **ChatWebRepository**: Handles chat persistence and bot response simulation
- **UserWebRepository**: Manages user profile and onboarding state
- **SwiftData Models**: Core data models with relationships and computed properties

#### Business Logic
- **ChatInteractor**: Manages chat operations, message sending, and read status
- **UserInteractor**: Handles user profile management and onboarding flow

#### UI Layer
- **Responsive Design**: Adaptive layouts for different screen sizes
- **Modern UI Components**: Custom message bubbles, input bars, and profile views
- **Smooth Animations**: Typewriter effects, message transitions, and scroll animations

## Key Implementation Decisions

### 1. SwiftData for Persistence
- **Why**: Modern, type-safe persistence layer that integrates seamlessly with SwiftUI
- **Benefits**: Automatic relationship management, query capabilities, and reduced boilerplate
- **Trade-offs**: iOS 17+ requirement, but provides better developer experience than Core Data

### 2. Repository Pattern with Protocols
- **Why**: Enables easy testing, dependency injection, and future data source changes
- **Benefits**: Clean separation between business logic and data access
- **Implementation**: Protocol-based repositories with concrete implementations

### 3. Environment-Based Dependency Injection
- **Why**: SwiftUI-native approach that scales well and supports testing
- **Benefits**: Clean dependency management without external frameworks
- **Usage**: Custom environment keys for interactors and app state

### 4. Automatic Message Read Status
- **Why**: Improves user experience by eliminating manual "mark as read" actions
- **Implementation**: Messages are marked as read both on screen appearance and when new messages arrive
- **Persistence**: Read status persists across app sessions

### 5. Bot Response Simulation
- **Why**: Demonstrates real-time messaging without requiring a backend
- **Implementation**: Randomized responses with realistic delays
- **Benefits**: Shows async handling and UI updates for incoming messages

## Testing Strategy

The project includes unit tests for core business logic:

### Test Coverage
- **Model Logic**: Chat read status, message sorting, and relationships
- **Interactor Logic**: Message sending, chat management, and user operations
- **Repository Logic**: Data persistence and retrieval operations
- **Error Handling**: Network failures and data corruption scenarios

### Testing Approach
- **Isolated Unit Tests**: Each component tested in isolation with mocked dependencies
- **Async Testing**: Proper testing of async/await operations
- **Edge Cases**: Boundary conditions and error scenarios

## Future Enhancements

Given more time, the following features would enhance the application:

### Immediate Improvements (1-2 hours)
- **Message Search**: Search functionality across all conversations
- **Message Timestamps**: Detailed timestamp display with relative formatting
- **Typing Indicators**: Show when the bot is "typing" a response
- **Message Status Icons**: Delivered/read indicators for sent messages

### Medium-term Features (Day)
- **Push Notifications**: Local notifications for new messages when app is backgrounded
- **Message Reactions**: Emoji reactions to messages
- **File Attachments**: Support for images, documents, and other media
- **Chat Settings**: Per-chat notification settings and customization
- **Export Conversations**: Ability to export chat history

### Advanced Features (1-2 weeks)
- **Real Backend Integration**: Replace bot simulation with actual messaging service, would at this point make the web vs preview repositories more varied
- **End-to-End Encryption**: Secure message transmission and storage
- **Group Chats**: Multi-participant conversations
- **Voice Messages**: Audio recording and playback
- **Video Calls**: Integrated video calling functionality
- **Cloud Sync**: Cross-device message synchronization

### Performance & Polish
- **Message Pagination**: Lazy loading for large conversation histories
- **Image Optimization**: Efficient image caching and compression
- **Accessibility**: VoiceOver support and accessibility improvements
- **Localization**: Multi-language support
- **Dark Mode Refinements**: Enhanced dark mode styling

## Technical Debt & Improvements

### Code Quality
- **Increased Test Coverage**: Expand unit tests to cover more edge cases
- **UI Testing**: Add UI tests for critical user flows
- **Documentation**: Add inline documentation for complex business logic
- **Code Review**: Implement stricter linting and code review processes

### Performance
- **Memory Management**: Optimize image loading and message rendering
- **Database Optimization**: Add indexes for common queries
- **Background Processing**: Move heavy operations off the main thread

### Architecture
- **Modularization**: Split into feature-based modules for better organization
- **Protocol Refinement**: More granular protocols for better testability
- **Error Handling**: More specific error types and user-friendly error messages

## Running the Project

1. **Requirements**: iOS 17.0+, Xcode 15.0+
2. **Setup**: Open `ios-interview-take-home.xcodeproj` in Xcode
3. **Build**: Select a simulator or device and press Cmd+R
4. **Testing**: Press Cmd+U to run the unit test suite

## Time Investment

This implementation represents approximately 4 hours of focused development time, covering:
- Core messaging functionality (1.5 hours)
- Data persistence and architecture (1 hour)
- UI polish and user experience (1 hour)
- Testing and documentation (0.5 hours)

The codebase demonstrates production-ready iOS development practices while maintaining clean, readable, and maintainable code suitable for a team environment.
