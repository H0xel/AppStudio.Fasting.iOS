//
//  ProductProvider.swift
//  AppStudio
//
//  Created by Denis Khlopin on 10.08.2023.
//

import AppStudioSubscriptions

protocol ProductProvider {
    var defaultProductIds: [String] { get }
    var productItems: [ProductCatalogItem] { get }
    var remoteExperimentsPlans: [RemoteExperimentPlans] { get }
}
