// ContentView.swift
// Ana görünüm - Uygulama akışını yönetir

import SwiftUI

struct ContentView: View {
    // Hangi ekranın gösterileceğini kontrol eder
    @State private var showHomeScreen = true
    @State private var selectedApp: NspireApp? = nil
    
    var body: some View {
        ZStack {
            // Arka plan
            Color(red: 0.05, green: 0.05, blue: 0.1)
                .ignoresSafeArea()
            
            if showHomeScreen {
                // Ana menü ekranı
                HomeScreenView(onAppSelect: { app in
                    selectedApp = app
                    showHomeScreen = false
                })
            } else if let app = selectedApp {
                // Seçilen uygulama
                AppContainerView(app: app, onBack: {
                    showHomeScreen = true
                    selectedApp = nil
                })
            }
        }
    }
}

// Uygulama container - Seçilen uygulamayı gösterir
struct AppContainerView: View {
    let app: NspireApp
    let onBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Üst bar
            HStack {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                Text(app.rawValue)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                HStack(spacing: 15) {
                    Image(systemName: "doc")
                    Image(systemName: "square.and.arrow.up")
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.white)
                .font(.title3)
            }
            .padding()
            .background(app.color)
            
            // Uygulama içeriği
            Group {
                switch app {
                case .calculator:
                    CalculatorAppView()
                case .graphs:
                    GraphsAppView()
                case .geometry:
                    GeometryAppView()
                case .lists:
                    ListsSpreadsheetAppView()
                case .data:
                    DataStatisticsAppView()
                case .notes:
                    NotesAppView()
                case .python:
                    PythonAppView()
                case .scratchpad:
                    ScratchpadAppView()
                }
            }
            .background(Color(white: 0.05))
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
