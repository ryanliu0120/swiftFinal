//
//  myCloset.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/5/8.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit
import Foundation

class myCloset: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/myfav.php"
    let kLineSpacing : CGFloat = 1
    let kInset : CGFloat = 0
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var clotheArray = [String]()
    var list = [String]()
    var namelist = [String]()
    
    @IBAction func goDetail(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goDetail3", sender: sender.tag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //透過viewController之間連線的segue
        let tag = sender as! Int
        let controller = segue.destination as! ClotheDetail
        controller.detail = list[tag]
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
        let postString = "uid="+id;
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
            print("進入我的衣櫥 = \(responseString)")
            
            self.showitem(item: responseString!)
            
        }
        
        task.resume()*/

        

    }
    
    func call(){
        let id = SharingManager.sharedInstance.shareId
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "uid="+id;
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
            print("進入我的衣櫥 = \(String(describing: responseString))")
            
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
        
        list.removeAll()
        namelist.removeAll()
        //迴圈 回傳數量 item放圖片名稱
        clotheArray = item.characters.split{$0==","}.map(String.init)
        
        for i in 0 ..< clotheArray.count/2{
            namelist.append(clotheArray[2*i])
        }
        //衣服名稱加入namelist
        
        for i in 0 ..< clotheArray.count/2{
            list.append(clotheArray[2*i+1])
        }
        //衣服圖片加入list
        self.refresh()
        

        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellForCloset", for: indexPath) as! cellForCloset
        //let closetItem = cell.closetItem as! UIButton
        //let itemName = cell.itemName as! UILabel
        cell.closetItem.tag = indexPath.row
        cell.closetItem.downloadedFrom(link: "http://140.119.19.18/img/"+list[indexPath.row])
        cell.itemName.text = namelist[indexPath.row]
        //改成downloadedfrom??
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        //print(indexPath)
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
