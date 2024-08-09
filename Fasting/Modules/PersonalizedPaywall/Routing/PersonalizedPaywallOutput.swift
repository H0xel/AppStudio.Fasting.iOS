//  
//  PersonalizedPaywallOutput.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.12.2023.
//
import AppStudioUI

typealias PersonalizedPaywallOutputBlock = ViewOutput<PersonalizedPaywallOutput>

enum PersonalizedPaywallOutput {
    case close
    case subscribed
    case showDiscountPaywall(DiscountPaywallInput)
    case showTrialPaywall
}
