//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import Foundation

public protocol OnboardingPickerOption: Identifiable, Hashable {
    var title: String { get }
    var description: String? { get }
    var isFt: Bool { get }
    var isRecommended: Bool { get }
}

extension HeightUnit: OnboardingPickerOption {
    public var isRecommended: Bool {
        false
    }
    
    public var id: String {
        rawValue
    }

    public var description: String? {
        nil
    }

    public var isFt: Bool {
        self == .ft
    }
}

extension WeightUnit: OnboardingPickerOption {
    public var isRecommended: Bool {
        false
    }

    public var id: String {
        rawValue
    }

    public var description: String? {
        nil
    }

    public var isFt: Bool {
        false
    }
}

extension Sex: OnboardingPickerOption {
    public var isRecommended: Bool {
        false
    }

    public var description: String? {
        nil
    }

    public var isFt: Bool {
        false
    }
}
