//
//  SignUp.swift
//  WTM
//
//  Created by Haris Hussain on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit

class SignUp: UIViewController {

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
