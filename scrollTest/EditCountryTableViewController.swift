//
//  EditCountryTableViewController.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/6/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import os.log

class EditCountryTableViewController: UITableViewController {

    // MARK: Properties
    @IBOutlet weak var saveButton: UIBarButtonItem!
    // Get the global lists that we will be making changes to
    var countriesDict = Globals.Countries.countries
    var countriesList = Globals.Countries.countries.allValues as! [Country]
    var visitedList = Globals.Countries.visitedCountries
    var wantToVisitList = Globals.Countries.wantToVisitCountries

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table views cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "EditCountryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EditCountryTableViewCell else {
            fatalError("The dequeued cell is not an instance of EditCountryTableViewCell")
        }
        
        // Fetches the appropriate country for the data source layout
        let country = countriesList[indexPath.row]
        
        // Get the country information we will display
        cell.nameLabel.text = country.name
        cell.flagImageView.image = country.flag
            
        // Change the color of the cell
        if country.hasVisited {
            cell.contentView.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)

        } else if country.wantToVisit {
            cell.contentView.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        } else {
            // Default is white if hasVisited and wantToVisit are both false
            cell.contentView.backgroundColor = .white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Fetches the appropriate country for the data source layout
        let country = countriesList[indexPath.row]
        
        // Functionality for when "BOTH" is selected
        var originalState = ""
        if country.hasVisited {
            originalState = "green"
        } else if country.wantToVisit {
            originalState = "blue"
        } else {
            originalState = "white"
        }
        // Update lists and objects based on the current state the cell is in
        switch originalState {
        case "white":
            // Country not in either list
            // Want to add it to visitedList and update the country object boolean
            visitedList.append(country.name)
            // Switch the value of this boolean
            country.hasVisited = true
            print("Added \(country.name) to visitedList")
        case "green":
            // Country in hasVisited (wantToVisitList could be either way)
            // Want to remove from visitedList, add to wantToVisitList, and update the country object booleans
            // Get the index of this country in the visitedList
            guard let countryIndex = visitedList.index(of: country.name) else {
                fatalError("Couldn't find \(country.name) in visitedList, but hasVisited=true")
            }
            // Remove and add to lists
            visitedList.remove(at: countryIndex)
            if !(wantToVisitList.contains(country.name)) {
                // Only add if not already in wantToVisitList
                wantToVisitList.append(country.name)
            }
            // Switch the value of the booleans
            country.hasVisited = false
            country.wantToVisit = true
            print("Added \(country.name) to wantToVisitList and removed from visitedList")
        case "blue":
            // Country in wantToVisitList and not in visitedList
            // Want to remove from wantToVisitList, and update the country object booleans
            // Get the index of this country in the wantToVisitList
            guard let countryIndex = wantToVisitList.index(of: country.name) else {
                fatalError("Couldn't find \(country.name) in wantToVisitList, but wantToVisit=true")
            }
            // Remove from wantToVisitList
            wantToVisitList.remove(at: countryIndex)
            // Switch the value of this boolean
            country.wantToVisit = false
            print("Removed \(country.name) from wantToVisitList")
        default:
            fatalError("Current state of country cell is not white/green/blue")
        }
        // Update the countriesList/Dict with the changes we made to this country
        countriesList[indexPath.row] = country
        countriesDict[country.name] = country
        // Reload this row to update the background color
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)

        // ***** Functionality for when "BEEN"/"WANT" selected - will need to make some tweaks *****
//        // Add or remove the country from visitedList depending on its current state
//        if country.hasVisited {
//            // Country is currently in the visitedList, we want to remove it from the list
//            // Get the index of this country in the list and remove it
//            guard let countryIndex = visitedList.index(of: country.name) else {
//                fatalError("Couldn't find \(country.name) in visitedList, but hasVisited=true")
//            }
//            visitedList.remove(at: countryIndex)
//            // Switch the value of this boolean
//            country.hasVisited = false
//            print("Switched value of \(country.name) from true to false")
//        } else {
//            // Country isn't in the visitedList, we want to add it
//            visitedList.append(country.name)
//            // Switch the value of this boolean
//            country.hasVisited = true
//            print("Switched value of \(country.name) from false to true")
//        }
//        // Update the countriesList with the changes we made to this country
//        countriesList[indexPath.row] = country
//        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Update our global lists with our changes when the save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        // Save button was pressed, update the global lists
        Globals.Countries.countries = countriesDict
        Globals.Countries.visitedCountries = visitedList
        Globals.Countries.wantToVisitCountries = wantToVisitList
    }
}
