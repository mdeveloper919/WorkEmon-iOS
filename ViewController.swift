//
//  ViewController.swift
//  WorkEmon
//
//  Created by Tomas on 7/22/16.
//  Copyright © 2016 Tomas Kihlman. All rights reserved.
//
import 	GoogleMobileAds
import UIKit

class JobDetail: NSObject {
    
    var jobtitle: String?
    var company: String?
    var city: String?
    var state: String?
    var country: String?
    var formattedLocation: String?
    var source: String?
    var date: String?
    var datePosted: NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, d MMM yyyy HH:mm:ss zzz"
        let formattedDate: NSDate = dateFormatter.dateFromString(date!)!
        return formattedDate
    }
    var snippet: String?
    var url: String?
    var jobkey: String?
    var formattedLocationFull: String?
    var sponsored: NSNumber?
    var expired: NSNumber?
    var indeedApply: NSNumber?
    var formattedRelativeTime: String?
    var noUniqueUrl: NSNumber?
    var onmousedown: String?
    
    init(dict: [String: AnyObject]) {
        super.init()
        self.setValuesForKeysWithDictionary(dict)
    }
    
}

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var searchControl: UISearchBar?
    @IBOutlet var searchResultTableView: UITableView?
    @IBOutlet weak var admobView: GADBannerView!  
    
    
    var jobs: [JobDetail]! = []
    var indeedURL = "http://api.indeed.com/ads/apisearch?publisher=5572911862581719&format=json&userip=127.0.0.1&filter=1&limit=15&co=us&useragent=Mozilla/5.0%20(iPhone;%20CPU%20iPhone%20OS%209_1%20like%20Mac%20OS%20X)%20AppleWebKit/601.1.46%20(KHTML,%20like%20Gecko)%20Version/9.0%20Mobile/13B143%20Safari/601.1&v=2&q="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
       // admobView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        admobView.adUnitID = "ca-app-pub-1896414122247902/7539162229"
        admobView.rootViewController = self
        admobView.loadRequest(GADRequest())

        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func getJobsForUrl(url: NSURL, completion: (success: Bool, result: NSArray?, jobs: [JobDetail]?, error: NSError?) -> ()) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url) {
            (data, response, error) -> Void in
            if let _ = data {
                do {
                    if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        let results = jsonResult["results"] as!  [AnyObject]!
                        var jobs: [JobDetail] = []

                        for items in results {
                            let item = items as! [String : AnyObject]
                            let jobItem: JobDetail = JobDetail(dict: item)
                            jobs.append(jobItem)
                        }
                        completion(success: true, result: nil, jobs: jobs, error: nil)
                    }
                }
                catch let error as NSError {
                    if error.code == 3840 {
                        completion(success: false, result: nil, jobs: nil, error: error)
                    }
                }
            }
            else {
                completion(success: false, result: nil, jobs: nil, error: error)
            }
        }
        task.resume()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchControl?.resignFirstResponder()
        
        var searchString: String! = searchControl?.text
        if (searchString.isEmpty) {
            return
        }

        
        searchString = searchString.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        print(searchString)
        
        let urlString = "\(indeedURL)\(searchString)"
        let url = NSURL(string: urlString)
        
        getJobsForUrl(url!) { (success, result, jobs, error) in
            if jobs != nil {
                self.jobs = jobs
            }
            else {
                self.jobs = []
            }
            self.searchResultTableView?.reloadData()
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dispatch_async(dispatch_get_main_queue(), {
            let backgroundImage = UIImage(named: "background.png")
            let imageView = UIImageView(image: backgroundImage)
            tableView.backgroundView = imageView
        })
        
        
        return jobs.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let job = jobs[indexPath.row]
        let text = job.snippet?.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        
        let constraintRect = CGSize(width: tableView.bounds.width - 16, height: 9999)
        let font = UIFont.systemFontOfSize(14)
        let size: CGSize = text!.boundingRectWithSize(constraintRect, options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil).size as CGSize
        
        return size.height + 90
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("JobCell", forIndexPath: indexPath) as! JobCell
        let job = jobs[indexPath.row]
        
        //  cell.backgroundColor = .clearColor()
     //   cell.backgroundColor = UIColor.whiteColor()
        
        cell.jobTitle.text = job.jobtitle!.capitalizedString
        cell.jobTitle.textColor = UIColor.blueColor()
        cell.jobCompany.text = job.company! + " - " + job.formattedLocation!
        cell.snippet.text = job.snippet?.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        cell.snippet.textColor = UIColor(red: 114 / 255,
                                         green: 114 / 255,
                                         blue: 114 / 255,
                                         alpha: 1.0)
        cell.relativetime.text = job.formattedRelativeTime
        cell.relativetime.textColor = UIColor.redColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        viewController.job = jobs[indexPath.row]
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

