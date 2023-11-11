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
import Security
import CommonCrypto
import SafariServices

struct Model: Codable {
    var name: String = ""
    var age: Int = 100
    init() { }
}

struct My: Constant {

}

class ViewController: UIViewController {
    
    let disposeBag: DisposeBag = .init()
    static weak var weakSelf: ViewController?
    
    var str1: String?
    let str2: String? = ""
    let str3: String? = "kkff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        Self.weakSelf = self
        
//        view.addSubview(UIButton.then(.init(type: .custom)) {
//            $0.titleOfNormal = "测试"
//            $0.titleColorOfNormal = .red
//            $0.rx.tap.subscribe(onNext: onAction).disposed(by: disposeBag)
//        }, constraints: [.top(100), .leading(), .trailing(), .height(100)])
//        
        
//        let v = UIView(frame: CGRect(x: 0, y: 40, width: 320, height: 60))
//        v.backgroundColor = UIColor(hex: 0xffee22)
        
        let vv = UIView(frame: CGRect(x: 0, y: 100, width: 320, height: 60))
//        vv.backgroundColor = UIColor.gray
//        view.addSubview(vv)
        
       
        var config = UIView.DrawConfig.default
        config.strokeColor = .red
//        config.lineDashPattern = (4, 4)
        
        view.addShade(hollowRect: .init(x: 100, y: 200, width: 200, height: 200))
    }
    
    deinit {
        Notify.remove(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    
//        puts("状态栏 ", App.shared.statusBarFrame)
//        puts("导航栏 ", navigationController?.navigationBar.bounds)
//        puts("标签栏 ", tabBarController?.tabBar.bounds)

    }
    
    func onAction(){
        let str = "#eebbff"
        print("\(str.hexToDecimal)")
    }
}
