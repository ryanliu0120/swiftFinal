//
//  shareData.swift
//  首頁介面
//
//  Created by 鄒家禾 on 2017/4/27.
//  Copyright © 2017年 鄒家禾. All rights reserved.
//

import Foundation
import UIKit

class SharingManager {
    var shareUser:String = "Default Message"
    var sharePasswd:String = "Default Message"
    var shareEmail:String = "Default Message"
    var shareId:String = "Default Message"
    var shareItemId:String = "Default Message"
    var shareImg:String = "Default Message"
    var shareArray:Array = [String]()
    
    var shareDetail:String = "Default Message"
    var backgroundImage:UIImage!
    static let sharedInstance = SharingManager()
}
