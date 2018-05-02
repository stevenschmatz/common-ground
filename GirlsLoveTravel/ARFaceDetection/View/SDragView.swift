//
//  SDragView.swift
//  SDragView
//
//  Created by Admin on 9/20/17.
//  Copyright © 2017 DhruvinThumar. All rights reserved.
//

import UIKit

class SDragView: UIView {

    //  MARK: - Public properties
    public var viewCornerRadius:CGFloat = 8
    public var viewBackgroundColor:UIColor = UIColor.white
    
    
    // MARK: - Private properties
    private var dragViewAnimatedTopMargin:CGFloat = 25.0 // View fully visible (upper spacing)
    private var viewDefaultHeight:CGFloat = 80.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    
    private lazy var diamondImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "diamond"))
        self.addSubview(image)
        return image
    }()
    
    private lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Paris, France"
        label.font = UIFont(name: "Apercu-Bold", size: 20)
        self.addSubview(label)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "April 15, 2018"
        label.textColor = UIColor(white: 0.0, alpha: 0.6)
        label.font = UIFont(name: "Apercu-Light", size: 16)
        self.addSubview(label)
        return label
    }()
    
    private lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.green
        self.addSubview(view)
        return view
    }()
    
    private lazy var summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "In Paris, you met 4 people and visited 5 landmarks."
        label.font = UIFont(name: "Apercu-Medium", size: 12)
        label.textColor = UIColor.black.withAlphaComponent(0.5)
        self.addSubview(label)
        return label
    }()
    
    private lazy var parisImageView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "paris"))
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        self.addSubview(image)
        return image
    }()
    
    private lazy var people1: UIImageView = {
        let image = UIImageView(image: UIImage(named: "people-1"))
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        self.addSubview(image)
        return image
    }()
    
    private lazy var people2: UIImageView = {
        let image = UIImageView(image: UIImage(named: "people-2"))
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        self.addSubview(image)
        return image
    }()
    
    private lazy var people3: UIImageView = {
        let image = UIImageView(image: UIImage(named: "people-3"))
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        self.addSubview(image)
        return image
    }()
    
    private lazy var people4: UIImageView = {
        let image = UIImageView(image: UIImage(named: "people-4"))
        image.layer.cornerRadius = 5
        image.layer.masksToBounds = true
        self.addSubview(image)
        return image
    }()
    
    
    required init(dragViewAnimatedTopSpace:CGFloat, viewDefaultHeightConstant:CGFloat)
    {
        dragViewAnimatedTopMargin = dragViewAnimatedTopSpace
        viewDefaultHeight = viewDefaultHeightConstant
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        super.init(frame: CGRect(x: 10, y:dragViewDefaultTopMargin , width: screenSize.width - 20, height: screenSize.height - dragViewAnimatedTopMargin))
        
        self.backgroundColor = viewBackgroundColor.withAlphaComponent(0.5)
        self.layer.cornerRadius = self.viewCornerRadius
        
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(white: 0.0, alpha: 0.2).cgColor
        self.layer.borderWidth = 1.0
        
        let blur = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.bounds
        blurView.clipsToBounds = true
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.layer.cornerRadius = self.viewCornerRadius
        self.addSubview(blurView)
        
        self.layoutIfNeeded()
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(gestureRecognizer)
        
        self.setViewConstraints()
    }
    
    private func setViewConstraints() {
        diamondImageView.size(toWidthAndHeight: 25)
        diamondImageView.pinToLeftEdgeOfSuperview(withOffset: 20)
        diamondImageView.pinToTopEdgeOfSuperview(withOffset: 20)
        
        cityLabel.centerVertically(to: diamondImageView)
        cityLabel.positionToTheRight(of: diamondImageView, withOffset: 20)
        
        dateLabel.centerVertically(to: cityLabel)
        dateLabel.positionToTheRight(of: cityLabel, withOffset: 20)
        
        parisImageView.positionBelow(dateLabel, withOffset: 30)
        parisImageView.pinLeftEdgeToLeftEdge(of: cityLabel)
        parisImageView.pinToRightEdgeOfSuperview(withOffset: 20)
        parisImageView.size(toHeight: 130)
        
        summaryLabel.pinLeftEdgeToLeftEdge(of: parisImageView)
        summaryLabel.positionBelow(parisImageView, withOffset: 15)
        summaryLabel.pinToRightEdgeOfSuperview(withOffset: 20)
        
        people1.pinLeftEdgeToLeftEdge(of: cityLabel)
        people1.positionBelow(summaryLabel, withOffset: 15)
        people1.size(toWidthAndHeight: 65)
        
        people2.centerVertically(to: people1)
        people2.positionToTheRight(of: people1, withOffset: 10)
        people2.size(toWidthAndHeight: 65)
        
        people3.centerVertically(to: people2)
        people3.positionToTheRight(of: people2, withOffset: 10)
        people3.size(toWidthAndHeight: 65)
        
        people4.centerVertically(to: people3)
        people4.positionToTheRight(of: people3, withOffset: 10)
        people4.size(toWidthAndHeight: 65)
        
        line.centerHorizontally(to: diamondImageView)
        line.positionBelow(diamondImageView, withOffset: -5)
        line.size(toHeight: 270)
        line.size(toWidth: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.superview)
            

            if(!(newTranslation.y < 0 && self.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.translatesAutoresizingMaskIntoConstraints = true
                self.center = CGPoint(x: self.center.x, y: self.center.y + newTranslation.y)
                
                if (newTranslation.y < 0)
                {
                    if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                    {
                        if self.frame.size.width >= (self.superview?.frame.size.width)!
                        {
                            self.frame = CGRect(x: self.frame.origin.x, y:self.frame.origin.y , width: self.frame.size.width, height: self.frame.size.height)
                        }
                        else{
                            self.frame = CGRect(x: self.frame.origin.x - 2, y:self.frame.origin.y , width: self.frame.size.width + 4, height: self.frame.size.height)
                        }
                        
                    }
                }
                else
                {
                    if("\(self.frame.size.width)" != "\((self.superview?.frame.size.width)! - 20)")
                    {
                        self.frame = CGRect(x: self.frame.origin.x + 2, y:self.frame.origin.y , width: self.frame.size.width - 4, height: self.frame.size.height)
                    }
                }
                
                // self.layoutIfNeeded()
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.superview)
                
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.frame.origin.y = dragViewAnimatedTopMargin
                self.isUserInteractionEnabled = false
            }
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            
            self.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.superview)
            
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            
            if(springVelocity > 0 && self.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
            }
            else if (springVelocity > 0)
            {
                
                if (self.frame.origin.y < (self.superview?.frame.size.height)!/3 && springVelocity < 7)
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewAnimatedTopMargin
                    }), completion: nil)
                }
                else
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.frame.size.width != (self.superview?.frame.size.width)! - 20)
                        {
                            self.frame = CGRect(x: 10, y:self.frame.origin.y , width: (self.superview?.frame.size.width)! - 20, height: self.frame.size.height)
                        }
                        
                        self.frame.origin.y = self.dragViewDefaultTopMargin
                    }), completion:  { (finished: Bool) in
                        
                    })
                }
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.frame.size.width)" == "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 10, y:self.frame.origin.y , width: self.frame.size.width - 20, height: self.frame.size.height)
                        }
                    }
                    else{
                        if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                        {
                            self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                        }
                    }
                    
                }), completion: nil)
            }
            else
            {
                if("\(self.frame.size.width)" != "\(String(describing: self.superview?.frame.size.width))")
                {
                    self.frame = CGRect(x: 0, y:self.frame.origin.y , width: (self.superview?.frame.size.width)!, height: self.frame.size.height)
                }
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.frame.origin.y = self.dragViewAnimatedTopMargin
                }), completion: nil)
            }
            viewLastYPosition = Double(self.frame.origin.y)
            
            self.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        
        if(self.frame.origin.y == dragViewAnimatedTopMargin)
        {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x: 10, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width - 20, height: self.frame.size.height)
                
            }), completion: nil)
            
        }
        else{
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                self.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.frame.size.height)
                
            }), completion: nil)
        }
    }

}
