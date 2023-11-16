//
//  SlidingSelectorView.swift
//  Weather
//
//  Created by jonathan saville on 25/10/2023.
//

import SwiftUI

struct SlidingSelectorView: View {
    @Binding var selectedIndex: Int
    let titles: [String]

    @State private var offset: CGFloat = 0
    
    var body: some View {
        let font = UIFont.defaultFont
        let padding: CGFloat = 8
        let cornerRadius: CGFloat = 8
        let animationDuration = 0.15
        let selectorFractionalWidth = 1 / CGFloat(titles.count)
        
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Color(UIColor.backgroundSecondary()))
            
                .overlay {
                    HStack(spacing: 0) {
                        // Having a full-width HStack for the overlay means I can default the offset to 0 without knowing
                        // the rendered width (if I just use a RoundeRectangle without an HStack, the overlay would
                        // initially be rendered centrally).
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .fill(Color(UIColor.button(for: .highlighted)))
                            .frame(width: geometry.size.width * selectorFractionalWidth)
                        ForEach(0..<titles.count-1, id: \.self) { i in
                            Rectangle()
                                .fill(.clear)
                                .frame(width: geometry.size.width * selectorFractionalWidth)
                        }
                    }
                    .offset(x: offset, y: 0)
                }

                .overlay {
                    HStack(spacing: 0) {
                        ForEach(0..<titles.count, id: \.self) { i in
                            Button {
                                selectedIndex = i
                                withAnimation(.linear(duration: animationDuration)) { self.offset = i == 0 ? 0 : geometry.size.width * CGFloat(i) * selectorFractionalWidth }
                            } label: {
                                Text(titles[safe: i] ?? "-")
                                    .buttonStyle(font: Font(font), isSelected: selectedIndex == i, width: geometry.size.width * selectorFractionalWidth)
                            }
                       }
                    }
                }
        }
        .frame(height: font.lineHeight + (padding * 2))
    }
}

private extension View {
    func buttonStyle(font: Font, isSelected: Bool, width: CGFloat) -> some View {
        self.font(font)
            .foregroundColor(isSelected ? Color(.backgroundPrimary()) : Color(.defaultText()))
            .frame(width: width)
    }
}

struct SlidingSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        OneStatePreviewWrapper(0) { SlidingSelectorView(selectedIndex: $0,
                                                        titles: ["A", "B", "C"]) }
            .preferredColorScheme(.dark)
    }
}
