//
//  BasketPageViewModel.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import Foundation
import RxSwift

class BasketpageViewModel {
    
    var prepo = ProductsRepository()
    var basketProductsList = BehaviorSubject <[ProductsBasket]> (value: [ProductsBasket]())
    
    init(){
        basketProductsList = prepo.basketProductsList
        prepo.getBasketProducts(nickname: "oya_ozcan")
        print(basketProductsList)
    }
    
    func delete(basketId:Int){
        prepo.delete(basketId: basketId, nickname: "oya_ozcan")
        getBasketProducts()
    }
    
    func ara(aramaKelimesi:String){
       // prepo.ara(aramaKelimesi: aramaKelimesi)
    }
    
    func getBasketProducts(){
        prepo.getBasketProducts(nickname: "oya_ozcan")
    }
}
