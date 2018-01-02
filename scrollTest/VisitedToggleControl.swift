//
//  VisitedToggleControl.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

@IBDesignable class VisitedToggleControl: UIStackView {

    // MARK: Properties
    private var visitedButton = UIButton()
    
    var visitedSelected = false {
        didSet {
            updateButtonSelectionState()
        }
    }
    
    @IBInspectable var visitedImgSize: CGSize = CGSize(width: 50.0, height: 50.0) {
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
    @objc func visitedButtonTapped(button: UIButton) {
        print("Visited button pressed")
        if visitedSelected {
            visitedSelected = false
        } else {
            visitedSelected = true
        }
    }
    
    // MARK: Private Methods
    private func setupButton() {
        // Load button images
        let bundle = Bundle(for: type(of: self))
        let regularVisited = UIImage(named: "visitedFalse", in: bundle, compatibleWith: self.traitCollection)
        let selectedVisited = UIImage(named: "visitedTrue", in: bundle, compatibleWith: self.traitCollection)
        
        // Create the button
        let button = UIButton()
        button.setImage(regularVisited, for: .normal)
        button.setImage(selectedVisited, for: .selected)
        button.setImage(selectedVisited, for: .highlighted)
        button.setImage(selectedVisited, for: [.highlighted, .selected])
        
        // Add constraints
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: visitedImgSize.height).isActive = true
        button.widthAnchor.constraint(equalToConstant: visitedImgSize.width).isActive = true
        
        // Setup the button action
        button.addTarget(self, action: #selector(VisitedToggleControl.visitedButtonTapped(button:)), for: .touchUpInside)
        
        // Add the button to the stack
        addArrangedSubview(button)
        
        visitedButton = button
        
        updateButtonSelectionState()
    }
    
    private func updateButtonSelectionState() {
        visitedButton.isSelected = visitedSelected
    }
    
}
