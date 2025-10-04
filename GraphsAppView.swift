//
//  GraphsAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//

// GraphsAppView.swift
// 2D ve 3D grafik çizim uygulaması
// GraphsAppView.swift
// 2D ve 3D grafik çizim uygulaması

import SwiftUI

struct GraphsAppView: View {
    @State private var functions: [GraphFunction] = [
        GraphFunction(expression: "sin(x)", color: .blue),
        GraphFunction(expression: "x²", color: .red)
    ]
    @State private var newFunction = ""
    @State private var show3D = false
    @State private var animate = false
    @State private var showAnalysis = false
    
    var body: some View {
        VStack(spacing: 0) {
            graphArea
            controlBar
            functionList
        }
    }
    
    // Grafik alanı
    private var graphArea: some View {
        ZStack {
            Color.black
            GraphGridView()
            statusOverlay
        }
        .frame(height: 300)
    }
    
    // Durum overlay
    private var statusOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 5) {
                    Text(show3D ? "3D Mode" : "2D Mode")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(5)
                    
                    if animate {
                        Text("Animating...")
                            .font(.caption)
                            .foregroundColor(.green)
                            .padding(6)
                            .background(Color.black.opacity(0.7))
                            .cornerRadius(5)
                    }
                }
                .padding()
            }
        }
    }
    
    // Kontrol çubuğu
    private var controlBar: some View {
        HStack(spacing: 15) {
            Toggle("3D", isOn: $show3D)
                .toggleStyle(SwitchToggleStyle(tint: .green))
            
            Toggle("Animate", isOn: $animate)
                .toggleStyle(SwitchToggleStyle(tint: .blue))
            
            Spacer()
            
            Button(action: { showAnalysis.toggle() }) {
                Label("Analysis", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(showAnalysis ? Color.purple : Color(white: 0.2))
                    .cornerRadius(8)
            }
        }
        .foregroundColor(.white)
        .padding()
        .background(Color(white: 0.1))
    }
    
    // Fonksiyon listesi
    private var functionList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Functions")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                ForEach(Array(functions.enumerated()), id: \.offset) { index, functionItem in
                    functionRow(index: index, function: functionItem)
                }
                
                addFunctionField
                
                if showAnalysis {
                    analysisTools
                }
                
                quickTemplates
            }
            .padding(.vertical)
        }
    }
    
    // Fonksiyon satırı
    private func functionRow(index: Int, function: GraphFunction) -> some View {
        HStack {
            Circle()
                .fill(function.color)
                .frame(width: 12, height: 12)
            
            Text("f\(index + 1)(x) = \(function.expression)")
                .font(.system(size: 16, design: .monospaced))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                functions[index].isVisible.toggle()
            }) {
                Image(systemName: function.isVisible ? "eye.fill" : "eye.slash.fill")
                    .foregroundColor(function.isVisible ? .blue : .gray)
            }
            
            Button(action: {
                functions.remove(at: index)
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(white: 0.12))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // Yeni fonksiyon ekleme alanı
    private var addFunctionField: some View {
        HStack {
            TextField("Enter function (e.g., x², sin(x))", text: $newFunction)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(Color(white: 0.15))
                .cornerRadius(8)
                .foregroundColor(.white)
            
            Button(action: addFunction) {
                Image(systemName: "plus.circle.fill")
                    .font(.title2)
                    .foregroundColor(.green)
            }
        }
        .padding(.horizontal)
    }
    
    // Analiz araçları
    private var analysisTools: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 10) {
                analysisButton(title: "Find Zero", icon: "target")
                analysisButton(title: "Find Minimum", icon: "arrow.down.to.line")
                analysisButton(title: "Find Maximum", icon: "arrow.up.to.line")
                analysisButton(title: "Find Intersection", icon: "arrow.triangle.merge")
                analysisButton(title: "Calculate Integral", icon: "function")
                analysisButton(title: "Calculate Derivative", icon: "f.cursive")
            }
        } label: {
            Text("Graph Analysis Tools")
                .foregroundColor(.white)
        }
        .backgroundStyle(Color(white: 0.12))
        .padding(.horizontal)
    }
    
    // Analiz butonu
    private func analysisButton(title: String, icon: String) -> some View {
        Button(action: {
            print("Analysis: \(title)")
        }) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 20)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .foregroundColor(.blue)
        }
    }
    
    // Hızlı şablonlar
    private var quickTemplates: some View {
        GroupBox {
            VStack(spacing: 8) {
                Text("Quick Templates")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        templateButton(text: "sin(x)")
                        templateButton(text: "cos(x)")
                        templateButton(text: "x²")
                        templateButton(text: "x³")
                        templateButton(text: "√x")
                        templateButton(text: "1/x")
                        templateButton(text: "e^x")
                        templateButton(text: "ln(x)")
                    }
                }
            }
        }
        .backgroundStyle(Color(white: 0.12))
        .padding(.horizontal)
    }
    
    // Şablon butonu
    private func templateButton(text: String) -> some View {
        Button(action: {
            newFunction = text
        }) {
            Text(text)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(8)
        }
    }
    
    // Fonksiyon ekleme fonksiyonu
    private func addFunction() {
        if !newFunction.isEmpty {
            let colors: [Color] = [.blue, .red, .green, .yellow, .purple, .orange, .pink, .cyan]
            let newColor = colors[functions.count % colors.count]
            functions.append(GraphFunction(expression: newFunction, color: newColor))
            newFunction = ""
        }
    }
}

// Grafik fonksiyon modeli
struct GraphFunction: Identifiable {
    let id = UUID()
    var expression: String
    var color: Color
    var isVisible = true
}

// Grid görünümü
struct GraphGridView: View {
    var body: some View {
        Canvas { context, size in
            let midX = size.width / 2
            let midY = size.height / 2
            let gridSpacing: CGFloat = 40
            
            // Grid çizgileri
            context.stroke(
                Path { path in
                    for i in stride(from: 0, to: size.width, by: gridSpacing) {
                        path.move(to: CGPoint(x: i, y: 0))
                        path.addLine(to: CGPoint(x: i, y: size.height))
                    }
                    for i in stride(from: 0, to: size.height, by: gridSpacing) {
                        path.move(to: CGPoint(x: 0, y: i))
                        path.addLine(to: CGPoint(x: size.width, y: i))
                    }
                },
                with: .color(.gray.opacity(0.2)),
                lineWidth: 0.5
            )
            
            // Ana eksenler
            context.stroke(
                Path { path in
                    path.move(to: CGPoint(x: 0, y: midY))
                    path.addLine(to: CGPoint(x: size.width, y: midY))
                    path.move(to: CGPoint(x: midX, y: 0))
                    path.addLine(to: CGPoint(x: midX, y: size.height))
                },
                with: .color(.white),
                lineWidth: 1.5
            )
            
            // Ok başları
            context.fill(
                Path { path in
                    path.move(to: CGPoint(x: size.width - 5, y: midY))
                    path.addLine(to: CGPoint(x: size.width - 15, y: midY - 5))
                    path.addLine(to: CGPoint(x: size.width - 15, y: midY + 5))
                    path.closeSubpath()
                },
                with: .color(.white)
            )
            
            context.fill(
                Path { path in
                    path.move(to: CGPoint(x: midX, y: 5))
                    path.addLine(to: CGPoint(x: midX - 5, y: 15))
                    path.addLine(to: CGPoint(x: midX + 5, y: 15))
                    path.closeSubpath()
                },
                with: .color(.white)
            )
        }
    }
}

// Preview
struct GraphsAppView_Previews: PreviewProvider {
    static var previews: some View {
        GraphsAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
