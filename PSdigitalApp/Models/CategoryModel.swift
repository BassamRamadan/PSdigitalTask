//
//  CategoryModel.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//

import Foundation

struct CategoryModel: Codable {
    let requestDate: String?
    let resonseCode: Int?
    let resonseTitle: String?
    let resonseMessage: String?
    let results: [CategoryResult]?

    enum CodingKeys: String, CodingKey {
        case requestDate = "RequestDate"
        case resonseCode = "ResonseCode"
        case resonseTitle = "ResonseTitle"
        case resonseMessage = "ResonseMessage"
        case results = "Results"
    }
}

struct CategoryResult: Codable {
    let id: Int?
    let name, resultDescription: String?
    let imagePath: String?
    let displayOrder: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case resultDescription = "Description"
        case imagePath = "ImagePath"
        case displayOrder = "DisplayOrder"
    }
}
