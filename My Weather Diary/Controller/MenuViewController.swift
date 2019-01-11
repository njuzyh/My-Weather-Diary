//
//  SidePanelViewController.swift
//  My Weather Diary
//
//  Created by zyh on 2018/12/2.
//  Copyright © 2018 njuzyh. All rights reserved.
//

import UIKit
import Social

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    let titleArray = ["个人主页", "城市管理", "天气日记", "我的收藏", "设置", "分享", "退出登录"]
    let imageArray = ["personal", "city", "diary", "star", "setting", "share", "newexit"]
    let activityViewController = UIActivityViewController(activityItems: ["我正在使用My Weather Diary，一起来用啊"], applicationActivities: nil)
    
    
    //var _tencentOAuth:TencentOAuth!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.imageView?.image = UIImage(named: self.imageArray[indexPath.row])
        cell.textLabel?.text = self.titleArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let cell = tableView.cellForRow(at: indexPath)
        print("点击了 \(cell?.textLabel?.text ?? "")")
        if indexPath.row == 5 {
            sendMessage(1 as AnyObject)
        }
        else if indexPath.row == 2{
            performSegue(withIdentifier: "showDiaryMenu", sender: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.]
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //_tencentOAuth = TencentOAuth.init(appId: "1108104828", andDelegate: nil)
    }
    
    
    func sendMessage(_ sender: AnyObject) {
        
        self.present(activityViewController, animated: true, completion: nil)
        
        let popover = activityViewController.popoverPresentationController
        popover!.sourceView = self.view //点击该button弹出
        popover!.sourceRect = CGRect(x: 0, y: 0, width: 20, height: 30)
        popover!.permittedArrowDirections = UIPopoverArrowDirection.any
        
        //消息分享相关代码
        /*let txtObj = QQApiTextObject(text: "欢迎访问 hangge.com")
        let req = SendMessageToQQReq(content: txtObj)
        //发送并获取响应结果
        let sendResult = QQApiInterface.send(req)
        //处理结果
        handleSendResult(sendResult:  sendResult)*/
    }
    
    /*func handleSendResult(sendResult:QQApiSendResultCode){
        var message = ""
        switch(sendResult){
        case EQQAPIAPPNOTREGISTED:
            message = "App未注册"
        case EQQAPIMESSAGECONTENTINVALID, EQQAPIMESSAGECONTENTNULL,
             EQQAPIMESSAGETYPEINVALID:
            message = "发送参数错误"
        case EQQAPIQQNOTINSTALLED:
            message = "QQ未安装"
        case EQQAPIQQNOTSUPPORTAPI:
            message = "API接口不支持"
        case EQQAPISENDFAILD:
            message = "发送失败"
        case EQQAPIQZONENOTSUPPORTTEXT:
            message = "空间分享不支持纯文本分享，请使用图文分享"
        case EQQAPIQZONENOTSUPPORTIMAGE:
            message = "空间分享不支持纯图片分享，请使用图文分享"
        default:
            message = "发送成功"
        }
        print(message)
    }*/

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
