//
//  ViewController.swift
//  UserDefaults
//
//  Created by Mahmut Senbek on 26.09.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var textField: UITextField!
    @IBOutlet var segmentControl: UISegmentedControl!
    @IBOutlet var textView: UITextView!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet var countLabel: UILabel!
    let defaults = UserDefaults.standard
    var count = 0
    var dreamDestinations: [DreamDestination] = []
    let destinationKey = "dreamDestinations"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showDestinations()
        print(dreamDestinations)
    }
    
    @IBAction func segmentControlValueChanged(_ sender: UISegmentedControl) {
        
    }
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        guard let placeName = textField.text, !placeName.isEmpty else {
            displayAlert(message: "Please enter a place name.")
            return
        }
        
        let visitedBefore = segmentControl.selectedSegmentIndex == 0
        let timesVisited = Int(stepper.value)
        
        // new destination
        let newDestination = DreamDestination(placeName: placeName, timesVisited: timesVisited, visitedBefore: visitedBefore)
        dreamDestinations.append(newDestination)
        
        // Fetch data
        if let savedDestinationsData = UserDefaults.standard.data(forKey: destinationKey) {
            let decoder = JSONDecoder()
            if var savedDestinations = try? decoder.decode([DreamDestination].self, from: savedDestinationsData) {
                savedDestinations.append(newDestination)
                saveDestinations(destinations: savedDestinations)
                showDestinations()
            }
        }
        print(dreamDestinations)
    }
    
    func saveDestinations(destinations: [DreamDestination]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(destinations) {
            UserDefaults.standard.set(encodedData, forKey: destinationKey)
        }
    }
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        countLabel.text = String(format:"%1.f", sender.value)
    }
    
    func saveDestinations() {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(dreamDestinations) {
            UserDefaults.standard.set(encodedData, forKey: destinationKey)
        }
    }
    func showDestinations() {
        if let savedDestinationsData = UserDefaults.standard.data(forKey: destinationKey) {
            let decoder = JSONDecoder()
            if let savedDestinations = try? decoder.decode([DreamDestination].self, from: savedDestinationsData) {
                var destinationsText = "Dream Destinations:\n"
                for destination in savedDestinations {
                    destinationsText += "- Place: \(destination.placeName), Times Visited: \(destination.timesVisited), Visited Before: \(destination.visitedBefore ? "Yes" : "No")\n"
                }
                textView.text = destinationsText
            }
        }
    }
    func displayAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController {
    struct DreamDestination: Codable {
        var placeName: String
        var timesVisited: Int
        var visitedBefore: Bool
    }
}
