//
//  StatefulPreviewWrapper.swift
//  Weather
//
//  Created by jonathan saville on 26/10/2023.
//

import Foundation
import SwiftUI

struct OneStatePreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

struct TwoStatesPreviewWrapper<Value1, Value2, Content: View>: View {
    @State var value1: Value1
    @State var value2: Value2
    var content: (Binding<Value1>, Binding<Value2>) -> Content

    var body: some View {
        content($value1, $value2)
    }

    init(_ value1: Value1, _ value2: Value2, content: @escaping (Binding<Value1>, Binding<Value2>) -> Content) {
        self._value1 = State(wrappedValue: value1)
        self._value2 = State(wrappedValue: value2)
        self.content = content
    }
}
