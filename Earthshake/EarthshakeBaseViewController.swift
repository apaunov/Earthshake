//
//  EarthshakeBaseViewController.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-30.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

extension Selector
{
    static let refreshButtonTapped = #selector(EarthshakeBaseViewController.didSelectRefresh)
}

class EarthshakeBaseViewController : UIViewController
{
    // Earthshake GeoJson Parameters
    let kStartTime = "starttime"
    let kEndTime = "endtime"
    let kMinMagnitude = "minmagnitude"
    let MIN_MAG_VALUE = "2.5"
    let decimalFormatter = NumberFormatter()

    var refreshButton: UIButton?                // Refresh button with functionality implemented by the subclesses
    var earthshakeService: EarthshakeService?   // Protocol to interact with the request service
    var parameters = [AnyHashable: Any]()       // Dictionary with parameters

    override func viewDidLoad()
    {
        // Adding the refresh button
        refreshButton = UIButton(type: UIButtonType.custom)
        refreshButton?.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        refreshButton?.addTarget(self, action: .refreshButtonTapped, for: UIControlEvents.touchUpInside)
        refreshButton?.setBackgroundImage(UIImage(named: "Refresh"), for: UIControlState.normal)

        let refreshButtonItem = UIBarButtonItem(customView: refreshButton!)
        navigationItem.rightBarButtonItems = [refreshButtonItem]

        // Date formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var dateComponents = DateComponents()
        dateComponents.day = -7

        // Magnitude formatting
        decimalFormatter.numberStyle = NumberFormatter.Style.decimal
        decimalFormatter.maximumFractionDigits = 2;

        let calender = NSCalendar.current
        let endTime = Date()
        let startTime = calender.date(byAdding: dateComponents, to: endTime)

        parameters = [AnyHashable: Any]()
        parameters[kStartTime] = dateFormatter.string(from: startTime!)
        parameters[kEndTime] = dateFormatter.string(from: endTime)
        parameters[kMinMagnitude] = MIN_MAG_VALUE

        earthshakeService = ((UIApplication.shared.delegate) as! EarthshakeAppDelegate).earthshakeService
    }

    // Helper methods

    func getRequestedData(success: EarthshakeSuccessBlock, failure: EarthshakeFailureBlock)
    {
        earthshakeService?.getRequestedData(parameters, success:success, failure:failure)
    }

    func didSelectRefresh() {}

    func displayAlert(error: Error)
    {
        let alert = UIAlertController.init(title: "Error".localized, message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let dismissAction = UIAlertAction.init(title: "OK".localized, style: UIAlertActionStyle.default) {(action) in}

        alert.addAction(dismissAction)

        present(alert, animated: true) {}
    }
}
