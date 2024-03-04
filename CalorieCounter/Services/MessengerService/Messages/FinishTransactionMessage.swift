//
//  FinishTransactionMessage.swift
//  AppStudio
//
//  Created by Aleksandr Shulga on 22.08.2022.
//  Copyright © 2022 GetPaid Inc. All rights reserved.
//

import StoreKit

class FinishTransactionMessage: AppStudioMessage {
    public let state: SKPaymentTransactionState
    public let context: PaywallContext?
    public let error: SKError?
    public init(state: SKPaymentTransactionState, context: PaywallContext?, error: SKError? = nil, sender: Any?) {
        self.state = state
        self.context = context
        self.error = error
        super.init(sender: sender)
    }
}

extension FinishTransactionMessage {
    var result: String {
        switch self.state {
        case .purchased:
            return "success"
        case .failed where self.error?.code == .paymentCancelled:
            return "cancelled"
        case .failed:
            return "fail"
        default:
            return ""
        }
    }
}
