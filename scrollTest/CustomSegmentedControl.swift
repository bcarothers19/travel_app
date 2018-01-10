//
//  CustomSegmentedControl.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/9/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UIControl {
    
    // MARK: Properties
    var buttons = [UIButton]()
    var selector : UIView!
    
    // Define the colors we will use
    let green = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    let blue = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    let black = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    let grey = UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1)
    
    // Define the text (when unselected) and background (when selected) colors for each button
    let buttonTextColorMap = [0: UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1), 1: UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1), 2: UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)] as Dictionary<Int, UIColor>
    let buttonBGColorMap = [0: UIColor(red: 169/255, green: 169/255, blue: 169/255, alpha: 1), 1: UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1), 2: UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)] as Dictionary<Int, UIColor>
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    
    func updateView() {
        // Clear any buttons or selectors previously in the view
        buttons.removeAll()
        subviews.forEach {
            $0.removeFromSuperview()
        }
        
        // Set up our buttons (manually for now)
        let button1 = UIButton(type: .system)
        button1.setTitle("Both", for: .normal)
        button1.setTitleColor(grey, for: .normal)
        button1.addTarget(self, action:#selector(buttonTapped(button:)) ,for: .touchUpInside)
        button1.layer.borderColor = grey.cgColor
        button1.layer.borderWidth = 2
        buttons.append(button1)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("Been", for: .normal)
        button2.setTitleColor(green, for: .normal)
        button2.addTarget(self, action:#selector(buttonTapped(button:)) ,for: .touchUpInside)
        button2.layer.borderColor = green.cgColor
        button2.layer.borderWidth = 2
        buttons.append(button2)
        
        let button3 = UIButton(type: .system)
        button3.setTitle("Want", for: .normal)
        button3.setTitleColor(blue, for: .normal)
        button3.addTarget(self, action:#selector(buttonTapped(button:)) ,for: .touchUpInside)
        button3.layer.borderColor = blue.cgColor
        button3.layer.borderWidth = 2
        buttons.append(button3)
        
        // The first button will be selected to start - so we need to set that up
        // Change text color to white
        buttons[0].setTitleColor(.white, for: .normal)
        // Get the width of the selector to start with
        var selectorWidth = CGFloat()
        // If this is the first iteration through (just loaded this segmented control), the buttons will have size=(0,0).
        // Need to make sure the button has a width first
        if buttons[0].frame.size.width == 0 {
            // Default to width/numButtons to start
            // We can use this default for now because we will always be using .fillEqually
            selectorWidth = frame.width / CGFloat(buttons.count)
        } else {
            // If the buttons have size, set the selector equal to the size of the first button (to cover it completely)
            selectorWidth = buttons[0].frame.size.width
        }
        // Create the selector view
        selector = UIView(frame: CGRect(x: 0, y: 0, width: selectorWidth, height: frame.height))
        //        selector.layer.cornerRadius = frame.height/2
        selector.backgroundColor = grey
        addSubview(selector)
        
        // Create a horizontal stack view of the buttons (spaced equally)
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    
    
    override func draw(_ rect: CGRect) {
        //        layer.cornerRadius = frame.height/2
        
        layer.cornerRadius = 1
        
    }
    
    @objc func buttonTapped(button : UIButton) {
        // Iterate through each of our buttons
        for (buttonIndex, btn) in buttons.enumerated() {
            // Check if this is the button that was selected
            if btn == button {
                // Get the x coordinate of where to start the selector view
                var selectorStartPos = CGFloat(0)
                // Add up the width of each button to the left of the newly selected button
                for i in 0 ..< buttonIndex {
                    selectorStartPos += (buttons[i].frame.size.width)
                }
                // Set the width of the selector view equal to the width of the newly selected button
                selector.frame.size.width = btn.frame.size.width
                // Move the selector
                UIView.animate(withDuration: 0.1, animations: {
                    self.selector.frame.origin.x = selectorStartPos
                })
                // Update the text and background color for the selected button
                btn.setTitleColor(.white, for: .normal)
                selector.backgroundColor = buttonBGColorMap[buttonIndex]
            } else {
                // Update the text color (for non-selected buttons - to reset the text if this button was the one previously selected)
                btn.setTitleColor(buttonTextColorMap[buttonIndex], for: .normal)
            }
        }
        sendActions(for: .valueChanged)
    }
}


