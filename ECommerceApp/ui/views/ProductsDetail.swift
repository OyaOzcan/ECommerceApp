//
//  ProductsDetail.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import UIKit
import Kingfisher
import Lottie

class ProductsDetail: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var tfProductCount: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductCategory: UILabel!
    @IBOutlet weak var labelProductImage: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var buttonAddBasket: UIButton!
    @IBOutlet weak var labelProductBrand: UILabel!
    @IBOutlet weak var buttonFavorite: UIBarButtonItem!
    private var isFavorite = false
    var product:Products?
    var viewModel = ProductsDetailViewModel()
    var productQuantity = 1
    private var animationView: LottieAnimationView?
    var favoriViewModel = FavoriPageViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true) 
        
        tfProductCount.delegate = self
        tfProductCount.text = String(productQuantity)
        
        if let p = product {
            labelProductName.text = p.ad
            labelProductCategory.text = p.kategori
            labelProductPrice.text = String(p.fiyat!)
            labelProductBrand.text = p.marka
            labelProductImage.text = p.resim 
            if let resimAdi = p.resim {
                    let imageUrl = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(resimAdi)")
                            productImageView.kf.setImage(with: imageUrl)
            }
        }
        setupAnimation()
    }
    
    @IBAction func buttonIncrease(_ sender: Any) {
        productQuantity += 1
        tfProductCount.text = String(productQuantity)
        
    }
    
    @IBAction func buttonDecrease(_ sender: Any) {
        if productQuantity > 1 { // Adet 1'den küçük olamaz
                   productQuantity -= 1
                   tfProductCount.text = String(productQuantity)
               }
        
    }
    
    private func updateFavoriteButton() {
            let imageName = isFavorite ? "heart.fill" : "heart"
            buttonFavorite.image = UIImage(systemName: imageName)
        }

    
    @IBAction func buttonFavorite(_ sender: Any) {
        guard let product = product else { return }

                if isFavorite {
                    // Favoriden kaldır
                    favoriViewModel.sil(id: product.id ?? 0)
                } else {
                    // Favoriye ekle
                    let favoriProduct = FavoriProduct(
                        id: product.id ?? 0,
                        ad: product.ad ?? "",
                        resim: product.resim ?? "",
                        kategori: product.kategori ?? "",
                        fiyat: product.fiyat ?? 0,
                        marka: product.marka ?? "",
                        favori: 1
                    )
                    favoriViewModel.kaydet(
                        ad: product.ad ?? "",
                        resim: product.resim ?? "",
                        kategori: product.kategori ?? "",
                        fiyat: product.fiyat ?? 0,
                        marka: product.marka ?? "",
                        favori: 1
                    )
                }

                isFavorite.toggle()
                updateFavoriteButton()
    }

        
    @IBAction func buttonAddBasket(_ sender: Any) {
        if let name = labelProductName.text,let category = labelProductCategory.text, let image = labelProductImage.text,let price = Int(labelProductPrice.text!) , let brand = labelProductBrand.text {
            viewModel.addBasket(name: name, image: image, category: category, price: price, brand: brand, orderCount: productQuantity , nickname: "oya_ozcan")
            print("\(name) ~sepete \(productQuantity) adet eklendi ")
        }
        animationView?.play { [weak self] finished in
                    if finished {
                        print("Animasyon tamamlandı.")
                        self?.animationView?.currentProgress = 0
                        self?.animationView?.pause()
                    }
                }
        
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
           if let text = textField.text, let value = Int(text), value > 0 {
               productQuantity = value
           } else {
               productQuantity = 1
               tfProductCount.text = String(productQuantity)
           }
       }
    
    private func setupAnimation() {
        animationView = LottieAnimationView(name: "detailadd")

                guard let animationView = animationView else { return }

                animationView.frame = buttonAddBasket.bounds
                animationView.contentMode = .scaleAspectFit
                animationView.loopMode = .playOnce
                animationView.isUserInteractionEnabled = false

                buttonAddBasket.subviews.forEach { $0.removeFromSuperview() }
                buttonAddBasket.addSubview(animationView)
       }
}
