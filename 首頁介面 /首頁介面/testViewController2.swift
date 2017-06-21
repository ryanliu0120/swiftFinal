//
//  testViewController2.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/5/15.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class testViewController2: UIViewController {
    
    var count = 0
    var E :String = "null"
    var F :String = "null"
    var G :String = "null"
    var H :String = "null"
    var selected2 = ["0"]
    let URL_TEST = "http://140.119.19.18/FC/quiz2.php"
    
    
    @IBOutlet var nextbutton: UIButton?
    
    @IBAction func itemE(_ sender: myRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            E = "E"
            selected2.append("E")
        } else{
            
            E = "null"
            selected2.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    
    @IBAction func itemF(_ sender: myRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            F = "F"
            selected2.append("F")
        } else{
            
            F = "null"
            selected2.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    
    @IBAction func itemG(_ sender: myRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            G = "G"
            selected2.append("G")
        } else{
            
            G = "null"
            selected2.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    
    @IBAction func itemH(_ sender: myRadioButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            H = "H"
            selected2.append("H")
        } else{
            
            H = "null"
            selected2.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    @IBAction func summit2(_ sender: Any) {
        if E=="null" && F=="null" && G=="null" && H=="null" || selected2.count>=4 {
            
            let alertController = UIAlertController(title: "Warning!", message:
                "Can't choose nothing or choose over 2 items", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
            
            
        }else{
            
            performSegue(withIdentifier: "show3" , sender: nil)
            
            let requestURL = NSURL(string: URL_TEST)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            
            
            //creating the post parameter by concatenating the keys and values from text field
            //let postParameters = "ID="+selected[0]+"&ID1="+selected[1]+"&ID2="+selected[2]+"&ID3="+selected[3]      //adding the parameters to request body
            let long2 = selected2.count-1
            
            let longstring2 = "\(long2)"
            
            let id = SharingManager.sharedInstance.shareId
            
            let postParameters = "ID4="+E+"&ID5="+F+"&ID6="+G+"&ID7="+H+"&uid="+id+"&long2="+longstring2
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    print("error is \(String(describing: error))")
                    return;
                }
                
                //parsing the response
            }
            //executing the task
            task.resume()
            
        }

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nextbutton?.layer.cornerRadius = 4.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
