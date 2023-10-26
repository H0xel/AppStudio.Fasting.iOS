//
//  Migration.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

protocol Migration {
    func migrate() async
}

extension Migration {
    var id: String { String(describing: type(of: self)) }
}
