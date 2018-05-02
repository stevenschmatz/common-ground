//
//  RootViewController.swift
//  ARFaceDetection
//
//  Created by Steven Schmatz on 5/2/18.
//  Copyright © 2018 Yanniki. All rights reserved.
//

import UIKit
import QuartzCore
import CoreLocation
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var id: Int
    
    init(coordinate: CLLocationCoordinate2D, id: Int) {
        self.coordinate = coordinate
        self.id = id
    }
}

class MapViewController: UIViewController, UIScrollViewDelegate, MKMapViewDelegate {
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.showsUserLocation = true
        view.delegate = self
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985664),
                                                                  regionRadius * 2.0, regionRadius * 2.0)
        
        let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985664), id: 0)
        view.addAnnotation(annotation)
        
        let annotation2 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.750641, longitude: -73.979664), id: 1)
        view.addAnnotation(annotation2)
        
        let annotation3 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.745641, longitude: -73.972664), id: 2)
        view.addAnnotation(annotation3)
        
        let annotation4 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 40.738641, longitude: -73.989664), id: 3)
        view.addAnnotation(annotation4)
        
        view.setRegion(coordinateRegion, animated: true)
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.25
        
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "girl"))
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.clipsToBounds = true
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var greyStarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "grey-star"))
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var starImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "star"))
        self.progressView.addSubview(view)
        return view
    }()
    
    var amount = 100
    
    private lazy var progressLabel: UILabel = {
        let label = UILabel()
        label.text = "100/300"
        label.font = UIFont(name: "Apercu-Medium", size: 18)
        label.textColor = Colors.green
        
        self.progressView.addSubview(label)
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        self.progressView.addSubview(view)
        return view
    }()
    
    private lazy var progressBar: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.green
        self.containerView.addSubview(view)
        return view
    }()
    
    private lazy var hiddenPrivacyLabel: UILabel = {
        let label = UILabel()
        label.text = " Location sharing on "
        label.layer.cornerRadius = 5.0
        label.textColor = .white
        label.layer.masksToBounds = false
        label.layer.shadowOffset = CGSize(width: 0, height: 2)
        label.layer.shadowRadius = 30
        label.layer.shadowOpacity = 0.25
        label.isUserInteractionEnabled = true
        
        self.view.addSubview(label)
        return label
    }()
    
    private lazy var privacyLabel: UILabel = {
        let label = UILabel()
        label.text = " Location sharing on "
        label.layer.cornerRadius = 5.0
        label.layer.masksToBounds = true
        label.font = UIFont(name: "Apercu-Bold", size: 17)
        label.backgroundColor = .white
        label.textColor = Colors.green
        label.isUserInteractionEnabled = true
        
        hiddenPrivacyLabel.addSubview(label)
        
        return label
    }()
    
    private lazy var profileView: UIImageView = {
        let view = UIImageView(image: UIImage(named: "profile"))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.25
        
        view.isHidden = true
        view.layer.opacity = 0.0
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var profileShadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 30
        view.layer.shadowOpacity = 0.25
        
        view.isHidden = true
        view.layer.opacity = 0.0
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "camera"), for: .normal)
        button.addTarget(self, action: #selector(cameraTapped), for: .touchUpInside)
        self.view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dragView = SDragView(dragViewAnimatedTopSpace:450, viewDefaultHeightConstant:75)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(privacyTapped))
        privacyLabel.addGestureRecognizer(tapGestureRecognizer)
        hiddenPrivacyLabel.addGestureRecognizer(tapGestureRecognizer)
        
        self.view.addSubview(dragView)
    }
    
    @objc private func cameraTapped() {
        let vc = FaceDetectionViewController()
        vc.parentView = self
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc private func privacyTapped() {
        let alert = UIAlertController(title: "Choose your location preference", message: "You can choose to share your location with everyone, with guides only, or with nobody. Guides are trusted members of your Facebook group who have been large contributors to the community.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Share my location", comment: "Default action"), style: .default, handler: { _ in
            self.privacyLabel.text = " Location sharing on "
            self.hiddenPrivacyLabel.text = self.privacyLabel.text
            self.privacyLabel.textColor = Colors.green
            self.privacyLabel.font = UIFont(name: "Apercu-Bold", size: 17)
            self.hiddenPrivacyLabel.font = self.privacyLabel.font
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Only share my location with guides", comment: "Default action"), style: .default, handler: { _ in
            self.privacyLabel.text = " Sharing on (guides only) "
            self.hiddenPrivacyLabel.text = self.privacyLabel.text
            self.privacyLabel.textColor = Colors.green
            self.privacyLabel.font = UIFont(name: "Apercu-Bold", size: 17)
            self.hiddenPrivacyLabel.font = self.privacyLabel.font
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Do not share my location", comment: "Default action"), style: .default, handler: { _ in
            self.privacyLabel.text = " Location sharing off "
            self.hiddenPrivacyLabel.text = self.privacyLabel.text
            self.privacyLabel.textColor = UIColor.black.withAlphaComponent(0.35)
            self.privacyLabel.font = UIFont(name: "Apercu-Medium", size: 17)
            self.hiddenPrivacyLabel.font = self.privacyLabel.font
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var barConstraint: NSLayoutConstraint? = nil
    
    private func layoutSubviews() {
        mapView.pinToEdgesOfSuperview()
        
        progressView.pinToTopEdgeOfSuperview(withOffset: 80)
        progressView.pinToLeftEdgeOfSuperview(withOffset: 20)
        progressView.pinToRightEdgeOfSuperview(withOffset: 60)
        progressView.size(toHeight: 50)
        
        containerView.pinToEdgesOfSuperview()
        
        progressBar.pinToBottomEdgeOfSuperview()
        progressBar.size(toHeight: 5)
        progressBar.pinToLeftEdgeOfSuperview()
        barConstraint = progressBar.size(toWidth: 60)
        
        starImageView.pinToTopEdgeOfSuperview(withOffset: 5)
        starImageView.pinToLeftEdgeOfSuperview(withOffset: 5)
        starImageView.pinToBottomEdgeOfSuperview(withOffset: 10)
        starImageView.size(toWidth: 40)
        
        progressLabel.pinToLeftEdgeOfSuperview(withOffset: 60)
        progressLabel.centerVerticallyInSuperview()
        
        hiddenPrivacyLabel.positionBelow(progressView, withOffset: 10)
        hiddenPrivacyLabel.pinLeftEdgeToLeftEdge(of: progressView)
        privacyLabel.pinToEdgesOfSuperview()
        
        profileImageView.pinToRightEdgeOfSuperview(withOffset: 30)
        profileImageView.pinToTopEdgeOfSuperview(withOffset: 55)
        profileImageView.size(toWidth: 100)
        profileImageView.size(toHeight: 100)
        
        greyStarImageView.pinToTopEdgeOfSuperview(withOffset: 45)
        greyStarImageView.pinToRightEdgeOfSuperview(withOffset: 25)
        greyStarImageView.size(toWidthAndHeight: 40)
        
        cameraButton.pinToBottomEdgeOfSuperview(withOffset: 75)
        cameraButton.pinToRightEdgeOfSuperview(withOffset: 0)
        cameraButton.size(toWidthAndHeight: 100)
        
        profileShadowView.pinToSideEdgesOfSuperview(withOffset: 25)
        profileShadowView.pinToTopAndBottomEdgesOfSuperview(withOffset: 200)
        
        profileView.pinToSideEdgesOfSuperview(withOffset: 25)
        profileView.pinToTopAndBottomEdgesOfSuperview(withOffset: 200)
    }
    
    @objc func addToBar() {
        self.barConstraint?.constant += 30
        amount += 30
        progressLabel.text = String(min(amount, 300)) + "/300"
        
        self.view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.1, animations: {
            self.progressBar.backgroundColor = .green
        })
        
        UIView.animate(withDuration: 0.4, animations: {
            self.view.layoutIfNeeded()
        })
        
        UIView.animate(withDuration: 0.1, delay: 0.3, options: .curveEaseInOut, animations: {
            self.progressBar.backgroundColor = Colors.green
        }, completion: nil)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation
        {
            return nil
        }
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        annotationView?.tag = (annotation as! CustomAnnotation).id
        annotationView?.image = UIImage(named: "map-" + String(annotationView!.tag))
        
        if annotationView?.tag == 0 {
            annotationView?.size(toWidthAndHeight: 75)
        } else {
            annotationView?.size(toWidth: 190)
            annotationView?.size(toHeight: 140)
        }
        
        
        return annotationView
    }
    
    var gestureRecognizer: UIGestureRecognizer? = nil
 
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if (view.tag == 1 || view.tag == 3) {
            profileView.isHidden = false
            profileShadowView.isHidden = false
            self.mapView.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 0.1, animations: {
                self.profileView.layer.opacity = 1.0
                self.profileShadowView.layer.opacity = 1.0
            }) { (completed) in
                self.gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissModal))
                self.view.addGestureRecognizer(self.gestureRecognizer!)
            }
        }
        
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
    
    @objc private func dismissModal() {
        UIView.animate(withDuration: 0.1, animations: {
            self.profileView.layer.opacity = 0.0
            self.profileShadowView.layer.opacity = 0.0
        }) { (completed) in
            self.profileView.isHidden = true
            self.profileShadowView.isHidden = true
            self.mapView.isUserInteractionEnabled = true
        }
        
        if let gesture = gestureRecognizer {
            view.removeGestureRecognizer(gesture)
        }
        
        
        
    }
}
