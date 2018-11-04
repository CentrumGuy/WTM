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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupCell
        return cell
    }
    
    @IBAction func pannedView(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: eventContainer).y
        
        if sender.state == .began {
            eventDescription.scrollView.isScrollEnabled = false
            if eventTopConstraint.constant == -100 {
                initialTopDistance = ViewUtils.distance(view1: eventContainer, edge1: .Top, view2: groupBar, edge2: .Bottom, parent: view)
                eventTopConstraint.constant = initialTopDistance
                eventTopConstraint.priority = UILayoutPriority(rawValue: 10)
                eventHeightConstraint.priority = UILayoutPriority(rawValue: 1)
            }
        } else if sender.state == .cancelled || sender.state == .ended {
            if eventTopConstraint.constant <= 80 || sender.velocity(in: view).y <= -800 {
                currentEventState = .fullScreen
                eventDescription.scrollView.isScrollEnabled = true
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .allowUserInteraction, animations: { [unowned this = self] in
                    this.eventTopConstraint.constant = 0
                    this.view.layoutIfNeeded()
                })
                
                return
            } else {
                currentEventState = .bottom
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .allowUserInteraction, animations: { [unowned this = self] in
                    this.eventTopConstraint.constant = this.initialTopDistance
                    this.view.layoutIfNeeded()
                })
                
                return
            }
        }
        
        switch currentEventState {
        case .bottom:
            let futureOffset = initialTopDistance + translation
            if futureOffset < 0 {
                let offset = futureOffset
                let toSet = offset - (offset / 1.1)
                eventTopConstraint.constant = toSet
                break
            } else if futureOffset > initialTopDistance {
                let offset = futureOffset - initialTopDistance
                let toSet = initialTopDistance + (offset - (offset / 1.1))
                eventTopConstraint.constant = toSet
                break
            }
            
            eventTopConstraint.constant = futureOffset
            break
        case .fullScreen:
            let futureOffset = translation
            if futureOffset > initialTopDistance {
                let offset = futureOffset
                let toSet = initialTopDistance + (offset - (offset / 1.1))
                eventTopConstraint.constant = toSet
                break
            } else if futureOffset < 0 {
                let offset = futureOffset
                let toSet = offset - (offset / 1.1)
                eventTopConstraint.constant = toSet
                break
            }
            
            eventTopConstraint.constant = futureOffset
            break
        default:
            break
        }
    }
}

