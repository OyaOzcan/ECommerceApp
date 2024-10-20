import Foundation
import RxSwift

class FavoriPageViewModel {

    var frepo = FavoriProductRepository()
    var favoriProductList = BehaviorSubject<[FavoriProduct]>(value: [])

    init() {
        favoriProductList = frepo.favoriProductList
        favoriYukle()
    }

    func kaydet(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, favori: Int) {
        frepo.favoriEkle(ad: ad, resim: resim, kategori: kategori, fiyat: fiyat, marka: marka, favori: favori)
    }

    func sil(id: Int) {
        frepo.sil(id: id)
        favoriYukle()
    }

    func favoriYukle() {
        frepo.favoriUrunleriYukle()
    }
}
