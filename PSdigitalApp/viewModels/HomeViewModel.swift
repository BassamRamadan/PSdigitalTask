//
//  HomeViewModel.swift
//  PSdigitalApp
//
//  Created by Bassam on 7/1/22.
//

import Foundation

class HomeViewModel{
    var Categories = Blindable<[CategoryResult]>()
    var CategoryItems = Blindable<[CategoryItemsResult]>()
    var state = Blindable<State>()
    var alertMessage = Blindable<String>()
    
    
    var CategoriesCount: Int {
        return Categories.value?.count ?? 0
    }
    var CategoryItemsCount: Int {
        return CategoryItems.value?.count ?? 0
    }
    func getCategoryCellData(at: Int) -> CategoryResult{
        return (Categories.value?[at])!
    }
    func cellIsCustomizable(at: Int) -> Bool{
        return (CategoryItems.value?[at])?.isCustomizeable ?? false
    }
    func getCategoryItemCellData(at: Int) -> CategoryItemsResult{
        return (CategoryItems.value?[at])!
    }
    func getItemImageAndName(at: Int) -> (String,String){
        return ((CategoryItems.value?[at])?.imagePath ?? "",(CategoryItems.value?[at])?.name ?? "")
    }
    func getComboId(at: Int) -> Int{
        return (CategoryItems.value?[at])?.comboID ?? 0
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
    
    func getCategories(){
        A(url: "http://txsrv_v5.psdigital.me/api/V5/Order/en/6/Menu/Category?OrderType=2", responseClass: CategoryModel.self) { (data) in
            self.Categories.value = data?.results
        }
    }
    func getCategoryItems(categoryId: Int){
        A(url: "http://txsrv_v5.psdigital.me/api/V5/Order/en/6/Menu/Category/Items?OrderType=2&Category=\(categoryId)&Branch=0", responseClass: CategoryItemsModel.self) { (data) in
            self.CategoryItems.value = data?.results
        }
    }
}
enum State {
    case loading
    case error
    case empty
    case populated
}
