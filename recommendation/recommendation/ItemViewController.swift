//
//  ItemViewController.swift
//  recommendation
//
//  Created by 戴余修 on 2017/4/20.
//  Copyright © 2017年 jamesTai. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ItemViewController: UICollectionViewController {
    
    var dataarray = [AnyObject]()
    let URL_SAVE_TEAM = "http://10.232.193.110/myapp/ranking.php"
    var session = URLSession(configuration: .default)

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadwithphp()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.backgroundColor = UIColor.white
        self.collectionView?.contentInset = UIEdgeInsets(top:20,left:0,bottom:0,right:0)
        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func downloadwithphp(){
        
        let requestURL = URL(string: URL_SAVE_TEAM)
        let task = session.dataTask(with: requestURL!, completionHandler: {
            (data, response, error) in
            if error != nil{
                print("error is \(error)")
                return
            }
            if data != nil{
                do{
                    //converting resonse to NSDictionary
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject]
                    DispatchQueue.main.async {
                        self.dataarray = myJSON["item"] as! [AnyObject]
                        self.collectionView?.reloadData()
                      
                    }
                    
                        //parsing the json
                   
                }catch{
                     print(error)
                }
            }
            
        })
        task.resume()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    //override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
    //}


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return dataarray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "itemcell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = (self.collectionView?.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath))! as UICollectionViewCell
        // 从界面查找到控件元素并设置属性
        
        //設置圖片
        let imageurl = dataarray[indexPath.item]["Picture"] as? String
        
        let picture:String = imageurl!
        
        let URLimage = "http://10.232.193.110/myapp/\(picture)"
        
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
                            //self.ImageView.image = downloadImage
                            (cell.contentView.viewWithTag(1) as! UIImageView).image = downloadImage
                            
                        }
                    }catch {
                        print(error)
                    }
                    
                }
                
                
            })
            datatask.resume()
            
        }
        //設置圖片
        
            (cell.contentView.viewWithTag(2) as! UILabel).text =
             dataarray[indexPath.item]["Name"] as? String
        return cell    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showITEM", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showITEM"{
            if let dvc = segue.destination as? ViewController{
            
                if let indexpaths = collectionView?.indexPathsForSelectedItems?[0].item{
                //let indexPath = indexpaths[0].row
                dvc.infoFromViewOne = dataarray[indexpaths]["ID"] as? String
                dvc.infoFromViewOne1 = dataarray[indexpaths]["Name"] as? String
                dvc.imageFromViewOne = dataarray[indexpaths]["Picture"] as? String
                
                
        }
    }
    }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
