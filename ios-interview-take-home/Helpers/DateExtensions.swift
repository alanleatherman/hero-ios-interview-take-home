import Foundation

extension Calendar {
    func isToday(_ date: Date) -> Bool {
        return isDate(date, inSameDayAs: Date())
    }
    
    func isYesterday(_ date: Date) -> Bool {
        guard let yesterday = self.date(byAdding: .day, value: -1, to: Date()) else {
            return false
        }
        return isDate(date, inSameDayAs: yesterday)
    }
    
    func isThisWeek(_ date: Date) -> Bool {
        guard let weekInterval = dateInterval(of: .weekOfYear, for: Date()) else {
            return false
        }
        return weekInterval.contains(date)
    }
}

extension Date {
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
        
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
    
    func messageTimeFormat() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
