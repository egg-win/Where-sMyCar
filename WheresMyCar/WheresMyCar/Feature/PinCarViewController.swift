//
//  PinCarViewController.swift
//  WheresMyCar
//
//  Created by AllenLai on 2019/4/2.
//  Copyright © 2019 EggWin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PinCarViewController: BaseViewController {
    // MARK: - Properties
    enum CarStatus {
        case unpark
        case parking
        case gettingCar
        case didGetCar
    }
    
    // UI
    lazy var mapView: MKMapView = {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = self
        mapView.isZoomEnabled = true
        mapView.mapType = .standard
        mapView.showsTraffic = true
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        return mapView
    }()
    
    lazy var addressLabel: ALLabel = {
        let label = ALLabel(frame: .zero)
        label.backgroundColor = .white
        label.layer.cornerRadius = .defaultCornerRadius
        label.lineBreakMode = .byTruncatingHead
        label.text = "..."
        label.textColor = .darkGray
        layerConfigurator.configure(layer: label.layer)
        return label
    }()
    
    lazy var pinCarButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(pinCar(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.layer.cornerRadius = .largeButtonHeight / 2
        button.setTitle("🚀", for: .normal)
        layerConfigurator.configure(layer: button.layer)
        return button
    }()
    
    let layerConfigurator: LayerConfigurator = {
        let layerConfigurator = LayerConfigurator()
        layerConfigurator.setup(shadowStyle: LayerShadowStyle(cornerRadius: nil,
                                                              shadowOpacity: 0.5,
                                                              shadowOffset: CGSize(width: 0, height: 1),
                                                              shadowRadius: 1))
        return layerConfigurator
    }()
    
    // Location
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        return locationManager
    }()
    
    var currentLocation: CLLocation?
    lazy var geocoder = CLGeocoder()
//    lazy var paragraphStyle: NSParagraphStyle = {
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.firstLineHeadIndent = .defaultMargin
//        paragraphStyle.headIndent = .defaultMargin
//        paragraphStyle.tailIndent = CGFloat.defaultMargin.negativeValue
//        return paragraphStyle
//    }()
    
    var carStatus: CarStatus = .unpark
    var carLocationCoordinate: CLLocationCoordinate2D?
    
    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Inherit method
    override func setupAuth() {
        super.setupAuth()
        
        AuthManager.setupAuth(with: .location, notDetermined: { _ in
            locationManager.requestWhenInUseAuthorization()
        }, success: { _ in
            locationManager.startUpdatingLocation()
        }, failure: { _ in
            UIAlertController.remindAlert(title: "提醒", message: "請開啟地圖權限")
        })
    }
    
    override func setupUI() {
        super.setupUI()
        
        title = "Where's my car"
        
        view.addSubview(mapView, constraints: [
            UIView.anchorConstraintEqual(with: \UIView.topAnchor),
            UIView.anchorConstraintEqual(with: \UIView.leadingAnchor),
            UIView.anchorConstraintEqual(with: \UIView.bottomAnchor),
            UIView.anchorConstraintEqual(with: \UIView.trailingAnchor)
            ])
        
        view.addSubview(addressLabel, constraints: [
            UIView.anchorConstraintEqual(with: \UIView.topAnchor, constant: .defaultMargin),
            UIView.anchorConstraintEqual(with: \UIView.leadingAnchor, constant: .defaultMargin),
            UIView.anchorConstraintEqual(with: \UIView.trailingAnchor, constant: CGFloat.defaultMargin.negativeValue),
            UIView.dimensionConstraintEqual(with: \UIView.heightAnchor, constant: .defaultViewHeight)
            ])
        
        view.addSubview(pinCarButton, constraints: [
            UIView.anchorConstraintEqual(with: \UIView.bottomAnchor, constant: CGFloat.defaultMargin.negativeValue * 2),
            UIView.anchorConstraintEqual(with: \UIView.trailingAnchor, constant: CGFloat.defaultMargin.negativeValue * 2),
            UIView.dimensionConstraintEqual(with: \UIView.heightAnchor, constant: .largeButtonHeight),
            UIView.dimensionConstraintEqual(withViewKeyPath1: \UIView.heightAnchor, viewKeyPath2: \UIView.widthAnchor)
            ])
    }
    
    override func setupData() {
        super.setupData()
        
        let carLocation = LocalStorageManager.shared.location()
        guard let latitude = carLocation.latitude, latitude != 0.0, let longitude = carLocation.longitude, longitude != 0.0  else {
            carStatus = .unpark
            return
        }
        
        carLocationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let carAnnotation = MKPointAnnotation()
        carAnnotation.title = "你的車停在這裡"
        carAnnotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapView.addAnnotation(carAnnotation)
        carStatus = .parking
    }
    
    // MARK: - Event
    @objc func pinCar(_ sender: UIButton) {
        switch carStatus {
        case .unpark: parking()
        case .parking: navigate()
        case .gettingCar: didGetCar()
        case .didGetCar: break
        }
    }
    
    // MARK: - Private method
    private func parking() {
        printLog("parking", level: .log)
        
        guard let currentLocationCoordinate = currentLocation?.coordinate else { return }
        let localStorageManager = LocalStorageManager.shared
        localStorageManager.setLatitude(currentLocationCoordinate.latitude)
        localStorageManager.setLongitude(currentLocationCoordinate.longitude)
        
        UIAlertController.remindAlert(title: "提醒", message: "已設定停車位置")
        
        carLocationCoordinate = currentLocationCoordinate
        let carAnnotation = MKPointAnnotation()
        carAnnotation.title = "你的車停在這裡"
        carAnnotation.coordinate = currentLocationCoordinate
        mapView.addAnnotation(carAnnotation)
        
        carStatus = .parking
        pinCarButton.setTitle("🏎🏃‍♂️", for: .normal)
    }
    
    private func navigate() {
        printLog("navigate", level: .log)
        
        // TODO: navigate user to car
        guard let currentLocationCoordinate = currentLocation?.coordinate,
            let carLocationCoordinate = carLocationCoordinate else { return }
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocationCoordinate))
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: carLocationCoordinate))
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [weak self] (response, error) in
            guard let strongSelf = self,
                let response = response,
                let route = response.routes.first else { return }
            
            strongSelf.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            let rect = route.polyline.boundingMapRect
            strongSelf.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
        
        carStatus = .gettingCar
        pinCarButton.setTitle("🏎💨", for: .normal)
    }
    
    private func didGetCar() {
        printLog("navigate", level: .log)
        
        carLocationCoordinate = nil
        LocalStorageManager.shared.removeLocation()
        mapView.removeAnnotations(mapView.annotations)
        
        UIAlertController.remindAlert(title: "恭喜", message: "車開走囉")
        
        carStatus = .unpark
        pinCarButton.setTitle("🚀", for: .normal)
    }
}

// MARK: - MKMapViewDelegate
extension PinCarViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .appleBlue
        renderer.lineWidth = 3.0
        return renderer
    }
}

// MARK: - CLLocationManagerDelegate
extension PinCarViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        printLog("locationManager did update locations: \(location.coordinate)", level: .log)
        
        // Set currentLocation for user pin car location.
        currentLocation = location
        
        // Set region at the first time.
        mapView.focusRegion(with: location.coordinate)
        
        // Get geocode.
        geocoder.addressLocation(from: location) { [weak self] placemark in
            guard let strongSelf = self else { return }
            
            let placemarkString = "\(placemark.postalCode ?? "")\(placemark.subAdministrativeArea ?? "")\(placemark.locality ?? "")\(placemark.name ?? "")附近"
            strongSelf.addressLabel.text = placemarkString
//            strongSelf.addressLabel.attributedText = NSAttributedString(string: placemarkString, attributes: [.paragraphStyle: strongSelf.paragraphStyle])
            
            printLog(placemark, level: .log)
        }
    }
}
