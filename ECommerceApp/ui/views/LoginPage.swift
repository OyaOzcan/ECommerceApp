//
//  LoginPage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 19.10.2024.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginPage: UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var passwordToggleButton: UIButton!

       var isPasswordHidden = true

       override func viewDidLoad() {
           super.viewDidLoad()
           setupBackgroundImage()
           configurePasswordField() 
           self.navigationItem.hidesBackButton = true
        
       }

       private func setupBackgroundImage() {
           backgroundImage.contentMode = .scaleAspectFill
           backgroundImage.translatesAutoresizingMaskIntoConstraints = false
           backgroundImage.contentMode = .scaleAspectFill
           backgroundImage.clipsToBounds = true

           NSLayoutConstraint.activate([
               backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
               backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
               backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor)
               
           ])
       }

       private func configurePasswordField() {
           tfPassword.isSecureTextEntry = true
           passwordToggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)

           passwordToggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
       }

       @objc private func togglePasswordVisibility() {
           isPasswordHidden.toggle()
           tfPassword.isSecureTextEntry = isPasswordHidden

           let iconName = isPasswordHidden ? "eye.slash" : "eye"  
           passwordToggleButton.setImage(UIImage(systemName: iconName), for: .normal)
       }

       @IBAction func loginUser(_ sender: UIButton) {
           guard let email = tfEmail.text, !email.isEmpty,
                    let password = tfPassword.text, !password.isEmpty else {
                  showAlert(title: "Hata", message: "Lütfen tüm alanları doldurun.")
                  return
              }

              guard isValidPassword(password) else {
                  showAlert(title: "Geçersiz Şifre", message: "Şifre en az 6 karakter olmalıdır.")
                  return
              }

              Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                  if let error = error {
                      self.showAlert(title: "Giriş Hatası", message: error.localizedDescription)
                      return
                  }

                  DispatchQueue.main.async {
                      if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomePage") {
                          let navigationController = UINavigationController(rootViewController: homeVC)
                          navigationController.interactivePopGestureRecognizer?.isEnabled = false  // Geri swipe'ı engelle

                          UIApplication.shared.windows.first?.rootViewController = navigationController
                          UIApplication.shared.windows.first?.makeKeyAndVisible()
                      }
                  }
              }
       }

       private func isValidPassword(_ password: String) -> Bool {
           return password.count >= 6
       }

       private func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Tamam", style: .default))
           present(alert, animated: true)
       }
   }
