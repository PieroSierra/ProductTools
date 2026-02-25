import SwiftUI
import AppKit

struct ContentView: View {
    // Percentage of value
    @State private var percentage = ""
    @State private var value = ""
    @State private var result = "-"

    // What percent
    @State private var part = ""
    @State private var whole = ""
    @State private var percentResult = "-"

    // Percentage change
    @State private var initialValue = ""
    @State private var finalValue = ""
    @State private var changeResult = "-"
    @State private var multiplierResult = "-"

    // Text stripping
    @State private var textToStrip = ""

    // Copy button states
    @State private var copiedPercent = false
    @State private var copiedReverse = false
    @State private var copiedChange = false

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // MARK: - Left Column: Calculators
            VStack(spacing: 12) {
                calculatorCard(title: "Percentage of value", copyText: result, copied: $copiedPercent) {
                    HStack {
                        Text("What is")
                        TextField("Value", text: $percentage)
                            .textFieldStyle(.plain)
                            .underlineField()
                            .frame(width: 50)
                        Text("% of")
                        TextField("Value", text: $value)
                            .textFieldStyle(.plain)
                            .underlineField()
                            .frame(width: 60)
                            .onSubmit { calculatePercentage() }
                        Spacer()
                        Text(result)
                            .font(.title3.monospacedDigit())
                            .foregroundStyle(.primary)
                        Button("Go") { calculatePercentage() }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                    }
                }

                calculatorCard(title: "Reverse percentage", copyText: percentResult, copied: $copiedReverse) {
                    HStack {
                        TextField("Part", text: $part)
                            .textFieldStyle(.plain)
                            .underlineField()
                            .frame(width: 60)
                        Text("is what % of")
                        TextField("Whole", text: $whole)
                            .textFieldStyle(.plain)
                            .underlineField()
                            .frame(width: 60)
                            .onSubmit { calculateWhatPercent() }
                        Spacer()
                        Text(percentResult)
                            .font(.title3.monospacedDigit())
                            .foregroundStyle(.primary)
                        Button("Go") { calculateWhatPercent() }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                    }
                }

                calculatorCard(title: "Percentage change", copyText: changeResult, copied: $copiedChange) {
                    HStack {
                        Text("From")
                        TextField("Initial", text: $initialValue)
                            .textFieldStyle(.plain)
                            .underlineField()
                            .frame(width: 60)
                        Text("to")
                        TextField("Final", text: $finalValue)
                            .textFieldStyle(.plain)
                            .underlineField()
                            .frame(width: 60)
                            .onSubmit { calculateIncreaseDecrease() }
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(changeResult)
                            Text(multiplierResult)
                                .foregroundStyle(.secondary)
                        }
                        .font(.title3.monospacedDigit())
                        Button("Go") { calculateIncreaseDecrease() }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.regular)
                    }
                }


            }
            .frame(minWidth: 390, maxWidth: 390)

            // MARK: - Right Column: Strip Formatting
            StripFormattingCard(textToStrip: $textToStrip)
                .frame(minWidth: 250)
                .frame(maxWidth: 250)
                .frame(maxHeight: 280)
                .frame(minHeight: 280)

        }
        .padding()
        .frame(minWidth: 700, minHeight: 320)
        .frame(maxWidth: 700, maxHeight: 320)

    }

    // MARK: - Card Builder

    @ViewBuilder
    private func calculatorCard<Content: View>(title: String, copyText: String, copied: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                if copyText != "-" && !copyText.isEmpty {
                    CopyButton(text: copyText, copied: copied)
                }
            }
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .percentCalcGlassEffect()
    }

    // MARK: - Calculations

    func calculatePercentage() {
        let percentageValue = Double(percentage) ?? 0
        let valueValue = Double(value) ?? 0
        let calculatedResult = (percentageValue / 100) * valueValue
        result = String(format: "%.2f", calculatedResult)
    }

    func calculateWhatPercent() {
        let partValue = Double(part) ?? 0
        let wholeValue = Double(whole) ?? 0
        let calculatedResult = (partValue / wholeValue) * 100
        percentResult = String(format: "%.2f%%", calculatedResult)
    }

    func calculateIncreaseDecrease() {
        let initialVal = Double(initialValue) ?? 0
        let finalVal = Double(finalValue) ?? 0
        let calculatedChange = ((finalVal - initialVal) / initialVal) * 100
        let calculatedMultiplier = finalVal / initialVal
        changeResult = String(format: "%.2f%%", calculatedChange)
        multiplierResult = String(format: "%.1fx", calculatedMultiplier)
    }

}

// MARK: - Underline Field Modifier

extension View {
    func underlineField() -> some View {
        self.overlay(alignment: .bottom) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.primary.opacity(0.35))
                .offset(y: 2)
        }
    }
}

// MARK: - Copy Button

struct CopyButton: View {
    let text: String
    @Binding var copied: Bool

    var body: some View {
        Button {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(text, forType: .string)
            copied = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                copied = false
            }
        } label: {
            Image(systemName: copied ? "checkmark" : "doc.on.doc")
                .font(.system(size: 11))
                .foregroundStyle(copied ? .green : .secondary)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 14, height: 14)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Strip Formatting Card

struct StripFormattingCard: View {
    @Binding var textToStrip: String
    @State private var copied = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header row
            HStack {
                Text("Strip formatting")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                if !textToStrip.isEmpty {
                    CopyButton(text: textToStrip, copied: $copied)
                }
            }
            .padding(.bottom, 8)

            // Document area
            ZStack(alignment: .topLeading) {
                DocumentLinesBackground()

                if textToStrip.isEmpty {
                    Text("Paste to strip formatting")
                        .font(.body)
                        .foregroundStyle(.quaternary)
                        .padding(.top, 1)
                        .padding(.leading, 5)
                        .allowsHitTesting(false)
                }

                TextEditor(text: $textToStrip)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .onChange(of: textToStrip) {
                        stripFormatting()
                    }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .percentCalcGlassEffect()
    }

    func stripFormatting() {
        var strippedText = textToStrip.unicodeScalars.filter {
            !$0.properties.isEmojiPresentation
        }.map { String($0) }.joined()

        strippedText = strippedText.replacingOccurrences(of: "\t", with: " ")
        strippedText = strippedText.replacingOccurrences(of: "[ ]{2,}", with: " ", options: .regularExpression)

        let lines = strippedText.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        strippedText = lines.filter { !$0.isEmpty }.joined(separator: "\n")

        textToStrip = strippedText
    }
}

// MARK: - Document Lines Background

struct DocumentLinesBackground: View {
    var body: some View {
        GeometryReader { geo in
            let lineHeight: CGFloat = 22
            let lineCount = Int(geo.size.height / lineHeight)
            Path { path in
                for i in 1...max(lineCount, 1) {
                    let y = CGFloat(i) * lineHeight
                    // Slight irregular offsets seeded by line index
                    let xStart: CGFloat = CGFloat((i * 7) % 5)
                    let xEnd: CGFloat = geo.size.width - CGFloat((i * 3) % 6)
                    path.move(to: CGPoint(x: xStart, y: y))
                    path.addLine(to: CGPoint(x: xEnd, y: y))
                }
            }
            .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    ContentView()
}
