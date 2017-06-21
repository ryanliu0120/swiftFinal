//
//  home.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/4/6.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class home: UIViewController {
    
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/ranking.php"
    
    @IBOutlet weak var clothe1: UIButton!
    @IBOutlet weak var clothe2: UIButton!
    @IBOutlet weak var clothe3: UIButton!
    @IBOutlet weak var clothe4: UIButton!
    @IBOutlet weak var clothe5: UIButton!
    @IBOutlet weak var clothe6: UIButton!
    @IBOutlet weak var clothe7: UIButton!
    @IBOutlet weak var clothe8: UIButton!
    @IBOutlet weak var clothe9: UIButton!

    
    @IBOutlet weak var simulator: UIButton!
    
    
    var clothe: Array<UIButton> = []
    
    
    var clotheArray = [String]()
    var list = [String]()
    
    
    @IBAction func goDetail(_ sender: UIButton) {
        //透過viewController之間連線的segue
        self.performSegue(withIdentifier: "goDetail", sender: sender.tag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //透過viewController之間連線的segue
        
        if segue.identifier == "goDetail"{
        
        let tag = sender as! Int
        let controller = segue.destination as! ClotheDetail
        controller.detail = list[tag]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        
        clothe.insert(clothe1, at: 0)
        clothe.insert(clothe2, at: 1)
        clothe.insert(clothe3, at: 2)
        clothe.insert(clothe4, at: 3)
        clothe.insert(clothe5, at: 4)
        clothe.insert(clothe6, at: 5)
        clothe.insert(clothe7, at: 6)
        clothe.insert(clothe8, at: 7)
        clothe.insert(clothe9, at: 8)

        
        //1-12:0-11
        
        let id = SharingManager.sharedInstance.shareId
    
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "userId="+id;
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
            print("首頁 = \(String(describing: responseString))")
            
            self.clotheArray = (responseString?.characters.split{$0==","}.map(String.init))!
            
            for i in 0 ..< self.clotheArray.count/2{
                self.list.append(self.clotheArray[2*i+1])
            }
            
            
            
            for i in 0...8{
                self.clothe[i].downloadedFrom(link: "http://140.119.19.18/img/\(self.clotheArray[2*i+1])")
                //要做迴圈1-12
            }
            
        }
        
        task.resume()
        


    }
    func call(){
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let id = SharingManager.sharedInstance.shareId
        let postString = "userId="+id;
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
            print("首頁 = \(String(describing: responseString))")
            
            self.clotheArray = (responseString?.characters.split{$0==","}.map(String.init))!
            
            for i in 0 ..< self.clotheArray.count/2{
                self.list.append(self.clotheArray[2*i+1])
            }
            
            
            
            for i in 0...8{
                self.clothe[i].downloadedFrom(link: "http://140.119.19.18/img/\(self.clotheArray[2*i+1])")
                //要做迴圈1-12
            }
            
        }
        
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        list.removeAll()
        call()
        
        
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

extension UIButton {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.sync() { () -> Void in
                //(self.subviews[0] as! UIImageView).contentMode = .scaleAspectFit
                self.setBackgroundImage(image, for: UIControlState.normal)
               // self.imageView?.contentMode = UIViewContentMode.scaleToFill
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

