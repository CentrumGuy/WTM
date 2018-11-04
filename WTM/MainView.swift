//
//  ViewController.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/3/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MainView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var groupBar: UICollectionView!
    
    lazy var eventDescription = children[0] as! EventInformationView
    @IBOutlet weak var eventContainer: UIView!
    
    @IBOutlet weak var eventTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventHeightConstraint: NSLayoutConstraint!
    
    var initialTopDistance: CGFloat = 0
    
    var currentEventState = EventState.dismissed
    enum EventState {
        case fullScreen
        case bottom
        case dismissed
        case movingToTop
        case movingToBottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navBar = navigationController!.navigationBar
        navBar.shadowImage = UIImage()
        navBar.layer.masksToBounds = false
        navBar.layer.shadowOpacity = 0.6
        navBar.layer.shadowColor = UIColor.black.cgColor
        navBar.layer.shadowRadius = 5
        navBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        groupBar.delegate = self
        groupBar.dataSource = self
        
        applyColorScheme(applyBG: false)
        
        currentEventState = .bottom
        let camera = GMSCameraPosition.camera(withLatitude: 33.7756, longitude: -84.3963, zoom: 16.0)
        mapView.camera = camera
    }
    
    override func viewDidLayoutSubviews() {
        initialTopDistance = ViewUtils.distance(view1: eventContainer, edge1: .Top, view2: groupBar, edge2: .Bottom, parent: view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventTopConstraint.constant = initialTopDistance
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupCell
        return cell
    }
    
    var oldEventTop: CGFloat = 0
    @IBAction func pannedView(_ sender: UIPanGestureRecognizer) {
        eventTopConstraint.constant = -150
        let translation = sender.translation(in: eventContainer)
        
        if sender.state == .began {
            oldEventTop = eventTopConstraint.constant
            if currentEventState == .bottom {
                currentEventState = .movingToTop
                eventTopConstraint.priority = UILayoutPriority(rawValue: 10)
                eventHeightConstraint.priority = UILayoutPriority(rawValue: 1)
            }
        }
        
        switch currentEventState {
        case .movingToTop:
            let futureOffset = oldEventTop + translation.y
            if futureOffset < 0 {
                let offset = futureOffset
                let toSet = eventTopConstraint.constant - (offset / 1.1)
                eventTopConstraint.constant = -1 * toSet
                break
            }
            
            eventTopConstraint.constant = -150
            view.layoutIfNeeded()
            break
        case .dismissed:
            break
        default:
            break
        }
    }
}

