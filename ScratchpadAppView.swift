//
//  ScratchpadAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//

import SwiftUI

struct ScratchpadAppView: View {
    @State private var expression = ""
    @State private var result = ""
    @State private var history: [(String, String)] = []
    
    var body: some View {
        VStack(spacing: 0) {
            quickCalculationArea
            historyArea
            keypad
        }
    }
    
    // Hızlı hesaplama alanı
    private var quickCalculationArea: some View {
        VStack(spacing: 15) {
            Text("Quick Calculate")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // İfade girişi
            HStack {
                TextField("Enter expression", text: $expression)
                    .font(.system(size: 24, design: .monospaced))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color(white: 0.12))
                    .cornerRadius(10)
                    .onSubmit {
                        calculateResult()
                    }
                
                Button(action: calculateResult) {
                    Image(systemName: "equal.circle.fill")
                        .font(.title)
                        .foregroundColor(.green)
                }
            }
            
            // Sonuç
            if !result.isEmpty {
                HStack {
                    Spacer()
                    Text(result)
                        .font(.system(size: 32, weight: .semibold, design: .monospaced))
                        .foregroundColor(.green)
                }
            }
        }
        .padding()
        .background(Color(white: 0.08))
    }
    
    // Geçmiş alanı
    private var historyArea: some View {
        ScrollView {
            VStack(spacing: 10) {
                if history.isEmpty {
                    Text("No history yet")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ForEach(Array(history.reversed().enumerated()), id: \.offset) { _, item in
                        VStack(alignment: .trailing, spacing: 5) {
                            Text(item.0)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text(item.1)
                                .font(.system(.body, design: .monospaced))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Color(white: 0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
    
    // Tuş takımı
    private var keypad: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 10) {
            KeypadButton("7") { expression += "7" }
            KeypadButton("8") { expression += "8" }
            KeypadButton("9") { expression += "9" }
            KeypadButton("÷", color: .orange) { expression += "÷" }
            
            KeypadButton("4") { expression += "4" }
            KeypadButton("5") { expression += "5" }
            KeypadButton("6") { expression += "6" }
            KeypadButton("×", color: .orange) { expression += "×" }
            
            KeypadButton("1") { expression += "1" }
            KeypadButton("2") { expression += "2" }
            KeypadButton("3") { expression += "3" }
            KeypadButton("−", color: .orange) { expression += "−" }
            
            KeypadButton("0") { expression += "0" }
            KeypadButton(".") { expression += "." }
            KeypadButton("C", color: .red) { clearAll() }
            KeypadButton("+", color: .orange) { expression += "+" }
            
            KeypadButton("(") { expression += "(" }
            KeypadButton(")") { expression += ")" }
            KeypadButton("⌫", color: .red) { deleteLast() }
            KeypadButton("=", color: .green) { calculateResult() }
        }
        .padding()
    }
    
    // Hesaplama
    private func calculateResult() {
        guard !expression.isEmpty else { return }
        
        var calcExpression = expression
        calcExpression = calcExpression.replacingOccurrences(of: "×", with: "*")
        calcExpression = calcExpression.replacingOccurrences(of: "÷", with: "/")
        calcExpression = calcExpression.replacingOccurrences(of: "−", with: "-")
        
        let exp = NSExpression(format: calcExpression)
        if let value = exp.expressionValue(with: nil, context: nil) as? Double {
            result = "= " + String(format: "%.6g", value)
            history.append((expression, result))
            expression = ""
        } else {
            result = "= Error"
        }
    }
    
    // Hepsini temizle
    private func clearAll() {
        expression = ""
        result = ""
    }
    
    // Son karakteri sil
    private func deleteLast() {
        if !expression.isEmpty {
            expression.removeLast()
        }
    }
}

// Tuş takımı butonu
struct KeypadButton: View {
    let title: String
    var color: Color = Color(white: 0.2)
    let action: () -> Void
    
    init(_ title: String, color: Color = Color(white: 0.2), action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(color)
                .cornerRadius(10)
        }
    }
}

// Preview
struct ScratchpadAppView_Previews: PreviewProvider {
    static var previews: some View {
        ScratchpadAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
