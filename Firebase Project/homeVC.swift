//
//  homeVC.swift
//  Firebase Project
//
//  Created by Mohsin on 22/12/2014.
//  Copyright (c) 2014 Mohsin. All rights reserved.
//

import UIKit

class homeVC: UIViewController {
    
    var msg: String!
    var status: String!

    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var btnBack: UIButton!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnBack.layer.cornerRadius = 4.0
        if msg != nil {
            self.txtMessage.text = self.msg
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(sender: AnyObject) {
       // performSegueWithIdentifier("backSeg", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
