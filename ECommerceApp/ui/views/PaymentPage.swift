//
//  PaymentPage.swift
//  ECommerceApp
//
//  Created by Oya Selmin Özcan on 13.10.2024.
//

import UIKit
import CoreLocation
import MapKit

class PaymentPage: UIViewController {
    
    @IBOutlet weak var buttonOtherOption: UIButton!
    @IBOutlet weak var buttonOption: UIButton!
    @IBOutlet weak var mapKit: MKMapView!
    
    let pickupPoints = [
        CLLocationCoordinate2D(latitude: 40.987220, longitude: 28.872380), // Bakırköy
        CLLocationCoordinate2D(latitude: 41.001590, longitude: 28.994800), // Zeytinburnu
        CLLocationCoordinate2D(latitude: 41.011840, longitude: 28.802820), // Florya
        CLLocationCoordinate2D(latitude: 40.980240, longitude: 28.814150), // Yeşilköy
        CLLocationCoordinate2D(latitude: 41.024380, longitude: 28.928530)  // Ataköy
    ]
    
    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    @IBAction func buttonOption(_ sender: UIButton) {
        if buttonOtherOption.currentImage == UIImage(systemName: "circle") {
                   buttonOtherOption.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                buttonOption.setImage(UIImage(systemName: "circle"), for: .normal)
               } else {
                   buttonOtherOption.setImage(UIImage(systemName: "circle"), for: .normal)
               }
    }
    
    @IBAction func buttonOtherOption(_ sender: UIButton) {
        if buttonOption.currentImage == UIImage(systemName: "circle") {
            buttonOption.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            buttonOtherOption.setImage(UIImage(systemName: "circle"), for: .normal)
        } else {
            buttonOption.setImage(UIImage(systemName: "circle"), for: .normal)
        }
       
    }
}
extension PaymentPage : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sonKonum = locations[locations.count-1]
        let enlem = sonKonum.coordinate.latitude
        let boylam = sonKonum.coordinate.longitude
        let hiz = sonKonum.speed
        let center = CLLocationCoordinate2D(latitude: enlem, longitude: boylam)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: center, span: span)
        mapKit.setRegion(region, animated: true)
        addPickupPoints()
        mapKit.showsUserLocation = true
    }
    
    private func addPickupPoints() {
        for point in pickupPoints {
            let annotation = MKPointAnnotation()
            annotation.coordinate = point
            annotation.title = "Gel-Al Noktası"
            annotation.subtitle = "Bu noktadan siparişinizi alabilirsiniz."
            mapKit.addAnnotation(annotation)
        }
    }
}

