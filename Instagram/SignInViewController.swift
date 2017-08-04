//
//  SignInViewController.swift
//  Instagram
//
//  Created by 潘凌震 on 2017/7/30.
//  Copyright © 2017年 plz821. All rights reserved.
//

import UIKit
import AVOSCloud

class SignInViewController: UIViewController {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserPwd: UITextField!
    
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBAction func btnSignIn_clicked(_ sender: Any) {
        print("登录按钮被单击！")
        
        // 隐藏键盘
        self.view.endEditing(true)
        
        if txtUserName.text!.isEmpty || txtUserPwd.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "请填写用户名和密码。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 实现用户登录功能
        AVUser.logInWithUsername(inBackground: txtUserName.text!, password: txtUserPwd.text!) { (user: AVUser?, error: Error?) in
            if error == nil {
                // 记住用户
                // 记住登录的用户
                UserDefaults.standard.set(user!.username, forKey: "username")
                // 将用户名写入到本地磁盘
                UserDefaults.standard.synchronize()
                
                // 从AppDelegate类中调用login方法
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            }
        }
    }
    
    // 隐藏视图中的虚拟键盘
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblName    .frame = CGRect(x: 10, y: 88, width: self.view.frame.width - 20, height: 50)
        txtUserName.frame = CGRect(x: 10, y: lblName.frame.origin.y + 70, width: self.view.frame.width - 20, height: 30)
        txtUserPwd .frame = CGRect(x: 10, y: txtUserName.frame.origin.y + 40, width: self.view.frame.width - 20, height: 30)
        btnForgot  .frame = CGRect(x: 10, y: txtUserPwd.frame.origin.y + 30, width: self.view.frame.width - 20, height: 30)
        btnSignIn  .frame = CGRect(x: 10, y: btnForgot.frame.origin.y + 40, width: self.view.frame.width / 4, height: 30)
        btnSignUp  .frame = CGRect(x: self.view.frame.width - btnSignIn.frame.width - 10, y: btnForgot.frame.origin.y + 40, width: self.view.frame.width / 4, height: 30)
        
        // 声明隐藏虚拟键盘的操作
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
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
