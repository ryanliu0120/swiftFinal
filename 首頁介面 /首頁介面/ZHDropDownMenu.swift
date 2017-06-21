//
//  ZHDropDownMenu.swift
//
//  Created by zhubch on 3/8/16.
//
//  Copyright (c) 2016 zhubch <cheng4741@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit

public protocol ZHDropDownMenuDelegate:class{
    func dropDownMenu(_ menu:ZHDropDownMenu!, didInput text:String!)
    func dropDownMenu(_ menu:ZHDropDownMenu!, didChoose index:Int)
}

@IBDesignable open class ZHDropDownMenu: UIView , UITableViewDataSource ,UITableViewDelegate,UITextFieldDelegate{
    
    public weak var delegate:ZHDropDownMenuDelegate?
    
    public var inputClosure: ((ZHDropDownMenu , _ text: String) ->Void )?
    
    public var chooseClosure: ((ZHDropDownMenu , _ index: Int) ->Void )?

    public var options:Array<String> = [] {//選單項目資料，設置完自動更新列表
        didSet {
            reload()
        }
    }
    
    private var _rowHeight:CGFloat = 0
    public var rowHeight:CGFloat { //選單項目的每一行行高，預設和本控制項一樣高，如果為0則和本控制項初始高度一樣
        get{
            if _rowHeight == 0{
                return self.frame.size.height
            }
            return _rowHeight
        }
        set{
            _rowHeight = newValue
            reload()
        }
    }
    
    private var _menuMaxHeight:CGFloat = 0
    public var menuHeight : CGFloat{// 選單展開的最大高度，當它為0時全部展開
        get {
            if _menuMaxHeight == 0{
                return CGFloat(self.options.count) * self.rowHeight
            }
            return min(_menuMaxHeight, CGFloat(self.options.count) * self.rowHeight)
        }
        set {
            _menuMaxHeight = newValue
            reload()
        }
    }
    
    @IBInspectable public var editable:Bool = false { //允许使用者編輯,預設是不允許
        didSet {
            contentTextField.isEnabled = editable
        }
    }
    
    @IBInspectable public var buttonImage:UIImage?{ //下拉按钮的图片
        didSet {
            pullDownButton.setImage(buttonImage, for: UIControlState())
        }
    }
    
    @IBInspectable public var placeholder:String? { //佔位符號
        didSet {
            contentTextField.placeholder = placeholder
        }
    }

    @IBInspectable public var defaultValue:String? { //預設值，這不是placeholder!!
        didSet {
            contentTextField.text = defaultValue
        }
    }
    
    @IBInspectable public var textColor:UIColor?{ //輸入框和下拉列表項目中文字顏色
        didSet {
            contentTextField.textColor = textColor
        }
    }
    
    public var font:UIFont?{ //輸入框和下拉列表項目中文字字體
        didSet {
            contentTextField.font = font
        }
    }
    
    public var showBorder:Bool = true { //是否顯示邊框，預設顯示
        didSet {
            if showBorder {
                layer.borderColor = UIColor.lightGray.cgColor
                layer.borderWidth = 0.5
                layer.masksToBounds = true
                layer.cornerRadius = 2.5
            }else {
                layer.borderColor = UIColor.clear.cgColor
                layer.masksToBounds = false
                layer.cornerRadius = 0
                layer.borderWidth = 0
            }
        }
    }
    
    private lazy var optionsList:UITableView = { //下拉列表
        let table = UITableView(frame: CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height, width: self.frame.size.width, height: 0), style: .plain)
        table.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        table.dataSource = self
        table.delegate = self
        table.layer.borderColor = UIColor.lightGray.cgColor
        table.layer.borderWidth = 0.5
        self.superview?.addSubview(table)
        return table
    }()
    
    private var isShown:Bool = false
    
    private var contentTextField:UITextField!
    
    private var pullDownButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        contentTextField = UITextField(frame: CGRect.zero)
        contentTextField.delegate = self
        contentTextField.isEnabled = false
        addSubview(contentTextField)
        
        pullDownButton = UIButton(type: .custom)
        pullDownButton.addTarget(self, action: #selector(ZHDropDownMenu.showOrHide), for: .touchUpInside)
        addSubview(pullDownButton)
        
        self.showBorder = true
        self.textColor = UIColor.darkGray
        self.font = UIFont.systemFont(ofSize: 16)
    }
    
    func showOrHide() {
        if isShown {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.pullDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*2))
                self.optionsList.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height-0.5, width: self.frame.size.width, height: 0)
                }, completion: { (finished) -> Void in
                    if finished{
                        self.pullDownButton.transform = CGAffineTransform(rotationAngle: 0.0)
                        self.isShown = false
                    }
            })
        } else {
            contentTextField.resignFirstResponder()
            optionsList.reloadData()
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.pullDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                self.optionsList.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height-0.5, width: self.frame.size.width, height:self.menuHeight)
                }, completion: { (finished) -> Void in
                    if finished{
                        self.isShown = true
                    }
            }) 
        }
    }
    
    func reload() {
        if !self.isShown {
            return
        }
        optionsList.reloadData()
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.pullDownButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            self.optionsList.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.size.height-0.5, width: self.frame.size.width, height:self.menuHeight)
        })
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        contentTextField.frame = CGRect(x: 15, y: 5, width: self.frame.size.width - 50, height: self.frame.size.height - 10)
        pullDownButton.frame = CGRect(x: self.frame.size.width - 35, y: 5, width: 30, height: 30)
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            self.delegate?.dropDownMenu(self, didInput: text)
            self.inputClosure?(self, text)
        }
        return true
    }
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.textLabel?.text = options[indexPath.row]
        cell.textLabel?.font = font
        cell.textLabel?.textColor = textColor
        
        return cell
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        contentTextField.text = options[indexPath.row]
        self.delegate?.dropDownMenu(self, didChoose:indexPath.row)
        self.chooseClosure?(self, indexPath.row)
        showOrHide()
    }
}
