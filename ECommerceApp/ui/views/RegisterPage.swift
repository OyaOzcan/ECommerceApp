//
//  RegisterPage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 19.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterPage: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfSurname: UITextField!
    @IBOutlet weak var tfEmailRegister: UITextField!
    @IBOutlet weak var tfPasswordRegister: UITextField!
    
    
    let db = Firestore.firestore() 

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        backgroundImage.contentMode = .scaleAspectFill
                backgroundImage.translatesAutoresizingMaskIntoConstraints = false
                backgroundImage.clipsToBounds = true

                NSLayoutConstraint.activate([
                    backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
                    backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
    }

    @IBAction func registerUser(_ sender: UIButton) {
        guard let name = tfName.text, !name.isEmpty,
                      let surname = tfSurname.text, !surname.isEmpty,
                      let email = tfEmailRegister.text, !email.isEmpty,
                      let password = tfPasswordRegister.text, !password.isEmpty else {
                    showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
                    return
                }

                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    if let error = error {
                        self.showAlert(title: "Kayıt Hatası", message: error.localizedDescription)
                        return
                    }

                    guard let userID = authResult?.user.uid else { return }

                    self.db.collection("users").document(userID).setData([
                        "name": name,
                        "surname": surname,
                        "email": email,
                        "uid": userID
                    ]) { error in
                        if let error = error {
                            self.showAlert(title: "Hata", message: "Veritabanına kaydedilirken hata: \(error.localizedDescription)")
                        } else {
                            self.navigateToHomePage()
                        }
                    }
                }
    }

     func navigateToHomePage() {
          let storyboard = UIStoryboard(name: "Main", bundle: nil)
          guard let homeVC = storyboard.instantiateViewController(withIdentifier: "HomePage") as? UIViewController else {
              print("HomePage bulunamadı.")
              return
          }

          let navController = UINavigationController(rootViewController: homeVC)
          navController.modalPresentationStyle = .fullScreen
          navController.setNavigationBarHidden(true, animated: false)  

          if let window = UIApplication.shared.windows.first {
              window.rootViewController = navController
              window.makeKeyAndVisible()
          }
      }
    
     func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
