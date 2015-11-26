//
//  UserTableViewController.swift
//  HangingOut
//
//  Created by Marco Rago on 26/11/15.
//  Copyright © 2015 marcorfree. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {

    var users = [String]()
    
    var followings = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        getUsers()
        
        getFollowings()
        
    }
    
  
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    func getUsers(){
        let query = PFUser.query()!
        //let query = PFQuery(className: "_User")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?)  -> Void in
            
            if error == nil {
                // The find succeeded.
                //print("Successfully retrieved \(objects!.count) items.")
                // Do something with the found objects

                      for object in objects! {
                        let user:PFUser = object as! PFUser
                        if user.username != PFUser.currentUser()?.username {
                          self.users.append(user.username!)
                        }
                        
                }
            self.tableView.reloadData()
            }
            else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    func getFollowings() {
        let query = PFQuery(className:"Followers")
        query.whereKey("follower", equalTo:PFUser.currentUser()!.username!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                //print("Successfully retrieved \(objects!.count) followings.")
                // Do something with the found objects
                for object in objects! {
                    let s: String = object.objectForKey("following") as! String
                    //print(s)
                    self.followings.append(s)
                    //print("followings int=\(self.followings)")
                }
            }
        }
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = users[indexPath.row]
        //Mark the followings
        if followings.contains(users[indexPath.row]) { cell.accessoryType = UITableViewCellAccessoryType.Checkmark }
        return cell
    }
    

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRow:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        
        if selectedRow.accessoryType == UITableViewCellAccessoryType.Checkmark {
            selectedRow.accessoryType = UITableViewCellAccessoryType.None
            let query = PFQuery(className:"Followers")
            query.whereKey("follower", equalTo:PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo:selectedRow.textLabel!.text!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    //print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                            object.deleteInBackground()
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        } else {
           selectedRow.accessoryType = UITableViewCellAccessoryType.Checkmark
           let follower = PFObject(className: "Followers")
            follower["follower"] = PFUser.currentUser()!.username
            follower["following"] = selectedRow.textLabel!.text!
            follower.saveInBackground()
            
        }
    }

    
    
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
