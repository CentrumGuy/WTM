//
//  GroupsView.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/4/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit

class GroupsView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var groupsView: UICollectionView!
    
    @IBOutlet weak var btn1: NSLayoutConstraint!
    @IBOutlet weak var btn2: NSLayoutConstraint!
    @IBOutlet weak var btn3: NSLayoutConstraint!
    @IBOutlet weak var btn4: NSLayoutConstraint!
    
    @IBOutlet weak var view1: NSLayoutConstraint!
    @IBOutlet weak var view2: NSLayoutConstraint!
    @IBOutlet weak var view3: NSLayoutConstraint!
    @IBOutlet weak var view4: NSLayoutConstraint!
    
    @IBOutlet weak var addBtn: UIButtonX!
    @IBOutlet weak var actualAddBtn: UIButton!
    
    @IBOutlet weak var addView: UIViewX!
    
    @IBOutlet weak var nameField: UITextFieldX!
    @IBOutlet weak var groupImage: UIButtonX!
    
    var addingGroup = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyColorScheme(applyBG: true)
        groupsView.delegate = self
        groupsView.dataSource = self
        
        btn1.priority = UILayoutPriority(rawValue: 10)
        btn2.priority = UILayoutPriority(rawValue: 10)
        btn3.priority = UILayoutPriority(rawValue: 10)
        btn4.priority = UILayoutPriority(rawValue: 10)
        
        view1.priority = UILayoutPriority(rawValue: 1)
        view2.priority = UILayoutPriority(rawValue: 1)
        view3.priority = UILayoutPriority(rawValue: 1)
        view4.priority = UILayoutPriority(rawValue: 1)
        
        addView.alpha = 0
        actualAddBtn.alpha = 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDelegate.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupCell
        let group = AppDelegate.groups[indexPath.row]
        cell.groupImage.image = group.groupImage!
        cell.groupLabel.text = group.name
        cell.groupLabel.textColor = .black
        return cell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setAdding(toAdd: Bool) {
        if !toAdd {
            addingGroup = false
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: { [unowned this = self] in
                this.btn1.priority = UILayoutPriority(rawValue: 10)
                this.btn2.priority = UILayoutPriority(rawValue: 10)
                this.btn3.priority = UILayoutPriority(rawValue: 10)
                this.btn4.priority = UILayoutPriority(rawValue: 10)
                
                this.view1.priority = UILayoutPriority(rawValue: 1)
                this.view2.priority = UILayoutPriority(rawValue: 1)
                this.view3.priority = UILayoutPriority(rawValue: 1)
                this.view4.priority = UILayoutPriority(rawValue: 1)
                
                this.view.layoutIfNeeded()
                
                this.addBtn.transform = .identity
                
                this.addView.cornerRadius = 25
                this.addView.alpha = 0
                this.actualAddBtn.alpha = 0
            })
        } else {
            addingGroup = true
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .allowUserInteraction, animations: { [unowned this = self] in
                this.btn1.priority = UILayoutPriority(rawValue: 1)
                this.btn2.priority = UILayoutPriority(rawValue: 1)
                this.btn3.priority = UILayoutPriority(rawValue: 1)
                this.btn4.priority = UILayoutPriority(rawValue: 1)
                
                this.view1.priority = UILayoutPriority(rawValue: 10)
                this.view2.priority = UILayoutPriority(rawValue: 10)
                this.view3.priority = UILayoutPriority(rawValue: 10)
                this.view4.priority = UILayoutPriority(rawValue: 10)
                
                this.view.layoutIfNeeded()
                
                this.addBtn.transform = CGAffineTransform(rotationAngle: 135 * (CGFloat.pi / 180))
                
                this.addView.cornerRadius = 16
                this.addView.alpha = 1
                this.actualAddBtn.alpha = 1
            })
        }
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        view.endEditing(true)
        setAdding(toAdd: !addingGroup)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        view.endEditing(true)
        setAdding(toAdd: false)
        
        guard let groupName = nameField.text, !groupName.isEmpty else {
            return
        }
        
        let groupImage = self.groupImage.image(for: .normal)
        
        Group.create(name: groupName, image: groupImage) { [unowned this = self] (group) in
            if let group = group {
                AppDelegate.groups.append(group)
                this.groupsView.reloadData()
            }
        }
    }
}
