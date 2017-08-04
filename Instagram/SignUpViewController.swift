//
//  SignUpViewController.swift
//  Instagram
//
//  Created by 潘凌震 on 2017/7/30.
//  Copyright © 2017年 plz821. All rights reserved.
//

import UIKit
import AVOSCloud

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserPwd: UITextField!
    @IBOutlet weak var txtUserPwd2: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtBrief: UITextField!
    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    // 注册按钮被单击
    @IBAction func btnSignUp_clicked(_ sender: UIButton) {
        //print("注册按钮被按下！")
        // 隐藏keyboard
        self.view.endEditing(true)
        // 输入合法性校验
        if txtUserName.text!.isEmpty || txtUserPwd.text!.isEmpty || txtUserPwd2.text!.isEmpty || txtEmail.text!.isEmpty
            || txtFullName.text!.isEmpty || txtBrief.text!.isEmpty || txtUrl.text!.isEmpty {
            // 弹出提示对话框
            let alert = UIAlertController(title: "请注意", message: "请填写好所有的字段。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 判断两次输入的密码是否一致
        if txtUserPwd.text != txtUserPwd2.text {
            let alert = UIAlertController(title: "请注意", message: "两次输入的密码不一致。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // 将数据提交到LeadCloud
        let user = AVUser()
        user.username = txtUserName.text?.lowercased()
        user.email = txtEmail.text?.lowercased()
        user.password = txtUserPwd.text
        
        user["fullname"] = txtFullName.text?.lowercased()
        user["brief"] = txtBrief.text
        user["url"] = txtUrl.text?.lowercased()
        user["gender"] = ""
        
        // 转换头像数据并发送到服务器
        let avatarData = UIImageJPEGRepresentation(imgAvatar.image!, 0.5) //将image转换为jpeg格式，0.5是JPEG图像的压缩质量，范围是0.0~1.0（最低~最高）
        let avatarFile = AVFile(name: "avatar.jpg", data: avatarData!)
        user["avatar"] = avatarFile
        
        // 后台将个人数据提交到LeadCloud（非主线程的其他线程）
        user.signUpInBackground {(success: Bool, error: Error? ) in
            if success {
                print("用户注册成功！")
                // 记住登录的用户
                UserDefaults.standard.set(user.username, forKey: "username")
                // 将用户名写入到本地磁盘
                UserDefaults.standard.synchronize()
                // 从AppDelegate类中调用login方法
                let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.login()
            } else {
                print(error?.localizedDescription ?? "用户注册失败。")
            }
        }
    }
    
    // 取消按钮被单击
    @IBAction func btnCancel_clicked(_ sender: UIButton) {
        //print("取消按钮被按下！")
        // 以动画方式去除通过modally方式添加进来的控制视图
        self.dismiss(animated: true, completion: nil)
    }

    // 根据需要，设置滚动视图的高度
    var scrollViewHeight: CGFloat = 0
    // 获取虚拟键盘的大小
    var keyboard: CGRect = CGRect()
    
    // 当键盘出现或消失时调用的方法
    func showKeyboard(notification: Notification) {
        // 定义keyboard的大小
        let rect = notification.userInfo! [UIKeyboardFrameEndUserInfoKey] as! NSValue
        keyboard = rect.cgRectValue
        // 当虚拟键盘出现以后，将滚动视图的实际高度缩小为屏幕高度减去键盘的高度
        UIView.animate(withDuration: 0.4) {
            self.scrollView.frame.size.height = self.scrollViewHeight - self.keyboard.size.height
        }
    }
    func hideKeyboard(notification: Notification) {
        // 当虚拟键盘消失后，将滚动视图的时间高度改变为屏幕的高度
        UIView.animate(withDuration: 0.4, animations: {
            self.scrollView.frame.size.height = self.view.frame.height
        })
    }
    
    // 隐藏视图中的虚拟键盘
    func hideKeyboardTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    func loadImage(recognizer: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true //允许编辑
        present(picker, animated: true, completion: nil)
    }
    
    // 关联选择好的照片到头像控件
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgAvatar.image = info[UIImagePickerControllerEditedImage] as? UIImage //指被用户编辑后的图像
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 头像框设置为圆形
        imgAvatar.layer.cornerRadius = imgAvatar.frame.width / 2
        imgAvatar.clipsToBounds = true
        
        // 滚动视图的窗口尺寸
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        // 定义滚动视图的内容视图尺寸与窗口尺寸一样
        scrollView.contentSize.height = view.frame.height
        scrollViewHeight = view.frame.height
        
        // 检测键盘出现或消失的状态
        NotificationCenter.default.addObserver(self, selector: #selector(showKeyboard), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
        // 声明隐藏虚拟键盘的操作
        let hideTap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardTap))
        hideTap.numberOfTapsRequired = 1
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(hideTap)
        
        // 将手势识别对象添加到头像控件
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        imgTap.numberOfTapsRequired = 1
        imgAvatar.isUserInteractionEnabled = true
        imgAvatar.addGestureRecognizer(imgTap)
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
