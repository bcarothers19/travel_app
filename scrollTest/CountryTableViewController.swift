//
//  CountryTableViewController.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/7/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import os.log

class CountryTableViewController: UITableViewController {
    
    // MARK: Properties
//    var countries = [Country]()
//    var visitedCountries = [Country]()
//    var wantToVisitCountries = [Country]()
    
    
    var countryCodesData = Dictionary<String, String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countryCodesData = loadJSONData(name: "CountryCodesJSON")
        
        
        // Load the country data
        loadCountries()
        Globals.Countries.visitedCountries = ["United States of America", "Sweden"]

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
        // #warning Incomplete implementation, return the number of rows
        return Globals.Countries.visitedCountries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table views cells are reused and should be dequeued using a cell identifier
        let cellIdentifier = "CountryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CountryTableViewCell else {
            fatalError("The dequeued cell is not an instance of CountryTableViewCell")
        }
        
        // Fetches the appropriate country for the data source layout
        let countryName = Globals.Countries.visitedCountries[indexPath.row]
        
        let countryObject = Globals.Countries.countries[countryName] as! Country
        
        cell.nameLabel.text = countryName
        cell.flagImageView.image = countryObject.flag
        
        
        // Change the color of the cell
        if countryObject.hasVisited {
            cell.contentView.backgroundColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
            
        } else if countryObject.wantToVisit {
            cell.contentView.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
        } // Default is white if hasVisited and wantToVisit are both fault
        
        
        
        return cell
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
    
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */
 
    
    // MARK: Private Methods
    private func loadJSONData(name: String) -> Dictionary<String, String> {
        if let dataAsset = NSDataAsset(name: name) {
            do {
                let data = try JSONSerialization.jsonObject(with: dataAsset.data, options: []) as! Dictionary<String, String>
                return data
            } catch {
                fatalError("Could not load JSON \(name)")
            }
        } else {
            fatalError("Could not load data asset \(name)")
        }
    }
    
    private func loadCountries() {
        var loadedCountries = [String: Country]()
        var loadedVisited = [String]()
        var loadedWantToVisit = [String]()
        for country in countryCodesData.keys {
            print(country)
            let flag = UIImage(named: "flags/" + country)
            let reFlag = flag!.resizedImageAspectFixedHeight(maxHeight: 40)
            guard let c = Country(name: countryCodesData[country]!, flag: reFlag, hasVisited: false, wantToVisit: false) else {
                fatalError("Unable to instantiate \(country)")
            }
            loadedCountries[c.name] = c
            if c.hasVisited {
                loadedVisited += [c.name]
            }
            if c.wantToVisit {
                loadedWantToVisit += [c.name]
            }
        }
        print(loadedCountries.count)
        
        // Update our global lists
        Globals.Countries.countries = NSMutableDictionary(dictionary: loadedCountries)
        Globals.Countries.visitedCountries = loadedVisited
        Globals.Countries.wantToVisitCountries = loadedWantToVisit
    }
    
    
    // MARK: Actions
    @IBAction func unwindToVisitedCountryList(sender: UIStoryboardSegue) {
        self.tableView.reloadData()
        
        os_log("unwinding293912", log: OSLog.default , type: .debug)
        
        print("clicked save")
//        let newIndexPath = IndexPath(row: Globals.Countries.visitedCountries.count, section: 0)
//        self.navigationController!.popViewController(animated: true)
    }
}
