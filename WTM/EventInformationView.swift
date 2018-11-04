//
//  EventInformationView.swift
//  WTM
//
//  Created by Shahar Ben-Dor on 11/3/18.
//  Copyright © 2018 Velocity. All rights reserved.
//

import UIKit

class EventImageCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageViewX!
}

class EventInformationView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var eventNameLbl: UILabelX!
    @IBOutlet weak var eventAddressLbl: UILabelX!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventImageCell", for: indexPath) as! EventImageCell
        return eventImageCell
    }
}
