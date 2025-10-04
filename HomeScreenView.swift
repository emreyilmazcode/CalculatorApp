//
//  HomeScreenView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//
// HomeScreenView.swift
// Ana menü ekranı - Tüm uygulamaları gösterir

import SwiftUI

struct HomeScreenView: View {
    // Bir uygulama seçildiğinde çalışacak fonksiyon
    let onAppSelect: (NspireApp) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Üst Bar
            HStack {
                Text("CL")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Batarya göstergesi
                HStack(spacing: 5) {
                    Image(systemName: "battery.100")
                        .foregroundColor(.green)
                    Text("100%")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color(white: 0.1))
            
            // Ana içerik
            ScrollView {
                VStack(spacing: 20) {
                    // Başlık
                    Text("My Documents")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Uygulama grid'i (3 sütun)
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        ForEach(NspireApp.allCases) { app in
                            AppIconView(app: app)
                                .onTapGesture {
                                    // Uygulamaya tıklandığında
                                    onAppSelect(app)
                                }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Scratchpad hızlı erişim butonu
                    Button(action: {
                        onAppSelect(.scratchpad)
                    }) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .font(.title3)
                            Text("Scratchpad - Hızlı hesaplamalar")
                                .font(.subheadline)
                        }
                        .foregroundColor(.blue)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(white: 0.15))
                        .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                }
            }
        }
    }
}

// Uygulama ikonu gösterimi
struct AppIconView: View {
    let app: NspireApp
    
    var body: some View {
        VStack(spacing: 10) {
            // İkon kutusu
            ZStack {
                // Arka plan
                RoundedRectangle(cornerRadius: 20)
                    .fill(app.color.opacity(0.2))
                    .frame(width: 80, height: 80)
                
                // Çerçeve
                RoundedRectangle(cornerRadius: 20)
                    .stroke(app.color, lineWidth: 2)
                    .frame(width: 80, height: 80)
                
                // Simge
                Image(systemName: app.icon)
                    .font(.system(size: 36))
                    .foregroundColor(app.color)
            }
            
            // Uygulama adı
            Text(app.rawValue)
                .font(.caption)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(height: 35)
        }
    }
}

// Preview
struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(onAppSelect: { _ in })
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
