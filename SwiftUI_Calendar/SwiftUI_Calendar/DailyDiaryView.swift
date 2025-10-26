//
//  DailyDiaryView.swift
//  SwiftUI_Calendar
//
//  Created by Janice on 2025/10/23.
//

import SwiftUI

struct DailyDiaryView: View {
    @StateObject private var vm = DailyDiaryViewModel()
    
    var body: some View {
        VStack {
            // 選擇日期
            //CalendarHeaderView(vm: vm)
            // 分隔線
            //Divider()
                //.padding(.vertical, 8)
            // 切換列：週 / 月 / < / > 切換按鈕
            CalendarSwitcherView(vm: vm)
            // 星期標籤
            CalendarWeekdayHeaderView(vm: vm)
            // 日曆
            CalendarGridView(vm: vm)
            // 選取日期的活動
            CalendarEventListView(vm: vm)
        }
        .padding(.horizontal)
    }
}

/// 日曆頁的標頭
struct CalendarHeaderView: View {
    @ObservedObject var vm: DailyDiaryViewModel
    
    var body: some View {
        // 選擇日期
        HStack {
            Spacer()
            VStack(alignment: .trailing) {
                Text(vm.selectedDateWeekday())
                Text(vm.selectedDateMonth())
            }
            
            Text(vm.selectedDateDay())
                .font(.system(size: 48, weight: .bold, design: .default))
        }
        .padding(.horizontal)
        
        // Title
        HStack {
            Spacer()
            Text("Diary")
                .font(.system(size: 48, weight: .bold, design: .default))
        }
        .padding(.horizontal)
    }
}

/// 切換列：週 / 月 / < / > 切換按鈕/
struct CalendarSwitcherView: View {
    @ObservedObject var vm: DailyDiaryViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    vm.prevCalendar()
                }) {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                
                Button("週") {
                    vm.changeDisplayMode(.week)
                }
                .foregroundColor(vm.displayMode ==   .week ? .blue : .gray)
                Spacer()
                
                /*Picker("", selection: $vm.displayMode) {
                 Text("Month").tag(true)
                 Text("Week").tag(false)
                 }
                 .pickerStyle(.segmented)
                 .padding(.horizontal)*/
                
                Button("月") {
                    vm.changeDisplayMode(.month)
                }
                .foregroundColor(vm.displayMode ==   .month ? .blue : .gray)
                Spacer()
                
                Button(action: {
                    vm.nextCalendar()
                }) {
                    Image(systemName: "chevron.right")
                }
                Spacer()
            }
            .padding()
        }
        HStack {
            Text(vm.displayDateMonth())
            Text(vm.displayDateYear())
        }
        .padding()
    }
}

/// 星期標籤
struct CalendarWeekdayHeaderView: View {
    @ObservedObject var vm: DailyDiaryViewModel
    
    var body: some View {
        HStack {
            ForEach(vm.weekTag(), id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
}

/// 日曆
struct CalendarGridView: View {
    @ObservedObject var vm: DailyDiaryViewModel
    //let offsetIndex: Int
    
    var body: some View {
        if #available(iOS 17.0, *) {
            calendarTabView()
                .onChange(of: vm.pageSelection) { _, newValue in
                    if newValue == 0 {  
                        vm.applyPageChange(direction: -1)
                    } else if newValue == 2 {   
                        vm.applyPageChange(direction: 1)
                    }
                }
            
        } else {
            calendarTabView()
                .onChange(of: vm.pageSelection) { newValue in
                    if newValue == 0 {  // 往左滑，顯示前一頁
                        vm.applyPageChange(direction: -1)
                    } else if newValue == 2 {   //  往右滑，顯示下一頁
                        vm.applyPageChange(direction: 1)
                    }
                }
        }
       
        
    }
    
    @ViewBuilder 
    private func calendarTabView() -> some View {
        TabView(selection: $vm.pageSelection) {
            calendarPageView(offset: -1).tag(0)
            calendarPageView(offset: 0).tag(1)
            calendarPageView(offset: 1).tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        //.frame(maxWidth: .infinity, minHeight: 70)
        .frame(maxHeight: vm.displayMode == .week ? 90 : 350)
        //.fixedSize(horizontal: false, vertical: true)
        .animation(.easeInOut, value: vm.displayMode)
        
    }
    
    @ViewBuilder
    private func calendarPageView(offset: Int) -> some View {
        let days = vm.calendarDates(offset: offset)
        let columns = Array(repeating: GridItem(.flexible()), count: 7)
        
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(days.indices, id: \.self) { index in
                if let date = days[index] {
                    let isSelected = vm.selectedDate.isTheSameDay(with: date)
                    let isToday = vm.currentDate.isTheSameDay(with: date)
                    let isEventDay: Bool = vm.events.contains(where: { $0.date.isTheSameDay(with: date)})
                    
                    VStack {
                        Text("\(date.day)")
                            .frame(maxWidth: .infinity, minHeight: 30)
                            .padding(6)
                            .background(isSelected ? .red.opacity(0.2) : .clear)
                            .clipShape(Circle())
                        
                        // 有事件的日期加上點
                        if isEventDay {
                            Circle()
                                .frame(width: 4, height: 4)
                                .foregroundStyle(.blue)
                        } else {
                            Circle()
                                .frame(width: 4, height: 4)
                                .foregroundStyle(.blue).opacity(0)
                            //Spacer()
                        } 
                    }
                    .onTapGesture {
                        vm.selectedDate = date
                    }
                } else {
                    Color.clear
                        .frame(maxWidth: .infinity, minHeight: 30)
                }
            }
        }
        .background(.gray.opacity(0.1))
    }
}

/// 選取日期的活動
struct CalendarEventListView: View {
    @ObservedObject var vm: DailyDiaryViewModel
    
    var body: some View {
        List(vm.eventsForSelectedDate()) { event in
            Text(event.title)
                .font(.headline)
            Text(event.article)
        }
        .background(.clear)
    }
}

#Preview {
    DailyDiaryView()
}
