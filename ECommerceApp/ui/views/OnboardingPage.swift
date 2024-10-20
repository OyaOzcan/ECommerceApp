//
//  OnboardingPage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 19.10.2024.
//

import UIKit
import Lottie

class OnboardingPage: UIViewController {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var buttonSkip: UIButton!
    
    let onboardingData = [
           (
               "Hoş Geldiniz!",
               "Binlerce ürünü tek tıkla keşfedin ve favorilerinize ekleyin.",
               "shopping_bag"
           ),
           (
               "Güvenli Ödeme",
               "Kolay ve güvenli ödeme seçenekleriyle alışveriş yapın.",
               "payment_security"
           ),
           (
               "Hızlı Teslimat",
               "Siparişleriniz kapınıza kadar hızlıca gelsin.",
               "fast_delivery"
           )
       ]

       var currentPage = 0
       var lottieAnimation: LottieAnimationView?

       // View yüklenirken çalışır
       override func viewDidLoad() {
           super.viewDidLoad()
           setupPageControl()  // Buton stillerini ayarla
           updateUI()
       }

       @IBAction func nextButtonTapped(_ sender: UIButton) {
           if currentPage < onboardingData.count - 1 {
               currentPage += 1
               updateUI()
           } else {
               navigateToLogin()
           }
       }

       @IBAction func skipButtonTapped(_ sender: UIButton) {
           navigateToLogin()
       }
    
       private func setupPageControl() {
           pageControl.numberOfPages = onboardingData.count
           pageControl.currentPage = 0
           pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)
       }
    
       private func updateUI() {
           let data = onboardingData[currentPage]
           labelTitle.text = data.0
           labelDescription.text = data.1
           pageControl.currentPage = currentPage

           let isLastPage = currentPage == onboardingData.count - 1
           nextButton.setTitle(isLastPage ? "Alışverişe Başla" : "Devam", for: .normal)
           buttonSkip.isHidden = isLastPage  // Son sayfadaysa Skip butonunu gizle

           playAnimation(named: data.2)
       }

       private func playAnimation(named name: String) {
           lottieAnimation?.removeFromSuperview()

           lottieAnimation = LottieAnimationView(name: name)
           lottieAnimation?.frame = animationView.bounds
           lottieAnimation?.contentMode = .scaleAspectFit
           lottieAnimation?.loopMode = .loop
           lottieAnimation?.play()

           if let animation = lottieAnimation {
               animationView.addSubview(animation)
           }
       }
    
    private func navigateToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "goLoginPage") as? LoginPage {
            navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    @objc private func pageControlChanged(_ sender: UIPageControl) {
           currentPage = sender.currentPage
           updateUI()
       }
   }
