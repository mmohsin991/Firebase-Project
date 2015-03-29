//
//  RootVC.swift
//  Firebase Project
//
//  Created by Mohsin on 25/12/2014.
//  Copyright (c) 2014 Mohsin. All rights reserved.
//

import UIKit

class RootVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userInfo: String! = ""

    var subTeams = [String : AnyObject]()
    var members = [String : Bool]()
    var admins = [String : Bool]()
    var teamName : String! = "Loading..."
    var adminsName : String! = ""
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txtUserInfo: UITextView!
    @IBOutlet weak var btnLogOut: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableview.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        self.tableview.separatorInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        
        self.txtUserInfo.text = self.userInfo
        self.btnLogOut.layer.cornerRadius = 1.0
        
//       Model.addUser(username: "mohsin3", email: "harpal_1242@gmail.com", fname: "muhammad", lname: "mohsin", teams: ["team1" : true, "team2": true, "team3": true])
//        Model.addUser(WowUser(userName: "mohsin4", email: "hidsa@gmail.com", firstName: "M.", lastName: "Mohsin", teams: nil))

        
       // Model.addTeam(parent: "team1", name: "team3", admins: ["mohsin" : true], members: ["mohsin" : true, "mohsin1" : true], subTeams: nil)
        
//        Model.addTeam(ancestorRef: "team1", name: "team3", admins: ["mohsin" : true], members: ["mohsin" : true, "mohsin1" : true], subTeams: nil)
//        
//        let tempTeam = WowTeam(ancestorRef: "team5", name: "team1", admins: ["mohsin2" : true], members: ["mohsin": true, "mohsin1": true, "mohsin2": true], SubTeams: nil)
//        let tempTeam1 = WowTeam(ancestorRef: "team5", name: "team2", admins: ["mohsin2" : true], members: ["mohsin": true, "mohsin1": true, "mohsin2": true], SubTeams: nil)
//        let tempTeam2 = WowTeam(ancestorRef: "team5", name: "team3", admins: ["mohsin2" : true], members: ["mohsin": true, "mohsin1": true, "mohsin2": true], SubTeams: nil)
//        
//        
//        Model.addTeam(WowTeam(ancestorRef: nil, name: "team5", admins: ["mohsin2" : true], members: ["mohsin": true, "mohsin1": true, "mohsin2": true], SubTeams: [tempTeam, tempTeam1, tempTeam2]))
        
//        Model.getUser("mohsin3")
        
        
        let refUsers = ref.childByAppendingPath("teams")
        
        println(self.members)

        refUsers.queryOrderedByKey().queryEqualToValue("team5").observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
            
            if snapshot != NSNull() {
                if let admins = snapshot.value["admins"] as? [String : Bool] {
                    self.admins = admins
                }
                if let members = snapshot.value["members"] as? [String : Bool] {
                    self.members = members
                }
                if let subTeams = snapshot.value["subTeams"] as? [String : AnyObject] {
                    self.subTeams = subTeams
                }
                self.teamName = snapshot.key
                for x in self.admins.keys.array{
                    self.adminsName = self.adminsName + x + ", "
                }

                
            }
            println(self.subTeams.keys.array)
            self.tableview.reloadData()

        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subTeams.count + self.members.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.teamName) - \(self.adminsName)"
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
        
        if indexPath.row < self.subTeams.count{
            cell.textLabel?.text = self.subTeams.keys.array[indexPath.row]
            cell.textLabel?.textColor = UIColor.whiteColor()
            
            cell.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.2)
        }
        else{
            cell.textLabel?.text = self.members.keys.array[indexPath.row - self.subTeams.count]
            cell.textLabel?.textColor = UIColor.whiteColor()
            
            cell.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
        }
        

        
        return cell
    }


    @IBAction func logOut(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
