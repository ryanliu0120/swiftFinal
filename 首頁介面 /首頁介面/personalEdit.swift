//
//  personalEdit.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/4/25.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class personalEdit: UIViewController {
    
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/edit.php"

    @IBOutlet weak var user: UITextField!
    
    
    @IBOutlet weak var passwd: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var comfirm: UIButton!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comfirm.layer.cornerRadius = 4.0
        //comfirm.layer.borderWidth = 1.0
        //comfirm.layer.borderColor = UIColor.blue.cgColor
        
        self.user.text = SharingManager.sharedInstance.shareUser
        self.passwd.text = SharingManager.sharedInstance.sharePasswd
        self.email.text = SharingManager.sharedInstance.shareEmail


        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func reg(_ sender: UIButton)
    {
        let user = self.user.text
        let passwd = self.passwd.text
        let email = self.email.text
        let id = SharingManager.sharedInstance.shareId
        
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "id="+id+"&name="+user!+"&passwd="+passwd!+"&email="+email!;
        //送資料到伺服器
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil
                else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
            }
            //確認連線
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("修改個人資訊 = \(String(describing: responseString))")
            
            
            SharingManager.sharedInstance.shareUser = user!
            SharingManager.sharedInstance.sharePasswd = passwd!
            SharingManager.sharedInstance.shareEmail = email!
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "", message:
                    "修改成功！", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            
        }
        
        task.resume()
        //資料庫回傳確認
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        //隱藏鍵盤
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
