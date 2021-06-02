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
import RxSwift
import RxCocoa

struct Model: Codable {
    var name: String = ""
    var age: Int = 100
    init() { }
}

class ViewController: UIViewController {
    
    let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        var date = Date(timeIntervalSince1970: 1621699200)
        print(date.weekDay == .sun)
        
        date = Date(timeIntervalSince1970: 1621785600)
        print(date.weekDay == .mon)
        
        date = Date(timeIntervalSince1970: 1621872000)
        print(date.weekDay == .tue)
        
        date = Date(timeIntervalSince1970: 1621958400)
        print(date.weekDay == .wed)
        
        date = Date(timeIntervalSince1970: 1622044800)
        print(date.weekDay == .thur)
        
        date = Date(timeIntervalSince1970: 1622131200)
        print(date.weekDay == .fri)
        
        date = Date(timeIntervalSince1970: 1622217600)
        print(date.weekDay == .sat)
        
    }
    
    @objc func dodo(event: Any?){
        puts("kkkkk ----")
    }
    
    func dodolab(event: Event<UILabel>){
        puts("kkkkk UILabel\(event.element!)")
    }
    
    func dodobtn(event: Event<UIButton>){
        puts("UIButton\(event.element!)")
    }
}
