//
//  ViewController.swift
//  Firebase Project
//
//  Created by Mohsin on 19/12/2014.
//  Copyright (c) 2014 Mohsin. All rights reserved.
//

import UIKit
import SwiftHTTP

class ViewController: UIViewController {

    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    @IBOutlet weak var watingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.watingIndicator.hidden = true
        
        
        self.btnSignIn.layer.cornerRadius = 4.0
        self.btnSignUp.layer.cornerRadius = 4.0

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    
    }

    @IBAction func signUP(sender: UIButton) {
        
        self.watingIndicator.hidden = false
        
        let ref = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com")
        
        ref.createUser(self.txtEmail.text, password: self.txtPassword.text,
            withCompletionBlock: { error in
                self.watingIndicator.hidden = true
                
                if error != nil {
                    // There was an error creating the account
                    self.lblErrorMsg.text = error.localizedDescription
                    
                } else {
                    // We created a new user account
                    
                    self.performSegueWithIdentifier("homeSeg", sender: "successfuly sign up")
                    

                }
        })
        
    }
    
    
    @IBAction func signIn(sender: UIButton) {
        
        self.watingIndicator.hidden = false
        
        let ref = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com")
        
        ref.authUser(self.txtEmail.text, password: self.txtPassword.text,
            withCompletionBlock: { error, authData in
                self.watingIndicator.hidden = true
                
                if error != nil {
                    // There was an error logging in to this account
                    self.lblErrorMsg.text = error.localizedDescription

                } else {
                    // We are now logged in
                   var message = "successfuly sign in "
//                    
                    message += "\n  User id: \(authData.uid)"
//                    message += "\n  User provider: \(authData.provider)"
//                    message += "\n  User expires time: \(authData.expires)"
                    let email: AnyObject = authData.providerData["email"]!
                    message += "\n  User email : \(email) "
//                    message += "\n  User token: \(authData.token)"
//
//                    
//                    self.performSegueWithIdentifier("homeSeg", sender: message)
                    
                        self.performSegueWithIdentifier("rootSeg", sender: message)


                }

        })

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "homeSeg" {
            let desVC = segue.destinationViewController as homeVC
            
            desVC.msg = sender as? String
            
        }
        if segue.identifier == "rootSeg" {
            let desVC = segue.destinationViewController as RootVC
            
            desVC.userInfo = sender as? String
            
        }
    }
    
    
    
    @IBAction func saveData(sender: AnyObject) {
        // firebase example
        
        let ref = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com/")
        
        let userDetail = [
            ["name":"Muhammad Mohsin", "email":"mmohsin.ee@gmail.com"],
            ["name":"Muhammad Ali Jhana", "email":"ali_22@gmail.com"],
        ]
        
        let userRef = ref.childByAppendingPath("users")
        
        let users = ["mohsin":userDetail[0],"ali":userDetail[1]]
        
        
        userRef.setValue(users)
        
//        ref.observeEventType(FEventType.Value, withBlock: { snapshot in })
//        
//        ref.observeEventType(FEventType.Value, withBlock: { snapShot in
//        println(snapShot.value )
//        },
//            withCancelBlock: nil)
        
        let ref1 = Firebase(url:"https://dinosaur-facts.firebaseio.com")
        ref1.queryOrderedByChild("height").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let height = snapshot.value.objectForKey("height") as? Double {
                println("\(snapshot.key) was \(height) meters tall")
            }
            
            var fd = FDataSnapshot()
            
            
        })
        
    
    }
    

}

