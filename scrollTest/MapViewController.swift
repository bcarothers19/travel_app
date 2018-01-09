//
//  MapViewController.swift
//  mapbox test
//
//  Created by Brian Carothers on 1/2/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import Mapbox

class MapViewController: UIViewController, MGLMapViewDelegate {
    
    
    var mapView = MGLMapView()
    
    var polyColor = UIColor()
    
    var countryBorderData = [String: Any]()
    
    var selectedCountries = [String]()
    
    
    // Define our colors
    let red = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
    let orange = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1)
    let yellow = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    let green = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
    let lightblue = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 1)
    let purple = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1)
    let pink = UIColor(red: 255/255, green: 100/255, blue: 175/255, alpha: 1)
    // Alternate color - needs a bit of tweaking to have the same vibrancy as the others
    // let darkgreen = UIColor(red: 23/255, green: 177/255, blue: 146/255, alpha: 1)
    
    // Reference dictionary for using a 7 color map for coloring countries
    // This will be initialized when we load the view
    // ****** Is that right? Or better to load here?? ******
    var mapColors7 = [Int: [String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up our map
        let styleURL = URL(string: "mapbox://styles/bcarothers19/cjc0427stg1vv2smqbhilp2a9")
        mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 12.476792, longitude: -69.951644), zoomLevel: 3, animated: false)
        view.addSubview(mapView)
        mapView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Setup the dictionary we will use for map color 7 scheme
        setMapColor7()
        print(red)
        // Load the GeoJSON of country borders
        let countryBorderData = loadJSONData(name: "CountryBordersJSON")
        loadCountryBorderData(data: countryBorderData)
        addAllSelectedAreas(colorMappingDict: mapColors7)
        
        //testPolyParse()
        //        testJson()
        //        var test = coordListToPolygon(coordsList: [1,2,3], internalPolygonList: [4,5,6])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testJson() {
        print(NSDataAsset(name: "CountryJSON"))
        if let dataAsset = NSDataAsset(name: "CountryJSON") {
            do {
                let data = try JSONSerialization.jsonObject(with: dataAsset.data, options: []) as! Dictionary<String, Any>
                let features = data["features"]! as! [Dictionary<String, Any>]
                let geometry = features[32]["geometry"]! as! Dictionary<String, Any>
                let coords = geometry["coordinates"]! as! Array<Array<Array<Double>>>
                let finalCoords = coords[0]
                //                print(finalCoords)
                //                print(type(of: coords))
                //                print(finalCoords)
                var mbCoords = [CLLocationCoordinate2D]()
                for coord in finalCoords {
                    let cl = CLLocationCoordinate2DMake(coord[1], coord[0])
                    mbCoords.append(cl)
                }
                print(mbCoords)
                let shape = MGLPolygon(coordinates: mbCoords, count:UInt(mbCoords.count))
                print(shape)
                mapView.addAnnotations([shape])
                
                print("Made it")
            } catch {
                fatalError("Failed here")
            }
        }
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .black
    }
    
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        //        return UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1)
        return polyColor
    }
    
    
    //        if let jsonPath = Bundle.main.path(forResource: "countries", ofType: "json") {
    //            do {
    //                let data = try Data(contentsOf: URL(fileURLWithPath: jsonPath), options: .mappedIfSafe)
    //                let countryJSON = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, AnyObject>
    //            } catch {
    //                fatalError("Couldn't load/parse countries JSON")
    //            }
    //        }
    //
    //let feats = countryJSON
    
    
    //let url = URL(fileURLWithPath: jsonPath!)
    
    //do {
    //  let data = try Data(contentsOf: url)
    //let ex = data["features"]
    //print(ex)
    //            let polygonFeature = try MGLPolygon(
    //  }
    //catch {
    //  print("GeoJSON parsing failed")
    // }
    
    
    
    
    // MARK: Private Methods
    
    private func coordsToCLLocationCoords(coordsList: [[Double]]) -> [CLLocationCoordinate2D] {
        var clCoord: CLLocationCoordinate2D
        var mbCoords = [CLLocationCoordinate2D]()
        // Convert the (lat, log) coordinates to CLLocationCoordinate2D objects
        for coord in coordsList {
            // Note that the order of latitude and longitude is reversed in the data source - fixing that here
            clCoord = CLLocationCoordinate2DMake(coord[1], coord[0])
            mbCoords.append(clCoord)
        }
        return mbCoords
    }
    
    private func coordListToPolygon(externalCoordsList: [[Double]], internalPolygonList: [MGLPolygon]?) -> MGLPolygon {
        // Create the external polygon
        let externalPolyCoords = coordsToCLLocationCoords(coordsList: externalCoordsList)
        // Create the MGLPolygon - will use different constructor depending if there are internal polygons included
        guard let internalPolys = internalPolygonList else {
            // There are no internal polygons to add to the polygon
            return MGLPolygon(coordinates: externalPolyCoords, count:UInt(externalPolyCoords.count))
        }
        // There are internal polygons, we need to pass the list of them to the constuctor
        return MGLPolygon(coordinates: externalPolyCoords, count: UInt(externalPolyCoords.count), interiorPolygons: internalPolys)
    }
    
    private func multipolyToSinglePolygons(polygons: [[[[Double]]]]) -> [MGLPolygon] {
        var externalPolyList = [[Double]]()
        var clCoords = [CLLocationCoordinate2D]()
        var completePoly = MGLPolygon()
        var allPolygons = [MGLPolygon]()
        
        // Go through each polygon in the multipolygon list (these polygons can contain both external and internal polygons)
        for polygon in polygons {
            var polyCount = 0
            var internalPolys = [MGLPolygon]()
            // Go through each part (external/internal) of the polygon individually
            for individualPolygon in polygon {
                if polyCount != 0 {
                    // All polygons after the first one is an internal polygon - we can convert this to a polygon now
                    // Convert our list of coordinates into CLLocationCoordinates which are used to create MGLPolygons
                    clCoords = coordsToCLLocationCoords(coordsList: individualPolygon)
                    internalPolys.append(MGLPolygon(coordinates: clCoords, count: UInt(clCoords.count)))
                } else {
                    // Else polyCount = 0, the first polygon is the external polygon
                    externalPolyList = individualPolygon
                }
                polyCount += 1
            }
            // Create this Polygon (contains both external and internal polygons)
            completePoly = coordListToPolygon(externalCoordsList: externalPolyList, internalPolygonList: internalPolys)
            // Add this Polygon to our list of polygons in this MultiPolygon
            allPolygons.append(completePoly)
        }
        return allPolygons
    }
    
    
    
    // ******** DELETE THIS *********************
    var countryPolygons2 = [MGLPolygon]()
    
    
    
    private func loadJSONData(name: String) -> Dictionary<String, Any> {
        if let dataAsset = NSDataAsset(name: name) {
            do {
                let data = try JSONSerialization.jsonObject(with: dataAsset.data, options: []) as! Dictionary<String, Any>
                return data
            } catch {
                fatalError("Could not load JSON \(name)")
            }
        } else {
            fatalError("Could not load data asset \(name)")
        }
    }
    
    var countryPolygons = [String: [String: Any]]()
    
    private func loadCountryBorderData(data: Dictionary<String, Any>) {
        for countryName in data.keys {
            // Get the information we need from this JSON
            let countryData = data[countryName] as! Dictionary<String, Any?>
            let mapColor7Value = countryData["MAPCOLOR7"] as! Int
            let coordType = countryData["coordType"] as! String
            var thisCountryPolygons = [MGLPolygon]()
            switch(coordType) {
            case "Polygon":
                let coords = countryData["coordinates"] as! Array<Array<Array<Double>>>
                var nestedPoly = [[[[Double]]]]()
                nestedPoly.append(coords)
                thisCountryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
            case "MultiPolygon":
                let coords = countryData["coordinates"] as! Array<Array<Array<Array<Double>>>>
                thisCountryPolygons = multipolyToSinglePolygons(polygons: coords)
            default:
                fatalError("coordType wasn't Polygon or Multipoly for country: \(countryName)")
            }
            // Add country data to color dictionary
            var colorCountryList = mapColors7[mapColor7Value]!["countries"] as! [String]
            colorCountryList.append(countryName)
            mapColors7[mapColor7Value]!["countries"] = colorCountryList
            // Add country data to countries dictionary
            countryPolygons[countryName] = ["color": mapColor7Value, "polygons": thisCountryPolygons]
        }
    }
    
    
    //    var mapColors7 = [Int: [String: Any]]()
    
    private func setMapColor7() {
        // ***** Think we can use ints here... delete if so ******
        //let mc7Values = [("red", red), ("orange", orange), ("yellow", yellow), ("green", green), ("lightblue", lightblue), ("purple", purple), ("pink", pink)]
        let mc7Values = [(1, red), (2, yellow), (3, green), (4, orange), (5, pink), (6, lightblue), (7, purple)]
        for (colorNum, UIColorVal) in mc7Values {
            mapColors7[colorNum] = ["UIColorValue": UIColorVal, "countries": [String]()]
        }
    }
    
    
    // ******** This first version is probably incorrect *******
    //    private func addAllSelectedAreas(colorCountryList: Dictionary<String, Any>) {
    //        // Add all annotations for all colors (one color at a time)
    //        for country in colorCountryList["countries"] as! [String]{
    //            // Get the color that we will be making these annotations
    //            let color = colorCountryList["color"] as! UIColor
    //            let colorCountries = colorCountryList["countries"] as! [String]
    //            let polysToAdd = getAllSelectedAreasForColor(colorCountries: colorCountries, countriesToSelect: [], selectAll: true)
    //            polyColor = color
    //            mapView.addAnnotations(polysToAdd)
    //        }
    //    }
    
    private func addAllSelectedAreas(colorMappingDict: Dictionary<Int, Dictionary<String, Any>>) {
        // Add all annotations for all colors (one color at a time)
        for colorInt in colorMappingDict.keys {
            let colorInfo = colorMappingDict[colorInt] as! Dictionary<String, Any>
            print(colorInfo)
            // Get the color that we will be making these annotations
            let color = colorInfo["UIColorValue"] as! UIColor
            // Get the list of possible countries for this color
            let colorCountries = colorInfo["countries"] as! [String]
            let polysToAdd = getAllSelectedAreasForColor(colorCountries: colorCountries, countriesToSelect: Globals.Countries.visitedCountries, selectAll: false)
            polyColor = color
            mapView.addAnnotations(polysToAdd)
        }
    }
    
    
    
    private func getAllSelectedAreasForColor(colorCountries: [String], countriesToSelect: Array<String>, selectAll: Bool) -> [MGLPolygon] {
        // colorCountryList = {color: .red, countries: [USA, Finland, ...]}
        
        // Adds all annotations for a single color
        
        // First check to make sure either allSelected=true or selectedCounties is not empty
        
        
        var countriesToAdd = [MGLPolygon]()
        
        // Go through each country in the list of possible countries for this color
        for country in colorCountries {
            if selectAll {
                if !(selectedCountries.contains(country)) {
                    let countryData = countryPolygons[country]
                    let countryPolys = countryData!["polygons"] as! Array<MGLPolygon>
                    for countryPoly in countryPolys {
                        countriesToAdd.append(countryPoly)
                    }
                }
            } else {
                if countriesToSelect.contains(country){
                    if !(selectedCountries.contains(country)) {
                        let countryData = countryPolygons[country]
                        let countryPolys = countryData!["polygons"] as! Array<MGLPolygon>
                        for countryPoly in countryPolys {
                            countriesToAdd.append(countryPoly)
                        }
                    }
                }
            }
            
        }
        return(countriesToAdd)
    }
    
    
    
    
    private func testPolyParse() {
        
        if let dataAsset = NSDataAsset(name: "CountryBordersJSON") {
            do {
                let data = try JSONSerialization.jsonObject(with: dataAsset.data, options: []) as! Dictionary<String, Any>
                var countryName = "Germany"
                polyColor = pink
                var countryJSON = data[countryName] as! Dictionary<String, Any>
                var coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    var countryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    var countryPolygons = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                
                countryName = "Netherlands"
                polyColor = green
                countryJSON = data[countryName] as! Dictionary<String, Any>
                coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    var countryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    var countryPolygons = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                countryName = "Denmark"
                polyColor = orange
                countryJSON = data[countryName] as! Dictionary<String, Any>
                coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    var countryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    var countryPolygons = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                countryName = "Czechia"
                polyColor = purple
                countryJSON = data[countryName] as! Dictionary<String, Any>
                coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    var countryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    var countryPolygons = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                countryName = "Poland"
                polyColor = lightblue
                countryJSON = data[countryName] as! Dictionary<String, Any>
                coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    var countryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    var countryPolygons = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                countryName = "Sweden"
                polyColor = yellow
                countryJSON = data[countryName] as! Dictionary<String, Any>
                coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    countryPolygons2 = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons2)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    countryPolygons2 = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons2)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                countryName = "Finland"
                polyColor = red
                countryJSON = data[countryName] as! Dictionary<String, Any>
                coordType = countryJSON["coordType"] as! String
                switch(coordType){
                case "Polygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Double>>>
                    var nestedPoly = [[[[Double]]]]()
                    nestedPoly.append(coords)
                    var countryPolygons = multipolyToSinglePolygons(polygons: nestedPoly)
                    mapView.addAnnotations(countryPolygons)
                //coords = [coords]
                case "MultiPolygon":
                    var coords = countryJSON["coordinates"] as! Array<Array<Array<Array<Double>>>>
                    var countryPolygons = multipolyToSinglePolygons(polygons: coords)
                    mapView.addAnnotations(countryPolygons)
                default:
                    fatalError("Country \(countryName) polygon type is not Polygon or MultiPolygon")
                }
                
                mapView.removeAnnotations(countryPolygons2)
                polyColor = pink
                mapView.addAnnotations(countryPolygons2)
                
            } catch {
                fatalError("Failed here")
            }
        }
    }
    
    
}

