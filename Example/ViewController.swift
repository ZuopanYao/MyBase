//
//  ViewController.swift
//  Example
//
//  Created by Harvey on 2021/5/18.
//

import UIKit
import MyBase
import ElegantSnap
import SnapKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.then {
            $0.backgroundColor = .red
        }.makeChian(view) {
            $0.top(100).leading(100).height(100).width(50).end()
        }
        
        UIView.then {
            $0.backgroundColor = .blue
        }.make(view) {
            $0.top.equalToSuperview().offset(200)
            $0.leading.equalTo(100)
            $0.height.equalTo(100)
            $0.width.equalTo(60)
        }
    }
}
