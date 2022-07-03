//
//  ComboModel.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//
import Foundation

// MARK: - Welcome
struct ComboModel: Codable {
    let requestDate: String?
    let resonseCode: Int?
    let resonseTitle: String?
    let resonseMessage: String?
    let results: ComboResults?

    enum CodingKeys: String, CodingKey {
        case requestDate = "RequestDate"
        case resonseCode = "ResonseCode"
        case resonseTitle = "ResonseTitle"
        case resonseMessage = "ResonseMessage"
        case results = "Results"
    }
}

// MARK: - Results
struct ComboResults: Codable {
    let id: Int?
    let name, resultsDescription: String?
    let imagePath: String?
    let defaultPrice, itemType: Int?
    let calories: String?
    let sizes: [Drink]?
    let drinks: [Drink]?
    let sides: [Drink]?
    let sandwiches: [Drink]?
    let chickenPieces, biscuits: [Drink]?
    let sauces: [Drink]?
    let isCustomizeable: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case resultsDescription = "Description"
        case imagePath = "ImagePath"
        case defaultPrice = "DefaultPrice"
        case itemType = "ItemType"
        case calories = "Calories"
        case sizes = "Sizes"
        case drinks = "Drinks"
        case sides = "Sides"
        case sandwiches = "Sandwiches"
        case chickenPieces = "ChickenPieces"
        case biscuits = "Biscuits"
        case sauces = "Sauces"
        case isCustomizeable = "IsCustomizeable"
    }
}

// MARK: - Drink
struct Drink: Codable {
    let id, productID: Int?
    let name, details: String?
    let imagePath: String?
    let defaultPrice: Double?
    let isDefault: Bool?
    let itemType, displayOrder: Int?
    let isSpicy, isLTO: Bool?
    let ltoName: String?
    let size, quantityMax, quantityDefault: Int?
    let ingredients: [Ingredient]?
  
    
    let drinksQuantityMax, drinksQuantityDefault, sidesQuantityMax, sidesQuantityDefault: Int?
    let dessertsQuantityMax, dessertsQuantityDefault, sandwishsQuantityMax, sandwishsQuantityDefault: Int?
    let chickenPiecesQuantityMax, chickenPiecesQuantityDefault, biscuitsQuantityMax, biscuitsQuantityDefault: Int?
    let saucesQuantityMax, saucesQuantityDefault: Int?
    

    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case productID = "ProductID"
        case name = "Name"
        case details = "Description"
        case imagePath = "ImagePath"
        case defaultPrice = "DefaultPrice"
        case isDefault = "IsDefault"
        case itemType = "ItemType"
        case displayOrder = "DisplayOrder"
        case isSpicy = "IsSpicy"
        case isLTO = "IsLTO"
        case ltoName = "LTOName"
        case size = "Size"
        case quantityMax = "QuantityMax"
        case quantityDefault = "QuantityDefault"
        case ingredients = "Ingredients"
        
        case drinksQuantityMax = "DrinksQuantityMax"
        case drinksQuantityDefault = "DrinksQuantityDefault"
        case sidesQuantityMax = "SidesQuantityMax"
        case sidesQuantityDefault = "SidesQuantityDefault"
        case dessertsQuantityMax = "DessertsQuantityMax"
        case dessertsQuantityDefault = "DessertsQuantityDefault"
        case sandwishsQuantityMax = "SandwishsQuantityMax"
        case sandwishsQuantityDefault = "SandwishsQuantityDefault"
        case chickenPiecesQuantityMax = "ChickenPiecesQuantityMax"
        case chickenPiecesQuantityDefault = "ChickenPiecesQuantityDefault"
        case biscuitsQuantityMax = "BiscuitsQuantityMax"
        case biscuitsQuantityDefault = "BiscuitsQuantityDefault"
        case saucesQuantityMax = "SaucesQuantityMax"
        case saucesQuantityDefault = "SaucesQuantityDefault"
        
    }
}
// MARK: - Ingredient
struct Ingredient: Codable {
    let id: Int?
    let name, ingredientDescription: String?
    let imagePath: String?
    let defaultPrice: Double?
    let displayOrder, quantityMax, quantityDefault: Int?

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name = "Name"
        case ingredientDescription = "Description"
        case imagePath = "ImagePath"
        case defaultPrice = "DefaultPrice"
        case displayOrder = "DisplayOrder"
        case quantityMax = "QuantityMax"
        case quantityDefault = "QuantityDefault"
    }
}
