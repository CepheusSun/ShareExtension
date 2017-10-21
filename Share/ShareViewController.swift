//
//  ShareViewController.swift
//  Share
//
//  Created by sunny on 2017/7/3.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    
    lazy var userToken: String? = self.fetchUserInfomation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder = "分享到微博"  // 占位文字
        charactersRemaining = 140  // 左下角的文字 展示数字，可以用来倒数，还能输入几个字, 小于等于0的时候变成红色
        
        if userToken == nil {
            
            let alert = UIAlertController(title: "还没有登录", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel) {[unowned self] _ in
                self.cancel()
            })
            alert.addAction(UIAlertAction(title: "去登录", style: .default) {[unowned self] _ in
//                let url = URL(string: "sunny://action=login")
//                self.extensionContext?.open(url!) { (success) in
//                    // 苹果爸爸只允许 Today 中使用
//                    print(success)
//                }
                self.openContainerApp()
                self.cancel()
            })
            present(alert, animated: true, completion: nil)
        }
    }
    
    // For skip compile error.
    @objc func openURL(_ url: URL) {
        return
    }
    
    func openContainerApp() {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))
        while responder != nil {
            if responder!.responds(to: selector) && responder != self {
                responder!.perform(selector, with: URL(string: "sunny://action=login")!)
                return
            }
            responder = responder?.next
        }
    }
    
    // 过滤分享的内容
    override func isContentValid() -> Bool {
        charactersRemaining = 140 - contentText.characters.count as NSNumber
        return contentText.characters.count > 2
    }

    // 点击发表的事件
    override func didSelectPost() {
        
        self.extensionContext?.inputItems.forEach({ (item) in
            print("//////////////////////////")
            
            let ext = item as! NSExtensionItem
            ext.attachments?.forEach({
                let atta = $0 as! NSItemProvider
                print(atta)
                // 分享的是网页
                if atta.hasItemConformingToTypeIdentifier("public.url") {
                    atta.loadItem(forTypeIdentifier: "public.url") { (item, error) in
                        print("//////////////////////////")
                        print(item!)
                    }
                    print("//////////////////////////")
                }
                // 分享的是图片
                if atta.hasItemConformingToTypeIdentifier("public.jpeg") {
                    atta.loadItem(forTypeIdentifier: "public.jpeg") { (item, error) in
                        print("//////////////////////////")
                        print(item!)
                    }
                    print("//////////////////////////")
                }
            })
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        })
    }
    
    func fetchUserInfomation() -> String? {
        let userdefault = UserDefaults.init(suiteName: "group.sunny.com")
        let info = userdefault?.value(forKey: "userInformation") as? [String: String]
        return info?["token"]
    }
    
    // 点击 取消 的事件
    override func didSelectCancel() {
        super.didSelectCancel()
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        
        // 定位
        let item1 = SLComposeSheetConfigurationItem()
        item1?.title = "位置"
        item1?.value = "无"
        item1?.valuePending = false
        item1?.tapHandler = {
            item1?.valuePending = true
            // 在这里做定位的操作
            // 模拟花了3s时间
            delay(3, task: {
                item1?.value = ""
                item1?.valuePending = false
                item1?.value = "四川省 成都市"
            })
        }
        
        // 跳转
        let item2 = SLComposeSheetConfigurationItem()
        item2?.title = "可见组"
        item2?.value = ""
        
        item2?.tapHandler = {
            let list = ListController()
            list.callbackClosure = {
                item2?.value = $0
            }
            self.pushConfigurationViewController(list)
        }
        
        // 测试预览
        /*
        let item3 = SLComposeSheetConfigurationItem()
        item3?.title = "预览"
        item3?.tapHandler = {
            let pre = self.loadPreviewView()// 这个方法实际上是用来获取右边的图片的
            pre?.frame = self.view.bounds
            self.view.addSubview(pre!)
        }
        */
        return [item1!, item2!]
    }
    
    deinit {
        print("//////////////////////" + "deinit")
    }

}


final class ListController: UIViewController {
    typealias CallbackClosure = (String) -> ()
    
    let tableView = UITableView()
    let dataSource = ["我的粉丝",
                      "互相关注",
                      "所有人"]
    static let identifier = "Cell"
    var callbackClosure: CallbackClosure?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "选择"
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor.clear // 不然没有模糊效果
        tableView.frame = CGRect(x: 0, y: 0,
                                 width: view.bounds.width,
                                 height: view.bounds.height)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: ListController.identifier)
        tableView.tableFooterView = UIView()
    
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 30
        tableView.reloadData()
    }
    
    deinit {
        print("listController deinited")
    }
}


extension ListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ListController.identifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: ListController.identifier)
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        cell?.backgroundColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if callbackClosure != nil {
            callbackClosure!(dataSource[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
}






