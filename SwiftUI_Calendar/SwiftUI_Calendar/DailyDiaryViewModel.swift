//
//  Untitled.swift
//  SwiftUI_Calendar
//
//  Created by Janice on 2025/10/23.
//

import SwiftUI

struct Event: Identifiable {
    var id: UUID = UUID()
    var title: String
    var date: Date
    var article: String
}

enum DiaryDisplayMode {
    case day
    case week
    case month
}

class DailyDiaryViewModel: ObservableObject {
    // MARK: Properties Initialize
    @Published var selectedDate: Date = Date()
    @Published var displayDate: Date// = Date()
    @Published var currentDate: Date = Date()
    @Published var weekOffset: Int = 0
    @Published var monthOffset: Int = 0
    //@Published var yearOffset: Int = 0
    @Published var displayMode: DiaryDisplayMode = .week
    /// TabView 當前頁
    @Published var pageSelection: Int = 1
    
    /// 一週從 Sunday 開始，或是從 Monday 開始
    /// true => 一週從 Monday 開始
    /// false => 一週從 Sunday 開始
    var weekStartOnMonday: Bool = false
    
    // 測試用假資料
    @Published var events: [Event] = [
        Event(title: "第一篇日記", date: Date().currentDayOffset(offset: -3), article: "今天心情普通"),
        Event(title: "第二篇日記", date: Date(), article: "今天心情好"),
        Event(title: "第三篇日記", date: Date().currentDayOffset(offset: 2), article: "今天心情不好")
    ]
    
    @Published var selectedDayEvents: [Event] = []
    @Published var selectedEvent: Event?
    
    init() {
        self.displayDate = Date().firstDateOfCurrentWeek(weekStartOnMonday: weekStartOnMonday)
    }
}    
    
// MARK: 日期相關
extension DailyDiaryViewModel {  
    
    /// 變更日曆顯示模式
    func changeDisplayMode(_ mode: DiaryDisplayMode) {
        displayMode = mode
    }
    
    /// 選擇日期的 day
    func selectedDateDay() -> String {
        return String(selectedDate.day)
    }
    
    /// 選擇日期的 weekday
    func selectedDateWeekday() -> String {
        return selectedDate.toString(dateFormat:"EEE")
    }
    
    /// 選擇日期的 month
    func selectedDateMonth() -> String {
        return selectedDate.toString(dateFormat:"MMM")
    }
    
    /// 選擇日期的 year
    func selectedDateYear() -> String {
        return selectedDate.toString(dateFormat:"yyyy")
    }
    
    /// 顯示日期的 month
    func displayDateMonth() -> String {
        //let displayDate = currentDate.currentWeekOffset(by: weekOffset)
        return displayDate.toString(dateFormat:"MMM")
    }
    
    /// 顯示日期的 year
    func displayDateYear() -> String {
        //let displayDate = currentDate.changeCurrentMonth(by: monthOffset)
        return displayDate.toString(dateFormat:"yyyy")
    }
    
    /// 日曆往前：前一個星期/月
    func prevCalendar() {
        switch displayMode {
        case .day:
            break
        case .week:
            changeWeek(by: -1)
        case .month:
            changeMonth(by: -1)
        }
    }
    
    /// 日曆往後：後一個星期/月
    func nextCalendar() {
        switch displayMode {
        case .day:
            break
        case .week:
            changeWeek(by: 1)
        case .month:
            changeMonth(by: 1)
        }
    }
    
    /// 日曆改變月份：
    /// - Parameter offset: -1 -> 前一個月, 1 -> 後一個月
    private func changeMonth(by offset: Int) {
        monthOffset += offset
        displayDate = currentDate.changeCurrentMonth(by: monthOffset)
        weekOffset = currentDate.weekdayDifference(with: displayDate)
        print("currentDate: \(currentDate)")
        print("displayDate: \(displayDate)")
        print("weekOffset:\(weekOffset)")
        print("monthOffset:\(monthOffset)")
        print("--------------------")
        //selectedDate = selectedDate.changeCurrentMonth(by: offset)
    }
    
    /// 日曆改變星期：
    /// - Parameter offset: -1 -> 前一個星期, 1 -> 後一個星期
    private func changeWeek(by offset: Int) {
        weekOffset += offset
        displayDate = currentDate.currentWeekOffset(by: weekOffset)
        monthOffset = currentDate.monthDifference(with: displayDate)
        print("currentDate: \(currentDate)")
        print("displayDate: \(displayDate)")
        print("weekOffset:\(weekOffset)")
        print("monthOffset:\(monthOffset)")
        print("--------------------")
        //selectedDate = selectedDate.currentWeekOffset(by: offset)
    }
    
    /*func changeYear(by offset: Int) {
        selectedDate = selectedDate.changeCurrentMonth(by: offset * 12)
    }*/
      
    /// 回傳日曆標頭
    func weekTag() -> [String] {
        if weekStartOnMonday {  // 一週從 Monday 開始          
            return ["Mon", "Tue", "Wed", "Thr", "Fri", "Sat", "Sun"]
            
        } else {                // 一週從 Sunday 開始   
            return ["Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat"]
        } 
    }
    
    /// 回傳在日曆上顯示的日期
    /// displayMode == .week -> 回傳一週的日期
    /// displayMode == .month -> 回傳一個月的日期
    func calendarDates(offset: Int = 0) -> [Date?] {
        switch displayMode {
        case .day:
            return []
        case .week:
            let displayDate = currentDate.currentWeekOffset(by: weekOffset + offset)
            return displayDate.datesInThisWeek(weekStartOnMonday: weekStartOnMonday).map { Optional($0) }
        case .month:
            let displayDate = currentDate.changeCurrentMonth(by: monthOffset + offset)
            return displayDate.datesInThisMonthWithBlank(weekStartOnMonday: weekStartOnMonday)
        }
        
        //displayMode == .week ? selectedDate.datesInThisWeek(weekStartOnMonday: weekStartOnMonday).map{ Optional($0) } :  selectedDate.datesInThisMonthWithBlank(weekStartOnMonday: weekStartOnMonday)
    }
    
    func applyPageChange(direction: Int) {
        switch displayMode {
        case .day:
            break
        case .week:
            changeWeek(by: direction)
        case .month:
            changeMonth(by: direction)
        }
        
        // 重設回中間頁
        DispatchQueue.main.async { 
            self.pageSelection = 1
        }
    }
}

// MARK: 日記相關
extension DailyDiaryViewModel {
    // 取得某日的日記
    //func events(for date: Date) {
    func eventsForSelectedDate() -> [Event] {
         events.filter { selectedDate.isTheSameDay(with: $0.date) }
    }
}
