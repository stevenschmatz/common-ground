//
//  PhotoCaptureViewController.swift
//  ARFaceDetection
//
//  Created by Steven Schmatz on 5/2/18.
//  Copyright © 2018 Yanniki. All rights reserved.
//

import UIKit
import CoreGraphics

class PhotoCaptureViewController: UIViewController {
    var image: UIImage? = nil
    var people: [String]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Colors.green
        
    }
}
