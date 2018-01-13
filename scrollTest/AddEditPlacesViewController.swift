//
//  ViewController.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/9/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import GooglePlaces



class AddEditPlacesViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    
    @IBOutlet weak var searchView: UIView! // Holds the Google Places search bar
    @IBOutlet weak var placeNameTextView: UITextView!
    @IBOutlet weak var placePhotoImageView: UIImageView!
    @IBOutlet weak var placeAddressTextView: UITextView!
    @IBOutlet weak var placeURLTextField: UITextField!
    
    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var endDateButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // Initialize variables for selecting best time to visit
    var startSelected = false
    var startMonth = ""
    var startDay = ""
    var startYear = ""
    var startText = ""
    var endSelected = false
    var endMonth = ""
    var endDay = ""
    var endYear = ""
    var endText = ""
    
//    var placeCoords = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the ISO 3166-1 alpha-2 country code data if we haven't already done so
        if Globals.Countries.countryCodes.isEmpty {
            Globals.Countries.countryCodes = loadJSONData(name: "CountryCodesJSON")
        }

        
        placeNameTextView.delegate = self
        placeAddressTextView.delegate = self
        placeURLTextField.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        print("INFOOOOOOO")
        print(searchController)
        print(searchController?.searchResultsUpdater)
        print(resultsViewController)
        print(resultsViewController?.delegate)
        print(self)
        print(searchController?.delegate)
       
        
        let subView = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        searchView.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        print(searchController)
        // When UISearchController presents the results view, present it in this view controller, not one further up the chain
        definesPresentationContext = true
        
        
        placeNameTextView.isScrollEnabled = false
        placeAddressTextView.isScrollEnabled = false
        
        // Set endDateButton to be disabled to start. Can only select endDate after startDate is selected.
        endDateButton.isEnabled = false
        
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
    
    
    // MARK: Date Buttons
    @IBAction func showDatePickerAlert(_ sender: UIButton) {
        guard (sender == startDateButton) || (sender == endDateButton) else {
            fatalError("In showDatePickerAlert but the button was not startDateButton or endDateButton. Sender button is \(sender)")
        }
        
        
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 375, height: 150)
        
        let datePicker = DatePickerView(frame: CGRect(x: 0, y: 0, width: 375, height: 150))

        
        var alertTitle = ""
        if sender == startDateButton {
            print("START BUTTON")
            
            if startSelected {
                datePicker.selectPreviouslySelected(month: startMonth, day: startDay, year: startYear)
                alertTitle = "Change start date"
            } else {
                datePicker.selectToday()
                alertTitle = "Select start date"
            }
        } else {
            print("END BUTTON")
            if endSelected {
                datePicker.selectPreviouslySelected(month: endMonth, day: endDay, year: endYear)
                alertTitle = "Change end date"
            } else {
                // ***** CHANGE THIS DEFAULT TO SELECTED START DATE *****
                datePicker.selectToday()
                alertTitle = "Select end date"
            }
        }
        
        
        vc.view.addSubview(datePicker)
        
        let alert = UIAlertController(title: alertTitle, message: "Must choose at least a month or a year", preferredStyle: .actionSheet) as! UIAlertController
        alert.isModalInPopover = true
        
        let okAction = UIAlertAction(title: "Done", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            //Perform Action
            print(datePicker.selectedMonth, datePicker.selectedDay, datePicker.selectedYear)
            if sender == self.startDateButton {
                // Update the startDate variables
                self.startSelected = true
                self.startMonth = datePicker.selectedMonth
                self.startDay = datePicker.selectedDay
                self.startYear = datePicker.selectedYear
                // Update the start button text
                self.startDateButton.setTitle("Change start date", for: .normal)
                // Update the date label
                self.startText = self.formatDateText(month: self.startMonth, day: self.startDay, year: self.startYear)
                self.dateLabel.text = self.combineDateTexts(start: self.startText, end: self.endText)
                // Enable the end date button now that a start date has been selected
                self.endDateButton.isEnabled = true
            } else {
                // Update the endDate variables
                self.endSelected = true
                self.endMonth = datePicker.selectedMonth
                self.endDay = datePicker.selectedDay
                self.endYear = datePicker.selectedYear
                // Update the end button text
                self.endDateButton.setTitle("Change end date", for: .normal)
                // Update the date label
                self.endText = self.formatDateText(month: self.endMonth, day: self.endDay, year: self.endYear)
                self.dateLabel.text = self.combineDateTexts(start: self.startText, end: self.endText)
            }
        })
        alert.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        alert.setValue(vc, forKey: "contentViewController")
        
        present(alert, animated: true, completion: nil)

    }
    
    // MARK: Private Methods
    private func loadJSONData(name: String) -> Dictionary<String, String> {
        // Get the data asset that we are trying to load
        if let dataAsset = NSDataAsset(name: name) {
            do {
                // Load the data as a JSON
                let data = try JSONSerialization.jsonObject(with: dataAsset.data, options: []) as! Dictionary<String, String>
                return data
            } catch {
                fatalError("Could not load JSON \(name)")
            }
        } else {
            fatalError("Could not load data asset \(name)")
        }
    }
    
    private func formatDateText(month: String, day: String, year: String) -> String {
        var dateString = ""
        if month != "----" {
            dateString += month
        }
        if day != "----" {
            let strippedZeros = String(describing: Int(day)!)
            dateString += " \(strippedZeros)"
        }
        if year != "----" {
            dateString += " \(year)"
        }
        return dateString
    }
    
    private func combineDateTexts(start: String, end: String) -> String {
        if (start.isEmpty) && (end.isEmpty) {
            return "-"
        } else if !(start.isEmpty) && (end.isEmpty) {
            return start
        } else if !(start.isEmpty) && !(end.isEmpty) {
            return "\(start) - \(end)"
        } else {
            fatalError("End date text is not empty while start date text is empty. Shouldn't be able to select end date without first selecting start date")
        }
    }
}

// Handle the users's selection
extension AddEditPlacesViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place coords: \(place.coordinate)")
        print("Place url: \(place.website)")
        print("Place open: \(String(describing: place.openNowStatus))")
        print("Place number: \(place.phoneNumber)")
        print("Place rating: \(place.rating)")
        print("Place price: \(place.priceLevel)")
        print("Place types: \(place.types)")
        print("Place viewport: \(place.viewport)")
        print("Place address parts: \(place.addressComponents)")
        for part in place.addressComponents! {
            print(part.type, part.name)
            let x = place.openNowStatus as GMSPlacesOpenNowStatus!
            //        print(text(for: place.openNowStatus))
            //            print()
            
            let placeID = place.placeID
            GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
                if let error = error {
                    // TODO: handle the error.
                    print("Error: \(error.localizedDescription)")
                } else {
                    print(photos)
                    if let firstPhoto = photos?.results.first {
                        self.loadImageForMetadata(photoMetadata: firstPhoto)
                    }
                }
            }
        }
        self.placeNameTextView.text = place.name
        self.placeAddressTextView.text = place.formattedAddress
        if let url = place.website {
            self.placeURLTextField.text = String(describing: url)
        } else {
            self.placeURLTextField.text = "Enter a URL"
        }
        
    }
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print(photo?.size)
                let resizedPhoto = photo?.resizedImageWithinRect(rectSize: CGSize(width: self.view.frame.width - 20, height: 375))
                print(resizedPhoto?.size)
                self.placePhotoImageView.image = resizedPhoto;
            }
        })
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController, didFailAutocompleteWithError error: Error) {
        // Handle the error
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

