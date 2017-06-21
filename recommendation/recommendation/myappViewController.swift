//
//  myappViewController.swift
//  recommendation
//
//  Created by 戴余修 on 2017/4/12.
//  Copyright © 2017年 jamesTai. All rights reserved.
//

import UIKit
import Foundation

class myappViewController: UITableViewController{
    
    var dataarray = [AnyObject]()
    let URL_SAVE_TEAM = "http://10.232.204.235/myapp/Sorting.php"

    override func viewDidLoad() {
        super.viewDidLoad()
        phpconnect()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(refreshData),
                                       for: .valueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新數據")
        
        refreshData()
        
        self.tableView.contentInset = UIEdgeInsets(top:20,left:0,bottom:0,right:0)
        
           }
    // 刷新数据
    func refreshData() {
        self.dataarray.removeAll()
        phpconnect()
        self.refreshControl!.endRefreshing()
            }
    

    func phpconnect(){
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_TEAM)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            //parsing the response
            //converting resonse to NSDictionary
            do {
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                
                
                self.dataarray = myJSON["item"] as! [AnyObject]
                self.tableView.reloadData()
                
                //parsing the json
                
            } catch {
                print(error)
            }
            
            
            
        }
        //executing the task
        task.resume()

        
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataarray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = dataarray[indexPath.row]["Name"] as? String

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showitem", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showitem"{
            if let dvc = segue.destination as? ViewController{
                if let selectedrow = tableView.indexPathForSelectedRow?.row{
                dvc.infoFromViewOne = dataarray[selectedrow]["ID"] as? String
                dvc.infoFromViewOne1 = dataarray[selectedrow]["Name"] as? String

                }
            }
    }

    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



}
