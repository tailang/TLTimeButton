//
//  TLTimeButton.swift
//  TLTimeButton
//
//  Created by tailang on 3/9/16.
//  Copyright © 2016 com.ecoolhud.TLTimeButton. All rights reserved.
//

import UIKit

class TLTimeButton: UIButton {
    
    var timeLine = 60 //倒计时时长，默认60s
    var originTitle = "获取验证码"
    var finishTitle: String? //倒计时完成文案，如果未指定，则显示originTitle文案
    var timeRunningUnit = "秒" //倒计时时，秒数后面显示的单位
    var enableColor = UIColor.redColor()
    var disableColor = UIColor.grayColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startWithTime() {
        
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
                    self.setTitle(self.originTitle, forState: .Normal)
                    self.userInteractionEnabled = true
                })
            }else{
                let timeStr = String(timeOut)+self.timeRunningUnit
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.backgroundColor = self.disableColor
                    self.setTitle(timeStr, forState: .Normal)
                    self.userInteractionEnabled = false
                })
                
                timeOut--
            }
        }
        
        dispatch_resume(timer)
        
    }
    
}
