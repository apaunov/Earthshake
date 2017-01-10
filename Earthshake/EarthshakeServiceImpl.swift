//
//  EarthshakeServiceImpl.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-28.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation
import AFNetworking

class EarthshakeServiceImpl : NSObject, EarthshakeService
{
    let USGS_END_EVENT_POINT = "http://earthquake.usgs.gov/fdsnws/event/1/"
    let kFormat = "format"
    let kGeoJson = "geojson"

    internal var earthshakeItemBuilder: EarthshakeItemBuilder?

    func getRequestedData(_ parameters: [AnyHashable: Any], success: EarthshakeSuccessBlock, failure: EarthshakeFailureBlock)
    {
        let endPoint = "\(USGS_END_EVENT_POINT)query"
        let url = URL(string: endPoint)!
        let sessionManager = AFHTTPSessionManager()

        let successBlock: HTTPSuccessBlock = {(_ task: URLSessionDataTask?, _ jsonObject: Any) -> Void in
            if success != nil
            {
                if let earthshakeItems = self.earthshakeItemBuilder?.buildAllEarthshakeItems((jsonObject as! [AnyHashable: Any]))
                {
                    success!(earthshakeItems)
                }
            }
        }

        let failureBlock: HTTPFailureBlock = {(_ task: URLSessionDataTask?, _ error: Error) -> Void in
            if failure != nil
            {
                failure!(error)
            }
        }

        // Add default params
        var localParameters = parameters
        localParameters[kFormat] = kGeoJson

        _ = sessionManager.get(url.absoluteString, parameters: localParameters, progress: nil, success: successBlock, failure: failureBlock)!
    }
}
