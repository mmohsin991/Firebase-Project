//
//  model.swift
//  Firebase Project
//
//  Created by Mohsin on 25/12/2014.
//  Copyright (c) 2014 Mohsin. All rights reserved.
//

import Foundation

let ref = Firebase(url: "https://sweltering-inferno-1689.firebaseio.com/")


struct Model {
    
    static func addUser(#username: String, email: String, fname: String, lname: String, teams: [String : Bool]){
    
        let usersRef = ref.childByAppendingPath("users")
    
        let insertedData = [username : [
            "firstName" : fname,
            "lastName" : lname,
            "email" : email,
            "teams" : teams
        ]]
        
        usersRef.updateChildValues(insertedData)
        
    
    }
    
    static func addUser(user: WowUser){
        
        let usersRef = ref.childByAppendingPath("users")
        
        if user.teams != nil {
            let insertedData = [user.userName : [
                "email" : user.email,
                "firstName" : user.firstName,
                "lastName" : user.lastName,
                "teams" : user.teams
            ]]
            
            usersRef.updateChildValues(insertedData)
        }
        else{
            let insertedData = [user.userName : [
                "email" : user.email,
                "firstName" : user.firstName,
                "lastName" : user.lastName,
            ]]
            
            usersRef.updateChildValues(insertedData)
        }

        
    }
    
    
    static func addTeam(#ancestorRef: String!, name: String, admins: [String : Bool], members: [String : Bool], subTeams : [String : AnyObject]!){
        
        let rootTeamRef = ref.childByAppendingPath("teams")
        var teamRef: Firebase!
        
        // if parent is null means this is the root team (orginization) so add at the teams node
        if ancestorRef == nil {
            teamRef = rootTeamRef
            if subTeams == nil {
                let insertedData = [name : [
                    "admins" : admins,
                    "members" : members,
                ]]
                teamRef.updateChildValues(insertedData)
            }
            else {
                let insertedData = [name : [
                    "admins" : admins,
                    "members" : members,
                    "subTeams" : subTeams
                ]]
                teamRef.updateChildValues(insertedData)
            }
        }
        
        // if parent is not null means this is the sub team of any team and add this at the subteams array of parant team
        else{
            teamRef = rootTeamRef.childByAppendingPath("\(ancestorRef)/subTeams")
            
            if subTeams == nil {
                let insertedData = [name : [
                    "admins" : admins,
                    "members" : members,
                ]]
                teamRef.updateChildValues(insertedData)
            }
            else {
                let insertedData = [name : [
                    "admins" : admins,
                    "members" : members,
                    "subTeams" : subTeams
                ]]
                teamRef.updateChildValues(insertedData)
            }
        }
        
    }
    
    static func addTeam(team : WowTeam){
            
        if team.subTeams == nil {
            let insertedData = [team.name : [
                "admins" : team.admins,
                "members" : team.members,
            ]]
            team.teamRef.updateChildValues(insertedData)
        }
                
        else {
            let insertedData = [team.name : [
                "admins" : team.admins,
                "members" : team.members,
            ]]
            team.teamRef.updateChildValues(insertedData)
            
            for x in team.subTeams{
                self.addTeam(x)
            }
        }
        
    }
    

    static func getUser(userName: String) {
        var email: String!
        var firstName: String!
        var lastName: String!
        var teams: [String : Bool]!

        
        let refUsers = ref.childByAppendingPath("users")
    
        
        refUsers.queryOrderedByKey().queryEqualToValue(userName).observeSingleEventOfType(.ChildAdded, withBlock: { snapshot in
           
            if snapshot != NSNull() {
                if let fName = snapshot.value["firstName"] as? String {
                    firstName = fName
                }
                if let lName = snapshot.value["lastName"] as? String {
                    lastName = lName
                }
                if let tempemail = snapshot.value["email"] as? String {
                    email = tempemail
                }
                if let tempteams = snapshot.value["teams"] as? [String : Bool] {
                    teams = tempteams
                }
                println(WowUser(userName: userName, email: email, firstName: firstName, lastName: lastName, teams: teams))

            }

        })
        

    }

}


class WowUser {
    var userName: String
    var email: String
    var firstName: String
    var lastName: String
    var teams: [String : Bool]!
    
    init(userName: String, email: String, firstName: String, lastName: String, teams: [String : Bool]!){
        self.userName = userName
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.teams = teams
    }
}

class WowTeam {
    var teamRef: Firebase
    var name: String
    var admins: [String: Bool]
    var members: [String: Bool]
    var subTeams: [WowTeam]!
    
    init(ancestorRef: String?, name: String, admins: [String: Bool], members: [String: Bool], SubTeams: [WowTeam]?) {
        if ancestorRef == nil {
            self.teamRef = ref.childByAppendingPath("teams")
        }
        else{
            self.teamRef = ref.childByAppendingPath("teams/\(ancestorRef!)/subTeams")
        }
        self.name = name
        self.admins = admins
        self.members = members
        self.subTeams = SubTeams
    }

}
