//
//  ResetPwdViewController.swift
//  Instagram
//
//  Created by 潘凌震 on 2017/7/30.
//  Copyright © 2017年 plz821. All rights reserved.
//

import UIKit
import AVOSCloud

class ResetPwdViewController: UIViewController {
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnCancel: UIButton!

    @IBAction func btnReset_clicked(_ sender: Any) {
        // 隐藏键盘
        self.view.endEditing(true)
        
        if txtEmail.text!.isEmpty {
            let alert = UIAlertController(title: "请注意", message: "请填写电子邮箱。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        AVUser.requestPasswordResetForEmail(inBackground: txtEmail.text!) { (success: Bool, error: Error?) in
            if success {
                let alert = UIAlertController(title: "请注意", message: "重置密码链接已经发送到您的电子邮箱，请注意查收。", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            } else {
                print(error?.localizedDescription ?? "重置密码链接发送失败。")
            }
        }
    }
    @IBAction func btnCancel_clicked(_ sender: Any) {
        //
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
