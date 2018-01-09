//
//  PlaceViewController.swift
//  scrollTest
//
//  Created by Brian Carothers on 12/31/17.
//  Copyright © 2017 Brian Carothers. All rights reserved.
//

import UIKit
import os.log

class PlaceViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var bucketlistToggleControl: BucketlistToggleControl!
    @IBOutlet weak var visitedToggleControl: VisitedToggleControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var place: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.delegate = self
        addressTextField.delegate = self
        urlTextField.delegate = self
        dateTextField.delegate = self
        
        // Set up views if editing an existing place
        if let place = place {
            navigationItem.title = place.name
            nameTextField.text = place.name
            addressTextField.text = place.address
            urlTextField.text = place.url
            dateTextField.text = place.date
            photoImageView.image = place.photo
            bucketlistToggleControl.bucketListSelected = place.bucketList
            visitedToggleControl.visitedSelected = place.visited
        }
        
        // Enable the Save button only if the text field has a valid Place name
        updateSaveButtonState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided with the following: \(info)")
        }
        
        // Set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    
    // Mark: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        print("cancelling")
        // Depending on the style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways
        let isPresentingInAddPlaceMode = presentingViewController is UITabBarController
        if isPresentingInAddPlaceMode {
            print("presenting in add place mode")
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The PlaceViewController is not inside a navigation controller")
        }
    }
    
    
    // This method lets you configure a view controller before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("preparing")
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let address = addressTextField.text ?? ""
        let url = urlTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let photo = photoImageView.image
        let bucketList = bucketlistToggleControl.bucketListSelected
        let visited = visitedToggleControl.visitedSelected
        
        // Set the place to be passed to the PlaceTableViewController after the unwind segue
        place = Place(name: name, photo: photo, address: address, url: url, date: date, bucketList: bucketList, visited: visited)
    }
    
    // MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func setBucketListImage(_ sender: UIButton) {
    }
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

