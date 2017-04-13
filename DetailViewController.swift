//
//  DetailViewController.swift
//  WorkEmon
//
//  Created by Tomas on 7/28/16.
//  Copyright © 2016 Tomas Kihlman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var job: JobDetail! = nil
    
    
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL (string: job.url!);
        let requestObj = NSURLRequest(URL: url!);
        webview.loadRequest(requestObj);
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onBtnBack () {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    

}
