//
//  ViewController.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/3/7.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/index.php"
    let URL_LOGIN_TEAM = "http://140.119.19.18/FC/login.php"
    
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var emailforlogin: UITextField!
    
    @IBOutlet weak var passwdforlogin: UITextField!
    
    var currentTextField: UITextField?
    var isKeyboardShown = false
    
    
    
    @IBOutlet weak var login: UIButton?
    @IBOutlet weak var register: UIButton?
    @IBOutlet weak var personaledit: UIButton?
    @IBOutlet weak var mycloset: UIButton?
    @IBOutlet weak var wear: UIButton?
    @IBOutlet weak var socialpic: UIButton?
    @IBOutlet weak var logout: UIButton?
    @IBOutlet weak var gotest: UIButton?
    
    @IBOutlet var starttest: UIButton?
    
    
    


    
    @IBAction func reg(_ sender: UIButton)
    {
        let user = self.user.text
        let passwd = self.passwd.text
        let email = self.email.text
        
        if(user != "" && passwd != "" && email != ""){
        
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "name="+user!+"&passwd="+passwd!+"&email="+email!;
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
            print("註冊 = \(String(describing: responseString))")
            
            let responseArr = responseString?.characters.split{$0==","}.map(String.init)
            
            
            if(responseArr?[0] == "success")
            {
                OperationQueue.main.addOperation {
                    let storyboard = UIStoryboard(name:"Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier:"test")
                    self.present(controller, animated: true, completion: nil)
                }
                SharingManager.sharedInstance.shareUser = user!
                SharingManager.sharedInstance.sharePasswd = passwd!
                SharingManager.sharedInstance.shareEmail = email!
                SharingManager.sharedInstance.shareId = (responseArr?[1])!
            }
            else
            {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "", message:
                        "此信箱已被註冊", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            
            //註冊不用再回傳姓名密碼電子郵件

            
            
        }
        
        task.resume()
        //資料庫回傳確認
        }
        else{
            
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "", message:
                    "請完整填寫", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
            
        }
    }
    
    
    
    @IBAction func login(_ sender: UIButton)
    {
        let emailforlogin = self.emailforlogin.text
        let passwdforlogin = self.passwdforlogin.text
        
        if(emailforlogin != "" && passwdforlogin != ""){
            
        
        
        var request = URLRequest(url: URL(string: URL_LOGIN_TEAM)!)
        request.httpMethod = "POST"
        let postString = "email="+emailforlogin!+"&passwd="+passwdforlogin!;
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil
                else {
                    // check for fundamental networking error
                    print("error=\(String(describing: error))")
                    return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("登入 = \(String(describing: responseString))")

            let responseArr = responseString?.characters.split{$0==","}.map(String.init)
            
            
            

            //登入連到home 之後要放進success
            
            
            if(responseArr?[0] == "success")
            {
                OperationQueue.main.addOperation {
                    let storyboard = UIStoryboard(name:"Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier:"home")
                    self.present(controller, animated: true, completion: nil)
                }
                SharingManager.sharedInstance.shareUser = (responseArr?[1])!
                SharingManager.sharedInstance.sharePasswd = passwdforlogin!
                SharingManager.sharedInstance.shareEmail = emailforlogin!
                SharingManager.sharedInstance.shareId = (responseArr?[2])!
            
            }
            else
            {
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "", message:
                        "帳號或密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            
            }
            

            //放在success並切割字串
            
            
        }
        
        task.resume()
            
        
        }
        else{
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "", message:
                    "請填寫帳號及密碼", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            }
        }

 
        
    }
    
 

    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func keyboardWillShow(_ note: Notification) {
        if isKeyboardShown {
            return
        }
        if (currentTextField != passwd && currentTextField != passwdforlogin && currentTextField != emailforlogin && currentTextField != email && currentTextField != user ) {
            return
        }
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        let keyboardFrameValue = keyboardAnimationDetail[UIKeyboardFrameBeginUserInfoKey]! as! NSValue
        let keyboardFrame = keyboardFrameValue.cgRectValue
        
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -keyboardFrame.size.height/2)
        })
        isKeyboardShown = true
    }
    
    func keyboardWillHide(_ note: Notification) {
        let keyboardAnimationDetail = note.userInfo as! [String: AnyObject]
        let duration = TimeInterval(keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey]! as! NSNumber)
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: -self.view.frame.origin.y)
        })
        isKeyboardShown = false
    }
        
    


    
    
    
    
    
    


        
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        login?.layer.cornerRadius = 4.0
        register?.layer.cornerRadius = 4.0
        personaledit?.layer.cornerRadius = 4.0
        mycloset?.layer.cornerRadius = 4.0
        wear?.layer.cornerRadius = 4.0
        socialpic?.layer.cornerRadius = 4.0
        logout?.layer.cornerRadius = 4.0
        gotest?.layer.cornerRadius = 4.0
        starttest?.layer.cornerRadius = 4.0
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UploadImageViewController.keyboardWillShow(_:)),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(UploadImageViewController.keyboardWillHide(_:)),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil)
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: UITextFieldDelegate {
    /*func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     return true
     }*/
}

