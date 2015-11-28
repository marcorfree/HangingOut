//
//  FeedsTableViewController.swift
//  HangingOut
//
//  Created by Marco Rago on 28/11/15.
//  Copyright © 2015 marcorfree. All rights reserved.
//

import UIKit
import Parse

class FeedsTableViewController: UITableViewController {

    var usernames = [String]()
    
    var titles = [String]()
    
    var images = [UIImage]()
    
    var imageFiles = [PFFile]()
    
    //var followings
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        let followersQuery = PFQuery(className:"Followers")
        followersQuery.whereKey("follower", equalTo:PFUser.currentUser()!.username!)
        followersQuery.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                //self.followings.removeAll(keepCapacity: true)
                //print("Successfully retrieved \(objects!.count) followings.")
                // Do something with the found objects
                for object in objects! {
                    //self.followings.append(object.["following"] as! String)
                    
                    let postQuery = PFQuery(className:"Post")
                    postQuery.whereKey("username", equalTo: object["following"])
                    postQuery.findObjectsInBackgroundWithBlock {
                        (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            // The find succeeded.
                            //print("Successfully retrieved \(objects!.count) scores.")
                            // Do something with the found objects
                            if let objects = objects {
                                for object in objects {
                                    //print(object.objectId)
                                    self.usernames.append(object["username"] as! (String))
                                    self.titles.append(object["title"] as! (String))
                                    //Postpone the images download later on, for performance purposes
                                    self.imageFiles.append(object["imageFile"] as! PFFile)
                                    self.tableView.reloadData()
                                }
                            }
                        } else {
                            // Log details of the failure
                            print("Error: \(error!) \(error!.userInfo)")
                        }//endelse
                    }//endblock postQuery

                    
                    
                    
                } //endfor
            } //endif

        } //endblock followersQuery
        
        
        
        
    }//viewDidLoad()

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
        return  titles.count
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //Specify that the cell is an own cell, not the stard one
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedsTableViewCell

        // Configure the cell...
        
        cell.usernameLabel.text = usernames[indexPath.row]
        
        cell.titleLabel.text = titles[indexPath.row]

        imageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                let image = UIImage(data:imageData!)
                cell.imageView1.image = image
            }
        }
        
        
        return cell
    }
    

    
    //The height of the cell in can be even left to the the default. Set at runtime, for dynamic cells
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 220
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
