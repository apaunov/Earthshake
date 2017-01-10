//
//  EarthshakeItem.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-28.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation
import MapKit

class EarthshakeItem : NSObject
{
    let kPlace = "place"
    let kMagnitude = "mag"
    let kTime = "time"
    let kTimeZone = "tz"
    let kFeatureType = "type"
    let kUrl = "url"
    let kTsunami = "tsunami"
    let kCoordinates = "coordinates"

    var properties = [AnyHashable: Any]()
    var geometry = [AnyHashable: Any]()
    var featureType = ""
    var earthshakeId = ""
    var title = ""
    var place: String = ""
    var magnitude: NSNumber!
    var date = ""
    var time = ""
    var detailURLString = ""
    var epicenter = CLLocationCoordinate2D()
    var tsunami: Int!

    func populateData(_ properties: [AnyHashable: Any], _ geometry: [AnyHashable: Any])
    {
        self.properties = properties
        self.geometry = geometry

        place = extractPlace()
        magnitude = extractMagnitude()
        date = extractDate()
        time = extractTime()
        detailURLString = extractDetailURLString()
        epicenter = extractEpicenter()
        tsunami = extractTsunami()
    }
    
    func extractPlace() -> String
    {
        var place = (properties[kPlace] as! String)
        let regex = try! NSRegularExpression(pattern: "^(\\d*\\s*(km)\\s*[NSEW]*\\s*(of)\\s*)", options: [])
        let match = regex.firstMatch(in: place, options: [], range: NSRange(location: 0, length: place.characters.count))
        let range = match?.rangeAt(1)
        var placeTrim = place

        if (range?.length) != nil && (range?.length)! > 0
        {
            placeTrim = place.substring(from: place.index(place.startIndex, offsetBy: (range?.location)! + (range?.length)!))
        }
        else
        {
            placeTrim = place
        }

        return placeTrim
    }

    func extractMagnitude() -> NSNumber
    {
        let magnitude = (properties[kMagnitude] as! NSNumber)
        return magnitude
    }

    func extractDate() -> String
    {
        let totalSeconds: Double = (properties[kTime] as! Double)
        let date = Date(timeIntervalSince1970: (totalSeconds / 1000))
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy'/'MM'/'dd"

        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    func extractTime() -> String
    {
        let totalSeconds: Double = (properties[kTime] as! Double)
        let date = Date(timeIntervalSince1970: (totalSeconds / 1000))
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "HH':'mm z"
        
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    func extractDetailURLString() -> String
    {
        let urlString = (properties[kUrl] as! String)
        return urlString
    }

    func extractEpicenter() -> CLLocationCoordinate2D
    {
        var coordinates = (geometry[kCoordinates] as! [Double])
        let epicenter = CLLocationCoordinate2DMake(coordinates[1], coordinates[0])
        return epicenter
    }

    func extractTsunami() -> Int
    {
        let tsunami = (properties[kTsunami] as! Int)
        return tsunami
    }
    
    func isEarthquake() -> Bool
    {
        var earthquake = false
        let type = (properties[kFeatureType] as! String)
        
        if (type == "earthquake")
        {
            earthquake = true
        }
        
        return earthquake
    }
    
    func isQuarry() -> Bool
    {
        var quarry = false
        let type = (properties[kFeatureType] as! String)
        
        if (type == "quarry")
        {
            quarry = true
        }
        
        return quarry
    }
}
