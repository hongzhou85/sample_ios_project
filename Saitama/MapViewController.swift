//  This is for project showcase only and not for commercial purposes.
//  Distribution or Redistribution and use in source and binary forms, with or without
//  modification, are strictly not allowed.
//
//  MapViewController.swift
//  Saitama
//
//  Created by hongzhou, Joe on 22/8/17.
//  Copyright © 2017 hongzhou. All rights reserved.
//  Email : tan.hongzhou@gmail.com
//

import UIKit
import MapKit
import CoreLocation
import SwiftyJSON
import STZPopupView
import SCLAlertView

class MapViewController : UIViewController, MKMapViewDelegate, RentPopupDelegate {
    
    @IBOutlet weak var mapView : MKMapView!
    @IBOutlet weak var historyButton : UIBarButtonItem!
    
    @IBAction func checkHistory() {
        let vc = PaymentHistoryController(nibName: "PaymentHistory", bundle: nil)

        self.present(vc, animated: true, completion: {
                
        })
    }
    
    var locationManager = CLLocationManager.init()
    var places : [Place] = []
    var annotations : [MKAnnotation] = []
    
    let placeInterface = PlaceInterface()
    let paymentInterface = PaymentInterface()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setupMap()
        fetchPlaces()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Basic map setup
    private func setupMap() {
        mapView.mapType = .standard
        mapView.showsScale = true
        mapView.showsCompass = true
        
        // Center to Saitama
        let saitamaRegionCenter = CLLocationCoordinate2D.init(latitude: SAITAMA_LAT, longitude: SAITAMA_LNG)
        let span = MKCoordinateSpan.init(latitudeDelta: 0.0075, longitudeDelta: 0.0075)
        let region = MKCoordinateRegion.init(center: saitamaRegionCenter, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    private func fetchPlaces() {
        
        placeInterface.listRentalPlace().continueWith { task in
            if task.cancelled {
                showError(message: "Connection was cancelled. Try again.")
            } else if task.faulted {
                showError(message: (task.error?.localizedDescription)!)
            } else {
                
                let jplaces : [JSON] = (task.result?["places"].arrayValue)!
                var idx = 0
                for place in jplaces {
                    let p : Place = Place(json: place)
                    let coordinate = CLLocationCoordinate2D.init(latitude: p.location.lat, longitude: p.location.lng)
                    
                    let a : MKAnnotation = MapAnnotation(index: idx, placeId: p.id, coordinate: coordinate, title: p.name, subtitle: "\(randomRating()) Stars")
                    
                    self.places.append(p)
                    self.annotations.append(a)
                    idx += 1
                }
                
                self.mapView.addAnnotations(self.annotations)
            }
        }
    }
    
    // Delegates for Map View
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        else {
            // Set icon and buttons for the annotations
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            annotationView.image = UIImage(named: "placeIcon")
            annotationView.canShowCallout = true
            
            let rentButton = UIButton(type: UIButtonType.custom)
            rentButton.imageEdgeInsets = UIEdgeInsets(top: 6,left: 60,bottom: 6,right: 6)
            rentButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: -30,bottom: 0,right: 34)
            rentButton.frame =  CGRect(x: 2, y: 74, width: 100, height: 40)
            rentButton.setTitle("RENT", for: .normal)
            rentButton.backgroundColor = UIColor.magenta
            rentButton.setImage(UIImage(named: "rentIcon"), for: UIControlState.normal)
            annotationView.rightCalloutAccessoryView = rentButton
            
            return annotationView
        }
    }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        guard view.annotation != nil else
        {
            return
        }
        
        // Set tapped actions for the annotations
        let a : MapAnnotation = view.annotation as! MapAnnotation
        let place = self.places[a.index!]
        let popupPaymentView = PaymentController(frame: CGRect(x: 0, y: 0, width: 300 , height: 425))
        popupPaymentView.place = place
        popupPaymentView.title.text = "Rent a bicycle at \(place.name!).\nProvide your credit card information"
        let popupConfig = STZPopupViewConfig()
        popupConfig.dismissTouchBackground = false
        popupPaymentView.popupDelegate = self
        self.presentPopupView(popupPaymentView, config: popupConfig)
    }

    // function the handle the rent action
    // cc : Credit Card information required
    //
    func rentNowPressed(cc : CreditCard) {
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: APP_TOKEN_KEY)
        
        paymentInterface.createPayment(token: token!, creditCard: cc).continueWith { task in
            if task.cancelled {
                showError(message: "Connection was cancelled. Try again.")
            } else if task.faulted {
                showError(message: (task.error?.localizedDescription)!)
            } else {
                // Object was successfully saved
                let json = task.result
                if let code = json?["code"].number {
                    switch code {
                    case 401:
                        showError(message: "You are not authorized to proceed with this transaction. Try login again?")
                    case 422:
                        showError(message: "Invaid submission. Try again?")
                    case 1002:
                        showError(message: "Seems like the location is not available. Contact us or try again?")
                    case 1003:
                        showError(message: "Check your credit card information, the credit card is invalid.")
                    case 1004:
                        self.dismissPopupView()
                        SCLAlertView().showSuccess("Booked!", subTitle: "You've successfully booked a bicycle.\nProceed to the location to collect it.")
                    default :
                        showError(message: "Unknown Error Code Encountered: \(code)")
                    }
                } else {
                    
                }
            }
        }
    }
    
    func cancelPressed() {
        dismissPopupView()
    }
    
}
