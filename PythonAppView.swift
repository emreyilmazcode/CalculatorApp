//
//  PythonAppView.swift
//  CL
//
//  Created by Emre Yılmaz on 4.10.2025.
//


import SwiftUI

struct PythonAppView: View {
    @State private var code = "# Python Programming\nprint('Hello from CL!')\n\n# Try some math\nimport math\nprint(f'π = {math.pi}')\nprint(f'e = {math.e}')\n\n"
    @State private var output = ""
    @State private var isRunning = false
    
    var body: some View {
        VStack(spacing: 0) {
            editorArea
            Divider().background(Color.gray)
            outputArea
            quickFunctions
        }
    }
    
    // Editör alanı
    private var editorArea: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Editor")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Button(action: runCode) {
                    HStack(spacing: 5) {
                        if isRunning {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.7)
                        } else {
                            Image(systemName: "play.fill")
                        }
                        Text(isRunning ? "Running..." : "Run")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(isRunning ? Color.orange : Color.green)
                    .cornerRadius(8)
                }
                .disabled(isRunning)
                
                Button(action: clearCode) {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.6))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            TextEditor(text: $code)
                .font(.system(.body, design: .monospaced))
                .foregroundColor(.white)
                .padding()
                .scrollContentBackground(.hidden)
                .background(Color(white: 0.08))
        }
        .frame(height: 300)
    }
    
    // Çıktı alanı
    private var outputArea: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text("Output / Shell")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                if !output.isEmpty {
                    Button(action: { output = "" }) {
                        Text("Clear")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal)
            
            ScrollView {
                Text(output.isEmpty ? "Ready. Click 'Run' to execute your code." : output)
                    .font(.system(.caption, design: .monospaced))
                    .foregroundColor(output.isEmpty ? .gray : .green)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            .background(Color.black)
        }
        .frame(maxHeight: .infinity)
    }
    
    // Hızlı fonksiyonlar
    private var quickFunctions: some View {
        VStack(spacing: 10) {
            Text("Quick Insert")
                .font(.caption)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    quickButton("import math") {
                        code += "import math\n"
                    }
                    quickButton("import random") {
                        code += "import random\n"
                    }
                    quickButton("for i in range():") {
                        code += "for i in range():\n    "
                    }
                    quickButton("if __name__ == '__main__':") {
                        code += "if __name__ == '__main__':\n    "
                    }
                    quickButton("def function():") {
                        code += "def function():\n    "
                    }
                    quickButton("class MyClass:") {
                        code += "class MyClass:\n    "
                    }
                    quickButton("try: / except:") {
                        code += "try:\n    \nexcept Exception as e:\n    "
                    }
                    quickButton("print()") {
                        code += "print()\n"
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 10)
        .background(Color(white: 0.1))
    }
    
    // Hızlı buton
    private func quickButton(_ text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.6))
                .cornerRadius(5)
        }
    }
    
    // Kodu çalıştır
    private func runCode() {
        isRunning = true
        output = ">>> Executing Python code...\n"
        
        // Simüle edilmiş gecikme
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Python kodu simülasyonu
            if code.contains("print('Hello from CL!')") {
                output += "Hello from CL!\n"
            }
            
            if code.contains("import math") {
                output += "π = 3.141592653589793\n"
                output += "e = 2.718281828459045\n"
            }
            
            if code.contains("random") {
                let randomNum = Int.random(in: 1...100)
                output += "Random number: \(randomNum)\n"
            }
            
            // Örnek hesaplamalar
            if code.contains("2 + 2") || code.contains("sum") {
                output += "4\n"
            }
            
            output += "\n>>> Execution completed successfully.\n"
            output += ">>> Python \(pythonVersion())\n"
            
            isRunning = false
        }
    }
    
    // Kodu temizle
    private func clearCode() {
        code = "# Python Programming\n\n"
        output = ""
    }
    
    // Python versiyonu
    private func pythonVersion() -> String {
        return "3.9.5"
    }
}

// Örnek kod şablonları
extension PythonAppView {
    static let exampleCodes = [
        """
        # Hello World
        print('Hello, World!')
        """,
        """
        # Simple Calculator
        def add(a, b):
            return a + b
        
        result = add(5, 3)
        print(f'5 + 3 = {result}')
        """,
        """
        # List Comprehension
        squares = [x**2 for x in range(10)]
        print(squares)
        """,
        """
        # Math Operations
        import math
        
        angle = 45
        radians = math.radians(angle)
        print(f'sin({angle}°) = {math.sin(radians):.4f}')
        print(f'cos({angle}°) = {math.cos(radians):.4f}')
        """,
        """
        # Statistics
        data = [12, 15, 18, 22, 25, 28, 30]
        mean = sum(data) / len(data)
        print(f'Mean: {mean:.2f}')
        """
    ]
}

// Preview
struct PythonAppView_Previews: PreviewProvider {
    static var previews: some View {
        PythonAppView()
            .background(Color(red: 0.05, green: 0.05, blue: 0.1))
    }
}
