//
//  ProductBasketCell.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 8.10.2024.
//

import UIKit

class ProductBasketCell: UITableViewCell {

    @IBOutlet weak var labelProductBasketName: UILabel!
    @IBOutlet weak var labelProductBasketCategory: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var labelProductBasketPrice: UILabel!
    @IBOutlet weak var labelProductBasketBrand: UILabel!
    @IBOutlet weak var labelOrderCount: UILabel!
    
    var viewModel = BasketpageViewModel()
    var basketProductsList = [ProductsBasket]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func resimGoster(resimAd:String){
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAd)"){
            DispatchQueue.main.async {
                self.productImageView.kf.setImage(with: url)
            }
        }
    }

}
