//
//  DataStatisticsAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//

import SwiftUI

struct DataStatisticsAppView: View {
    @State private var chartType: ChartType = .histogram
    @State private var sampleData: [Double] = [12, 15, 18, 22, 25, 28, 30, 32, 35, 38, 40, 42, 45, 48]
    
    var body: some View {
        VStack(spacing: 0) {
            chartTypePicker
            chartArea
            statisticsPanel
            regressionPanel
        }
    }
    
    // Grafik tipi seçici
    private var chartTypePicker: some View {
        Picker("Chart Type", selection: $chartType) {
            ForEach(ChartType.allCases, id: \.self) { type in
                Text(type.rawValue).tag(type)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        .background(Color(white: 0.1))
    }
    
    // Grafik alanı
    private var chartArea: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 20) {
                Text(chartType.rawValue)
                    .font(.title3)
                    .foregroundColor(.white)
                
                chartVisualization
            }
            .padding()
        }
        .frame(height: 300)
    }
    
    // Grafik görselleştirmesi
    private var chartVisualization: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                switch chartType {
                case .histogram:
                    drawHistogram(context: context, size: size)
                case .boxPlot:
                    drawBoxPlot(context: context, size: size)
                case .scatterPlot:
                    drawScatterPlot(context: context, size: size)
                case .barChart:
                    drawBarChart(context: context, size: size)
                }
            }
        }
    }
    
    // Histogram çizimi
    private func drawHistogram(context: GraphicsContext, size: CGSize) {
        let barWidth = size.width / CGFloat(sampleData.count)
        let maxValue = sampleData.max() ?? 1
        
        for (index, value) in sampleData.enumerated() {
            let barHeight = (value / maxValue) * size.height * 0.8
            let x = CGFloat(index) * barWidth
            let y = size.height - barHeight
            
            let rect = CGRect(x: x, y: y, width: barWidth - 2, height: barHeight)
            context.fill(Path(rect), with: .color(.red.opacity(0.7)))
            context.stroke(Path(rect), with: .color(.red), lineWidth: 1)
        }
    }
    
    // Box Plot çizimi
    private func drawBoxPlot(context: GraphicsContext, size: CGSize) {
        let sorted = sampleData.sorted()
        let min = sorted.first ?? 0
        let max = sorted.last ?? 100
        let q1 = sorted[sorted.count / 4]
        let median = sorted[sorted.count / 2]
        let q3 = sorted[3 * sorted.count / 4]
        
        let scale = size.width / (max - min)
        let centerY = size.height / 2
        let boxHeight: CGFloat = 60
        
        // Kutu
        let boxX1 = CGFloat(q1 - min) * scale
        let boxX3 = CGFloat(q3 - min) * scale
        let boxRect = CGRect(x: boxX1, y: centerY - boxHeight/2, width: boxX3 - boxX1, height: boxHeight)
        context.fill(Path(boxRect), with: .color(.blue.opacity(0.3)))
        context.stroke(Path(boxRect), with: .color(.blue), lineWidth: 2)
        
        // Median çizgisi
        let medianX = CGFloat(median - min) * scale
        context.stroke(
            Path { path in
                path.move(to: CGPoint(x: medianX, y: centerY - boxHeight/2))
                path.addLine(to: CGPoint(x: medianX, y: centerY + boxHeight/2))
            },
            with: .color(.red),
            lineWidth: 2
        )
        
        // Whiskers (bıyıklar)
        let minX = CGFloat(min - min) * scale
        let maxX = CGFloat(max - min) * scale
        
        context.stroke(
            Path { path in
                path.move(to: CGPoint(x: minX, y: centerY))
                path.addLine(to: CGPoint(x: boxX1, y: centerY))
            },
            with: .color(.blue),
            lineWidth: 2
        )
        
        context.stroke(
            Path { path in
                path.move(to: CGPoint(x: boxX3, y: centerY))
                path.addLine(to: CGPoint(x: maxX, y: centerY))
            },
            with: .color(.blue),
            lineWidth: 2
        )
    }
    
    // Scatter Plot çizimi
    private func drawScatterPlot(context: GraphicsContext, size: CGSize) {
        let maxValue = sampleData.max() ?? 1
        
        for (index, value) in sampleData.enumerated() {
            let x = (CGFloat(index) / CGFloat(sampleData.count)) * size.width
            let y = size.height - (value / maxValue) * size.height * 0.8
            
            context.fill(
                Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8)),
                with: .color(.green)
            )
        }
    }
    
    // Bar Chart çizimi
    private func drawBarChart(context: GraphicsContext, size: CGSize) {
        let barWidth = size.width / CGFloat(sampleData.count)
        let maxValue = sampleData.max() ?? 1
        
        for (index, value) in sampleData.enumerated() {
            let barHeight = (value / maxValue) * size.height * 0.8
            let x = CGFloat(index) * barWidth
            let y = size.height - barHeight
            
            let rect = CGRect(x: x, y: y, width: barWidth - 4, height: barHeight)
            context.fill(Path(rect), with: .color(.purple.opacity(0.7)))
            context.stroke(Path(rect), with: .color(.purple), lineWidth: 1)
        }
    }
    
    // İstatistik paneli
    private var statisticsPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                GroupBox {
                    VStack(alignment: .leading, spacing: 8) {
                        StatRow(label: "Count", value: String(sampleData.count))
                        StatRow(label: "Mean", value: String(format: "%.2f", calculateMean()))
                        StatRow(label: "Median", value: String(format: "%.2f", calculateMedian()))
                        StatRow(label: "Std Dev", value: String(format: "%.2f", calculateStdDev()))
                        StatRow(label: "Min", value: String(format: "%.2f", sampleData.min() ?? 0))
                        StatRow(label: "Max", value: String(format: "%.2f", sampleData.max() ?? 0))
                        StatRow(label: "Q1", value: String(format: "%.2f", calculateQuartile(0.25)))
                        StatRow(label: "Q3", value: String(format: "%.2f", calculateQuartile(0.75)))
                    }
                } label: {
                    Text("Summary Statistics")
                        .foregroundColor(.white)
                }
                .backgroundStyle(Color(white: 0.12))
                .padding(.horizontal)
                
                regressionPanel
            }
            .padding(.vertical)
        }
    }
    
    // Regresyon paneli
    private var regressionPanel: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 8) {
                regressionButton(title: "Linear Regression")
                regressionButton(title: "Quadratic Regression")
                regressionButton(title: "Exponential Regression")
                regressionButton(title: "Logarithmic Regression")
                regressionButton(title: "Power Regression")
                regressionButton(title: "Sinusoidal Regression")
            }
        } label: {
            Text("Regression Analysis")
                .foregroundColor(.white)
        }
        .backgroundStyle(Color(white: 0.12))
        .padding(.horizontal)
    }
    
    // Regresyon butonu
    private func regressionButton(title: String) -> some View {
        Button(action: {
            print("Regression: \(title)")
        }) {
            HStack {
                Image(systemName: "function")
                    .foregroundColor(.red)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // İstatistik hesaplamaları
    private func calculateMean() -> Double {
        guard !sampleData.isEmpty else { return 0 }
        return sampleData.reduce(0, +) / Double(sampleData.count)
    }
    
    private func calculateMedian() -> Double {
        let sorted = sampleData.sorted()
        let count = sorted.count
        if count % 2 == 0 {
            return (sorted[count / 2 - 1] + sorted[count / 2]) / 2
        } else {
            return sorted[count / 2]
        }
    }
    
    private func calculateStdDev() -> Double {
        let mean = calculateMean()
        let variance = sampleData.map { pow($0 - mean, 2) }.reduce(0, +) / Double(sampleData.count)
        return sqrt(variance)
    }
    
    private func calculateQuartile(_ percentile: Double) -> Double {
        let sorted = sampleData.sorted()
        let index = Int(percentile * Double(sorted.count))
        return sorted[min(index, sorted.count - 1)]
    }
}

// Grafik tipleri
enum ChartType: String, CaseIterable {
    case histogram = "Histogram"
    case boxPlot = "Box Plot"
    case scatterPlot = "Scatter Plot"
    case barChart = "Bar Chart"
}

// İstatistik satırı
struct StatRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.system(.body, design: .monospaced))
        }
    }
}

// Preview
struct DataStatisticsAppView_Previews: PreviewProvider {
    static var previews: some View {
        DataStatisticsAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
