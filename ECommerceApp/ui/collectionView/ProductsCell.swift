//
//  CollectionViewCell.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import UIKit
import Kingfisher
import Lottie


class ProductsCell: UICollectionViewCell {
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductImage: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelProductBrand: UILabel!
    
    @IBOutlet weak var butonAddBasket: UIButton!
    var viewModel = HomepageViewModel()
    
    private var animationView: LottieAnimationView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAnimation()
    }

  /*  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    } */

    @IBAction func butonAddBasket(_ sender: Any) {
          if let name = labelProductName.text,let category = labelProductCategory.text, let image = labelProductImage.text,let price = Int(labelProductPrice.text!) , let brand = labelProductBrand.text {
              viewModel.addBasket(name: name, image: image, category: category, price: price, brand: brand, orderCount: 1, nickname: "oya_ozcan")
              print("\(name) ~sepete ekle tıklandı")
          }
        animationView?.play { [weak self] finished in
                    if finished {
                        print("Animasyon tamamlandı.")
                        // Animasyonu başlangıç pozisyonuna döndür
                        self?.animationView?.currentProgress = 0
                        self?.animationView?.pause()
                    }
                }
    }
    
    private func setupAnimation() {
        animationView = LottieAnimationView(name: "add")

                guard let animationView = animationView else { return }

                animationView.frame = butonAddBasket.bounds
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .playOnce
                animationView.isUserInteractionEnabled = false

                butonAddBasket.subviews.forEach { $0.removeFromSuperview() }
                butonAddBasket.addSubview(animationView)
       }
    
    func resimGoster(resimAd:String){
        if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAd)"){
            DispatchQueue.main.async {
                self.productImageView.kf.setImage(with: url)
            }
        }
    }
}
