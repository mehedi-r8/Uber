//
//  HomeVCTableView.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/27/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import Foundation
import UIKit
import Firebase


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
        let mapItem = matchingLocation[indexPath.row]
        cell.textLabel?.text = mapItem.name
        cell.detailTextLabel?.text = mapItem.placemark.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let id = Auth.auth().currentUser
        if id != nil {
            let keyid = Auth.auth().currentUser?.uid
            let passengerCoordinate = manager?.location?.coordinate
            let passengerAnnotation = PassengerAnnotation(coordinate: passengerCoordinate!, key: keyid!)
            mapView.addAnnotation(passengerAnnotation)
            destinationTxtField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            let selectedResult = matchingLocation[indexPath.row]
            DataService.instance.REF_USERS.child(keyid!).updateChildValues(["tripCoordinate": [selectedResult.placemark.coordinate.latitude, selectedResult.placemark.coordinate.longitude]])
            
            dropPinFor(palacemark: selectedResult.placemark)
            
            searchMapkitForResultsWithPolyLine(formapItem: selectedResult)
            
            animateTableView(shouldShow: false)
            print(indexPath.row)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if destinationTxtField.text == "" {
            animateTableView(shouldShow: false)
        }
    }
}
 
