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
        
        async(delay: 1.0) {
            puts(Global.isNotchScreen)
        }
        
    
        let m = Model()
        let data = m.encode!
        puts(data)
        
        async(delay: 1.0) {
            let mmm = Model.decode(data)!
            
        }
        
        UIView.then {
            $0.backgroundColor = .blue
        }.makeChian(view) {
            $0.top(100).leading().width().height(300).end()
        }.with { bgView in
            UILabel.then {
                $0.text = "广西"
                $0.textColor = .yellow
            }.makeChian(bgView) {
                $0.top().leading().trailing().height(40).end()
            }.with { label in
                UIButton.then {
                    $0.backgroundColor = .green
                    $0.titleOfNormal = "kdkdkdk"
                    $0.titleColorOfNormal = .red
                }.makeChian(bgView) {
                    $0.top(label.snp.bottom, 30)
                        .leading().trailing().height(40).end()
                }
            }
        }.end()
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
