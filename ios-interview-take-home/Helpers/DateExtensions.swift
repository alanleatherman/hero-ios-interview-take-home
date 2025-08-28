import Foundation

extension Calendar {
    /// Check if a date is today
    func isToday(_ date: Date) -> Bool {
        return isDate(date, inSameDayAs: Date())
    }
    
    /// Check if a date is yesterday
    func isYesterday(_ date: Date) -> Bool {
        guard let yesterday = self.date(byAdding: .day, value: -1, to: Date()) else {
            return false
        }
        return isDate(date, inSameDayAs: yesterday)
    }
    
    /// Check if a date is within the current week
    func isThisWeek(_ date: Date) -> Bool {
        guard let weekInterval = dateInterval(of: .weekOfYear, for: Date()) else {
            return false
        }
        return weekInterval.contains(date)
    }
}

extension Date {
    /// Format date for chat display (Today, Yesterday, day of week, or short date)
    func chatDisplayFormat() -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        
        if calendar.isToday(self) {
            formatter.timeStyle = .short
            return formatter.string(from: self)
        }
        
        if calendar.isYesterday(self) {
            return "Yesterday"
        }
        
        if calendar.isThisWeek(self) {
            formatter.dateFormat = "EEEE" // Day of week
            return formatter.string(from: self)
        }
        
        // Older dates
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    /// Format time for message display (just time)
    func messageTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}