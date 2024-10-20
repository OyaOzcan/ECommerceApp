//
//  FavoriPage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 15.10.2024.
//

import UIKit
import RxSwift

class FavoriPage: UIViewController {
    
    @IBOutlet weak var favoriTableView: UITableView!
    var favoriProductList = [FavoriProduct]()
    
    var viewModel = FavoriPageViewModel()
       let disposeBag = DisposeBag()

       override func viewDidLoad() {
           super.viewDidLoad()
           self.navigationItem.hidesBackButton = true

           setupTableView()
           bindViewModel()
       }

       override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           viewModel.favoriYukle() // Favori ürünleri yükle
       }

       private func setupTableView() {
           favoriTableView.delegate = self
           favoriTableView.dataSource = self
           favoriTableView.rowHeight = 110
       }

       private func bindViewModel() {
           viewModel.favoriProductList
               .observe(on: MainScheduler.instance)
               .subscribe(onNext: { [weak self] liste in
                   self?.favoriProductList = liste
                   self?.favoriTableView.reloadData()
               })
               .disposed(by: disposeBag)
       }
   }

   extension FavoriPage: UITableViewDelegate, UITableViewDataSource {

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return favoriProductList.count
       }

       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard indexPath.row < favoriProductList.count else {
               print("Hatalı index erişimi: \(indexPath.row)")
               return UITableViewCell()
           }

           let cell = tableView.dequeueReusableCell(withIdentifier: "favoriCell", for: indexPath) as! FavoriCell
           configureCell(cell, with: favoriProductList[indexPath.row])
           return cell
       }

       private func configureCell(_ cell: FavoriCell, with product: FavoriProduct) {
           cell.labelFavoriCategory.text = product.kategori
           cell.labelFavoriName.text = product.ad
           cell.labelFavoriBrand.text = product.marka
           cell.labelFavoriPrice.text = String(product.fiyat)

           if let url = URL(string: "http://kasimadalan.pe.hu/urunler/resimler/\(product.resim)") {
               cell.favoriImageView.kf.setImage(with: url)
           }
       }

       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let favori = favoriProductList[indexPath.row]
           print("\(favori.ad) seçildi")
           tableView.deselectRow(at: indexPath, animated: true)
       }

       func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           let silAction = UIContextualAction(style: .destructive, title: "sil") {_,_,_ in //contextualAction, view, bool anlamına geliyor onları temsil ediyor
               let favori = self.favoriProductList[indexPath.row]
               let alert = UIAlertController(title: "Silme İşlemi", message: "\(favori.ad) ~ silinsin mi???", preferredStyle: .alert)
               let iptalAction = UIAlertAction(title: "iptal", style: .cancel)
               alert.addAction(iptalAction)
               let evetAction = UIAlertAction(title: "Evet", style: .destructive) { action in
                   //print("Kisi sil : \(kisi.kisi_id!)")
                   self.viewModel.sil(id: favori.id)
               }
               alert.addAction(evetAction)
               self.present(alert, animated: true)
           }
           return UISwipeActionsConfiguration(actions: [silAction])
       }

     
   }
