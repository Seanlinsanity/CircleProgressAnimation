//
//  ViewController.swift
//  CircleProgressAnimation
//
//  Created by SEAN on 2018/3/3.
//  Copyright © 2018年 SEAN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, URLSessionDownloadDelegate {
    

    var shapeLayer: CAShapeLayer!

    var pulsatingLayer: CAShapeLayer!
    
    let percentagLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Start"
        lb.textAlignment = .center
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 32)
        return lb
    }()
    
    private func createCircleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
    
        let layer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: .zero, radius: 100, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineWidth = 20
        layer.lineCap = kCALineCapRound
        layer.position = view.center
    
        return layer
    }
    
    fileprivate func setupCircleLayer() {
        
        pulsatingLayer = createCircleShapeLayer(strokeColor: .clear, fillColor: UIColor(red: 86/255, green: 30/255, blue: 63/255, alpha: 1))
        view.layer.addSublayer(pulsatingLayer!)
        
        animatePulsatingLayer()
        
        let trackLayer = createCircleShapeLayer(strokeColor: UIColor(red: 56/255, green: 25/255, blue: 49/255, alpha: 1), fillColor: UIColor(red: 21/255, green: 22/255, blue: 23/255, alpha: 1))
        view.layer.addSublayer(trackLayer)
        
        shapeLayer = createCircleShapeLayer(strokeColor: UIColor(red: 234/255, green: 46/255, blue: 111/255, alpha: 1), fillColor: .clear)
        //shapeLayer.transform = CATransform3DMakeRotation(-CGFloat.pi / 2 , 0, 0, 1)
        shapeLayer.strokeEnd = 0
        view.layer.addSublayer(shapeLayer)
 
    }
    
    fileprivate func setupPercentageLabel() {
        view.addSubview(percentagLabel)
        percentagLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        percentagLabel.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 21/255, green: 22/255, blue: 23/255, alpha: 1)
        
        setupCircleLayer()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    
        setupPercentageLabel()
    }
    
    private func animatePulsatingLayer(){
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.5
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer?.add(animation, forKey: "pulsing")
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


//    fileprivate func animateCircle() {
//        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
//        basicAnimation.toValue = 1
//        basicAnimation.duration = 2
//        basicAnimation.fillMode = kCAFillModeForwards
//        basicAnimation.isRemovedOnCompletion = false
//
//        shapeLayer.add(basicAnimation, forKey: "Basic")
//    }
    
    @objc private func handleTap(){
        
        beginDownloadFile()
        percentagLabel.text = "Wait"
        
        //animateCircle()
        
    }
    
    
}

