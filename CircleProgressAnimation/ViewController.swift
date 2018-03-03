//
//  ViewController.swift
//  CircleProgressAnimation
//
//  Created by SEAN on 2018/3/3.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    

    let shapeLayer = CAShapeLayer()

    let percentagLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Start"
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 32)
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(percentagLabel)
        percentagLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentagLabel.center = view.center
        
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        let trackLayer = CAShapeLayer()
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.lightGray.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 10
        trackLayer.lineCap = kCALineCapRound
        trackLayer.position = view.center
        view.layer.addSublayer(trackLayer)
        
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.position = view.center
        
        //shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2 , 0, 0, 1)
        
        shapeLayer.strokeEnd = 0
        
        view.layer.addSublayer(shapeLayer)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    private func beginDownloadFile(){
        
        shapeLayer.strokeEnd = 0
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-c38ae.appspot.com/o/message-movies%2F36F265FE-BD83-4B3E-9B84-CBD74BC3A2F4.mov?alt=media&token=058aaf87-34fe-4f16-be25-ba20a04a3044"
        
        let configuration = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let urlSession = URLSession(configuration: configuration, delegate: self, delegateQueue: operationQueue)
        
        guard let url = URL(string: urlString) else { return }
        let downlaodTask = urlSession.downloadTask(with: url)
        downlaodTask.resume()
        
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downlaoding file")
    }
    
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //print(totalBytesWritten, totalBytesExpectedToWrite)
        
        let percentage = CGFloat(totalBytesWritten) / CGFloat(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.shapeLayer.strokeEnd = percentage
            self.percentagLabel.text = "\(Int(percentage * 100))%"

        }
        print(percentage)
    }


    fileprivate func animateCircle() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        
        shapeLayer.add(basicAnimation, forKey: "Basic")
    }
    
    @objc private func handleTap(){
        
        beginDownloadFile()
        
        //animateCircle()
        
    }
    
    
}

