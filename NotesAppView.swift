// NotesAppView.swift
// Not alma ve belgeleme uygulaması

import SwiftUI

struct NotesAppView: View {
    @State private var noteText = ""
    @State private var isBold = false
    @State private var isItalic = false
    @State private var isUnderline = false
    @State private var showMathKeyboard = false
    
    var body: some View {
        VStack(spacing: 0) {
            toolbar
            textEditor
        }
    }
    
    // Araç çubuğu
    private var toolbar: some View {
        VStack(spacing: 10) {
            // Metin biçimlendirme
            HStack(spacing: 15) {
                toolButton(icon: "textformat.size", isActive: false) {
                    print("Font size")
                }
                
                toolButton(icon: "bold", isActive: isBold) {
                    isBold.toggle()
                }
                
                toolButton(icon: "italic", isActive: isItalic) {
                    isItalic.toggle()
                }
                
                toolButton(icon: "underline", isActive: isUnderline) {
                    isUnderline.toggle()
                }
                
                Spacer()
                
                toolButton(icon: "list.bullet") {
                    noteText += "\n• "
                }
                
                toolButton(icon: "list.number") {
                    noteText += "\n1. "
                }
                
                toolButton(icon: "function", isActive: showMathKeyboard) {
                    showMathKeyboard.toggle()
                }
                
                toolButton(icon: "photo") {
                    print("Insert image")
                }
            }
            .padding(.horizontal)
            
            // Matematik klavyesi
            if showMathKeyboard {
                mathKeyboard
            }
        }
        .padding(.vertical)
        .background(Color(white: 0.1))
    }
    
    // Matematik klavyesi
    private var mathKeyboard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                mathButton("∫") { noteText += "∫" }
                mathButton("∑") { noteText += "∑" }
                mathButton("√") { noteText += "√" }
                mathButton("π") { noteText += "π" }
                mathButton("α") { noteText += "α" }
                mathButton("β") { noteText += "β" }
                mathButton("γ") { noteText += "γ" }
                mathButton("θ") { noteText += "θ" }
                mathButton("∞") { noteText += "∞" }
                mathButton("≈") { noteText += "≈" }
                mathButton("≠") { noteText += "≠" }
                mathButton("≤") { noteText += "≤" }
                mathButton("≥") { noteText += "≥" }
                mathButton("∂") { noteText += "∂" }
                mathButton("Δ") { noteText += "Δ" }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
        .background(Color(white: 0.08))
    }
    
    // Araç butonu
    private func toolButton(icon: String, isActive: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isActive ? .blue : .white)
                .frame(width: 40, height: 40)
                .background(isActive ? Color.blue.opacity(0.2) : Color.clear)
                .cornerRadius(8)
        }
    }
    
    // Matematik butonu
    private func mathButton(_ symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(symbol)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(8)
        }
    }
    
    // Metin editörü
    private var textEditor: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $noteText)
                .font(.body)
                .foregroundColor(.white)
                .padding()
                .scrollContentBackground(.hidden)
            
            if noteText.isEmpty {
                Text("Start typing your notes here...\n\nYou can:\n• Format text with bold, italic, underline\n• Insert mathematical symbols\n• Create lists\n• Add images")
                    .font(.body)
                    .foregroundColor(.gray)
                    .padding()
                    .padding(.top, 8)
                    .allowsHitTesting(false)
            }
        }
        .background(Color(white: 0.05))
    }
}

// Preview
struct NotesAppView_Previews: PreviewProvider {
    static var previews: some View {
        NotesAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
