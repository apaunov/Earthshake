//
//  EarthshakeSettingsViewController.swift
//  Earthshake
//
//  Created by Andrey on 2016-12-30.
//  Copyright © 2016 AP. All rights reserved.
//

import Foundation

class EarthshakeSettingsViewController : EarthshakeBaseViewController, UITableViewDelegate, UITableViewDataSource
{
    var sectionTitles = [AnyHashable: Any]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        sectionTitles["Notifications".localized] = "Notifications Settings".localized
        sectionTitles["Measurements".localized] = ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sectionTitles.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch (section)
        {
            case 0:
                return ""

            case 1:
                return "About".localized

            default:
                return ""
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "cell"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

        if cell != nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.text = "Test"
        }

        return cell!
    }
}
