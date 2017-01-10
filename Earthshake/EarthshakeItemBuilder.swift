//
//  EarthshakeItemBuilder.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-28.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

class EarthshakeItemBuilder : NSObject
{
    // Properties
    let kMetadata = "metadata"
    let kFeatures = "features"
    let kProperties = "properties"
    let kGeometry = "geometry"

    func buildEarthshakeItem(_ json: [AnyHashable: Any]) -> EarthshakeItem?
    {
        if json.isEmpty
        {
            return nil
        }

        let earthshakeItem: EarthshakeItem = EarthshakeItem()
        earthshakeItem.populateData(json[kProperties] as! [AnyHashable : Any], json[kGeometry] as! [AnyHashable : Any])
        
        return earthshakeItem
    }

    func buildAllEarthshakeItems(_ json: [AnyHashable: Any]) -> [Any]?
    {
        if json.count == 0
        {
            return nil
        }
    
        var earthshakeItems = [Any]()
        let features = json[kFeatures] as! [Any]
    
        for feature in features
        {
            if let earthshakeItem = buildEarthshakeItem((feature as! [AnyHashable: Any]))
            {
                earthshakeItems.append(earthshakeItem)
            }
        }
    
        return earthshakeItems
    }
}
