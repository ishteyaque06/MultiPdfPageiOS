//
//  WebViewController.swift
//  MultiPdfPageiOS
//
//  Created by Ahmed on 11/01/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit
class WebViewController: UIViewController {

    //@IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var webView: UIWebView!
    var urlString=""
    override func viewDidLoad() {
        super.viewDidLoad()
        let url=URL(string: urlString)
        let request=URLRequest(url: url!)
        webView.loadRequest(request)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
