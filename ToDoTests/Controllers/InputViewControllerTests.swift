//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Tomas Sidenfaden on 8/3/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import XCTest
import CoreLocation
@testable import ToDo

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        sut = storyboard
            .instantiateViewController(
                withIdentifier: "InputViewController")
            as! InputViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut.itemManager?.removeAll()
        super.tearDown()
    }

    func test_HasTitleTextField() {
        let titleTextFieldIsSubView =
            sut.titleTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleTextFieldIsSubView)
    }
    
    func test_HasDateTextField() {
        let dateTextFieldIsSubView = sut.dateTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(dateTextFieldIsSubView)
    }
    
    func test_HasLocationTextField() {
        let locationTextFieldIsSubview = sut.locationTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(locationTextFieldIsSubview)
    }
    
    func test_HasAddressTextField() {
        let addressTextFieldIsSubView = sut.addressTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(addressTextFieldIsSubView)
    }
    
    func test_HasItemDescriptionTextField() {
        let itemDescriptionTextFieldIsSubView = sut.itemDescriptionTextField?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(itemDescriptionTextFieldIsSubView)
    }
    
    func test_HasSaveButton() {
        let saveButtonIsSubView = sut.saveButton?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(saveButtonIsSubView)
    }
    
    func test_HasCancelButton() {
        let cancelButtonIsSubView = sut.cancelButton?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(cancelButtonIsSubView)
    }
    
    func xtest_Save_UsesGeocoderToGetCoordinateFromAddress() {
        let mockSut = MockInputViewController()
        mockSut.titleTextField = UITextField()
        mockSut.dateTextField = UITextField()
        mockSut.locationTextField = UITextField()
        mockSut.addressTextField = UITextField()
        mockSut.itemDescriptionTextField = UITextField()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let timestamp = 1456095600.0
        let date = Date(timeIntervalSince1970: timestamp)
        mockSut.titleTextField.text = "Foo"
        mockSut.dateTextField.text = dateFormatter.string(from: date)
        mockSut.locationTextField.text = "Bar"
        mockSut.addressTextField.text = "Infinite Loop 1, Cupertino"
        mockSut.itemDescriptionTextField.text = "Baz"
        let mockGeocoder = MockGeocoder()
        mockSut.geocoder = mockGeocoder
        mockSut.itemManager = ItemManager()
        let dismissExpectation = expectation(description: "Dismiss")
        mockSut.completionHandler = {
            dismissExpectation.fulfill()
        }
        mockSut.save()
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851,
                                                    -122.0300674)
        mockGeocoder.completionHandler?([placemark], nil)
        placemark.mockCoordinate = coordinate
        waitForExpectations(timeout: 1, handler: nil)
        let item = mockSut.itemManager?.item(at: 0)
        let testItem = ToDoItem(title: "Foo",
                                itemDescription: "Baz",
                                timestamp: timestamp,
                                location: Location(name: "Bar",
                                                   coordinate: coordinate))
        XCTAssertEqual(item, testItem)
        mockSut.itemManager?.removeAll()
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.saveButton
        guard let actions = saveButton.actions(
            forTarget: sut,
            forControlEvent: .touchUpInside) else {
                XCTFail(); return
        }
        XCTAssertTrue(actions.contains("save"))
    }
    
    func test_Geocoder_FetchesCoordinates() {
        let geocoderAnswered = expectation(description: "Geocoder")
        let address = "Infinite Loop 1, Cupertino"
        CLGeocoder().geocodeAddressString(address) { (placemarks, error) -> Void in
            let coordinate = placemarks?.first?.location?.coordinate
            guard let latitude = coordinate?.latitude else {
                XCTFail()
                return
            }
            guard let longitude = coordinate?.longitude else {
                XCTFail()
                return
            }
            XCTAssertEqual(latitude,
                            37.3316,
                            accuracy: 0.001)
            XCTAssertEqual(longitude,
                            -122.0300,
                            accuracy: 0.001)
            geocoderAnswered.fulfill()
        }
        waitForExpectations(timeout: 3, handler: nil)
    }
    
    func testSave_DismissesViewController() {
        let mockInputViewController = MockInputViewController()
        mockInputViewController.titleTextField = UITextField()
        mockInputViewController.dateTextField = UITextField()
        mockInputViewController.locationTextField = UITextField()
        mockInputViewController.addressTextField = UITextField()
        mockInputViewController.itemDescriptionTextField = UITextField()
        mockInputViewController.titleTextField.text = "Test Title"
        mockInputViewController.save()
        XCTAssertTrue(mockInputViewController.dismissGotCalled)
    }
}

extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        override func geocodeAddressString(
            _ addressString: String,
            completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    class MockPlacemark : CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        override var location: CLLocation? {
            guard let coordinate = mockCoordinate else
            { return CLLocation() }
            return CLLocation(latitude: coordinate.latitude,
                              longitude: coordinate.longitude)
        }
    }
    class MockInputViewController : InputViewController {
        var dismissGotCalled = false
        var completionHandler: (() -> Void)?
        override func dismiss(animated flag: Bool,
                              completion: (() -> Void)? = nil) {
            dismissGotCalled = true
            completionHandler?()
        }
    }
}

