//
//  ViewController.swift
//  exam
//
//  Created by Julius Matanguihan on 31/05/2019.
//  Copyright © 2019 julius. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblCityName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        lblCityName.isHidden = true
        let name = UserDefaults.standard.string(forKey:"nameCity") ?? ""
        if (name != nil) {
            lblCityName.text = "You selected: " + name
            lblCityName.isHidden = false
        }
    }


}

