//
//  ViewController.swift
//  MultiPdfPageiOS
//
//  Created by Ahmed on 11/01/18.
//  Copyright © 2018 Ahmed. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var tableView: UITableView!
    let dateFormatter=DateFormatter()
    var urlString=""

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib_Trace = UINib (nibName: "NewCustomTableViewCell", bundle: nil)
        tableView.register(cellNib_Trace, forCellReuseIdentifier:"Cell")
        tableView.delegate=self
        tableView.dataSource=self
        //tableView.reloadData()
    }
    @IBAction func generatePdf(_ sender: UIButton) {
        tableView.frame.size.height=tableView.contentSize.height
        pdfDataWithMultipleView(tableView: tableView, mapView: firstView)
    }
    
    func pdfDataWithMultipleView(tableView: UIView,mapView:UIView) {
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.width, height:tableView.frame.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        let pdfPageViewBounds=CGRect(x:0, y:0, width:mapView.frame.width, height:self.view.frame.height)
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageViewBounds,nil)
        UIGraphicsBeginPDFPage()
        mapView.layer.render(in: UIGraphicsGetCurrentContext()!)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        if let documentDirectories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            dateFormatter.dateFormat="dd-MM-yyyy HH:mm:ss"
            let fileName = "\(dateFormatter.string(from: Date()).removingWhitespaces()).pdf"
            let documentsFileName = documentDirectories + "/" + fileName
            let url=URL(string:"file://\(documentsFileName)")
            pdfData.write(to: url!, atomically: true)
            urlString=documentsFileName
            self.performSegue(withIdentifier: "toWebView", sender: self)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="toWebView"{
            if let webView=segue.destination as? WebViewController{
                webView.urlString=urlString
            }
        }
    }

}
extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)as! NewCustomTableViewCell
        cell.titleNewLabel?.text="Testing Pdf Generation"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
}
