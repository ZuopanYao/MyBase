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

class ViewController: UIViewController {
    
    let disposeBag: DisposeBag = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIButton.then {
            $0.titleOfNormal = "按钮"
            $0.titleColorOfNormal = .red
            $0.click = dodobtn
        }.makeChian(view) {
            $0.top(100).leading(20).width(100).height(40).end()
        }.end()
                
        UILabel.then {
            $0.text = "test"
            $0.textColor = .red
            $0.click = dodolab
        }.makeChian(view) {
            $0.top(200).leading(20).width(100).height(40).end()
        }.end()
        
       // view.click = dodo

        view.longPress(target: self, action: #selector(dodo(event:)))
    }
    
    @objc func dodo(event: Any){
        puts("kkkkk ----")
    }
    
    func dodolab(event: Event<UILabel>){
        puts("kkkkk UILabel\(event.element!)")
    }
    
    func dodobtn(event: Event<UIButton>){
        puts("UIButton\(event.element!)")
    }
}
