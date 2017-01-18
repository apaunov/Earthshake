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
    var sections = [String]()
    var rows = [[String]]()
    var showSettingsDetailsIdentifier = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()

        showSettingsDetailsIdentifier = "ShowSettingsDetails"
        
        sections = ["Notifications".localized, "Measurements".localized, "Information".localized]
        rows = [["Near me".localized], ["Kilometers (km)".localized, "Miles (mi)".localized], ["Legal".localized, "App Info".localized]]
        
        refreshButton?.isHidden = true
    }

    func numberOfSections(in tableView: UITableView) -> Int
    {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return rows[section].count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "cell"

        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil
        {
            cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellIdentifier)
            cell?.textLabel?.text = rows[indexPath.section][indexPath.row]
            
            switch indexPath.section
            {
                case 0:
                    // Notifications section

                    switch indexPath.row
                    {
                        case 0:
                            // Alerts
                            let cellSwitch = UISwitch()
                            cellSwitch.isOn = false
                            cellSwitch.addTarget(self, action: #selector(switchChanged), for: UIControlEvents.valueChanged)

                            cell?.detailTextLabel?.text = "Earthquakes near your location".localized
                            cell?.selectionStyle = .none
                            cell?.accessoryView = cellSwitch

                            break

                        default:
                            break
                    }

                    break

                case 1:
                    // Measurements section
                
                    switch indexPath.row
                    {
                        case 0:
                            // Unit settings
                            break
                    
                        default:
                            break
                    }

                    break
                
                case 2:
                    // Information section
                
                    switch indexPath.row
                    {
                        case 0:
                            // About settings
                            break
                    
                        default:
                            break
                    }
                
                    break
                
                default:
                    break
            }
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        performSegue(withIdentifier: showSettingsDetailsIdentifier, sender: nil)
    }

    func setAlertSettings()
    {
        
    }

    func setUnitsSettings()
    {
        
    }

    func setAboutInformation()
    {
        
    }

    func switchChanged()
    {
        
    }
}
