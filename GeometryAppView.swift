//
//  GeometryAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//


import SwiftUI

struct GeometryAppView: View {
    @State private var selectedTool: GeometryTool = .point
    @State private var shapes: [GeometryShape] = []
    @State private var showProperties = false
    @State private var selectedShape: GeometryShape?
    
    var body: some View {
        VStack(spacing: 0) {
            canvasArea
            toolBar
            propertiesPanel
        }
    }
    
    // Çizim alanı
    private var canvasArea: some View {
        ZStack {
            Color.black
            
            // Izgara
            Canvas { context, size in
                let gridSpacing: CGFloat = 30
                
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
                    with: .color(.gray.opacity(0.15)),
                    lineWidth: 0.5
                )
            }
            
            // Bilgi metni
            VStack {
                Spacer()
                Text("Geometry Construction Area")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("Tap tools below to draw")
                    .font(.caption2)
                    .foregroundColor(.gray.opacity(0.7))
                Spacer()
            }
        }
        .frame(height: 400)
    }
    
    // Araç çubuğu
    private var toolBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(GeometryTool.allCases, id: \.self) { tool in
                    toolButton(for: tool)
                }
            }
            .padding()
        }
        .background(Color(white: 0.1))
    }
    
    // Araç butonu
    private func toolButton(for tool: GeometryTool) -> some View {
        VStack(spacing: 5) {
            Image(systemName: tool.icon)
                .font(.title2)
                .foregroundColor(selectedTool == tool ? tool.color : .white)
                .frame(width: 50, height: 50)
                .background(selectedTool == tool ? tool.color.opacity(0.2) : Color(white: 0.15))
                .cornerRadius(10)
            
            Text(tool.rawValue)
                .font(.caption2)
                .foregroundColor(.white)
        }
        .onTapGesture {
            selectedTool = tool
        }
    }
    
    // Özellikler paneli
    private var propertiesPanel: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 15) {
                // Seçili araç bilgisi
                GroupBox {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: selectedTool.icon)
                                .foregroundColor(selectedTool.color)
                            Text(selectedTool.rawValue)
                                .font(.headline)
                            Spacer()
                        }
                        
                        Text(selectedTool.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                } label: {
                    Text("Selected Tool")
                        .foregroundColor(.white)
                }
                .backgroundStyle(Color(white: 0.12))
                .padding(.horizontal)
                
                // Geometri araçları
                GroupBox {
                    VStack(alignment: .leading, spacing: 10) {
                        geometryActionButton(title: "Measure Distance", icon: "ruler")
                        geometryActionButton(title: "Measure Angle", icon: "angle")
                        geometryActionButton(title: "Find Area", icon: "square")
                        geometryActionButton(title: "Find Perimeter", icon: "circle")
                        geometryActionButton(title: "Perpendicular Line", icon: "line.diagonal")
                        geometryActionButton(title: "Parallel Line", icon: "equal")
                    }
                } label: {
                    Text("Construction Tools")
                        .foregroundColor(.white)
                }
                .backgroundStyle(Color(white: 0.12))
                .padding(.horizontal)
                
                // Transformasyon araçları
                GroupBox {
                    VStack(alignment: .leading, spacing: 10) {
                        geometryActionButton(title: "Reflect", icon: "arrow.left.and.right")
                        geometryActionButton(title: "Rotate", icon: "arrow.clockwise")
                        geometryActionButton(title: "Translate", icon: "arrow.up.left.and.arrow.down.right")
                        geometryActionButton(title: "Dilate", icon: "arrow.up.left.and.down.right.and.arrow.up.right.and.down.left")
                    }
                } label: {
                    Text("Transformations")
                        .foregroundColor(.white)
                }
                .backgroundStyle(Color(white: 0.12))
                .padding(.horizontal)
                
                // Şekil özellikleri
                if selectedShape != nil {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 8) {
                            propertyRow(label: "Type", value: "Point")
                            propertyRow(label: "Color", value: "Orange")
                            propertyRow(label: "Label", value: "A")
                            propertyRow(label: "Coordinates", value: "(0, 0)")
                        }
                    } label: {
                        Text("Properties")
                            .foregroundColor(.white)
                    }
                    .backgroundStyle(Color(white: 0.12))
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
    
    // Geometri aksiyon butonu
    private func geometryActionButton(title: String, icon: String) -> some View {
        Button(action: {
            print("Action: \(title)")
        }) {
            HStack {
                Image(systemName: icon)
                    .frame(width: 25)
                    .foregroundColor(.orange)
                Text(title)
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // Özellik satırı
    private func propertyRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .foregroundColor(.gray)
                .font(.caption)
            Spacer()
            Text(value)
                .foregroundColor(.white)
                .font(.caption)
        }
    }
}

// Geometri araçları
enum GeometryTool: String, CaseIterable {
    case point = "Point"
    case line = "Line"
    case ray = "Ray"
    case segment = "Segment"
    case circle = "Circle"
    case triangle = "Triangle"
    case polygon = "Polygon"
    case angle = "Angle"
    case measure = "Measure"
    
    var icon: String {
        switch self {
        case .point: return "smallcircle.filled.circle"
        case .line: return "line.diagonal"
        case .ray: return "arrow.up.right"
        case .segment: return "minus"
        case .circle: return "circle"
        case .triangle: return "triangle"
        case .polygon: return "hexagon"
        case .angle: return "angle"
        case .measure: return "ruler"
        }
    }
    
    var color: Color {
        switch self {
        case .point: return .blue
        case .line: return .green
        case .ray: return .cyan
        case .segment: return .purple
        case .circle: return .red
        case .triangle: return .orange
        case .polygon: return .yellow
        case .angle: return .pink
        case .measure: return .white
        }
    }
    
    var description: String {
        switch self {
        case .point: return "Create a point on the canvas"
        case .line: return "Draw an infinite line through two points"
        case .ray: return "Draw a ray starting from one point"
        case .segment: return "Draw a line segment between two points"
        case .circle: return "Create a circle with center and radius"
        case .triangle: return "Construct a triangle with three points"
        case .polygon: return "Draw a polygon with multiple points"
        case .angle: return "Measure or create an angle"
        case .measure: return "Measure distances and properties"
        }
    }
}

// Geometri şekli modeli
struct GeometryShape: Identifiable {
    let id = UUID()
    var type: GeometryTool
    var points: [CGPoint]
    var color: Color
    var label: String?
}

// Preview
struct GeometryAppView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
