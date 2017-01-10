//
//  EarthshakeDetailsViewController.swift
//  Earthshake
//
//  Created by Andrey on 2017-01-03.
//  Copyright © 2017 AP. All rights reserved.
//

import Foundation

class EarthshakeDetailsViewController: EarthshakeBaseViewController, UIWebViewDelegate
{
    @IBOutlet weak var earthshakeWebView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var detailURLString = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        earthshakeWebView.delegate = self
        
        loadDetailsData()
    }
    
    // WebView delegate methods
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        spinner.stopAnimating()
        
        earthshakeWebView.isHidden = false
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error)
    {
        spinner.stopAnimating()
    }
    
    // Helper methods
    
    func loadDetailsData()
    {
        earthshakeWebView.isHidden = true

        spinner.startAnimating()

        let url = URL(string: detailURLString)
        let requestObject: URLRequest = URLRequest(url: url!)

        earthshakeWebView.loadRequest(requestObject)
    }
    
    override func didSelectRefresh()
    {
        super.didSelectRefresh()
        
        loadDetailsData()
    }
}
