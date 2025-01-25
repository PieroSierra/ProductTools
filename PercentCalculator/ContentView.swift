import SwiftUI
import AppKit

struct ContentView: View {
    @State private var percentage: String = ""
    @State private var value: String = ""
    @State private var result: String = "-"

    @State private var part: String = ""
    @State private var whole: String = ""
    @State private var percentResult: String = "-"

    @State private var initialValue: String = ""
    @State private var finalValue: String = ""
    @State private var changeResult: String = "-"
    @State private var multiplierResult: String = "-"

    @State private var textToStrip: String = ""

    var body: some View {
        ZStack {
            VStack(spacing: 20){
                Spacer().frame(height: 200)
                Text("Paste to strip text formatting")
                Spacer()
            }
            
            VStack(spacing: 20) {
                Spacer()
                // Percentage Calculation
                HStack {
                    Text("What is")
                    TextField("%", text: $percentage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Text("of")
                    TextField("Value", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            calculatePercentage()
                        }
                        .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Button("Go") {
                        calculatePercentage()
                    }
                    .frame(height: nil)
                    .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    
                    Text(result)
                        .font(.headline)
                        .padding(5.5)
                        .frame(minWidth: 85.0)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(5)
                }
                
                // What Percent Calculation
                HStack {
                    TextField("Part", text: $part)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Text("is what % of")
                    TextField("Whole", text: $whole)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            calculateWhatPercent()
                        }
                        .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Button("Go") {
                        calculateWhatPercent()
                    }
                    .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Text(percentResult)
                        .font(.headline)
                        .padding(5.5)
                        .frame(minWidth: 85.0)
                        .background(Color.green.opacity(0.3))
                        .cornerRadius(5)
                }
                
                // Percentage Change Calculation
                HStack {
                    Text("% change from")
                    TextField("Initial", text: $initialValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Text("to")
                    TextField("Final", text: $finalValue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onSubmit {
                            calculateIncreaseDecrease()
                        }
                        .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    Button("Go") {
                        calculateIncreaseDecrease()
                    }
                    .controlSize(/*@START_MENU_TOKEN@*/.extraLarge/*@END_MENU_TOKEN@*/)
                    VStack {
                        Text(changeResult)
                        Text(multiplierResult)
                    }
                    .font(.headline)
                    .padding(5.5)
                    .frame(minWidth: 85.0)
                    .background(Color.green.opacity(0.3))
                    .cornerRadius(5)
                }
                
                // Text Stripping
                TextEditor(text: $textToStrip)
                    .frame(height: 100.0)
                    .onChange(of: textToStrip) {
                        stripFormatting()
                    }
                    .opacity(0.7)
                    .font(/*@START_MENU_TOKEN@*/.body/*@END_MENU_TOKEN@*/)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.all, 2) // Add some padding to ensure the text doesn't touch the rounded edges
                    .background(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.827, green: 0.827, blue: 0.827), lineWidth: 1)
                    )
                
                HStack {
                    Spacer()
                    Text("Piero Sierra, 2024")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
                .opacity(0.5)
                Spacer()
            }
            .frame(minHeight: 300, maxHeight: 300)
            .frame(minWidth: 500, maxWidth: 500)
            .padding()
            .toolbar {
                Image("LogoSq32")
            } // END MAIN CONTENT VSTACK
         //   .background(TranslucentBackgroundView())
        } // END ZSTACK
    }

    // Function Definitions
    func calculatePercentage() {
        let percentageValue = Double(percentage) ?? 0
        let valueValue = Double(value) ?? 0
        let calculatedResult = (percentageValue / 100) * valueValue
        result = String(format: "%.2f%%", calculatedResult)
        
        // Copy the result to the clipboard
        copyToClipboard(result)
    }

    func calculateWhatPercent() {
        let partValue = Double(part) ?? 0
        let wholeValue = Double(whole) ?? 0
        let calculatedResult = (partValue / wholeValue) * 100
        percentResult = String(format: "%.2f%%", calculatedResult)
        
        // Copy the result to the clipboard
        copyToClipboard(percentResult)
    }

    func calculateIncreaseDecrease() {
        let initialValueValue = Double(initialValue) ?? 0
        let finalValueValue = Double(finalValue) ?? 0
        let calculatedChange = ((finalValueValue - initialValueValue) / initialValueValue) * 100
        let calculatedMultiplier = finalValueValue / initialValueValue
        changeResult = String(format: "%.2f%%", calculatedChange)
        multiplierResult = String(format: "%.1fx", calculatedMultiplier)
        
        // Copy the percentage change result to the clipboard
        copyToClipboard(changeResult)
    }

    func stripFormatting() {
        // Remove emojis and unwanted characters
        var strippedText = textToStrip.unicodeScalars.filter {
            !$0.properties.isEmojiPresentation
        }.map { String($0) }.joined()

        // Replace tabs with a single space
        strippedText = strippedText.replacingOccurrences(of: "\t", with: " ")

        // Remove multiple spaces
        strippedText = strippedText.replacingOccurrences(of: "[ ]{2,}", with: " ", options: .regularExpression)

        // Trim each line
        let lines = strippedText.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        strippedText = lines.filter { !$0.isEmpty }.joined(separator: "\n")

        textToStrip = strippedText
        
        // Copy the stripped text to the clipboard
        copyToClipboard(strippedText)
    }

    func copyToClipboard(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
