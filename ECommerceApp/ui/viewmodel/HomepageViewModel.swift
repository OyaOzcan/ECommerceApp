//
//  HomepageViewModel.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import Foundation
import RxSwift

class HomepageViewModel {
    
    var prepo = ProductsRepository()
    var productsList = BehaviorSubject <[Products]> (value: [Products]())
    var filterProductsList = BehaviorSubject <[Products]> (value: [Products]())
    
    init(){
        productsList = prepo.productsList
        getProducts()
        print(productsList)
    }
    
    func delete(basketId:Int){
       prepo.delete(basketId: basketId, nickname: "oya_ozcan")
        getProducts()
    }
    
    func searchProducts(searchText:String){
        prepo.searchProducts(searchText: searchText)
    }
    
    func addBasket(name:String, image:String, category:String, price:Int, brand:String, orderCount:Int, nickname:String){
        prepo.kaydet(name: name, image: image, category: category, price: price, brand: brand, orderCount: orderCount, nickname: nickname)
    }
    
    func getProducts(){
        prepo.getProducts()
    }
}
