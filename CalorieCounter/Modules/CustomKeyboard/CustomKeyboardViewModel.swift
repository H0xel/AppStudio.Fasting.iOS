//  
//  CustomKeyboardViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Combine

class CustomKeyboardViewModel: BaseViewModel<CustomKeyboardOutput> {
    var router: CustomKeyboardRouter!
    var style: CustomKeyboardStyle
    @Published var isTextSelected: Bool
    @Published var currentServing: MealServing
    @Published var textBeforeSlash = ""
    @Published var textAfterSlash = ""
    let title: String
    @Published private var isSlashAdded = false
    let mealServings: [MealServing]

    init(input: CustomKeyboardInput, output: @escaping CustomKeyboardOutputBlock) {
        style = input.style
        title = input.title
        isTextSelected = !input.text.isEmpty
        currentServing = input.currentServing
        mealServings = input.servings
        super.init(output: output)
        initialize(text: input.text)
        observeIsPresentedPublisher(pubisher: input.isPresentedPublisher)
        observeServing()
    }

    var grammsValue: String? {
        if currentServing == .gramms || currentServing == .serving || !mealServings.contains(.gramms) {
            return nil
        }
        let result = result
        let grammValue = (result.value * (result.serving.weight ?? 1)) / result.serving.quantity
        return "\(grammValue.withoutDecimalsIfNeeded) \(MealServing.gramms.units(for: grammValue))"
    }

    var displayText: String {
        var result = textBeforeSlash
        if isSlashAdded {
            result.append(" / \(textAfterSlash)")
        }
        return result
    }

    var units: String {
        let result = result
        return currentServing.units(for: result.value)
    }

    func changeServing(to serving: MealServing) {
        let convertedResult = currentServing.convert(value: result.value, to: serving)
        isSlashAdded = false
        initialize(text: "\(convertedResult)")
        currentServing = serving
    }

    func numberTapped(_ number: Int) {
        appendNextSymbol(symbol: "\(number)")
    }

    func buttonTapped(_ button: CustomKeyboardButton) {
        switch button {
        case .delete:
            remove()
            valueChanged()
        case .up:
            output(.direction(.up))
        case .down:
            output(.direction(.down))
        case .done, .log, .add:
            sendResult()
        case .dot:
            appendNextSymbol(symbol: ".")
            valueChanged()
        case .slash:
            appendSlash()
            valueChanged()
        case .collapse:
            break
        }
    }

    private func appendSlash() {
        guard !isSlashAdded, !textBeforeSlash.isEmpty else { return }
        isSlashAdded = true
        if textBeforeSlash.last?.isNumber == false {
            _ = textBeforeSlash.popLast()
        }
    }

    private func appendNextSymbol(symbol: String) {
        if isTextSelected {
            clearText()
            isTextSelected = false
            valueChanged()
        }
        var newValue = targetText + symbol
        if newValue == "00" {
            return
        }
        let punctuation = newValue.filter { !$0.isNumber }

        guard punctuation.count <= 1 else {
            return
        }
        if let separator = punctuation.first,
           let index = newValue.map({ $0 }).firstIndex(of: separator),
            newValue.count - index > 3 {
            return
        }
        if targetText == "0", punctuation.isEmpty {
            _ = newValue.removeFirst()
        }
        let result = newValue.isEmpty ? "0" : newValue
        if Double(result) != nil  {
            assignText(text: result)
            valueChanged()
        }
    }

    private func assignText(text: String) {
        if isSlashAdded {
            textAfterSlash = text
        } else {
            textBeforeSlash = text
        }
    }

    private func clearText() {
        isSlashAdded = false
        textBeforeSlash = ""
        textAfterSlash = ""
    }

    private func remove() {
        if isTextSelected {
            clearText()
            isTextSelected = false
            return
        }
        if !isSlashAdded {
            _ = textBeforeSlash.popLast()
            return
        }
        if textAfterSlash.isEmpty {
            isSlashAdded = false
            return
        }
        _ = textAfterSlash.popLast()
    }

    private func initialize(text: String) {
        guard !text.isEmpty else { return }
        let parts = text.components(separatedBy: "/")
        textBeforeSlash = parts.first?.withoutDecimalsIfNeeded ?? ""
        if parts.count > 1 {
            isSlashAdded = true
            textAfterSlash = parts.last?.withoutDecimalsIfNeeded ?? ""
        }
    }

    private func observeServing() {
        $currentServing
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                if !this.displayText.isEmpty {
                    this.isTextSelected = true
                }
                this.output(.valueChanged(this.result))
            }
            .store(in: &cancellables)
    }

    private func sendResult() {
        output(.add(result))
    }

    private func valueChanged() {
        output(.valueChanged(result))
    }

    private func observeIsPresentedPublisher(pubisher: AnyPublisher<Bool, Never>) {
        pubisher
            .filter { !$0 }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, isPresented in
                this.output(.dismissed(this.result))
            }
            .store(in: &cancellables)
    }

    private var result: CustomKeyboardResult {
        let firstValue = Double(textBeforeSlash) ?? 0
        let secondValue = Double(textAfterSlash) ?? 0
        var result = firstValue
        if isSlashAdded, secondValue > 0 {
            result = firstValue / secondValue
        }
        return CustomKeyboardResult(displayText: displayText,
                                    value: result,
                                    serving: currentServing)
    }

    private var targetText: String {
        isSlashAdded ? textAfterSlash : textBeforeSlash
    }
}
