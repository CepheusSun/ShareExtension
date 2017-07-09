//
//  ViewController.swift
//  ShareExtension
//
//  Created by sunny on 2017/7/3.
//  Copyright © 2017年 CepheusSun. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func shareButtonClicked(_ sender: Any) {
        
        let activity = UIActivityViewController(activityItems: [URL(string: "http://www.baidu.com")!], applicationActivities: nil)
        // 不分享到 ...
        activity.excludedActivityTypes = [.airDrop, .copyToPasteboard, .message, .addToReadingList, .mail]
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func shareButtonClicked2(_ sender: Any) {
        // 判断是否支持 微博
        
        if !SLComposeViewController.isAvailable(forServiceType: SLServiceTypeSinaWeibo) {
            // 应该是没有登录的原因, 所以一直不会返回
            print("不可用")
            return
        }
        
        let composeVC = SLComposeViewController(forServiceType: SLServiceTypeSinaWeibo)
        //        // 添加要分享的图片
        //        composeVC?.add(UIImage(named: "Nameless"))
        //        // 添加要分享的文字
        //        composeVC?.setInitialText("分享到XXX")
        //        // 添加要分享的url
        //        composeVC?.add(URL(string: "http://www.baidu.com"))
        //        // 弹出分享控制器
        self.present(composeVC!, animated: true, completion: nil)
        //        // 监听用户点击事件
        composeVC?.completionHandler = {
            if $0 == .done {
                NSLog("点击了发送");
            } else if $0 == .cancelled {
                NSLog("点击了取消");
            }
        }
    }
    
    
    @IBAction func shareButtonClicked3(_ sender: Any) {
        
        
        
        
        
        
        
    }


}

extension ViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self;
    }
    
}













