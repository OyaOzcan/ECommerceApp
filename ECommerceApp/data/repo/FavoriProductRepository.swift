import Foundation
import RxSwift

class FavoriProductRepository {

    var favoriProductList = BehaviorSubject<[FavoriProduct]>(value: [])
    let db: FMDatabase?

    init() {
        let hedefYol = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let veritabaniURL = URL(fileURLWithPath: hedefYol).appendingPathComponent("favori.sqlite")
        db = FMDatabase(path: veritabaniURL.path)
    }

    func favoriEkle(ad: String, resim: String, kategori: String, fiyat: Int, marka: String, favori: Int) {
        db?.open()
        do {
            try db!.executeUpdate(
                """
                INSERT OR REPLACE INTO favori (ad, resim, kategori, fiyat, marka, favori)
                VALUES (?, ?, ?, ?, ?, ?)
                """,
                values: [ad, resim, kategori, fiyat, marka, favori]
            )
            print("\(ad) favorilere eklendi.")
            favoriUrunleriYukle()
        } catch {
            print("Ekleme hatası: \(error.localizedDescription)")
        }
        db?.close()
    }

    func sil(id: Int) {
        db?.open()
        do {
            try db!.executeUpdate("DELETE FROM favori WHERE id = ?", values: [id])
            print("Ürün favorilerden silindi.")
        } catch {
            print("Silme hatası: \(error.localizedDescription)")
        }
        db?.close()
    }
   

    func favoriUrunleriYukle() {
        db?.open()
        var liste = [FavoriProduct]()
        do {
            let rs = try db!.executeQuery("SELECT * FROM favori", values: nil)
            while rs.next() {
                let product = FavoriProduct(
                    id: Int(rs.int(forColumn: "id")),
                    ad: rs.string(forColumn: "ad") ?? "",
                    resim: rs.string(forColumn: "resim") ?? "",
                    kategori: rs.string(forColumn: "kategori") ?? "",
                    fiyat: Int(rs.int(forColumn: "fiyat")),
                    marka: rs.string(forColumn: "marka") ?? "",
                    favori: Int(rs.int(forColumn: "favori"))
                )
                liste.append(product)
            }
            favoriProductList.onNext(liste)
        } catch {
            print("Yükleme hatası: \(error.localizedDescription)")
        }
        db?.close()
    }
}
