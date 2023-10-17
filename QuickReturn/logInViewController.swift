//
//  logInViewController.swift
//  QuickReturn
//
//  Created by aryaman mittal on 11/10/23.
//

import UIKit
import Alamofire
class logInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var loginDic:[String:Any] = [:]
    let usrDef:UserDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
                passField.layer.cornerRadius = 8
                passField.layer.borderWidth = 2
                passField.layer.borderColor = UIColor(red: 0.9294, green: 0.439, blue: 0.4196, alpha: 1).cgColor
        //237 112 107
                emailField.layer.cornerRadius = 8
                emailField.layer.borderWidth = 2
                emailField.layer.borderColor = UIColor(red: 0.9294, green: 0.439, blue: 0.4196, alpha: 1).cgColor
                
                let paddingView = UIView(frame: CGRectMake(0, 0, 8, self.emailField.frame.height))
                emailField.leftView = paddingView
                emailField.leftViewMode = UITextField.ViewMode.always
                
                let paddingView2 = UIView(frame: CGRectMake(0, 0, 8, self.passField.frame.height))
                passField.leftView = paddingView2
                passField.leftViewMode = UITextField.ViewMode.always
        
                indicator.isHidden=true
                indicator.stopAnimating()

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        logButton.isEnabled = true
    }
    

    @IBAction func logInButton(_ sender: Any)
    {
       //validateFields()
        registerButton.isEnabled = false
        logButton.isEnabled = false
        indicator.isHidden=false
        indicator.startAnimating()
        let email = emailField.text!
        let password = passField.text!
        let logData = Login(email: email, password: password)
        AF.request("https://arcanists-04-3jz1.onrender.com/api/v1/login", method: HTTPMethod.post, parameters: logData, encoder: JSONParameterEncoder.default).response { (responseObj:AFDataResponse<Data?>)
            in
            if(responseObj.data != nil){
                
                do{
                    self.loginDic = try JSONSerialization.jsonObject(with: responseObj.data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                    
                }
                catch{
                    print("json serializagtion error")
                }
                
                print(self.loginDic)
                if (self.loginDic["success"] as! Bool){
                    self.usrDef.setValue(self.loginDic["token"], forKey: "token")
                    self.usrDef.set(email  , forKey: "email")
                    self.usrDef.set(password, forKey: "password")
                     DispatchQueue.main.async {
                         self.registerButton.isEnabled = true
                         self.indicator.isHidden=true
                         self.indicator.stopAnimating()
                    let issCon:ViewController = self.storyboard?.instantiateViewController(identifier: "issued_screen") as! ViewController
                     self.navigationController?.pushViewController(issCon, animated: true)
                     
                     
                     }
                }
                else{
                    DispatchQueue.main.async
                    {
                        let message = self.loginDic["message"] as! String
                         self.openAlert(title: "Alert", message: "\(message)", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
                        self.logButton.isEnabled = true
                        self.indicator.stopAnimating()
                        self.indicator.isHidden = true
                        self.registerButton.isEnabled = true
                    }

                }
            }
        }
    }
    
    
    func validateFields() {
        if let email = emailField.text, let password = passField.text{
                    if !email.validateEmailId(){
                        openAlert(title: "Alert", message: "Email address not found.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                    }else if !password.validatePassword(){
                        openAlert(title: "Alert", message: "Please enter valid password", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                            print("Okay clicked!")
                        }])
                    }else{
                        // Navigation - Home Screen
                    }
                }else{
                    openAlert(title: "Alert", message: "Please add detail.", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default], actions: [{ _ in
                        print("Okay clicked!")
                    }])
                }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        logButton.isEnabled = false
    }
    
}
