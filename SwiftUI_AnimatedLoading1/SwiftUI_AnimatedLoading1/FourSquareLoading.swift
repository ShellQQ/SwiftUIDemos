//
//  FourSquareLoading.swift
//  SwiftUI_AnimatedLoading1
//
//  Created by Janice on 2025/10/26.
//

import SwiftUI

struct FourSquareLoading: View {
    // 控制方塊是否變成圓形
    @State private var isCircle = false
    // 用來決定目前動畫的「位移起點」，讓四個方塊循環移動位置
    @State private var positionIndex = 0
    
    // 方塊（或圓形）的寬高
    let size: CGFloat = 100
    // 4 個相對位置（下、右、上、左），用於控制每個方塊的偏移
    let position:[(x: CGFloat, y: CGFloat)] = [(x: 0, y: 1),
                                               (x: 1, y: 0),
                                               (x: 0, y: -1),
                                               (x: -1, y: 0)]
    // 每個方塊的顏色交替（橘黃、淡黃）
    let colors: [Color] = [Color(r:240, g: 148, b: 78),
                           Color(r: 243, g: 226, b:107),
                           Color(r:240, g: 148, b: 78),
                           Color(r: 243, g: 226, b:107)]

    var body: some View {
        
        ZStack {
            ForEach(0..<4, id: \.self) { i in
                RoundedRectangle(cornerRadius: isCircle ? size / 2 : 0, style: .continuous)
                    .fill(colors[i])
                    .frame(width: size, height: size)
                    .rotationEffect(.degrees(45))
                    .offset(
                        x: position[(positionIndex + i) % 4].x * size, 
                        y: position[(positionIndex + i) % 4].y * size
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                // 方塊位置依序循環（0→1→2→3→0），形成旋轉感
                withAnimation(Animation.easeInOut(duration: 1)) {
                    positionIndex = (positionIndex + 1) % 4
                }
                // 方塊在「方形 ↔ 圓形」之間反覆切換
                withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    isCircle.toggle()
                }
            }

        }
    }
}

#Preview {
    FourSquareLoading()
}
