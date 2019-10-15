//
//  ViewController.swift
//  Example
//
//  Created by Chandran, Sudha | SDTD on 15/10/19.
//  Copyright © 2019 Chandran, Sudha. All rights reserved.
//

import UIKit
import GithubSearchAPI

class ViewController: UIViewController {

    var searchAPI: GithubSearchAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchAPI = GithubSearchAPI()
        print(searchAPI.add(a: 1, b: 1))
        
    }
}


