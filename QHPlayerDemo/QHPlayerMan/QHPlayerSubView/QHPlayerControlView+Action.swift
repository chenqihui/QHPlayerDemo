//
//  QHPlayerControlView+Action.swift
//  QHPlayerDemo
//
//  Created by Anakin chen on 2018/8/29.
//  Copyright © 2018年 Chen Network Technology. All rights reserved.
//

import Foundation
import UIKit

extension QHPlayerControlView {
    
    @objc func playAction() {
        if bReadyToPlay == false {
            return
        }
        delegate?.playerControlTo(self, bPlay: !playBtn.isSelected)
        playBtn.isSelected = !playBtn.isSelected
    }
    
    @objc func backwardAction() {
        if bReadyToPlay == false {
            return
        }
        self.bTouchSlider = true
        delegate?.playerControlTo(self, toward: -15, completionHandler: { (bFinished) in
            self.bTouchSlider = false
        })
    }
    
    @objc func forwardAction() {
        if bReadyToPlay == false {
            return
        }
        self.bTouchSlider = true
        delegate?.playerControlTo(self, toward: 15, completionHandler: { (bFinished) in
            self.bTouchSlider = false
        })
    }
    
    @objc func sliderValueChangedAction(slider: UISlider) {
        if bReadyToPlay == false {
            return
        }
        playTimeL.text = p_secondsToString(Int(slider.value))
        bTouchSlider = true
    }
    
    @objc func sliderTouchUpInsideAction(slider: UISlider) {
        if bReadyToPlay == false {
            return
        }
        delegate?.playerControlTo(self, seconds: CGFloat(slider.value), completionHandler: { (bFinished) in
            self.bTouchSlider = false
        })
    }
    
    @objc func sliderTouchUpOutsideAction(slider: UISlider) {
        if bReadyToPlay == false {
            return
        }
        bTouchSlider = false
    }
    
    @objc func gravityAction() {
        if bReadyToPlay == false {
            return
        }
        delegate?.playerControlTo(self, bGravity: !gravityBtn.isSelected)
        gravityBtn.isSelected = !gravityBtn.isSelected
    }
    
    @objc func muteAction() {
        if bReadyToPlay == false {
            return
        }
        delegate?.playerControlTo(self, bMute: !muteBtn.isSelected)
        muteBtn.isSelected = !muteBtn.isSelected
    }
    
    @objc func volumeSliderValueChangedAction(slider: UISlider) {
        if bReadyToPlay == false {
            return
        }
        delegate?.playerControlTo(self, volume : slider.value)
    }
    
    @objc func hideControlTimerAction() {
        p_control(isHidden: true)
    }
    
    @objc func tapAction() {
//        p_hideControlTimer()
        p_control(isHidden: !bottomView.isHidden)
    }
}
