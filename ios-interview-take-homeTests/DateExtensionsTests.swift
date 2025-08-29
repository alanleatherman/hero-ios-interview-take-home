import Testing
import Foundation
@testable import ios_interview_take_home

struct DateExtensionsTests {
    
    @Test func chatDisplayFormatToday() {
        // Given
        let now = Date()
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now)
        let timeToday = calendar.date(byAdding: .hour, value: 2, to: today)!
        
        // When
        let result = timeToday.chatDisplayFormat()
        
        // Then
        // Should show time format (e.g., "2:00 PM")
        #expect(result.contains(":"))
        #expect(result.contains("M")) // AM or PM
    }
    
    @Test func chatDisplayFormatYesterday() {
        // Given
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: Date())!
        
        // When
        let result = yesterday.chatDisplayFormat()
        
        // Then
        #expect(result == "Yesterday")
    }
    
    @Test func chatDisplayFormatThisWeek() {
        // Given
        let calendar = Calendar.current
        let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
        
        // When
        let result = twoDaysAgo.chatDisplayFormat()
        
        // Then
        // Should show day name (e.g., "Monday", "Tuesday", etc.)
        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        #expect(dayNames.contains(result))
    }
    
    @Test func chatDisplayFormatOlderDate() {
        // Given
        let calendar = Calendar.current
        let oldDate = calendar.date(byAdding: .day, value: -10, to: Date())!
        
        // When
        let result = oldDate.chatDisplayFormat()
        
        // Then
        // Should show date format (e.g., "1/15/24")
        #expect(result.contains("/"))
    }
    
    @Test func chatDisplayFormatVeryOldDate() {
        // Given
        let calendar = Calendar.current
        let veryOldDate = calendar.date(byAdding: .year, value: -2, to: Date())!
        
        // When
        let result = veryOldDate.chatDisplayFormat()
        
        // Then
        // Should show date format with year
        #expect(result.contains("/"))
    }
    
    @Test func chatDisplayFormatEdgeCases() {
        // Test midnight today
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let midnightResult = startOfToday.chatDisplayFormat()
        #expect(midnightResult.contains(":"))
        
        // Test end of yesterday
        let endOfYesterday = calendar.date(byAdding: .second, value: -1, to: startOfToday)!
        let yesterdayResult = endOfYesterday.chatDisplayFormat()
        #expect(yesterdayResult == "Yesterday")
    }
}