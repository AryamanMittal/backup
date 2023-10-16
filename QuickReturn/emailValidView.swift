//
//  emailValidView.swift
//  QuickReturn
//
//  Created by aryaman mittal on 13/10/23.
//

import UIKit
import Alamofire
class emailValidView: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendOtpButton: UIButton!
    
    @IBOutlet weak var activityIndi: UIActivityIndicatorView!
    var otpDic:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndi.isHidden = true
        activityIndi.stopAnimating()
        emailTextField.layer.cornerRadius = 8
        emailTextField.layer.borderWidth = 2
        emailTextField.layer.borderColor = UIColor(red: 0.9294, green: 0.439, blue: 0.4196, alpha: 1).cgColor
        let paddingView = UIView(frame: CGRectMake(0, 0, 8, self.emailTextField.frame.height))
        emailTextField.leftView = paddingView
        emailTextField.leftViewMode = UITextField.ViewMode.always

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        sendOtpButton.isEnabled = true
        activityIndi.isHidden = true
        activityIndi.stopAnimating()

    }
    
    @IBAction func sendOtpAction(_ sender: Any) {
        activityIndi.isHidden = false
        activityIndi.startAnimating()
        sendOtpButton.isEnabled = false
        if let email = emailTextField.text {
            if(
                email.validateEmailId()
            ){
                let regMail = RegistMail(email: email)
                AF.request("https://arcanists-04-3jz1.onrender.com/api/v1/sendotp",method: HTTPMethod.post,parameters: regMail,encoder: JSONParameterEncoder.default).response
                { responseObj in
                    if(responseObj.data != nil)
                    {
                        
                        do{
                            self.otpDic = try JSONSerialization.jsonObject(with: responseObj.data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String:Any]
                            print(self.otpDic)
                            if(self.otpDic["success"] as! Bool)
                            {
                                DispatchQueue.main.async
                                {
                                    let regCon:registerViewController = self.storyboard?.instantiateViewController(identifier: "register_screen") as! registerViewController
                                    
                                    regCon.emailToFix = email
                                    
                                    self.navigationController?.pushViewController(regCon, animated: true)
                                }
                             }
                            else
                            {
                                DispatchQueue.main.async
                                {
                                    self.sendOtpButton.isEnabled = true
//                                    self.openAlert(title: "Enter A Valid Mail", message: "", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default] , actions: [{ _ in
//                                        print("Okay Clicked")
//                                    }])
                                }
                            }
                          }
                        catch
                        {
                            print("json serializagtion error")
                        }
                    }
                }
            }else{
                openAlert(title: "Enter A Valid Mail", message: "", alertStyle: .alert, actionTitles: ["Okay"], actionStyles: [.default] , actions: [{ _ in
                    print("Okay Clicked")
                }])
            }
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
