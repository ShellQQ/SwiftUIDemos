//
//  FBGradientMaskView.swift
//  SwiftUI_FBGradientMask
//
//  Created by Janice on 2025/10/23.
//

import SwiftUI

struct FBGradientMaskView: View {
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 15) {
                        ForEach(messages) {message in
                            MessageCareView(geometry: geometry, message: message)
                                //.frame(maxWidth: .infinity, alignment: message.isReply ? .leading : .trailing)
                        }
                    }
                    .padding(15)
                }
                .navigationTitle("Message")
            }
        }
    }
}

struct MessageCareView: View {
    var geometry: GeometryProxy
    var message: Message
    
    var body: some View {
        Text(message.message)
            .padding(10)
            .foregroundStyle(message.isReply ? Color.primary : .white)
            .background {
                if message.isReply {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(.gray.opacity(0.2))
                } else {
                    GeometryReader {
                        let size = $0.size
                        let rect = $0.frame(in: .global)
                        let screenSize = geometry.size
                        let safeArea = geometry.safeAreaInsets
                        
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(.linearGradient(colors: [
//                                Color.gradient1,
//                                Color.gradient2,
//                                Color.gradient3,
//                                Color.gradient4
//                            ], startPoint: .top, endPoint: .bottom))
                        LinearGradient(colors: [
                            Color.gradient1,
                            Color.gradient2,
                            Color.gradient3,
                            Color.gradient4
                        ], startPoint: .top, endPoint: .bottom)
                            // 使用 .mask 只顯示氣泡範圍
                            .mask(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 15)
                                // Step 3：對齊漸層與遮罩位置
                                .frame(width: size.width, height: size.height)
                                .offset(x: rect.minX, y: rect.minY)
                            }
                            // 建立一個整個畫面大的「漸層矩形」
                            .offset(x: -rect.minX, y: -rect.minY)
                            .frame(width: screenSize.width, height: screenSize.height + safeArea.top + safeArea.bottom)

                        
                    }
                }
            }
            .frame(maxWidth: 250, alignment: message.isReply ? .leading : .trailing)
            .frame(maxWidth: .infinity, alignment: message.isReply ? .leading : .trailing)
    }
}

#Preview {
    FBGradientMaskView()
}


struct Message: Identifiable {
    var id: UUID = UUID()
    var message: String
    var isReply: Bool = false
}

let messages: [Message] = [
    .init(message: "嗨～今天有空嗎？"),
    .init(message: "有啊！你想約幾點？", isReply: true),
    .init(message: "下午三點可以嗎？我們去咖啡店。"),
    .init(message: "好啊，我知道那間店，有插座又安靜。", isReply: true),
    .init(message: "對，我想帶筆電去寫點東西。"),
    .init(message: "最近在忙新專案嗎？", isReply: true),
    .init(message: "嗯，正在做一個 SwiftUI 的聊天室介面。"),
    .init(message: "喔～聽起來很酷，介面是自己設計的？", isReply: true),
    .init(message: "對啊，我用 GeometryReader 控制佈局。"),
    .init(message: "GeometryReader？那不是很容易錯位嗎 XD", isReply: true),
    .init(message: "哈哈，一開始是啦，後來就熟了。"),
    .init(message: "我覺得你應該錄個教學影片。", isReply: true),
    .init(message: "這主意不錯，或許可以放在 Medium 上。"),
    .init(message: "你之前不是有寫泛型的系列文嗎？", isReply: true),
    .init(message: "對，那系列我還在整理下一篇。"),
    .init(message: "每次看你的文章都覺得好清楚。", isReply: true),
    .init(message: "謝啦 😄 我盡量讓例子實用一點。"),
    .init(message: "真的，尤其協議擴展那篇超實用。", isReply: true),
    .init(message: "哈哈，那篇我也花最多時間寫。"),
    .init(message: "你下次要不要寫 SwiftUI 動畫？", isReply: true),
    .init(message: "這主題不錯，我最近也在研究 mask 的用法。"),
    .init(message: "就是那個可以做漸層遮罩的？", isReply: true),
    .init(message: "對啊，可以拿來做訊息氣泡的漸層特效。"),
    .init(message: "原來那是 mask，我一直以為是 clipShape。", isReply: true),
    .init(message: "clipShape 是固定形狀，mask 可以用任何 View。"),
    .init(message: "感覺你快要出 SwiftUI 教科書了 XD", isReply: true),
    .init(message: "哈哈，不敢當，我只是邊學邊整理。"),
    .init(message: "那太棒了，到時候我一定第一個看。", isReply: true),
    .init(message: "好喔，到時候請你幫我校對～"),
    .init(message: "沒問題！", isReply: true)
]


