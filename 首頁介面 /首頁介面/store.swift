//
//  store.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/4/10.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import UIKit

class store: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ZHDropDownMenuDelegate, UICollectionViewDelegateFlowLayout {
    
    let URL_SAVE_TEAM = "http://140.119.19.18/FC/catesearch.php"
    let URL_CLASS = "http://140.119.19.18/FC/catesearch.php"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var clotheArray = [String]()
    var list = [String]()
    var namelist = [String]()
    let kLineSpacing : CGFloat = 1
    let kInset : CGFloat = 0
    
    //放入切割後字串
    @IBAction func goDetail(_ sender: UIButton) {
        //透過viewController之間連線的segue
        
        self.performSegue(withIdentifier: "goDetail2", sender: sender.tag)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //透過viewController之間連線的segue
        let controller = segue.destination as! ClotheDetail
        let tag = sender as! Int
        
        controller.detail = list[tag]
       
    }

    

   
    @IBOutlet weak var menu1: ZHDropDownMenu!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        menu1.options = ["全部顯示","正式","夜店","約會","野餐","T-shirt","短袖襯衫","長袖襯衫","polo衫","西裝外套","夾克外套","飛行員夾克","大衣與風衣","牛仔褲","球衣","背心","長褲","九分褲","短褲"] //設罝下拉選項資料
        
        
        
        menu1.menuHeight = 400//設置最大高度
        menu1.textColor = UIColor.darkGray
        menu1.delegate = self //設置代理
        
        
        
        var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
        request.httpMethod = "POST"
        let postString = "getImage";
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
                print("進入商品庫 = \(String(describing: responseString))")
                
                self.showitem(item: responseString!)
            

        }
        
        task.resume()
        
        

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
        
        self.refresh()
        
        
        
    }
    

 
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MyCell
        
        //let goods = cell.goods as! UIButton
        //let goodsName = cell.goodsName as! UILabel
        cell.goods.tag = indexPath.row
         DispatchQueue.main.async() {
        cell.goods.downloadedFrom(link: "http://140.119.19.18/img/"+self.list[indexPath.row])
        }
        cell.goodsName.text = namelist[indexPath.row]
        //改成downloadedfrom??
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        //print(indexPath)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: (UIScreen.main.bounds.width - 2*kInset - 2*kLineSpacing)/3, height: (UIScreen.main.bounds.width - 2*kInset - 2*kLineSpacing)/3/124*197)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return kLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: kInset, left: kInset, bottom: kInset, right: kInset)
    }

    
    
    //分類選擇完之後呼叫
    func dropDownMenu(_ menu: ZHDropDownMenu!, didChoose index: Int) {
        print("choosed at index \(index)")
        
        
        
        if(index == 0){
            
            var request = URLRequest(url: URL(string: URL_SAVE_TEAM)!)
            request.httpMethod = "POST"
            let postString = "getImage";
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
                print("全部顯示 =\(String(describing: responseString))")
                
                self.showitem(item: responseString!)
                
                
                
                
                
            }
            
            task.resume()

            
        }
        else{
            
            let id = SharingManager.sharedInstance.shareId
            
            var request = URLRequest(url: URL(string: URL_CLASS)!)
            request.httpMethod = "POST"
            let postString = "uid="+id+"&class="+menu1.options[index];
            
            print(postString)
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
                print("過濾結果 = \(String(describing: responseString))")
                
                self.showitem(item: responseString!)
                //responsestring要切割
                
                
                
            }
            
            task.resume()
            
        }
        
      

    }
    
    //编辑完成後呼叫
    func dropDownMenu(_ menu: ZHDropDownMenu!, didInput text: String!) {
        print("\(menu) input text \(text)")
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



