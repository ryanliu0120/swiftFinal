//
//  testViewController.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/5/15.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    
    var count = 0
    var A :String = "null"
    var B :String = "null"
    var C :String = "null"
    var D :String = "null"
    
    
    var selected = ["0"]
    
    
    let URL_TEST = "http://140.119.19.18/FC/quiz.php"
    
    

    @IBOutlet var nextbutton: UIButton?
   
    
    
    @IBAction func summit(_ sender: Any) {
        
        
        
        if A=="null" && B=="null" && C=="null" && D=="null" || selected.count>=4 {
            
            let alertController = UIAlertController(title: "Warning!", message:
                "Can't choose nothing or choose over 2 items", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
            
            
        }else{
            
            performSegue(withIdentifier: "show2" , sender: nil)
            
            let requestURL = NSURL(string: URL_TEST)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            
            
            //creating the post parameter by concatenating the keys and values from text field
            //let postParameters = "ID="+selected[0]+"&ID1="+selected[1]+"&ID2="+selected[2]+"&ID3="+selected[3]      //adding the parameters to request body
            let long = selected.count-1
            
            let longstring = "\(long)"
            
            let id = SharingManager.sharedInstance.shareId
            
            let postParameters = "ID="+A+"&ID1="+B+"&ID2="+C+"&ID3="+D+"&uid="+id+"&long="+longstring
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
    
    
    
    
    @IBAction func itemA(_ sender: myRadioButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            A = "A"
            selected.append("A")
            
        } else{
            
            A = "null"
            selected.removeLast()
            
            //selected.remove(at: 3)
            
            
        }

        
    }
    
    
    @IBAction func itemB(_ sender: myRadioButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            B = "B"
            selected.append("B")
        } else{
            
            B = "null"
            selected.removeLast()
            //selected.remove(at: 3)
            
            
        }

        
    }
    
    @IBAction func itemC(_ sender: myRadioButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            C = "C"
            selected.append("C")
        } else{
            
            C = "null"
            selected.removeLast()
            //selected.remove(at: 3)
            
            
        }

        
        
    }
    
    @IBAction func IitemD(_ sender: myRadioButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            D = "D"
            selected.append("D")
        } else{
            
            D = "null"
            selected.removeLast()
            //selected.remove(at: 3)
            
            
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
