//
//  ProductProvider.swift
//  AppStudio
//
//  Created by Denis Khlopin on 10.08.2023.
//

import NewAppStudioSubscriptions

protocol ProductProvider {
    var defaultProductIds: [String] { get }
}
