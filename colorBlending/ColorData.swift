//
//  ColorData.swift
//  colorBlending
//
//  Created by Anna Melekhina on 21.01.2025.
//

import Foundation

struct ColorData: Decodable {
    var name: Name?
}

struct Name: Decodable {
    var value: String?
}
