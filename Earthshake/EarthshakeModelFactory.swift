//
//  EarthshakeModelFactory.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-08.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

class EarthshakeModelFactory : NSObject
{
    var earthshakeItemBuilder: EarthshakeItemBuilder?
    
    func createEarthshakeItemBuilder() -> EarthshakeItemBuilder
    {
        if (earthshakeItemBuilder != nil)
        {
            return earthshakeItemBuilder!
        }

        earthshakeItemBuilder = EarthshakeItemBuilder()

        return earthshakeItemBuilder!
    }
}
