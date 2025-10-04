//
//  CalculatorAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//

import SwiftUI

struct CalculatorAppView: View {
    @State private var display = ""
    @State private var history: [String] = []
    @State private var isCASMode = true
    @State private var isDegreeMode = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Ekran - Geçmiş ve mevcut hesaplama
            ScrollView {
                VStack(alignment: .trailing, spacing: 10) {
                    // Geçmiş hesaplamalar
                    ForEach(history, id: \.self) { item in
                        Text(item)
                            .font(.system(size: 16, design: .monospaced))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    
                    // Mevcut girdi
                    if !display.isEmpty {
                        Text(display)
                            .font(.system(size: 28, design: .monospaced))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    } else {
                        Text("_")
                            .font(.system(size: 28, design: .monospaced))
                            .foregroundColor(.white.opacity(0.3))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                .padding()
            }
            .frame(height: 200)
            .background(Color(white: 0.1))
            
            // Mod geçişleri
            HStack {
                Toggle("CAS", isOn: $isCASMode)
                    .toggleStyle(SwitchToggleStyle(tint: Color(red: 0.2, green: 0.6, blue: 1.0)))
                    .foregroundColor(.white)
                    .font(.caption)
                
                Spacer()
                
                Toggle(isDegreeMode ? "DEG" : "RAD", isOn: $isDegreeMode)
                    .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                    .foregroundColor(.white)
                    .font(.caption)
            }
            .padding()
            .background(Color(white: 0.08))
            
            Divider().background(Color.gray.opacity(0.3))
            
            // Tuş takımı
            ScrollView {
                VStack(spacing: 12) {
                    // CAS Fonksiyonları (sadece CAS modunda)
                    if isCASMode {
                        GroupBox {
                            VStack(spacing: 8) {
                                HStack(spacing: 8) {
                                    CalcButton("factor", color: .purple) {
                                        display += "factor("
                                    }
                                    CalcButton("expand", color: .purple) {
                                        display += "expand("
                                    }
                                    CalcButton("solve", color: .purple) {
                                        display += "solve("
                                    }
                                }
                                HStack(spacing: 8) {
                                    CalcButton("∫", color: .purple) {
                                        display += "∫("
                                    }
                                    CalcButton("d/dx", color: .purple) {
                                        display += "d/dx("
                                    }
                                    CalcButton("lim", color: .purple) {
                                        display += "limit("
                                    }
                                }
                            }
                        } label: {
                            Text("CAS Functions")
                                .foregroundColor(.white)
                                .font(.caption)
                        }
                        .backgroundStyle(Color(white: 0.12))
                    }
                    
                    // Bilimsel Fonksiyonlar
                    GroupBox {
                        VStack(spacing: 8) {
                            HStack(spacing: 8) {
                                CalcButton("sin", color: .blue) {
                                    display += "sin("
                                }
                                CalcButton("cos", color: .blue) {
                                    display += "cos("
                                }
                                CalcButton("tan", color: .blue) {
                                    display += "tan("
                                }
                                CalcButton("ln", color: .blue) {
                                    display += "ln("
                                }
                            }
                            HStack(spacing: 8) {
                                CalcButton("√", color: .blue) {
                                    display += "√("
                                }
                                CalcButton("x²", color: .blue) {
                                    display += "²"
                                }
                                CalcButton("xʸ", color: .blue) {
                                    display += "^"
                                }
                                CalcButton("π", color: .blue) {
                                    display += "π"
                                }
                            }
                        }
                    } label: {
                        Text("Math Functions")
                            .foregroundColor(.white)
                            .font(.caption)
                    }
                    .backgroundStyle(Color(white: 0.12))
                    
                    // Sayılar ve İşlemler
                    VStack(spacing: 8) {
                        HStack(spacing: 8) {
                            CalcButton("7") { display += "7" }
                            CalcButton("8") { display += "8" }
                            CalcButton("9") { display += "9" }
                            CalcButton("÷", color: .orange) { display += "÷" }
                            CalcButton("AC", color: .red) {
                                display = ""
                                history.removeAll()
                            }
                        }
                        
                        HStack(spacing: 8) {
                            CalcButton("4") { display += "4" }
                            CalcButton("5") { display += "5" }
                            CalcButton("6") { display += "6" }
                            CalcButton("×", color: .orange) { display += "×" }
                            CalcButton("⌫", color: .red) {
                                if !display.isEmpty {
                                    display.removeLast()
                                }
                            }
                        }
                        
                        HStack(spacing: 8) {
                            CalcButton("1") { display += "1" }
                            CalcButton("2") { display += "2" }
                            CalcButton("3") { display += "3" }
                            CalcButton("−", color: .orange) { display += "−" }
                            CalcButton("(") { display += "(" }
                        }
                        
                        HStack(spacing: 8) {
                            CalcButton("0") { display += "0" }
                            CalcButton(".") { display += "." }
                            CalcButton("x") { display += "x" }
                            CalcButton("+", color: .orange) { display += "+" }
                            CalcButton(")") { display += ")" }
                        }
                        
                        // Enter butonu
                        CalcButton("enter", color: .green) {
                            if !display.isEmpty {
                                history.append(display)
                                let result = evaluateExpression(display)
                                history.append("= " + result)
                                display = ""
                            }
                        }
                        .frame(height: 50)
                    }
                }
                .padding()
            }
        }
    }
    
    // Hesaplama fonksiyonu (basitleştirilmiş)
    func evaluateExpression(_ expr: String) -> String {
        if isCASMode {
            return "[Symbolic result]"
        }
        
        // Basit sayısal hesaplama
        var expression = expr
        expression = expression.replacingOccurrences(of: "×", with: "*")
        expression = expression.replacingOccurrences(of: "÷", with: "/")
        expression = expression.replacingOccurrences(of: "−", with: "-")
        expression = expression.replacingOccurrences(of: "π", with: String(Double.pi))
        
        // NSExpression kullanarak hesapla
        let exp = NSExpression(format: expression)
        if let result = exp.expressionValue(with: nil, context: nil) as? Double {
            return String(format: "%.6g", result)
        }
        
        return "Error"
    }
}

// Hesap makinesi butonu
struct CalcButton: View {
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
                .font(.system(size: title == "enter" ? 18 : 20, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 45)
                .background(color)
                .cornerRadius(10)
        }
    }
}

// Preview
struct CalculatorAppView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
