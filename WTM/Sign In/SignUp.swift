//
//  SignUp.swift
//  WTM
//
//  Created by Haris Hussain on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit
import Firebase

class SignUp: UIViewController {
    @IBOutlet weak var emailField: UITextFieldX!
    @IBOutlet weak var passField: UITextFieldX!
    
    
    @IBAction func signUp(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty else {
            showAlert(title: "Error", desc: "No email provided")
            return
        }
        guard let ps = passField.text, !ps.isEmpty else{
            showAlert(title: "Error", desc: "Please enter a password")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: ps) { (result, error) in
            guard error == nil else {
                self.showAlert(title: "Error", desc: error!.localizedDescription)
                return
            }
            
            print("Great!")
            //TODO: Transition to next app
        }
        
    }
    
    func showAlert(title: String, desc: String) {
        let alert = UIAlertController(title: title, message: desc, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorScheme(applyBG: true)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:))))

        // Do any additional setup after loading the view.
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
