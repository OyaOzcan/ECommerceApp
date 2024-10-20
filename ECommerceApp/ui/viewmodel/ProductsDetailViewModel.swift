//
//  ProductsDetailViewModel.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import Foundation

class ProductsDetailViewModel {
    var prepo = ProductsRepository()
    
    func addBasket(name:String, image:String, category:String, price:Int, brand:String, orderCount:Int, nickname:String){
        prepo.kaydet(name: name, image: image, category: category, price: price, brand: brand, orderCount: orderCount, nickname: nickname)
    }
    
}
