//
//  WelcomeViewController.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/25/23.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    
    
    // MARK: - ViewDid___() Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 10
    }
    
    
    
    // MARK: - IBActions

    @IBAction func getStartedButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "getStartedPressed", sender: self)
    }

}
