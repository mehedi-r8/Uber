//
//  HomeVC.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/24/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import UIKit
import MapKit
import RevealingSplashView
import CoreLocation
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var actionBtn: RoundedShadowButton!
    @IBOutlet weak var centerBtn: UIButton!
    @IBOutlet weak var destinationTxtField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var destinationCircle: CircleView!
    
    var matchingLocation: [MKMapItem] = [MKMapItem]()
    var selectedPlacemrk: MKPlacemark? = nil
    
    var tableView = UITableView()
    
    var manager: CLLocationManager?
    
    var route: MKRoute!
    
    var regionRadius: CLLocationDistance = 500
    
    var delegate: CenterVCDelegate?
    
    
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "splash")!, iconInitialSize: CGSize(width: 90, height: 90), backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupView()
        manager = CLLocationManager()
        manager?.delegate = self
        manager?.desiredAccuracy = kCLLocationAccuracyBest
        checkLocationAuthStatus()
        mapView.delegate = self
        centerMapOnUserLocation()
        destinationTxtField.delegate = self
        
        DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
            self.loadDriverAnnotationFromFB()
        }
        
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.minimumBeats = 4
        revealingSplashView.heartAttack = true
    }
    
    
//    func setupView() {
//        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeVC.handleTap))
//        view.addGestureRecognizer(tap)
//    }
//
//    //Handle Keyboard
//    @objc func handleTap() {
//        view.endEditing(true)
//    }
    
    func checkLocationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            manager?.startUpdatingLocation()
        } else {
            manager?.requestAlwaysAuthorization()
        }
    }
    
    func loadDriverAnnotationFromFB() {
    
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let driverSnapShot = snapshot.children.allObjects as? [DataSnapshot] {
                for driver in driverSnapShot {
                    if driver.hasChild("userIsDriver") {
                        
                        if driver.hasChild("coordinate") {
                            if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                                if let driverDict = driver.value as? Dictionary<String, AnyObject> {
                                    let coordinateArray = driverDict["coordinate"] as! NSArray
                                    let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    
                                    let annotation = DriverAnnotation(coordinate: driverCoordinate, withkey: driver.key)
                                    self.mapView.addAnnotation(annotation)
                                    
                                    var driverIsVisible: Bool {
                                        return self.mapView.annotations.contains(where: { (anotation) -> Bool in
                                             if let driverAnnotation = annotation as? DriverAnnotation {
                                                if driverAnnotation.key == driver.key {
                                                    driverAnnotation.update(annotationPosition: driverAnnotation, withCoordinate: driverCoordinate)
                                                    return true
                                                }
                                            }
                                            return false
                                        })
                                    }
                                    if !driverIsVisible {
                                        self.mapView.addAnnotation(annotation)
                                    }
                                }
                            } else {
                                for annotation in self.mapView.annotations {
                                    if annotation.isKind(of: DriverAnnotation.self) {
                                        if let annotation = annotation as? DriverAnnotation{
                                            if annotation.key == driver.key {
                                                self.mapView.removeAnnotation(annotation)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func actionBtnPressed(_ sender: Any) {
        actionBtn.animateButton(shouldLoad: true, withMessage: nil)
        
    }
    @IBAction func centerMapBtnPressed(_ sender: Any) {
        centerMapOnUserLocation()
        centerBtn.fadeTo(alphaValue: 0.0, withDuration: 0.2)
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
        
    }
}



