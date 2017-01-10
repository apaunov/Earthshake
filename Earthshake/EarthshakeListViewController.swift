//
//  EarthshakeListViewController.swift
//  Earthshake
//
//  Created by Andrey on 2017-01-06.
//  Copyright © 2017 AP. All rights reserved.
//

import Foundation

class EarthshakeListViewController: EarthshakeBaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate
{
    // UI properties
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var earthshakeTableView: UITableView!
    
    // Constants
    let numberOfSections = 1
    let numberOfRowsInSection = 20

    // Local properties
    var allEarthshakeItems = [EarthshakeItem]()             // All accuired items
    var earthshakeItemsSearchResults = [EarthshakeItem]()   // Search results on specific search criteria
    var searchController: UISearchController!               // Search controller
    var showEarthshakeDetailsSegueIdentifier = ""           // Identifier to help distinguish between segues
    var showSearchResults = false                           // Decides whether to show search results base on whether we are search a word or not
    
    // Delegate methods
    override func viewDidLoad()
    {
        super.viewDidLoad()

        showEarthshakeDetailsSegueIdentifier = "ShowEarthshakeDetails"
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self

        earthshakeTableView.tableHeaderView = self.searchController.searchBar
        definesPresentationContext = true

        loadTableData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if showSearchResults
        {
            return earthshakeItemsSearchResults.count
        }
        else
        {
            return allEarthshakeItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "earthshakeCell"

        var cell: EarthshakeCell? = earthshakeTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! EarthshakeCell?

        if cell == nil
        {
            cell = EarthshakeCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }

        var earthshakeItem: EarthshakeItem

        if showSearchResults
        {
            // From search results
            earthshakeItem = earthshakeItemsSearchResults[indexPath.row]
        }
        else
        {
            // Initial data acquired
            earthshakeItem = allEarthshakeItems[indexPath.row]
        }

        cell?.place.text = earthshakeItem.place
        cell?.magnitude.text = decimalFormatter.string(from: earthshakeItem.magnitude)
        cell?.magnitude.backgroundColor = determineMagnitudeColor(earthshakeItem.magnitude)
        cell?.date.text = earthshakeItem.date
        cell?.time.text = earthshakeItem.time

        if earthshakeItem.isEarthquake()
        {
            cell?.earthshakeImageView.image = UIImage(named: "Earthquake")
        }
        else if earthshakeItem.isQuarry()
        {
            cell?.earthshakeImageView.image = UIImage(named: "Explosion")
        }

        if Int(earthshakeItem.tsunami) == 1
        {
            cell?.tsunamiImageView.image = UIImage(named: "Tsunami")
        }
        else
        {
            cell?.tsunamiImageView.image = nil
        }

        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Searching methods

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        showSearchResults = true
        earthshakeTableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        showSearchResults = false
        earthshakeTableView.reloadData()
    }

    func updateSearchResults(for searchController: UISearchController)
    {
        let resultPredecate = NSPredicate(format: "place contains[cd] %@", searchController.searchBar.text!)
        earthshakeItemsSearchResults = allEarthshakeItems.filter() { resultPredecate.evaluate(with: $0) }
        earthshakeTableView.reloadData()
    }
    
    // Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination
        // Pass the selected object to the new view controller.

        if segue.identifier == showEarthshakeDetailsSegueIdentifier
        {
            if segue.destination.isKind(of: EarthshakeDetailsViewController.self)
            {
                let destination = segue.destination as! EarthshakeDetailsViewController
                var earthshakeItem: EarthshakeItem

                if searchController.isActive
                {
                    earthshakeItem = earthshakeItemsSearchResults[(earthshakeTableView.indexPath(for: sender as! EarthshakeCell)?.row)!]
                }
                else
                {
                    earthshakeItem = allEarthshakeItems[(earthshakeTableView.indexPathForSelectedRow?.row)!]
                }

                destination.detailURLString = earthshakeItem.detailURLString
            }
        }
    }
    
    // Helper methods
    
    func determineMagnitudeColor(_ magnitude: NSNumber) -> UIColor
    {
        let mag = Float(magnitude)
        var color = UIColor.white
    
        if (1.0 < mag && mag < 3.0)
        {
            color = UIColor(red: (255.0 / 255.0), green:(230.0 / 255.0), blue:(230.0 / 255.0), alpha:1.0)
        }
        else if (3.0 <= mag && mag < 4.0)
        {
            color = UIColor(red: (255.0 / 255.0), green:(204.0 / 255.0), blue:(204.0 / 255.0), alpha:1.0)
        }
        else if (4.0 <= mag && mag < 5.0)
        {
            color = UIColor(red: (255.0 / 255.0), green:(153.0 / 255.0), blue:(153.0 / 255.0), alpha:1.0)
        }
        else if (5.0 <= mag && mag < 6.0)
        {
            color = UIColor(red: (255.0 / 255.0), green:(128.0 / 255.0), blue:(128.0 / 255.0), alpha:1.0)
        }
        else if (6.0 <= mag && mag < 7.0)
        {
            color = UIColor(red: (255.0 / 255.0), green:(102.0 / 255.0), blue:(102.0 / 255.0), alpha:1.0)
        }
        else if (7.0 <= mag)
        {
            color = UIColor(red: (255.0 / 255.0), green: 0.0, blue: 0.0, alpha: 1.0)
        }

        return color
    }

    func loadTableData()
    {
        earthshakeTableView.isHidden = true
    
        spinner.startAnimating()
    
        super.getRequestedData(success:
            {
                (earthshakeItems) in
            
                // Success
                self.spinner.stopAnimating()

                self.allEarthshakeItems = earthshakeItems as! [EarthshakeItem]
                self.earthshakeTableView.isHidden = false
                self.earthshakeTableView.reloadData()

                if earthshakeItems.count > 0
                {
                    self.hideSearchBar()
                }
        },
                               failure:
            {
                (error) in

                // Failure
                self.spinner.stopAnimating()

                super.displayAlert(error: error)
        })
    }

    func hideSearchBar()
    {
        earthshakeTableView.setContentOffset(CGPoint(x: 0.0, y: (earthshakeTableView.tableHeaderView?.frame.size.height)!), animated: true)
    }
    
    override func didSelectRefresh()
    {
        super.didSelectRefresh()
    
        loadTableData()
    }
}
