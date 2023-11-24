//
//  String+subscript.swift
//  Fasting
//
//  Created by Amakhin Ivan on 21.11.2023.
//

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
}
