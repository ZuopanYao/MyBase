//
//  ViewController.swift
//  Example
//
//  Created by Harvey on 2021/5/18.
//

import UIKit
import MyBase

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let doc = App.Path.document
//        let path: String = App.Path.document + "/RPReplay_Final1620818994.MP4"
//        let size = File.Size(path)
//        let byte: Float = size.value(.byte)
//        let mb: Float = size.value(.mb)

        print(File(doc + "/政策&协议.rtf").attributedString())
        
//        puts(byte, mb)
    }
}
