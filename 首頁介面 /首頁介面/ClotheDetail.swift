//
//  ClotheDetail.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/4/6.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class ClotheDetail: UIViewController, UIScrollViewDelegate {
    
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/godetail.php"
    let URL_FAV = "http://140.119.19.18/FC/myfav.php"
    let URL_UPDATE = "http://140.119.19.18/FC/update.php"
 
    
    
    var detail = ""
    
    var detailArray = [String]()
    
    

    @IBOutlet var narration: UITextView!
    
    
    @IBOutlet weak var link: UITextView!
    
    
    @IBOutlet weak var clotheImage: UIImageView!
    
    @IBOutlet weak var brand: UILabel!
    
    @IBOutlet weak var clotheName: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet var contentview: UIView!
    
    @IBOutlet weak var scrollview: UIScrollView!
    
    @IBOutlet weak var addfav: UIButton!
    
    var clothe: [UIImageView] = []
    
    @IBOutlet weak var image1: UIImageView!
    
    @IBOutlet weak var image2: UIImageView!
    
    
    @IBOutlet weak var image3: UIImageView!
    
    
    @IBOutlet weak var image4: UIImageView!
    
    @IBOutlet weak var image5: UIImageView!
    
    @IBOutlet weak var image6: UIImageView!
    
    @IBOutlet weak var image7: UIImageView!
    
    
    @IBOutlet weak var image8: UIImageView!
   
    
    
    func updateInfo(){
        //更新畫面上的資訊
        //number.text = detail
        
        
        let id = SharingManager.sharedInstance.shareId
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "uid="+id+"&img0="+detail;
      
        
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
            print("商品資訊 = \(String(describing: responseString))")
            
            self.detailArray = (responseString?.characters.split{$0==","}.map(String.init))!
            
            if(self.detailArray[0] == "true"){
                
                DispatchQueue.main.async {
                    
                    self.addfav.backgroundColor = UIColor.red
                    //self.addfav.setTitle("已加入", for: UIControlState.normal)
                    self.addfav.setNeedsDisplay()
                }
            }
            else
            {
                DispatchQueue.main.async {
                    
                    self.addfav.backgroundColor = UIColor.darkGray
                    //self.addfav.setTitle("加入衣櫥", for: UIControlState.normal)
                    self.addfav.setNeedsDisplay()
                }
            }
            
            
            DispatchQueue.main.async {
                self.clotheImage.downloadedFrom(link: "http://140.119.19.18/img/"+self.detailArray[8])
                self.brand.text = self.detailArray[3]
                self.clotheName.text = self.detailArray[2]
                self.price.text = "NT$ \(self.detailArray[4])"
                
            }
            
            SharingManager.sharedInstance.shareItemId = self.detailArray[1]
            SharingManager.sharedInstance.shareImg = self.detailArray[8]

            //放在success並切割字串
            DispatchQueue.main.async {
            self.narration.text = self.detailArray[5]
            self.link.text = self.detailArray[6]
            }
            
            
            
            for i in 8..<self.detailArray.count-1{
                self.clothe[i-8].downloadedFrom(link: "http://140.119.19.18/img/"+self.detailArray[i])
            }
            
            self.addtag()
            
        }
        
        task.resume()


    }
    
    func addtag(){
        let id = SharingManager.sharedInstance.shareId
        
        var request = URLRequest(url: URL(string: URL_UPDATE)!)
        request.httpMethod = "POST"
        let postString = "uid="+id+"&itemid="+detailArray[1];
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
            print("加tag = \(String(describing: responseString))")
            
        }
        
        task.resume()
        
    }

    
    
    @IBAction func addToCloset(_ sender: UIButton) {
        
        let itemid = SharingManager.sharedInstance.shareItemId
        let id = SharingManager.sharedInstance.shareId
       
        
        
    
        var request = URLRequest(url: URL(string: URL_FAV)!)
        request.httpMethod = "POST"
        let postString = "uid="+id+"&itemid="+itemid;
        
        
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
            print("加入我的衣櫥 = \(String(describing: responseString))")
            
 
             
  
            
            if(self.addfav.backgroundColor == UIColor.red){
                DispatchQueue.main.async {
                    self.addfav.backgroundColor = UIColor.darkGray
                    //self.addfav.setTitle("加入衣櫥", for: UIControlState.normal)
                    self.addfav.setNeedsDisplay()
                    let alertController = UIAlertController(title: "", message:
                        "已從我的衣櫥刪除", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
            else{
                DispatchQueue.main.async {
                    self.addfav.backgroundColor = UIColor.red
                    //self.addfav.setTitle("已加入", for: UIControlState.normal)
                    self.addfav.setNeedsDisplay()
                    let alertController = UIAlertController(title: "", message:
                        "已加入我的衣櫥", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        
            
    
    
        }
        task.resume()
        
        

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("用戶選擇 ＝ "+detail)
        
        addfav.layer.cornerRadius = 4.0
        
        clothe.insert(image1, at: 0)
        clothe.insert(image2, at: 1)
        clothe.insert(image3, at: 2)
        clothe.insert(image4, at: 3)
        clothe.insert(image5, at: 4)
        clothe.insert(image6, at: 5)
        clothe.insert(image7, at: 6)
        clothe.insert(image8, at: 7)
        
        updateInfo()
        scrollview.contentSize.height = 3200
        

        

       

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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}



