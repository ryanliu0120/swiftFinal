//
//  myWearing.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/5/8.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class myWearing: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/myupload.php"
    let kLineSpacing : CGFloat = 1
    let kInset : CGFloat = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    var clotheArray = [String]()
    var list = [String]()
    let refreshControl = UIRefreshControl()

    @IBAction func goDetail(_ sender: UIButton) {
        //let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        /*self.addChildViewController(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)*/
        

        self.performSegue(withIdentifier: "goPopup", sender: sender.tag)
    }

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //透過viewController之間連線的segue
        let tag = sender as! Int
        let controller = segue.destination as! PopUpViewController
 
        controller.detail = clotheArray[tag]
        self.addChildViewController(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.addTarget(self, action: #selector(call),
                                 for: .valueChanged)
        self.collectionView.refreshControl = refreshControl
        
        call()
        
        /*let id = SharingManager.sharedInstance.shareId
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "uid="+id+"&class=0";
        //送資料到伺服器
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil
                else {
                    // check for fundamental networking error
                    print("error=\(error)")
                    return
            }
            //確認連線
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("進入我的搭配 = \(responseString)")
            
            self.showitem(item: responseString!)
        }
        
        task.resume()*/


        // Do any additional setup after loading the view.
    }
    
    func call(){
        let id = SharingManager.sharedInstance.shareId
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "uid="+id+"&class=0";
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
            print("進入我的搭配 = \(String(describing: responseString))")
            
            self.showitem(item: responseString!)
        }
        
        task.resume()
        self.refreshControl.endRefreshing()
        
    }
    
    func refresh(){
        DispatchQueue.main.async() {
            self.collectionView.reloadData()
        }
        
    }
    
    func showitem(item:String){
        
        clotheArray.removeAll()
        //迴圈 回傳數量 item放圖片名稱
        clotheArray = item.characters.split{$0==","}.map(String.init)
        
        /*for i in 0 ..< clotheArray.count/2{
            list.append(clotheArray[2*i+1])
        }*/
        self.refresh()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clotheArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForWear", for: indexPath) as! cellForWear
        cell.wearPhoto.tag = indexPath.row
        cell.wearPhoto.downloadedFrom(link: "http://140.119.19.18/imgup/"+clotheArray[indexPath.row])
        //改downloadedfrom??
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        print(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width - 2*kInset - kLineSpacing)/2, height: (UIScreen.main.bounds.width - 2*kInset - kLineSpacing)/2/187*260)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return kLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: kInset, left: kInset, bottom: kInset, right: kInset)
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
