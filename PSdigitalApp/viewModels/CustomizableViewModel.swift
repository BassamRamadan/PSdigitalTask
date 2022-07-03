//
//  CustomizableViewModel.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/2/22.
//

import Foundation
struct itemCustomizables {
    let sectionName: String
    let sectionData: [Drink]
}
class CustomizableViewModel{
    var itemDetails = Blindable<ComboResults>()
    var state = Blindable<State>()
    var alertMessage = Blindable<String>()
    var items = [itemCustomizables]()
    
    func getSectionsCount() -> Int{
        return items.count
    }
    func getSectionIdentifier(at: Int) -> String{
        switch items[at-1].sectionName{
        case "Combo Sizes":
            return "section1"
        case "Sauces":
            return "section2"
        default:
            return "section0"
        }
    }
    func getSectionItemsCount(at: Int) -> Int{
        return items[at-1].sectionData.count
    }
    func getCellData(at: IndexPath) -> Drink{
        return items[at.section-1].sectionData[at.row]
    }
    
    func getSectionName(at: Int) -> String{
        return items[at-1].sectionName
    }
    
    fileprivate func setItems(){
        if !(itemDetails.value?.sizes ?? []).isEmpty{
            items.append(.init(sectionName: "Combo Sizes", sectionData: itemDetails.value?.sizes ?? []))
        }
        if !(itemDetails.value?.sauces ?? []).isEmpty{
            items.append(.init(sectionName: "Sauces", sectionData: itemDetails.value?.sauces ?? []))
        }
        if !(itemDetails.value?.sides ?? []).isEmpty{
            items.append(.init(sectionName: "Sides", sectionData: itemDetails.value?.sides ?? []))
        }
        if !(itemDetails.value?.drinks ?? []).isEmpty{
            items.append(.init(sectionName: "Drinks", sectionData: itemDetails.value?.drinks ?? []))
        }
    }
    
    func A<T: Codable>(url: String,responseClass: T.Type,completion: @escaping (T?) -> Void){
        state.value = .loading
        DispatchQueue.global().async {
            AlamofireRequests.getMethod(url: url, headers:[:]) { [weak self] (error, success , jsonData) in
                guard let self = self else {
                    return
                }
                guard error == nil else{
                    self.state.value = .error
                    self.alertMessage.value = error?.localizedDescription
                    return
                }
                do{
                    let objects = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(objects)
                    self.state.value = .populated
                }catch{
                    self.state.value = .error
                    self.alertMessage.value = "حدث خطأ بالرجاء التاكد من اتصالك بالانترنت "
                }
            }
        }
    }
    
    func getCustomizableOptions(ComboID: Int){
        A(url: "http://txsrv_v5.psdigital.me/api/V5/Order/en/6/Menu/Combo?Branch=0&Combo=\(ComboID)", responseClass: ComboModel.self) { (data) in
            self.itemDetails.value = data?.results
            self.setItems()
        }
    }
}
