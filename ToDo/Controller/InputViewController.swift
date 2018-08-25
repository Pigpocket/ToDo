//
//  InputViewController.swift
//  ToDo
//
//  Created by Tomas Sidenfaden on 8/3/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import UIKit
import CoreLocation

class InputViewController: UIViewController {
    
    lazy var geocoder = CLGeocoder()
    var itemManager: ItemManager?
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var addressTextField: UITextField!
    @IBOutlet var itemDescriptionTextField: UITextField!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var cancelButton: UIButton!
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter
    }()
    
    @IBAction func save() {
        guard let titleString = titleTextField.text,
            titleString.count > 0 else { return }
        let date: Date?
        if let dateText = self.dateTextField.text,
            dateText.count > 0 {
            date = dateFormatter.date(from: dateText)
        } else {
            date = nil }
        let itemDescriptionString = itemDescriptionTextField.text
        if let locationName = locationTextField.text,
            locationName.count > 0 {
            if let address = addressTextField.text,
                address.count > 0 {
                geocoder.geocodeAddressString(address) {
                    [unowned self] (placeMarks, error) -> Void in
                    let placeMark = placeMarks?.first
                    let item = ToDoItem(
                        title: titleString,
                        itemDescription: itemDescriptionString,
                        timestamp: date?.timeIntervalSince1970,
                        location: Location(
                            name: locationName,
                            coordinate: placeMark?.location?.coordinate))
                
                    DispatchQueue.main.async(execute: {
                    self.itemManager?.add(item)
                    self.dismiss(animated: true)
                })
            }
        } else {
            let item = ToDoItem(title: titleString,
                                itemDescription: itemDescriptionString,
                                timestamp: date?.timeIntervalSince1970,
                                location: nil)
                self.itemManager?.add(item)
                dismiss(animated: true)
            }
        } else {
            let item = ToDoItem(title: titleString,
                                itemDescription: itemDescriptionString,
                                timestamp: date?.timeIntervalSince1970,
                                location: nil)
            self.itemManager?.add(item)
            dismiss(animated: true)
        }
    }
        
}
