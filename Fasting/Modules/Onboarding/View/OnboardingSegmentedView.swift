//
//  OnboardingSegmentedView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI
import AppStudioUI

struct OnboardingSegmentedView<Segment: OnboardingPickerOption>: View {

    let title: String
    let description: String?
    @Binding var value: CGFloat
    @Binding var currentSegment: Segment
    let segments: [Segment]

    @State private var stringValue = ""
    @State private var textFieldWidth: CGFloat = 0
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: .zero) {
            Text(title)
                .font(.poppins(.headerM))
                .foregroundStyle(.accent)
                .multilineTextAlignment(.center)
                .padding(.top, Layout.topPadding)

            if let description {
                Text(description)
                    .foregroundStyle(.fastingGrayText)
                    .font(.poppins(.body))
                    .padding(.top, Layout.descriptionTopPadding)
                    .multilineTextAlignment(.center)
            }
            Spacer()
            ZStack {
                Text(stringValue.isEmpty ? "0" : stringValue)
                    .withViewWidthPreferenceKey
                    .opacity(0)
                TextField("0", text: $stringValue)
                    .frame(width: textFieldWidth)
                    .focused($isFocused)
                    .keyboardType(.decimalPad)
            }
            .font(.poppins(.accentS))
            .foregroundStyle(.accent)

            HStack(spacing: -Layout.segmentInnerPadding * 2) {
                ForEach(segments) { segment in
                    Button(action: {
                        currentSegment = segment
                    }, label: {
                        Text(segment.title)
                            .font(.poppins(.body))
                            .padding(.horizontal, Layout.segmentHorizontalPadding)
                            .padding(.vertical, Layout.segmentVerticalPadding)
                            .background(segment == currentSegment ? Color.fastingGrayFillProgress : nil)
                            .continiousCornerRadius(Layout.segmentCornerRadius)
                            .padding(Layout.segmentInnerPadding)
                    })
                }
            }
            .border(configuration: .init(cornerRadius: Layout.cornerRadius,
                                         color: .fastingGreyStrokeFill))
            .padding(.top, Layout.segmentedControlTopPadding)
            Spacer()
            Spacer()
        }
        .onViewWidthPreferenceKeyChange { newWidth in
            textFieldWidth = newWidth
        }
        .onAppear {
            isFocused = true
            if value > 0 {
                var stringValue = "\(value)"
                if stringValue.hasSuffix(".0") {
                    stringValue.removeLast(2)
                }
                self.stringValue = stringValue
            }
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
                            currentSegment: .constant(HeightUnit.cm),
                            segments: HeightUnit.allCases)
}
