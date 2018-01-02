//
//  BucketlistToggleControl.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

@IBDesignable class BucketlistToggleControl: UIStackView {
    
    // MARK: Properties
    private var bucketListButton = UIButton()
    
    var bucketListSelected = false {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var bucketImgSize: CGSize = CGSize(width:50.0, height: 50.0) {
        didSet {
            setupButton()
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: Button Action
    @objc func bucketlistButtonTapped(button: UIButton) {
        print("BL button pressed")
        if bucketListSelected {
            bucketListSelected = false
        } else {
            bucketListSelected = true
        }
    }
    
    // MARK: Private Methods
    private func setupButton() {
        // Load button images
        let bundle = Bundle(for: type(of: self))
        let regularBucket = UIImage(named: "bucketListBlack", in: bundle, compatibleWith: self.traitCollection)
        let selectedBucket = UIImage(named: "bucketListGreen", in: bundle, compatibleWith: self.traitCollection)
        
        // Create the button
        let button = UIButton()
        button.setImage(regularBucket, for: .normal)
        button.setImage(selectedBucket, for: .selected)
        button.setImage(selectedBucket, for: .highlighted)
        button.setImage(selectedBucket, for: [.highlighted, .selected])
        
        // Add contraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: bucketImgSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: bucketImgSize.width).isActive = true
       
        // Setup the button action
        button.addTarget(self, action: #selector(BucketlistToggleControl.bucketlistButtonTapped(button:)), for: .touchUpInside)
        
        // Add the button to the stack
        addArrangedSubview(button)
        
        bucketListButton = button
        
        updateButtonSelectionState()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    private func updateButtonSelectionState() {
        bucketListButton.isSelected = bucketListSelected
    }
    
}
