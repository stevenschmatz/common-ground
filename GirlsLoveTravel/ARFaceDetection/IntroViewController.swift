//
//  IntroViewController.swift
//  
//
//  Created by Steven Schmatz on 5/2/18.
//

import UIKit
import FacebookLogin

class IntroViewController: UIViewController, LoginButtonDelegate {
    
    private lazy var logoView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        self.view.addSubview(imageView)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "GirlsLoveTravel"
        titleLabel.font = UIFont(name: "Apercu-Bold", size: 26)
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    private lazy var detailLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Building offline friendships from online connections"
        titleLabel.font = UIFont(name: "Apercu-Regular", size: 13)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        let button = LoginButton(readPermissions: [.publicProfile])
        button.delegate = self
        
        view.addSubview(button)
        
        logoView.pinToTopEdgeOfSuperview(withOffset: 200)
        logoView.centerHorizontallyInSuperview()
        logoView.size(toWidthAndHeight: 200)
        
        titleLabel.centerHorizontallyInSuperview()
        titleLabel.positionBelow(logoView, withOffset: 20)
        
        detailLabel.centerHorizontallyInSuperview()
        detailLabel.positionBelow(titleLabel, withOffset: 10)
        detailLabel.size(toWidth: 300)
        
        button.centerHorizontallyInSuperview()
        button.pinToBottomEdgeOfSuperview(withOffset: 50)
        button.size(toHeight: 50)
        button.size(toWidth: 250)
    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        self.present(MapViewController(), animated: true, completion: nil)
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        return
    }
}
