//
//  QRScanner.swift
//  MyBase
//
//  Created by Harvey on 2017/10/24.
//  Copyright © 2017年 Harvey. All rights reserved.
//

import UIKit
import AVFoundation

public class QRScanner: NSObject {
        
    private let captureSession = AVCaptureSession()
    private let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    /// 识别到二维码
    public var recognizedQR: ((String) -> Void)!
    public var metadataObjectTypes: [AVMetadataObject.ObjectType] = [
        .qr,        /// 二维码
        .ean13,     /// 条形码
        .ean8,      /// 条形码
        .code128    /// 条形码
    ]
    
    /// 是否拥有访问摄像头权限
    public var isCanAccess: Bool = false
    
    public override init() {
        super.init()
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (isSuccess) in
            self.isCanAccess = isSuccess
            guard isSuccess else { return puts("无权访问摄像机") }
            self.prepare()
        }
    }
    
    private func prepare() {
        guard let device = AVCaptureDevice.default(for: .video) else {
            puts("获取摄像设备发生错误")
            return
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: device) else {
            puts("创建设备输入流发生错误")
            return
        }
        
        /// 创建数据输出流
        let metadataOutput = AVCaptureMetadataOutput()
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        /// 创建设备输出流
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue.main)
        
        /// 会话采集率: AVCaptureSessionPresetHigh
        captureSession.sessionPreset = .high
        
        /// 添加数据输出流到会话对象
        captureSession.addOutput(metadataOutput)
        
        /// 添加设备输出流到会话对象
        captureSession.addOutput(videoDataOutput)
      
        /// 添加设备输入流到会话对象
        captureSession.addInput(deviceInput)
        
        /// 设置数据输出类型
        metadataOutput.metadataObjectTypes = metadataObjectTypes
        
        videoPreviewLayer.session = captureSession
        videoPreviewLayer.videoGravity = .resizeAspectFill
    }
    
    public func designPreview(design: @escaping (_ previewLayer: CALayer) -> Void) {
        design(videoPreviewLayer)
    }
    
    public func startRunning() {
        captureSession.startRunning()
    }
    
    public func stopRunning() {
        captureSession.stopRunning()
    }
}

extension QRScanner: AVCaptureMetadataOutputObjectsDelegate {
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard metadataObjects.count > 0 else { return }
        stopRunning()
        
        guard let stringValue = metadataObjects.first!.value(forKey: "stringValue") as? String else { return }
        recognizedQR(stringValue)
    }
}

extension QRScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(_ output: AVCaptureOutput,
                              didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
    }
}
