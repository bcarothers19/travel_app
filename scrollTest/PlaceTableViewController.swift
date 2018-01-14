//
//  PlaceTableViewController.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import os.log
import GooglePlaces

class PlaceTableViewController: UITableViewController {

    // MARK: Properties
    var places = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the edit button item provided by the table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved places, otherwise load sample data
        if let savedPlaces = loadPlaces() {
            places += savedPlaces
        } else {
            // Load the sample data
            loadSamplePlaces()
        }
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

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            places.remove(at: indexPath.row)
            savePlaces()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        print(segue.identifier)
        switch(segue.identifier ?? ""){
        case "AddItem":
            os_log("Adding a new place", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let placeDetailViewController = segue.destination as? PlaceViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedPlaceCell = sender as? PlaceTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedPlaceCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedPlace = places[indexPath.row]
            placeDetailViewController.place = selectedPlace
        default:
            fatalError("Unexpected segue identifier: \(String(describing: segue.identifier))")
        }
    }

    // MARK: Actions
    @IBAction func unwindToPlaceList(sender: UIStoryboardSegue) {

        if let sourceViewController = sender.source as? AddEditPlaceViewController, let place = sourceViewController.place {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing place
                places[selectedIndexPath.row] = place
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new place
                let newIndexPath = IndexPath(row: places.count, section: 0)
                places.append(place)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the places
            savePlaces()
        }
    }
    
    // MARK: Private Methods
    private func loadSamplePlaces() {
        let photo1 = UIImage(named: "sample_tokyo")
        guard let place1 = Place(name: "Tokyo", photo: photo1, address: "Tokyo, Japan", url: nil, coords: CLLocationCoordinate2D(latitude: 35.711741, longitude: 139.746427), viewpoint: nil, country: "Japan", city: "Tokyo", bucketList: false, visited: false, dateRangeText: "-", startSelected: false, startMonth: "", startDay: "", startYear: "", startText: "", endSelected: false, endMonth: "", endDay: "", endYear: "", endText: "") else {
            fatalError("Unable to instantiate place1")
        }

//        let x = CLLocationCoordinate2D(latitude: 39.665548, longitude: -105.206001)
        
        let photo2 = UIImage(named: "sample_lappland_dome")
        guard let place2 = Place(name: "Kakslauttanen Arctic Resort", photo: photo2, address: "Kiilopääntie 9, 99830 Saariselkä, Finland", url: "www.kakslauttanen.fi", coords: CLLocationCoordinate2D(latitude: 68.334278, longitude: 27.334439), viewpoint: nil, country: "Finland", city: nil, bucketList: true, visited: false, dateRangeText: "-", startSelected: false, startMonth: "", startDay: "", startYear: "", startText: "", endSelected: false, endMonth: "", endDay: "", endYear: "", endText: "") else {
            fatalError("Unable to instantiate place2")
        }
        
        let photo3 = UIImage(named: "sample_lappland_husky")
        guard let place3 = Place(name: "Lappland Husky Sled Overnight", photo: photo3, address: "Lappland, Finland", url: "https://www.pallashusky.com/english/husky-tours/", coords: CLLocationCoordinate2D(latitude: 68.334278, longitude: 27.334439), viewpoint: nil, country: "Finland", city: nil, bucketList: true, visited: false, dateRangeText: "-", startSelected: false, startMonth: "", startDay: "", startYear: "", startText: "", endSelected: false, endMonth: "", endDay: "", endYear: "", endText: "") else {
            fatalError("Unable to instantiate place3")
        }
        
        let photo4 = UIImage(named: "sample_zion")
        guard let place4 = Place(name: "Zion National Park", photo: photo4, address: "Zion National Park, Utah", url: "www.zionnationalpark.com", coords: CLLocationCoordinate2D(latitude: 37.206379, longitude: -112.986383), viewpoint: nil, country: "United States of America", city: nil,  bucketList: true, visited: false, dateRangeText: "-", startSelected: false, startMonth: "", startDay: "", startYear: "", startText: "", endSelected: false, endMonth: "", endDay: "", endYear: "", endText: "") else {
            fatalError("Unable to instantiate place4")
        }
        
        let photo5 = UIImage(named: "sample_florence")
        guard let place5 = Place(name: "Florence", photo: photo5, address: "Florence, Italy", url: nil, coords: CLLocationCoordinate2D(latitude: 43.774745, longitude: 11.251192), viewpoint: nil, country: "Italy", city: "Florence", bucketList: false, visited: true, dateRangeText: "-", startSelected: false, startMonth: "", startDay: "", startYear: "", startText: "", endSelected: false, endMonth: "", endDay: "", endYear: "", endText: "") else {
            fatalError("Unable to instantiate place5")
        }
        
        let photo6 = UIImage(named: "sample_redrocks")
        guard let place6 = Place(name: "Red Rocks Ampitheatre", photo: photo6, address: "18300 W Alameda Pkwy, Morrison, CO 80465", url: "redrocksonline.com/", coords: CLLocationCoordinate2D(latitude: 39.665548, longitude: -105.206001), viewpoint: nil, country: "United States of America", city: "Denver", bucketList: true, visited: true, dateRangeText: "-", startSelected: false, startMonth: "", startDay: "", startYear: "", startText: "", endSelected: false, endMonth: "", endDay: "", endYear: "", endText: "") else {
            fatalError("Unable to instantiate place6")
        }
        
        places += [place1, place2, place3, place4, place5, place6]
    }
    
    private func savePlaces() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(places, toFile: Place.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Places successfully saved", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save places", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPlaces() -> [Place]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Place.ArchiveURL.path) as? [Place]
    }
    
}
