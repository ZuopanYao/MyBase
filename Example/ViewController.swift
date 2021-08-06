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

struct MyParam: Constant {
    
//    static var tabBarHeight: CGFloat {
//        65.0
//    }
}


class ViewController: UIViewController {
    
    let disposeBag: DisposeBag = .init()
    static weak var weakSelf: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        Self.weakSelf = self
        
        view.addSubview(UILabel.then {
            $0.backgroundColor = .red
            $0.text = "Btn1"
            $0.frame = CGRect(x: 10, y: 150, width: 200, height: 30)
            $0.click = { _ in
                UILabel.appearance().textColor = .red
            }
        })
        
        view.addSubview(UILabel.then {
            $0.backgroundColor = .red
            $0.text = "Btn2"
            $0.frame = CGRect(x: 10, y: 200, width: 200, height: 30)
            
            $0.click = { [weak self] _ in
                self?.view.addSubview(UILabel.then {
                    $0.text = "testerasr"
                    $0.frame = CGRect(x: 10, y: 250, width: 200, height: 30)
                })
            }
        })
        
//        AppStore().lookup(appID: "444934666") { info in
//            guard let info = info else { return }
//            print(info.version)
//            print(info.currentVersionReleaseDate)
//            print(info.releaseNotes)
//        }
        
        
        AppStore().customerReviews(appID: "444934666", country: "/cn") { (review, comments) in
            puts("comments.count = \(comments.count)")
            comments.forEach { comment in
                puts(comment.title.value, comment.content.value, comment.rating.value, comment.author.name.value)
            }
        }
    }
    
    deinit {
        Notify.remove(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        puts(self.view.safeAreaInsets)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        puts(MyParam.tabBarHeight)
        puts(App.shared.keyWindow!.safeAreaInsets)

//        puts("状态栏 ", App.shared.statusBarFrame)
//        puts("导航栏 ", navigationController?.navigationBar.bounds)
//        puts("标签栏 ", tabBarController?.tabBar.bounds)

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
