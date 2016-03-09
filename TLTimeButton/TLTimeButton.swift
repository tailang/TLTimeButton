//
//  TLTimeButton.swift
//  TLTimeButton
//
//  Created by tailang on 3/9/16.
//  Copyright © 2016 com.ecoolhud.TLTimeButton. All rights reserved.
//

import UIKit

@objc public protocol TLTimeButtonDelegate {
    
    optional func timeWillRun()
    optional func timeRunning(currentTime: Int)
    optional func timeDidRun()
}

public class TLTimeButton: UIButton {
    
    private var timeLine: Int = 60 //倒计时初始时间
    private var originTitle: String! //原始文案显示
    private var finishTitle: String? //倒计时完成文案，如果未指定，则显示originTitle文案
    private var timeRunningUnit: String? //倒计时时数字后面的单位，如果为空则不显示
    private var enableColor: UIColor! //使能时的颜色
    private var disableColor: UIColor! //不使能时的颜色
    
    weak public var delegate: TLTimeButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience public init(frame: CGRect, timeLine: Int, originTitle: String, finishTitle: String?, timeRunningUnit: String?, enableColor: UIColor, disableColor: UIColor) {
        self.init(frame: frame)
        
        self.timeLine = timeLine
        self.originTitle = originTitle
        self.finishTitle = finishTitle
        self.timeRunningUnit = timeRunningUnit
        self.enableColor = enableColor
        self.disableColor = disableColor
        
        styleInit()
    }
    
    private func styleInit() {
        self.userInteractionEnabled = true
        self.backgroundColor = enableColor
        self.setTitle(originTitle, forState: .Normal)
        self.addTarget(self, action: "clickButton:", forControlEvents: .TouchUpInside)
    }
    
    private func clickButton(sender: TLTimeButton){
        
        if let theDelegate = delegate {
            if let theMethod = theDelegate.timeWillRun?() {
                theMethod
            }
        }
        
        startWithTime()
    }
    
    private func startWithTime() {
        
        var timeOut = timeLine
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //每秒执行一次
        dispatch_source_set_timer(timer, dispatch_walltime(nil, 0), UInt64(1.0) * NSEC_PER_SEC, 0);
        
        dispatch_source_set_event_handler(timer) { () -> Void in
            if timeOut <= 0 {
                dispatch_source_cancel(timer)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.backgroundColor = self.enableColor
                    self.setTitle(self.finishTitle ?? self.originTitle, forState: .Normal)
                    self.userInteractionEnabled = true
                })
                
                if let theDelegate = self.delegate {
                    if let theMethod = theDelegate.timeDidRun?() {
                        theMethod
                    }
                }
                
            }else{
                let timeStr = String(timeOut)+(self.timeRunningUnit ?? "")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.backgroundColor = self.disableColor
                    self.setTitle(timeStr, forState: .Normal)
                    self.userInteractionEnabled = false
                })
                
                if let theDelegate = self.delegate {
                    if let theMethod = theDelegate.timeRunning?(timeOut) {
                        theMethod
                    }
                }
                
                timeOut--
            }
        }
        
        dispatch_resume(timer)
    }
    
}

