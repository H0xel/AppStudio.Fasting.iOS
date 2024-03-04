//  
//  BarcodeOutput.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 28.12.2023.
//
import AppStudioUI

typealias BarcodeOutputBlock = ViewOutput<BarcodeOutput>

enum BarcodeOutput {
    case barcode(String)
    case close
}
