//
//  EarthshakeServiceFactory.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-08.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

class EarthshakeServiceFactory : NSObject
{
    var earthshakeModelFactory: EarthshakeModelFactory?
    var earthshakeService: EarthshakeService?

    func createEarthshakeService() -> EarthshakeService?
    {
        if (earthshakeService == nil)
        {
            earthshakeService = EarthshakeServiceImpl()
            earthshakeService!.earthshakeItemBuilder = earthshakeModelFactory!.createEarthshakeItemBuilder()
        }

        return earthshakeService
    }
}
