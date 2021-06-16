//
//  PrivacyPolicyViewController.swift
//  StuckByKev Release Form
//
//  Created by Kevin Green on 11/14/16.
//  Copyright © 2016 Kevin Green. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var webView: WKWebView!
    
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\n**** PrivacyPolicyViewController ****")
        
        title = "Privacy Policy"
        webView.scrollView.minimumZoomScale = 0.01
        
        if let pdf = Bundle.main.url(forResource: "Privacy_Policy", withExtension: "pdf", subdirectory: nil, localization: nil)  {
            let req = URLRequest(url: pdf)
            webView.load(req as URLRequest)
        }
    }
    
    deinit { print("PrivacyPolicyViewController DEINIT") }
    
    
}

