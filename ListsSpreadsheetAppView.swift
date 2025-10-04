//
//  ListsSpreadsheetAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//


import SwiftUI

struct ListsSpreadsheetAppView: View {
    @State private var data: [[String]] = Array(repeating: Array(repeating: "", count: 10), count: 20)
    @State private var selectedCell: (Int, Int)?
    @State private var showRegression = false
    @State private var regressionResult: RegressionResult?
    
    var body: some View {
        VStack(spacing: 0) {
            formulaBar
            spreadsheetArea
            functionBar
            
            if showRegression {
                regressionPanel
            }
        }
    }
    
    // Formül çubuğu
    private var formulaBar: some View {
        HStack {
            Text(selectedCell != nil ? "Cell \(columnName(selectedCell!.1))\(selectedCell!.0 + 1):" : "Select a cell")
                .foregroundColor(.gray)
                .font(.caption)
            
            TextField("Enter value or formula", text: Binding(
                get: { selectedCell != nil ? data[selectedCell!.0][selectedCell!.1] : "" },
                set: { if let cell = selectedCell { data[cell.0][cell.1] = $0 } }
            ))
            .textFieldStyle(PlainTextFieldStyle())
            .padding(8)
            .background(Color(white: 0.15))
            .cornerRadius(5)
            .foregroundColor(.white)
        }
        .padding()
        .background(Color(white: 0.1))
    }
    
    // Spreadsheet alanı
    private var spreadsheetArea: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 0) {
                // Başlık satırı
                HStack(spacing: 0) {
                    Text("")
                        .frame(width: 40, height: 30)
                        .background(Color(white: 0.15))
                    
                    ForEach(0..<10, id: \.self) { col in
                        Text(columnName(col))
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 80, height: 30)
                            .background(Color(white: 0.15))
                            .border(Color.gray.opacity(0.3), width: 0.5)
                    }
                }
                
                // Veri satırları
                ForEach(0..<20, id: \.self) { row in
                    HStack(spacing: 0) {
                        Text("\(row + 1)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .frame(width: 40, height: 35)
                            .background(Color(white: 0.15))
                            .border(Color.gray.opacity(0.3), width: 0.5)
                        
                        ForEach(0..<10, id: \.self) { col in
                            Text(data[row][col])
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 80, height: 35)
                                .background(selectedCell?.0 == row && selectedCell?.1 == col ? Color.blue.opacity(0.3) : Color(white: 0.08))
                                .border(Color.gray.opacity(0.3), width: 0.5)
                                .onTapGesture {
                                    selectedCell = (row, col)
                                }
                        }
                    }
                }
            }
        }
    }
    
    // Fonksiyon çubuğu
    private var functionBar: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    FunctionButton("SUM") { insertFunction("sum(") }
                    FunctionButton("MEAN") { insertFunction("mean(") }
                    FunctionButton("MEDIAN") { insertFunction("median(") }
                    FunctionButton("STDEV") { insertFunction("stdev(") }
                    FunctionButton("MIN") { insertFunction("min(") }
                    FunctionButton("MAX") { insertFunction("max(") }
                }
                .padding(.horizontal)
            }
            
            // En Küçük Kareler butonu
            Button(action: {
                showRegression.toggle()
            }) {
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Linear Regression (En Küçük Kareler)")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(showRegression ? Color.green.opacity(0.6) : Color.purple.opacity(0.6))
                .cornerRadius(10)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
        .background(Color(white: 0.1))
    }
    
    // Regresyon paneli
    private var regressionPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                Text("Linear Regression (En Küçük Kareler)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                
                // Veri seçimi
                GroupBox {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Data Columns")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("X Column:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Picker("X", selection: .constant(0)) {
                                    ForEach(0..<10, id: \.self) { col in
                                        Text(columnName(col)).tag(col)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(height: 30)
                            }
                            
                            VStack(alignment: .leading) {
                                Text("Y Column:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Picker("Y", selection: .constant(1)) {
                                    ForEach(0..<10, id: \.self) { col in
                                        Text(columnName(col)).tag(col)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(height: 30)
                            }
                        }
                        
                        Button(action: calculateRegression) {
                            Text("Calculate Regression")
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                    }
                } label: {
                    Text("Data Selection")
                        .foregroundColor(.white)
                }
                .backgroundStyle(Color(white: 0.12))
                .padding(.horizontal)
                
                // Sonuçlar
                if let result = regressionResult {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            resultRow(label: "Equation", value: result.equation, highlight: true)
                            Divider().background(Color.gray.opacity(0.3))
                            resultRow(label: "Slope (m)", value: String(format: "%.6f", result.slope))
                            resultRow(label: "Intercept (b)", value: String(format: "%.6f", result.intercept))
                            resultRow(label: "R² (Coefficient of Determination)", value: String(format: "%.6f", result.rSquared))
                            resultRow(label: "r (Correlation)", value: String(format: "%.6f", result.correlation))
                            Divider().background(Color.gray.opacity(0.3))
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Interpretation:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(interpretRSquared(result.rSquared))
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    } label: {
                        Text("Regression Results")
                            .foregroundColor(.white)
                    }
                    .backgroundStyle(Color(white: 0.12))
                    .padding(.horizontal)
                }
                
                // Açıklama
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("About Linear Regression")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("Linear regression finds the best-fitting straight line through your data points using the least squares method.")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("• y = mx + b (line equation)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("• R² close to 1 = strong fit")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("• R² close to 0 = weak fit")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .backgroundStyle(Color(white: 0.12))
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .frame(maxHeight: 400)
    }
    
    // Sonuç satırı
    private func resultRow(label: String, value: String, highlight: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(.caption, design: highlight ? .monospaced : .default))
                .fontWeight(highlight ? .bold : .regular)
                .foregroundColor(highlight ? .green : .white)
        }
    }
    
    // R² yorumlama
    private func interpretRSquared(_ rSquared: Double) -> String {
        if rSquared > 0.9 {
            return "Excellent fit - The line explains \(Int(rSquared * 100))% of the variation"
        } else if rSquared > 0.7 {
            return "Good fit - The line explains \(Int(rSquared * 100))% of the variation"
        } else if rSquared > 0.5 {
            return "Moderate fit - The line explains \(Int(rSquared * 100))% of the variation"
        } else {
            return "Weak fit - The line explains only \(Int(rSquared * 100))% of the variation"
        }
    }
    
    // Regresyon hesaplama
    private func calculateRegression() {
        // Örnek veri ile hesaplama (gerçek implementasyon için sütunlardan veri çekilir)
        let xData: [Double] = [1, 2, 3, 4, 5, 6]
        let yData: [Double] = [2, 4, 5, 4, 5, 7]
        
        let n = Double(xData.count)
        let sumX = xData.reduce(0, +)
        let sumY = yData.reduce(0, +)
        let sumXY = zip(xData, yData).map(*).reduce(0, +)
        let sumX2 = xData.map { $0 * $0 }.reduce(0, +)
        let sumY2 = yData.map { $0 * $0 }.reduce(0, +)
        
        // Eğim (slope)
        let slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX)
        
        // Kesişim (intercept)
        let intercept = (sumY - slope * sumX) / n
        
        // R²
        let meanY = sumY / n
        let ssTotal = yData.map { pow($0 - meanY, 2) }.reduce(0, +)
        let ssResidual = zip(xData, yData).map { x, y in
            pow(y - (slope * x + intercept), 2)
        }.reduce(0, +)
        let rSquared = 1 - (ssResidual / ssTotal)
        
        // Korelasyon
        let numerator = n * sumXY - sumX * sumY
        let denominator = sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY))
        let correlation = numerator / denominator
        
        // Denklemi oluştur
        let equation = String(format: "y = %.4fx %@ %.4f",
                            slope,
                            intercept >= 0 ? "+" : "",
                            intercept)
        
        regressionResult = RegressionResult(
            slope: slope,
            intercept: intercept,
            rSquared: rSquared,
            correlation: correlation,
            equation: equation
        )
    }
    
    // Fonksiyon ekleme
    private func insertFunction(_ funcName: String) {
        if let cell = selectedCell {
            data[cell.0][cell.1] = funcName
        }
    }
    
    // Sütun adı
    private func columnName(_ col: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String(letters[letters.index(letters.startIndex, offsetBy: col)])
    }
}

// Fonksiyon butonu
struct FunctionButton: View {
    let title: String
    let action: () -> Void
    
    init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.purple.opacity(0.6))
                .cornerRadius(5)
        }
    }
}

// Regresyon sonuç modeli
struct RegressionResult {
    let slope: Double
    let intercept: Double
    let rSquared: Double
    let correlation: Double
    let equation: String
}

// Preview
struct ListsSpreadsheetAppView_Previews: PreviewProvider {
    static var previews: some View {
        ListsSpreadsheetAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
