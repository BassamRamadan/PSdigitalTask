//
//  CategoryItemsModel.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//

import Foundation

struct CategoryItemsModel: Codable {
    let requestDate: String?
    let resonseCode: Int?
    let resonseTitle: String?
    let resonseMessage: String?
    let results: [CategoryItemsResult]?

    enum CodingKeys: String, CodingKey {
        case requestDate = "RequestDate"
        case resonseCode = "ResonseCode"
        case resonseTitle = "ResonseTitle"
        case resonseMessage = "ResonseMessage"
        case results = "Results"
    }
}

// MARK: - Result
struct CategoryItemsResult: Codable {
    let id: Int?
    let name, resultDescription: String?
    let imagePath: String?
    let defaultPrice, comboDefaultPrice: Double?
    let itemType, displayOrder: Int?
    let isSpicy, isLto: Bool?
    let haveACombo, haveSizes, isOnlyACombo: Bool?
    let comboID: Int?
    let isFavorite, isCustomizeable: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case resultDescription = "Description"
        case imagePath = "ImagePath"
        case defaultPrice = "DefaultPrice"
        case comboDefaultPrice = "ComboDefaultPrice"
        case itemType = "ItemType"
        case displayOrder = "DisplayOrder"
        case isSpicy = "IsSpicy"
        case isLto = "IsLto"
        case haveACombo = "HaveACombo"
        case haveSizes = "HaveSizes"
        case isOnlyACombo = "IsOnlyACombo"
        case comboID = "ComboID"
        case isFavorite = "IsFavorite"
        case isCustomizeable = "IsCustomizeable"
    }
}
