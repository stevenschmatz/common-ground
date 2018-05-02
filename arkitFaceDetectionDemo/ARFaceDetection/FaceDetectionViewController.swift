//
//  FaceDetectionViewController.swift
//  ARFaceDetection
//
//  Created by Steven Schmatz.
//  Copyright © 2018 Steven. All rights reserved.
//

import UIKit
import ARKit
import Vision

class FaceDetectionViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    private var scanTimer: Timer?
    
    private var scannedFaceViews = [UIView]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    class TriangleView : UIView {
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override func draw(_ rect: CGRect) {
            
            guard let context = UIGraphicsGetCurrentContext() else { return }
            
            context.beginPath()
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
            context.closePath()
            
            context.setFillColor(red: 75/255.0, green: 225/255.0, blue: 218/255.0, alpha: 1.0)
            context.fillPath()
        }
    }
    
    //get the orientation of the image that correspond's to the current device orientation
    private var imageOrientation: CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
            case .portrait: return .right
            case .landscapeRight: return .down
            case .portraitUpsideDown: return .left
            case .unknown: fallthrough
            case .faceUp: fallthrough
            case .faceDown: fallthrough
            case .landscapeLeft: return .up
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        
        let buttonView = UIButton()
        buttonView.frame = CGRect(x: self.view.frame.width / 2.0 - 40, y: self.view.frame.maxY - 120, width: 80, height: 80)
        buttonView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        buttonView.layer.cornerRadius = 40
        buttonView.layer.borderColor = UIColor.white.cgColor
        buttonView.layer.borderWidth = 5.0
        buttonView.showsTouchWhenHighlighted = true
        buttonView.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        self.view.addSubview(buttonView)
    }
    
    @objc func buttonPressed() {
        let highlightView = UIView()
        highlightView.frame = view.frame
        highlightView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        view.addSubview(highlightView)
        
        let auxView = UIView()
        auxView.frame = CGRect(x: 0, y: -50, width: view.frame.width, height: 50)
        auxView.backgroundColor = UIColor(red: 75/255.0, green: 225/255.0, blue: 218/255.0, alpha: 1.0)
        
        let savedView = UILabel()
        savedView.text = "Saved photo to camera roll!"
        savedView.textColor = .white
        savedView.backgroundColor = UIColor(red: 75/255.0, green: 225/255.0, blue: 218/255.0, alpha: 1.0)
        savedView.frame = CGRect(x: 0, y: -50, width: view.frame.width, height: 30)
        savedView.textAlignment = .center
        view.addSubview(auxView)
        view.addSubview(savedView)
        
        self.capturePhoto()

        UIView.animate(withDuration: 0.1) {
            highlightView.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        }

        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveEaseInOut, animations: {
            highlightView.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        }, completion: { (completed) -> Void in
            highlightView.removeFromSuperview()
        })
    }
    
    private func capturePhoto() {
        let snapShot = self.sceneView.snapshot()
        UIImageWriteToSavedPhotosAlbum(snapShot, self, nil, nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
        
        //scan for faces in regular intervals
        scanTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(scanForFaces), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        scanTimer?.invalidate()
        sceneView.session.pause()
    }
    
    @objc
    private func scanForFaces() {
        
        //get the captured image of the ARSession's current frame
        guard let capturedImage = sceneView.session.currentFrame?.capturedImage else { return }
        
        let image = CIImage.init(cvPixelBuffer: capturedImage)
        
        let detectFaceRequest = VNDetectFaceRectanglesRequest { (request, error) in
            
            DispatchQueue.main.async {
                //Loop through the resulting faces and add a red UIView on top of them.
                if let faces = request.results as? [VNFaceObservation] {
                    //remove the test views and empty the array that was keeping a reference to them
                    _ = self.scannedFaceViews.map { $0.removeFromSuperview() }
                    self.scannedFaceViews.removeAll()
                    
                    var sortedFaces = faces
                    sortedFaces.sort(by: { (a: VNFaceObservation, b: VNFaceObservation) -> Bool in
                        return a.boundingBox.minX < b.boundingBox.minX
                    })
                    
                    for (i, face) in sortedFaces.enumerated() {
                        let originalFrame = self.faceFrame(from: face.boundingBox)
                        let margin: CGFloat = 20
                        let faceFrame = CGRect(x: originalFrame.minX - margin, y: originalFrame.minY - margin, width: originalFrame.width + margin * 2, height: originalFrame.height + margin * 2)
                        let containerFrame = CGRect(x: faceFrame.minX, y: faceFrame.minY, width: faceFrame.width, height: faceFrame.height + 80)
                        let containerView = UIView(frame: containerFrame)
                        let boundingFrame = CGRect(x: 0, y: 0, width: faceFrame.width, height: faceFrame.height)
                        
                        let faceView = UIView(frame: boundingFrame)
                    
                        faceView.layer.borderColor = UIColor.white.cgColor
                        faceView.layer.borderWidth = 0.0
                        faceView.layer.cornerRadius = 20.0
                    
                        containerView.addSubview(faceView)
                        
                        let label = UILabel()
                        label.backgroundColor = UIColor(red: 75/255.0, green: 225/255.0, blue: 218/255.0, alpha: 1.0)
                        label.textColor = .black
                        label.font = UIFont.systemFont(ofSize: 22)
                        label.text = "  " + ["Steven", "Erica", "Jessica", "George"][i % 4] + "  "
                        label.frame = CGRect(x: (containerFrame.width - 75) / 2.0, y: containerFrame.height - 30, width: faceFrame.width, height: 40)
                        label.sizeToFit()
                        label.layer.cornerRadius = 20
                        
                        let triangle = TriangleView(frame: CGRect(x: label.center.x - 12.5, y: label.frame.minY - 10.5, width: 25 , height: 11))
                        triangle.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
                        containerView.addSubview(triangle)
                        
                        let rectShape = CAShapeLayer()
                        rectShape.bounds = label.frame
                        rectShape.position = label.center
                        rectShape.path = UIBezierPath(roundedRect: label.bounds, byRoundingCorners: [.bottomLeft , .bottomRight, .topLeft, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
                        label.layer.mask = rectShape
                        
                        containerView.addSubview(label)
                        
                        self.sceneView.addSubview(containerView)
                        self.scannedFaceViews.append(containerView)
                    }
                }
            }
        }
        
        DispatchQueue.global().async {
            try? VNImageRequestHandler(ciImage: image, orientation: self.imageOrientation).perform([detectFaceRequest])
        }
    }
    
    private func faceFrame(from boundingBox: CGRect) -> CGRect {
        
        //translate camera frame to frame inside the ARSKView
        let origin = CGPoint(x: boundingBox.minX * sceneView.bounds.width, y: (1 - boundingBox.maxY) * sceneView.bounds.height)
        let size = CGSize(width: boundingBox.width * sceneView.bounds.width, height: boundingBox.height * sceneView.bounds.height)
        
        return CGRect(origin: origin, size: size)
    }
}

extension FaceDetectionViewController: ARSCNViewDelegate {
    //implement ARSCNViewDelegate functions for things like error tracking
}
