//
//  RootViewController.swift
//  ARFaceDetection
//
//  Created by Steven Schmatz on 5/2/18.
//  Copyright © 2018 Yanniki. All rights reserved.
//

import UIKit
import QuartzCore
import MapKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    private lazy var mapView: MKMapView = {
        let view = MKMapView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        layoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let dragView = SDragView(dragViewAnimatedTopSpace:360, viewDefaultHeightConstant:75)
        
        self.view.addSubview(dragView)
    }
    
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
        progressBar.size(toWidth: 140)
        
        starImageView.pinToTopEdgeOfSuperview(withOffset: 5)
        starImageView.pinToLeftEdgeOfSuperview(withOffset: 5)
        starImageView.pinToBottomEdgeOfSuperview(withOffset: 10)
        starImageView.size(toWidth: 40)
        
        progressLabel.pinToLeftEdgeOfSuperview(withOffset: 60)
        progressLabel.centerVerticallyInSuperview()
        
        profileImageView.pinToRightEdgeOfSuperview(withOffset: 30)
        profileImageView.pinToTopEdgeOfSuperview(withOffset: 55)
        profileImageView.size(toWidth: 100)
        profileImageView.size(toHeight: 100)
        
        greyStarImageView.pinToTopEdgeOfSuperview(withOffset: 45)
        greyStarImageView.pinToRightEdgeOfSuperview(withOffset: 25)
        greyStarImageView.size(toWidthAndHeight: 40)
    }
}
