//
//  EarthshakeService.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-15.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

typealias HTTPSuccessBlock = (_ task: URLSessionDataTask?, _ jsonObject: Any) -> Void
typealias HTTPFailureBlock = (_ task: URLSessionDataTask?, _ error: Error) -> Void
typealias EarthshakeSuccessBlock = ((_ earthshakeItems: [Any]) -> Void)?
typealias EarthshakeFailureBlock = ((_ error: Error) -> Void)?

protocol EarthshakeService
{
    var earthshakeItemBuilder: EarthshakeItemBuilder? { get set }

    func getRequestedData(_ parameters: [AnyHashable: Any], success: EarthshakeSuccessBlock, failure: EarthshakeFailureBlock)
}
