//
//  OnboardingSegmentedView.swift
//
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioModels

public struct OnboardingSegmentedView<Segment: OnboardingPickerOption>: View {

    let title: String
    let description: String?
    @Binding var value: CGFloat
    @Binding var inchValue: CGFloat
    @Binding var currentSegment: Segment
    let segments: [Segment]

    @State private var stringValue = ""
    @State private var inchString = ""
    @State private var textFieldWidth: CGFloat = 0
    @State private var textFieldFtWidth: CGFloat = 0
    @FocusState private var isFocused: Bool
    @FocusState private var isInchFocused: Bool

    public init(title: String,
                description: String?,
                value: Binding<CGFloat>,
                inchValue: Binding<CGFloat> = .constant(0),
                currentSegment: Binding<Segment>,
                segments: [Segment]) {
        self.title = title
        self.description = description
        self._value = value
        self._inchValue = inchValue
        self._currentSegment = currentSegment
        self.segments = segments
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Text(title)
                .font(.poppins(.headerM))
                .foregroundStyle(Color.studioBlackLight)
                .multilineTextAlignment(.center)
                .padding(.top, Layout.topPadding)

            if let description {
                Text(description)
                    .foregroundStyle(Color.studioGrayText)
                    .font(.poppins(.body))
                    .padding(.top, Layout.descriptionTopPadding)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            ZStack {
                Text(stringValue.isEmpty ? "0" : stringValue)
                    .withViewWidthPreferenceKey
                    .opacity(0)
                if currentSegment.isFt {
                    Text(inchString.isEmpty ? "0" : inchString)
                        .withFtViewWidthPreferenceKey
                        .opacity(0)
                }
                HStack(alignment: .firstTextBaseline) {
                    Spacer()
                    TextField("0", text: $stringValue)
                        .frame(width: textFieldWidth)
                        .focused($isFocused)
                        .keyboardType(.decimalPad)
                        .onChange(of: stringValue) { newValue in
                            guard currentSegment.isFt else { return }
                            if !newValue.isEmpty {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.isInchFocused = true
                                }
                            }
                            let maxNumbers = 3
                            stringValue = String(newValue.prefix(maxNumbers).filter { $0.isNumber })
                        }

                    if currentSegment.isFt {
                        Text(String.feets)
                            .font(.poppins(.headerM))

                        TextField("0", text: $inchString)
                            .focused($isInchFocused)
                            .frame(width: textFieldFtWidth)
                            .keyboardType(.decimalPad)
                            .onChange(of: inchString) { newValue in
                                guard currentSegment.isFt else { return }
                                let maxNumbers = 2
                                let maxInchAmount = 11

                                inchString = String(newValue.prefix(maxNumbers).filter { $0.isNumber })

                                guard let number = Int(inchString) else { return }
                                if number > maxInchAmount {
                                    inchString = String(newValue.prefix(1).filter { $0.isNumber })
                                }

                                inchValue = CGFloat(number)
                            }

                        Text(String.inches)
                            .font(.poppins(.headerM))
                    }
                    Spacer()
                }
            }
            .font(.poppins(.accentS))
            .foregroundStyle(Color.studioBlackLight)

            HStack(spacing: -Layout.segmentInnerPadding * 2) {
                ForEach(segments) { segment in
                    Button(action: {
                        currentSegment = segment
                    }, label: {
                        Text(segment.title)
                            .font(.poppins(.body))
                            .padding(.horizontal, Layout.segmentHorizontalPadding)
                            .padding(.vertical, Layout.segmentVerticalPadding)
                            .background(segment == currentSegment ? Color.studioGrayFillProgress : nil)
                            .continiousCornerRadius(Layout.segmentCornerRadius)
                            .padding(Layout.segmentInnerPadding)
                    })
                }
            }
            .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                         color: .studioGreyStrokeFill))
            .padding(.top, Layout.segmentedControlTopPadding)
            Spacer()
            Spacer()
        }
        .onViewWidthPreferenceKeyChange { newWidth in
            textFieldWidth = newWidth
        }
        .onViewFtWidthPreferenceKeyChange { newWidth in
            textFieldFtWidth = newWidth
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.isFocused = true
            }
            convertValueToString(value: value)
            convertInchValueToString(inchValue: inchValue)
        }
        .onChange(of: stringValue) { newValue in
            let numbers = newValue.filter { $0.isNumber }
            guard !numbers.isEmpty else {
                stringValue = ""
                value = 0
                return
            }
            let punctuation = newValue.filter { !$0.isNumber }
            guard punctuation.count <= 1 else {
                _ = stringValue.popLast()
                return
            }
            if let separator = punctuation.first,
               let index = newValue.map({ $0 }).firstIndex(of: separator),
                newValue.count - index > 3 {
                _ = stringValue.popLast()
                return
            }
            let newValue = newValue.isEmpty ? "0" : newValue
            if let doubleValue = Double(newValue) {
                value = CGFloat(doubleValue)
            }
        }
    }

    private func convertInchValueToString(inchValue: CGFloat) {
        if inchValue > 0 {
            var stringValue = "\(inchValue)"
            if stringValue.hasSuffix(".0") {
                stringValue.removeLast(2)
            }
            inchString = stringValue
        } else {
            inchString = ""
        }
    }

    private func convertValueToString(value: CGFloat) {
        if value > 0 {
            var stringValue = "\(value)"
            if stringValue.hasSuffix(".0") {
                stringValue.removeLast(2)
            }
            self.stringValue = stringValue
        } else {
            stringValue = ""
        }
    }
}

private extension String {
    static let feets = "HeightUnit.ft".localized(bundle: .module)
    static let inches = "HeightUnit.in" .localized(bundle: .module)
}

private extension OnboardingSegmentedView {
    enum Layout {
        static var topPadding: CGFloat { 24 }
        static var descriptionTopPadding: CGFloat { 16 }
        static var segmentedControlTopPadding: CGFloat { 16 }
        static var pickerHeight: CGFloat { 42 }
        static var cornerRadius: CGFloat { 48 }
        static var segmentVerticalPadding: CGFloat { 8 }
        static var segmentHorizontalPadding: CGFloat { 24 }
        static var segmentCornerRadius: CGFloat { 56 }
        static var segmentInnerPadding: CGFloat { 4 }
    }
}

#Preview {
    OnboardingSegmentedView(title: "What's your current weight?",
                            description: "Let's get there together",
                            value: .constant(0),
                            currentSegment: .constant(HeightUnit.ft),
                            segments: HeightUnit.allCases)
}

private extension View {
    var withFtViewWidthPreferenceKey: some View {
        self
            .background(
                GeometryReader {
                    Color.clear.preference(key: ViewFtWidthPreferenceKey.self,
                                           value: $0.frame(in: .local).size.width)
                }
            )
    }

    func onViewFtWidthPreferenceKeyChange(_ action: @escaping (CGFloat) -> Void) -> some View {
        self.onPreferenceChange(ViewFtWidthPreferenceKey.self, perform: action)
    }
}


private struct ViewFtWidthPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

