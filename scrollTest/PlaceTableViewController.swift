//
//  PlaceTableViewController.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

class PlaceTableViewController: UITableViewController {

    // MARK: Properties
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data
        loadSamplePlaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused an should be dequeued using a cell identifier
        let cellIdentifier = "PlaceTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PlaceTableViewCell else {
            fatalError("The dequeued cell is not an instance of PlaceTableViewCell")
        }
        
        // Fetches the appropriate place for the data source layout
        let place = places[indexPath.row]

        // Configure the cell
        cell.nameLabel.text = place.name
        cell.photoImageView.image = place.photo
        cell.visitedToggleControl.visitedSelected = place.visited
        
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Private Methods
    private func loadSamplePlaces() {
        let photo1 = UIImage(named: "sample_tokyo")
        guard let place1 = Place(name: "Tokyo", photo: photo1, address: "Tokyo, Japan", url: nil, date: "Anytime!", bucketList: false, visited: false) else {
            fatalError("Unable to instantiate place1")
        }
        
        let photo2 = UIImage(named: "sample_lappland_dome")
        guard let place2 = Place(name: "Kakslauttanen Arctic Resort", photo: photo2, address: "Kiilopääntie 9, 99830 Saariselkä, Finland", url: "www.kakslauttanen.fi", date: "Dec - Feb", bucketList: true, visited: false) else {
            fatalError("Unable to instantiate place2")
        }
        
        let photo3 = UIImage(named: "sample_lappland_husky")
        guard let place3 = Place(name: "Lappland Husky Sled Overnight", photo: photo3, address: "Lappland, Finland", url: "https://www.pallashusky.com/english/husky-tours/", date: "Dec - Feb", bucketList: true, visited: false) else {
            fatalError("Unable to instantiate place3")
        }
        
        let photo4 = UIImage(named: "sample_lappland_zion")
        guard let place4 = Place(name: "Zion National Park", photo: photo4, address: "Zion National Park, Utah", url: "www.zionnationalpark.com", date: "Apr - May", bucketList: true, visited: false) else {
            fatalError("Unable to instantiate place4")
        }
        
        let photo5 = UIImage(named: "sample_lappland_florence")
        guard let place5 = Place(name: "Florence", photo: photo4, address: "Florence, Italy", url: nil, date: "Anytime!", bucketList: false, visited: true) else {
            fatalError("Unable to instantiate place5")
        }
        
        let photo6 = UIImage(named: "sample_lappland_redrocks")
        guard let place6 = Place(name: "Red Rocks Ampitheatre", photo: photo6, address: "18300 W Alameda Pkwy, Morrison, CO 80465", url: "redrocksonline.com/", date: "Anytime!", bucketList: true, visited: true) else {
            fatalError("Unable to instantiate place6")
        }
        
        places += [place1, place2, place3, place4, place5, place6]
    }
    
}
