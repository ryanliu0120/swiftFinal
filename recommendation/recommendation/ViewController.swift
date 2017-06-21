//
//  ViewController.swift
//  recommendation
//
//  Created by 戴余修 on 2017/3/24.
//  Copyright © 2017年 jamesTai. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    var imageFromViewOne:String?
    var infoFromViewOne:String?
    var infoFromViewOne1:String?
    var session = URLSession(configuration: .default)
    
    let URL_SAVE_TEAM = "http://10.232.193.110/myapp/createteam.php"
    
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var ITEMA: UILabel!
    
       override func viewDidLoad() {
        super.viewDidLoad()
        //取得圖片
        let imageurl:String = imageFromViewOne!
        
        let URLimage = "http://10.232.193.110/myapp/\(imageurl)"
        //print(URLimage)
        
        if let imageURL = URL(string:URLimage ){
            let datatask = session.downloadTask(with: imageURL, completionHandler: {
                (url, response, error) in
                if error != nil{
                    print("error is \(error)")
                    return;
                }
                if let okURL = url{
                    do{
                        let downloadImage = UIImage(data: try Data(contentsOf: okURL))
                        DispatchQueue.main.async {
                            self.ImageView.image = downloadImage
                        }
                    }catch {
                        print(error)
                    }

                }
                
                
            })
            datatask.resume()
        
        }
        
        
        //if let URLimage = URLimage //如果有圖片網址，向伺服器請求圖片資料
        //{
           // let sessionWithConfigure = URLSessionConfiguration.default
            
            //let session = URLSession(configuration: sessionWithConfigure, delegate: self, delegateQueue: OperationQueue.main)
            
            //let dataTask = session.downloadTask(with: ((NSURL(string: URLimage ) as? URL))!)
            
           // dataTask.resume()
        //}
        
        
        ITEMA.text = infoFromViewOne1
        
        if let itemid = infoFromViewOne{
        
        //created NSURL
        let requestURL = NSURL(string: URL_SAVE_TEAM)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "ID="+itemid
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            //parsing the response
        }
        //executing the task
        task.resume()

    }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

}

