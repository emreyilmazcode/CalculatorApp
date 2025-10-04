//
//  NspireApp.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//
// NspireApp.swift
// Uygulama türlerini ve özelliklerini tanımlar

import SwiftUI

// 8 farklı uygulama türü
enum NspireApp: String, CaseIterable, Identifiable {
    case calculator = "Calculator"
    case graphs = "Graphs"
    case geometry = "Geometry"
    case lists = "Lists & Spreadsheet"
    case data = "Data & Statistics"
    case notes = "Notes"
    case python = "Python"
    case scratchpad = "Scratchpad"
    
    // Her uygulama için benzersiz ID
    var id: String { self.rawValue }
    
    // Her uygulama için simge
    var icon: String {
        switch self {
        case .calculator: return "function"
        case .graphs: return "chart.line.uptrend.xyaxis"
        case .geometry: return "triangle"
        case .lists: return "tablecells"
        case .data: return "chart.bar.fill"
        case .notes: return "note.text"
        case .python: return "chevron.left.forwardslash.chevron.right"
        case .scratchpad: return "square.and.pencil"
        }
    }
    
    // Her uygulama için renk
    var color: Color {
        switch self {
        case .calculator: return Color(red: 0.2, green: 0.6, blue: 1.0)
        case .graphs: return Color(red: 0.3, green: 0.8, blue: 0.4)
        case .geometry: return Color(red: 1.0, green: 0.6, blue: 0.2)
        case .lists: return Color(red: 0.8, green: 0.4, blue: 0.9)
        case .data: return Color(red: 1.0, green: 0.4, blue: 0.4)
        case .notes: return Color(red: 1.0, green: 0.8, blue: 0.2)
        case .python: return Color(red: 0.4, green: 0.6, blue: 0.9)
        case .scratchpad: return Color(red: 0.5, green: 0.7, blue: 0.3)
        }
    }
    
    // Her uygulama için açıklama
    var description: String {
        switch self {
        case .calculator: return "Bilimsel ve cebirsel hesaplamalar"
        case .graphs: return "2D ve 3D grafik çizimi"
        case .geometry: return "Geometrik şekiller ve yapılar"
        case .lists: return "Veri tabloları ve hesaplamalar"
        case .data: return "İstatistik ve veri analizi"
        case .notes: return "Not alma ve belgeleme"
        case .python: return "Python programlama"
        case .scratchpad: return "Hızlı hesaplamalar"
        }
    }
}
