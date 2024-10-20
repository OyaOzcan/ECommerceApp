//
//  FavoriCell.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 15.10.2024.
//

import UIKit

class FavoriCell: UITableViewCell {

    @IBOutlet weak var labelFavoriImage: UILabel!
    @IBOutlet weak var labelFavoriBrand: UILabel!
    @IBOutlet weak var labelFavoriPrice: UILabel!
    @IBOutlet weak var labelFavoriCategory: UILabel!
    @IBOutlet weak var labelFavoriName: UILabel!
    @IBOutlet weak var favoriImageView: UIImageView!
    
    override func awakeFromNib() {
          super.awakeFromNib()
      }

      func configure(with product: FavoriProduct) {
          labelFavoriName.text = product.ad
          labelFavoriBrand.text = product.marka
          labelFavoriCategory.text = product.kategori
          labelFavoriPrice.text = "\(product.fiyat) TL"

          if let imageUrl = URL(string: product.resim) {
              favoriImageView.kf.setImage(with: imageUrl)
          } else {
              favoriImageView.image = UIImage(named: "placeholder")  
          }
      }
  }
