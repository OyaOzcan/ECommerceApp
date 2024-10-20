//
//  ProfilePage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 19.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfilePage: UIViewController {

    @IBOutlet weak var labelNameSurname: UILabel!
    @IBOutlet weak var labelEmail: UILabel!

    @IBOutlet weak var profileTableView: UITableView!
    let db = Firestore.firestore()
    let profileOptions = [
           ("Önceki Siparişlerim", UIImage(systemName: "cart")!),
           ("Sipariş Takibi", UIImage(systemName: "map")!),
           ("İndirim Kuponlarım", UIImage(systemName: "tag")!),
           ("Ürün Yorumlarım", UIImage(systemName: "text.bubble")!),
           ("Canlı Destek", UIImage(systemName: "headphones")!)
       ]

    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        
        profileTableView.rowHeight = 75
        profileTableView.estimatedRowHeight = 75
        profileTableView.separatorColor = .lightGray
        fetchUserData()
    }

    private func fetchUserData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userID).getDocument { (document, error) in
            if let error = error {
                print("Veri çekme hatası: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? "Ad Yok"
                let surname = data?["surname"] as? String ?? "Soyad Yok"
                let email = data?["email"] as? String ?? "Email Yok"

                // UI'yi güncelle
                self.labelNameSurname.text = "\(name) \(surname)"
                self.labelEmail.text = email
            } else {
                print("Kullanıcı verisi bulunamadı.")
            }
        }
    }
    
    @IBAction func buttonLogout(_ sender: Any) {
        do {
                  try Auth.auth().signOut()
                  navigateToLogin()
              } catch let signOutError as NSError {
                  print("Çıkış yapılamadı: \(signOutError.localizedDescription)")
              }
    }
    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "goLoginPage") as? LoginPage else {
            print("LoginPage bulunamadı.")
            return
        }

        if let navController = self.navigationController {
            navController.pushViewController(loginVC, animated: true)
        } else {
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: true, completion: nil)
        }
    }
}

extension ProfilePage: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! ProfileCell
        let option = profileOptions[indexPath.row]
        cell.labelProfile.text = option.0 
        cell.profileImageView.image = option.1

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        case 0:
            print("Önceki Siparişlerim seçildi")
        case 1:
            print("Sipariş Takibi seçildi")
        case 2:
            print("İndirim Kuponlarım seçildi")
        case 3:
            print("Ürün Yorumlarım seçildi")
        case 4:
            print("Canlı Destek seçildi")
        default:
            break
        }
    }
}
