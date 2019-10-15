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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GithubSearchAPI().search(matching: "android", filterBy: "rakutentech") { (result) in
            switch result {
            case .success(let repositories):
                print(repositories)
                //Handle Success
            case .failure( _):
                //Handle Failure
                break
            }
        }
    }
}


