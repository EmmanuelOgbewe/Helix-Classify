//
//  StartVC.swift
//  HelixBrain
//
//  Created by Emmanuel  Ogbewe on 11/21/18.
//  Copyright © 2018 Emmanuel Ogbewe. All rights reserved.
//

import UIKit

class StartVC: UIViewController {

    var welcomeLabel  : UILabel = {
        let label = UILabel()
        label.text = "Welcome to Helix Brain"
        label.font = UIFont(name: "Avenir-Roman", size: 30)
        label.numberOfLines = 2
        label.textColor = UIColor.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var optionStack : UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 30
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var button1 : UIButton = {
        var b = UIButton()
        b.setTitle("Image recognition", for: UIControl.State.normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        return b
    }()
    var button2 : UIButton = {
        var b = UIButton()
        b.setTitle("Do Math", for: UIControl.State.normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        return b
    }()
    var button3 : UIButton = {
        var b = UIButton()
        b.setTitle("Voice Commands", for: UIControl.State.normal)
        b.setTitleColor(UIColor.white.withAlphaComponent(0.7), for: .normal)
        return b
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setuplayout()
        addTargets()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    private func setuplayout(){
        view.backgroundColor = UIColor(rgb: 0x0C0D0E)
        view.addSubview(welcomeLabel)
        view.addSubview(optionStack)
      
        
        [
            button1,button2,button3
            ].forEach{$0.showsTouchWhenHighlighted = true}
        
        optionStack.addArrangedSubview(button1)
        optionStack.addArrangedSubview(button2)
        optionStack.addArrangedSubview(button3)
    
        [
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ].forEach{$0.isActive = true }
        
        
        [
           optionStack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 100),
           optionStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
           optionStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
           welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ].forEach{$0.isActive = true }

    }
    private func addTargets(){
        button1.addTarget(self, action: #selector(self.pushToImagesVC), for: .touchUpInside)
    }
    @objc private func pushToImagesVC(){
         let imageVC = ImagesVC()
        presentingViewController?.modalTransitionStyle = .crossDissolve
        self.present(imageVC, animated: true, completion: nil)
    }
}
