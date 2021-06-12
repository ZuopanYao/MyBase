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
        
        //        if "hello" + "world" ~~ "^[a-z]+$" {
        //            print("it's ok")
        //        } else {
        //            print("it's error")
        //        }
        //
        
        let value: Float? = nil
        // (view.backgroundColor = .red) <-- isValue(value) --> (view.backgroundColor = .blue)
        
        print("it's error join") <-- isValue(value) --> print("it's OK join")
        isValue(value) <-- print("it's error signle")
        isValue(value) --> print("it's ok signle")
        
        if isValue(value) { print("it's error signle") }
        
        //        let name = myName(optional: value, defaultValue: 10.0)
        //        let name1 = myName1(optional: value, defaultValue: { 10.0 })
        //
        //        value == nil ? false : true
        //
        //        let state = value == nil
        //
        print(2*2 <> 3*2)
        print(2*2 <<>> 3*2)
        
        print(4/2 <> 6/2)
        print(4/2 <<>> 6/2)
        
        print(2 + 1 <> 3 + 1)
        print(2 + 1 <<>> 3 + 1)
        
        print(4 - 1 <> 3 - 1)
        print(2 - 1 <<>> 3 - 1)
        
        print(24 - 4 + 3 / 3 <> 3)
        print(2 <<>> 3)
        
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

infix operator <--: LogicalDisjunctionPrecedence
infix operator -->: LogicalDisjunctionPrecedence

func --> (condition: Bool, closure: @autoclosure () -> Void) {
    if condition {
        closure()
    }
}

func <-- (condition: Bool, closure: @autoclosure () -> Void) {
    if condition == false {
        closure()
    }
}

func <-- (closure: @autoclosure () -> Void, condition: Bool) -> Bool {
    if condition == false {
        closure()
    }
    return condition
}

infix operator <>: AssignmentPrecedence
infix operator <<>>: AssignmentPrecedence

func <> <T: Numeric>(iPhone: T, iPad: T) -> T {
    return iPhone * iPad
}

func <<>> <T: Numeric>(iPhone: T, iPad: T) -> T {
    return iPhone + iPad
}
