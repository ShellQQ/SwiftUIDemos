//
//  Date_Ext.swift
//  SwiftUI_Calendar
//
//  Created by Janice on 2025/10/23.
//

import Foundation

// MARK: Initializer 初始化
extension Date {
    init(year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, min: Int? = nil, sec: Int? = nil, calendar: Calendar = Calendar.current) {
        self.init()
        
        if let date = self.setDate(year: year, month: month, day: day, hour: hour, min: min, sec: sec, calendar: calendar) {
            self = date
        }
    }
}

// MARK: Properties 
extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    
    //var components: DateComponents { return Calendar.current.dateComponents([.year], from: self) }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: dayBegin)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: dayBegin)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var dayBegin: Date {
        return Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: self)!
    }
    var era: Int {
        return Calendar.current.component(.era, from: self)
    }
    var year: Int {
        get { return Calendar.current.component(.year, from: self) }
        set { if let date = self.setDate(year: newValue) { self = date } }
    }
    var month: Int {
        get { return Calendar.current.component(.month, from: self) }
        set { if let date = self.setDate(month: newValue) { self = date } }
    }
    var day: Int {
        get { return Calendar.current.component(.day, from: self) }
        set { if let date = self.setDate(day: newValue) { self = date } }
    }
    var hour: Int {
        get { return Calendar.current.component(.hour, from: self) }
        set { if let date = self.setDate(hour: newValue) { self = date } }
    }
    var minute: Int {
        get { return Calendar.current.component(.minute, from: self) }
        set { if let date = self.setDate(min: newValue) { self = date } }
    }
    var second: Int {
        get { return Calendar.current.component(.second, from: self) }
        set { if let date = self.setDate(sec: newValue) { self = date } }
    }
    var nanosecond: Int {
        return Calendar.current.component(.nanosecond, from: self)
    }
    var millisecond : Int {
        return (self.nanosecond) / 1000000
    }
    var firstDateOfCurrentWeek: Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 1   // 1: Sunday, 2: Monday
        let components = calendar.dateComponents(Set([.yearForWeekOfYear, .weekOfYear]), from: self)
        return calendar.date(from: components)!
    }
    var lastDateOfCurrentWeek: Date {
        return Calendar.current.date(byAdding: .day, value: 6, to: self.firstDateOfCurrentWeek)!
    }
    var firstDateOfCurrentMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents(Set([.year, .month]), from: self)
        return calendar.date(from: components)!
    }
    var lastDateOfCurrentMonth: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: self.firstDateOfCurrentMonth)!
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    var isToday: Bool {
        //let today = Date()
        //return self.year == today.year && self.month == today.month && self.day == today.day
        return Calendar.current.isDateInToday(self)
    }
    // DateComponents 1 是 星期日，2 是 星期一（以此類推）
    // -1後 回傳 1 是 星期一，2 是 星期二， ... ，7 是 星期日
    var weekDay: Int {
        let weekday = Calendar.current.component(.weekday, from: self) - 1
        return weekday == 0 ? 7 : weekday
    }
}

// MARK: Difference
extension Date {
    /// 相差月份
    public func monthDifference(with date: Date) -> Int {
        let components = Calendar.current.dateComponents([.month], from: self, to: date)
        return components.month ?? 0
    }
    
    /// 相差星期
    public func weekdayDifference(with date: Date) -> Int {
        let components = Calendar.current.dateComponents([.weekOfYear], from: self, to: date)
        return components.weekOfYear ?? 0
    }
    
    /// 相差天數
    public func dayDifference(with date: Date) -> Int {
        let components = Calendar.current.dateComponents([.day], from: self, to: date)
        return components.day ?? 0
    }
    
    /// 相差分鐘數
    public func minuteDifference(with date: Date) -> Int {
        let components = Calendar.current.dateComponents([.minute], from: self, to: date)
        return components.minute ?? 0
    }
    
    /// 幾天前
    public func dateBefore(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: -day, to: self)!
    }
    
    /// 是否同一天
    public func isTheSameDay(with date: Date) -> Bool {
        //return self.year == date.year && self.month == date.month && self.day == date.day
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
}

// MARK: Month 處理
extension Date {
    
    /// 指定日期的月份所有日期，前後不補空白
    /// - Parameters:
    ///   - date: 可傳入欲計算月份的 日期
    /// - Returns：[Date] -- 當月日期的陣列 
    func datesInMonth(for date: Date) -> [Date] {
        let calendar = Calendar.current
        // 當月範圍
        guard let range = calendar.range(of: .day, in: .month, for: date), 
                let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) // 當月第一天
        else { return [] }

        return range.compactMap { day -> Date? in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
    }
    
    /// 目前月份的所有日期
    func datesInThisMonth() -> [Date] {
        return datesInMonth(for: self)
    }
    
    /// 前一個月份的所有日期
    func datesInPrevMonth() -> [Date] {
        return datesInMonth(for: monthOffset(from: self, offset: -1))
    }
    
    /// 下一個月份的所有日期
    func datesInNextMonth() -> [Date] {
        return datesInMonth(for: monthOffset(from: self, offset: 1))
    }
    
    /// 指定日期的月份所有日期，包含前後補空白，可選擇一週從星期一或星期日開始
    /// - Parameters:
    ///   - date: 可傳入欲計算月份的 日期
    ///   - weekStartsOnMonday: true => 一週從 Monday 開始；false => 一週從 Sunday 開始
    /// - Returns：[Date?]，當月日期的陣列，包含前後補空白，長度為 7 的倍數，nil 表示空白格
    func datesInMonthWithBlank(for date: Date, weekStartOnMonday: Bool = false) -> [Date?] {
        var calendar = Calendar.current
        calendar.firstWeekday = weekStartOnMonday ? 2 : 1 // 1 = Sunday, 2 = Monday
        // 當月範圍
        guard let range = calendar.range(of: .day, in: .month, for: date), 
                let monthInterval = calendar.dateInterval(of: .month, for: date)
                //let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) // 當月第一天
        else { return [] }
        
        // 當月第一天
        // 比起用 dateComponents, 用 dateInterval 更穩健
        let startOfMonth = monthInterval.start
        // 該月所有日期
        let days: [Date] = range.compactMap { day in
            // 在 startOfMonth(to) 上，加上 day - 1(value) 天(byAdding)
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)!
        }
        
        // 取得第一天是星期幾（1 = Sunday, 2 = Monday, ...)
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        
        // 前置空白數量(weedday 是從 1 開始，這裡我們要轉換成 0-based)
        let leadingEmpty = (firstWeekday - calendar.firstWeekday + 7) % 7

        // 後製空白數量，讓總數為 7 的倍數
        let totalCount = leadingEmpty + days.count
        let trailingEmpty = (7-(totalCount % 7)) % 7
        
        let result: [Date?] = Array(repeating: nil, count: leadingEmpty) + days + Array(repeating: nil, count: trailingEmpty)
        
        return result
    }
    
    /// 目前月份的所有日期
    func datesInThisMonthWithBlank(weekStartOnMonday: Bool = false) -> [Date?] {
        return datesInMonthWithBlank(for: self, weekStartOnMonday: weekStartOnMonday)
    }
    
    /// 切換月份（offset = -1 往前一個月，+1 往後一個月）
    func monthOffset(from date: Date, offset: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: offset, to: date)!
    }
    
    /// 切換當月（offset = -1 往前一個月，+1 往後一個月）
    func changeCurrentMonth(by offset: Int) -> Date {
        self.monthOffset(from: self, offset: offset)
    }
    
}

// MARK: Week 處理
extension Date {
    
    /// 回傳該日期所在週的起始日（依照 calendar.firstWeekday 決定週的起始）
    func firstDateOfCurrentWeek(weekStartOnMonday: Bool = false) -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = weekStartOnMonday ? 2 : 1 
        
        return calendar.dateInterval(of: .weekOfYear, for: self)!.start
    }
    
    /// 指定日期所在週所有日期
    func datesInWeek(for date: Date, weekStartOnMonday: Bool = false) -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = weekStartOnMonday ? 2 : 1 // 1 = Sunday, 2 = Monday
        
        let startOfWeek = calendar.dateInterval(of: .weekOfMonth, for: date)?.start ?? date
        return (0..<7).compactMap {
            calendar.date(byAdding: .day, value: $0, to: startOfWeek)
        }
    }
    
    /// 本週的所有日期
    func datesInThisWeek(weekStartOnMonday: Bool = false) -> [Date] {
        return datesInWeek(for: self, weekStartOnMonday: weekStartOnMonday)
    }
    
    /// 前一週的所有日期
    func datesInPrevWeek() -> [Date] {
        return datesInWeek(for: weekOffset(from: self, offset: -1))
    }
    
    /// 下一週的所有日期
    func datesInNextWeek() -> [Date] {
        return datesInWeek(for: weekOffset(from: self, offset: 1))
    }
    
    /// 切換週（offset = -1 往前一週，+1 往後一週）
    func weekOffset(from date: Date, offset: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: offset, to: date)!
    }
    
    /// 本日切換週（offset = -1 往前一週，+1 往後一週）
    func currentWeekOffset(by offset: Int) -> Date {
        return weekOffset(from: self, offset: offset)
    }
    

}    
   
// MARK: Day 處理
extension Date {    
    /// 切換日（offset = -1 往前一天，+1 往後一天）
    func dayOffset(from date: Date, offset: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: offset, to: date)!
    }
    
    // 本日切換日（offset = -1 往前一天，+1 往後一天）
    func currentDayOffset(offset: Int) -> Date {
        return dayOffset(from: self, offset: offset)
    }
}

// MARK: 其他處理
extension Date {
    public func weekOfYear() -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1       // 設定星期日為一週開始
        
        return calendar.component(.weekOfYear, from: self)
    }
    
    public func currentWeek() -> [Date] {
        return weekAfterCurrent(weekNum: 0)
    }
    
    public func weekAfterCurrent(weekNum: Int) -> [Date] {
        let calendar = Calendar.current
        let date = calendar.date(byAdding: .day, value: weekNum * 7, to: self)!
        let components = calendar.dateComponents(Set([.yearForWeekOfYear, .weekOfYear]), from: date)
        let startDate = calendar.date(from: components)!
        
        var weekDays = [Date]()
        
        for i in 0...6 {
            weekDays.append(calendar.date(byAdding: .day, value: i, to: startDate)!)
        }
        
        return weekDays
    }
    
    // 設定 Date 年、月、日、小時、分鐘、秒
    public func setDate(year: Int? = nil,
                        month: Int? = nil,
                        day: Int? = nil,
                        hour: Int? = nil,
                        min: Int? = nil,
                        sec: Int? = nil,
                        calendar: Calendar = Calendar.current) -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)

        if (year != nil){
            components.year = year
        }

        if (month != nil){
            components.month = month
        }

        if (day != nil){
            components.day = day
        }

        if (hour != nil){
            components.hour = hour
        }
        
        if (min != nil){
            components.minute = min
        }
        
        if (sec != nil){
            components.second = sec
        }

        return cal.date(from: components)
    }
    
    // 回傳日期字串
    // - dateFormat: http://www.unicode.org/reports/tr35/tr35-dates.html#Date_Format_Patterns
    //   - 時區 : zzz
    //   - 年  : yyyy: 2022, yy: 22
    //   - 月  : MM: 10, MMM: Oct
    //   - 日  : dd
    //   - 時  : HH
    //   - 分  : mm
    //   - 秒  : ss
    //   - 星期 : EEEE
    public func toString(dateFormat: String = "yyyy-MM-dd", timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    
}

extension TimeZone {
    static func currentString() -> String {
        let identifier = TimeZone.current.identifier
        guard let str = identifier.split(separator: "/").last else { return identifier }
        return String(str)
    }
}
