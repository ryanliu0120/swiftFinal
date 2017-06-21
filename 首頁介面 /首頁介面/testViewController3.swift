//
//  testViewController3.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/5/15.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class testViewController3: UIViewController {
    
    var I :String = "null"
    var J :String = "null"
    var K :String = "null"
    var L :String = "null"
    var selected3 = ["0"]
    let URL_TEST = "http://140.119.19.18/FC/quiz3.php"
    
    
    @IBOutlet var nextbutton: UIButton?
    
    @IBAction func itemI(_ sender: myRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            I = "I"
            selected3.append("I")
        } else{
            
            I = "null"
            selected3.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    @IBAction func itemJ(_ sender: myRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            J = "J"
            selected3.append("J")
        } else{
            
            J = "null"
            selected3.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    
    @IBAction func itemK(_ sender: myRadioButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            K = "K"
            selected3.append("K")
        } else{
            
            K = "null"
            selected3.removeLast()
            //selected.remove(at: 3)
            
            
        }

    }
    
    @IBAction func itemL(_ sender: myRadioButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected{
            
            L = "L"
            selected3.append("L")
        } else{
            
            L = "null"
            selected3.removeLast()
            //selected.remove(at: 3)
            
            
        }

        
        
        
    }
    
    @IBAction func summit3(_ sender: Any) {
        if I=="null" && J=="null" && K=="null" && L=="null" || selected3.count>=4 {
            
            let alertController = UIAlertController(title: "Warning!", message:
                "Can't choose nothing or choose over 2 items", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return
            
            
        }else{
            
            performSegue(withIdentifier: "gohome" , sender: nil)
            
            let requestURL = NSURL(string: URL_TEST)
            
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            
            
            //creating the post parameter by concatenating the keys and values from text field
            //let postParameters = "ID="+selected[0]+"&ID1="+selected[1]+"&ID2="+selected[2]+"&ID3="+selected[3]      //adding the parameters to request body
            let long3 = selected3.count-1
            
            let longstring3 = "\(long3)"
            
            let id = SharingManager.sharedInstance.shareId
            
            let postParameters = "ID8="+I+"&ID9="+J+"&ID10="+K+"&ID11="+L+"&uid="+id+"&long3="+longstring3
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
