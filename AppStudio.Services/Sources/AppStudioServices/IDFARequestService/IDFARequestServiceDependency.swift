//
//  File.swift
//  
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import Dependencies

public extension DependencyValues {
    var idfaRequestService: IDFARequestService {
        self[IdfaRequestServiceKey.self]
    }
}

private enum IdfaRequestServiceKey: DependencyKey {
    static var liveValue = IDFARequestServiceImpl()
}
