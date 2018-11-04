//
//  SignIn.swift
//  WTM
//
//  Created by Haris Hussain on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit
import Firebase

class SignIn: UIViewController {

    @IBOutlet weak var email: UITextFieldX!
    @IBOutlet weak var ps: UITextFieldX!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyColorScheme(applyBG: true)
        //Allows tap-out gesture
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:))))
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signIn(_ sender: Any) {
        guard let email = email.text, !email.isEmpty, let pass = ps.text, !pass.isEmpty else {
            return
        }
    }
        
    
    
}
