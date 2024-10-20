//
//  BasketPage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import UIKit
import Kingfisher

class BasketPage: UIViewController {
    
    @IBOutlet weak var productsBasketTableView: UITableView!
    
    @IBOutlet weak var labelTotalPrice: UILabel!
    var basketProductsList = [ProductsBasket]()
    
    var viewModel = BasketpageViewModel ()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        productsBasketTableView.delegate = self
        productsBasketTableView.dataSource = self
        productsBasketTableView.isScrollEnabled = true
        productsBasketTableView.translatesAutoresizingMaskIntoConstraints = false
           
           NSLayoutConstraint.activate([
               productsBasketTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               productsBasketTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
               productsBasketTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
               productsBasketTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
           ])
        productsBasketTableView.rowHeight = 130
        productsBasketTableView.estimatedRowHeight = 130
        productsBasketTableView.separatorStyle = .none
        
        _ = viewModel.basketProductsList.subscribe(onNext: { list in
            self.basketProductsList = list
            DispatchQueue.main.async {
                self.productsBasketTableView.reloadData()
                self.calculateTotalPrice()
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getBasketProducts()
        print("burası")
        print(viewModel.getBasketProducts())
    }

    func calculateTotalPrice() {
        let totalPrice = basketProductsList.reduce(0) { result, product in
            let productTotal = (product.fiyat ?? 0) * (product.siparisAdeti ?? 1)
            return result + productTotal
        }
        labelTotalPrice.text = "Toplam: \(totalPrice) ₺"
    }
}


extension BasketPage: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(basketProductsList)
           print(basketProductsList.count)
           return basketProductsList.count
       }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "basketProductCell", for: indexPath) as! ProductBasketCell
           let basketProduct = basketProductsList[indexPath.item]
           cell.labelProductBasketName.text = basketProduct.ad
           cell.labelProductBasketCategory.text = basketProduct.kategori
           cell.labelProductBasketBrand.text = basketProduct.marka
           cell.labelProductBasketPrice.text = String(basketProduct.fiyat!)
            cell.labelOrderCount.text = String(basketProduct.siparisAdeti!)
        print("sepetim:")
        print("ensonnnn")
        print(basketProduct.resim!)
        print("bitiş")
            cell.resimGoster(resimAd: basketProduct.resim!)
           return cell
       }
       
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = .clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let basketProduct = basketProductsList[indexPath.item]
           print("\(basketProduct.ad!) seçildi")
       }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
          let silAction = UIContextualAction(style: .destructive, title: "Sil") { _, _, completionHandler in
              let product = self.basketProductsList[indexPath.item]
              let alert = UIAlertController(title: "Silme İşlemi", message: "\(product.ad ?? "Ürün") silinsin mi?", preferredStyle: .alert)

              let iptalAction = UIAlertAction(title: "İptal", style: .cancel) { _ in
                  completionHandler(false)
              }
              alert.addAction(iptalAction)

             let evetAction = UIAlertAction(title: "Evet", style: .destructive) { _ in
                  self.viewModel.delete(basketId: product.sepetId!)
                  
              
                  self.basketProductsList.remove(at: indexPath.item)
                  self.viewModel.getBasketProducts()
                  
                  DispatchQueue.main.async {
                      self.productsBasketTableView.performBatchUpdates({
                          self.productsBasketTableView.deleteRows(at: [indexPath], with: .automatic)
                          
                      }) { _ in
                          self.calculateTotalPrice()
                      }
                  }
                  completionHandler(true)
              }
              
              alert.addAction(evetAction)

              self.present(alert, animated: true)
          }

          return UISwipeActionsConfiguration(actions: [silAction])
      }
  }
