//
//  ViewController.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 7.10.2024.
//

import UIKit
import RxSwift

class HomePage: UIViewController {

    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    var allProductsList = [Products]()
    var productsList = [Products]()
    var categoryList = ["Tüm Ürünler", "Teknoloji", "Kozmetik", "Aksesuar"]
    var filterProductsList = [Products]()
    var categorizedProducts = [String: [Products]]()
    private let disposeBag = DisposeBag()
    let assetNames = ["kategori", "kategori1", "kategori3", "kategori2"]
    let assetAdNames = ["ads1", "ads2", "ads3", "ads4"]
    var adsList = ["Kampanya 1", "Özel İndirim", "Yeni Ürün", "Fırsatlar"] 

    
    var viewModel = HomepageViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        
        let adsLayout = UICollectionViewFlowLayout()
        adsLayout.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        adsLayout.minimumInteritemSpacing = 10
        adsLayout.minimumLineSpacing = 10

        let totalSpacing = adsLayout.sectionInset.left + adsLayout.sectionInset.right + adsLayout.minimumInteritemSpacing
        let itemWidth = (view.frame.width - totalSpacing) / 2
        adsLayout.itemSize = CGSize(width: 225, height: 100)

        adsLayout.scrollDirection = .horizontal
        adsCollectionView.collectionViewLayout = adsLayout

        adsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            adsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                adsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                adsCollectionView.bottomAnchor.constraint(equalTo: categoriesCollectionView.topAnchor, constant: -30),
                adsCollectionView.heightAnchor.constraint(equalToConstant: 120)
            
        ])
        
        let productsLayout = UICollectionViewFlowLayout()
        productsLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        productsLayout.minimumInteritemSpacing = 5
        productsLayout.minimumLineSpacing = 5
        let screenWidth = UIScreen.main.bounds.width
        let productItemWidth = (screenWidth - 45) / 2
        productsLayout.itemSize = CGSize(width: productItemWidth, height: productItemWidth * 1.25)
        
        productsCollectionView.collectionViewLayout = productsLayout
        productsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
              productsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
              productsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
              productsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
              productsCollectionView.heightAnchor.constraint(equalToConstant: 375)
        ])

           let categoriesLayout = UICollectionViewFlowLayout()
           categoriesLayout.scrollDirection = .horizontal
           categoriesLayout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
           categoriesLayout.minimumInteritemSpacing = 0
           categoriesLayout.minimumLineSpacing = 25
           let categoryItemWidth = (screenWidth - 150) / 4
           categoriesLayout.itemSize = CGSize(width: 85, height: 100)
        
           categoriesCollectionView.collectionViewLayout = categoriesLayout
           categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
            categoriesCollectionView.bottomAnchor.constraint(equalTo: productsCollectionView.topAnchor, constant: -50),
                categoriesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                categoriesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
                categoriesCollectionView.heightAnchor.constraint(equalToConstant: categoryItemWidth + 25)
           ])
        
        _ = viewModel.productsList.subscribe(onNext: { list in
            self.allProductsList = list
            self.productsList = list
            self.filterProductsList = list
            DispatchQueue.main.async {
                self.productsCollectionView.reloadData()
            }
        })
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getProducts()
        print(viewModel.getProducts())
    }

    @IBAction func buttonFilter(_ sender: Any) {
        let alert = UIAlertController(title: "Filtreleme Seçenekleri", message: "Bir filtre seçin", preferredStyle: .actionSheet)
        
        let artanFiyatAction = UIAlertAction(title: "Artan Fiyat", style: .default) { action in
            self.productsList.sort { $0.fiyat! < $1.fiyat! }
            self.productsCollectionView.reloadData()
        }
        
        let azalanFiyatAction = UIAlertAction(title: "Azalan Fiyat", style: .default) { action in
            self.productsList.sort { $0.fiyat! > $1.fiyat! }
            self.productsCollectionView.reloadData()
        }
        
        let ismeGoreAction = UIAlertAction(title: "İsme Göre", style: .default) { action in
            self.productsList.sort { $0.ad! < $1.ad! }
            self.productsCollectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        
        alert.addAction(artanFiyatAction)
        alert.addAction(azalanFiyatAction)
        alert.addAction(ismeGoreAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func filterProducts(by category: String) {
        productsList = allProductsList.filter { $0.kategori == category }
        productsCollectionView.reloadData()
    }
    
    func showAllProducts() {
        productsList = allProductsList // Ana listeyi geri yükle
        productsCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            if let product = sender as? Products {
                let gidilecekVC = segue.destination as! ProductsDetail
                gidilecekVC.product = product
            }
        }
    }
}

extension HomePage : UISearchBarDelegate  {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            viewModel.getProducts()
        }
        else {
            viewModel.searchProducts(searchText: searchText)
        }
    }
}


extension HomePage: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
                    return categoryList.count
                } 
        else if collectionView == productsCollectionView {
            return productsList.count
        }
        else if collectionView == adsCollectionView {
                return adsList.count
            }
        else {
                return adsList.count
            }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == categoriesCollectionView {
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoriesCell
                        cell.labelCategory.text = categoryList[indexPath.item]
                        cell.layer.cornerRadius = 15
                        cell.backgroundColor = .red
                        if indexPath.item < assetNames.count {
                           cell.categoryImageView.image = UIImage(named: assetNames[indexPath.item])
                       }
                      return cell
                  }
            else if collectionView == productsCollectionView  {
                      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductsCell
                      let product = productsList[indexPath.item]
                      cell.labelProductName.text = product.ad
                      cell.labelProductCategory.text = product.kategori
                      cell.labelProductBrand.text = product.marka
                      cell.labelProductPrice.text = String(product.fiyat ?? 0)
                      cell.labelProductImage.text = product.resim
                      cell.resimGoster(resimAd: product.resim!)
                cell.layer.cornerRadius = 15
                    //cell.backgroundColor = .white
                      return cell
                  }
                    else if collectionView == adsCollectionView  {
                        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adCell", for: indexPath) as! AdsCell
                        cell.layer.cornerRadius = 20
                        cell.backgroundColor = .red
                        if indexPath.item < assetAdNames.count {
                            let backgroundImage = UIImageView(image: UIImage(named: assetAdNames[indexPath.item]))
                            backgroundImage.contentMode = .scaleAspectFill
                            cell.backgroundView = backgroundImage
                        }
                       /* cell.backgroundView =
                        if indexPath.item < assetAdNames.count {
                           cell.adsImageView.image = UIImage(named: assetAdNames[indexPath.item])
                       } */
                        return cell
                    }
           return UICollectionViewCell()
       }
    
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if collectionView == categoriesCollectionView {
                   let selectedCategory = categoryList[indexPath.item]
                   
                   if selectedCategory == "Tüm Ürünler" {
                       productsList = allProductsList
                   } else {
                       filterProducts(by: selectedCategory)
                   }
                   productsCollectionView.reloadData()
               }  else {
                      let product = productsList[indexPath.item]
                      performSegue(withIdentifier: "toDetail", sender: product)
                  }
           
       }
}
