//
//  FirstViewController.swift
//  OopsTunnel
//
//  Created by Nicolas Pessemier on 2019-06-14.
//  Copyright © 2019 Coyote Lab. All rights reserved.
//

import UIKit
import MapKit

// MARK: - MapViewController

public class MapViewController: UIViewController {

    // MARK: Private @IBOutlet
    
    @IBOutlet weak var mapView: MKMapView!

    enum AnnotionIdentfier: String {
        case carView
    }

    // MARK: Private propreties

    public var kDefaultRadius = 800.0
    public var currentCenter = CLLocationCoordinate2D(latitude: 48.40589683781286, longitude: -4.50762325061973)
    public var currentAnnotations: [MapAnnotation] {
        return self.mapView.annotations.compactMap { $0 as? MapAnnotation }
    }

    private var carTimer: Timer?

    // MARK: LifeCycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = false
        self.mapView.mapType = .standard
        self.mapView.showsCompass = true
        self.mapView.delegate = self
    }

    // MARK: Methods

    public func addAnnotation(with mapAnnotation: MapAnnotation)  {
        let currentAnnotations = self.currentAnnotations.filter(by: mapAnnotation.identifier)
        if currentAnnotations.count > 0 {
            self.mapView.removeAnnotations(currentAnnotations)
        }
        mapView.addAnnotation(mapAnnotation)
    }


    @discardableResult
    public func addAnnotation(for identifier: String, type: MapAnnotation.MKAnnotationType, with coordinate: CLLocationCoordinate2D) -> MapAnnotation {
        let currentAnnotations = self.currentAnnotations.filter(by: identifier)
        if currentAnnotations.count > 0 {
            self.mapView.removeAnnotations(currentAnnotations)
        }
        let newAnnotion = MapAnnotation(type: type, for: identifier)
        newAnnotion.coordinate = coordinate
        mapView.addAnnotation(newAnnotion)
        return newAnnotion
    }

    public func registrer(type: MapAnnotation.MKAnnotationType, for identifier: String) {
        switch type {
        case .pin:
            self.mapView.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: identifier)
        case .view:
            self.mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: identifier)
        }
    }

    public func setRegion(with geoPoint: GeoPoint) {
        self.mapView.setRegion(
            MKCoordinateRegion(center:geoPoint.toCLLocationCoordinate2D,
                               latitudinalMeters: kDefaultRadius,
                               longitudinalMeters: kDefaultRadius), animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let tripAnnotation = annotation as? MapAnnotation else {
            return nil
        }

        guard !tripAnnotation.identifier.isEmpty else {
            return nil
        }

        let identifier = tripAnnotation.identifier
        let markerView: MKAnnotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: identifier, for: annotation)

        switch tripAnnotation.type {
        case .view:
            markerView.image = UIImage(named: "iconHome")
        case .pin:
            guard let pin = markerView as? MKPinAnnotationView else {
                return nil
            }
            pin.pinTintColor = .green
        }
        return markerView
    }
}
