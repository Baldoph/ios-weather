//
//  UIView+Layout.swift
//  nink
//
//  Created by Perso on 15/04/2015.
//  Copyright (c) 2015 Noranda. All rights reserved.
//

import UIKit
import ObjectiveC

var _EditedFrameKey: UInt8 = 0

let scale = UIScreen.mainScreen().scale

/** round a value to be sharp on screen */
func roundScreen(value: CGFloat) -> CGFloat {
	return round(value * scale) / scale
}

extension UIView {
	
	private var editedFrame: CGRect? {
		set {
			if let frame = newValue {
                objc_setAssociatedObject(self, &_EditedFrameKey, NSStringFromCGRect(frame), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			} else {
				objc_setAssociatedObject(self, &_EditedFrameKey, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
			}
		}
		get {
            if let s = objc_getAssociatedObject(self, &_EditedFrameKey) as? String {
                return CGRectFromString(s)
            }
			return nil
		}
	}
	
	private var isEditingFrame: Bool {
		get {
			return objc_getAssociatedObject(self, &_EditedFrameKey) != nil;
		}
	}
	
	private var actualFrame: CGRect {
		get {
			if isEditingFrame {
				return editedFrame!
			} else {
				return self.frame
			}
		}
		set {
			if isEditingFrame {
				self.editedFrame = newValue
			} else {
				self.frame = newValue
			}
		}
	}
	
	func beginEditingFrame() {
		if isEditingFrame {
			print("Already editing frame for view \(self)")
		} else {
			editedFrame = self.frame
		}
	}
	
	func endEditingFrame() {
		if isEditingFrame {
			if self.frame != editedFrame {
				self.frame = editedFrame!
			}
			editedFrame = nil
		} else {
			print("Wasn't editing frame for view: \(self)")
		}
	}
	
	var width: CGFloat {
		get {
			return actualFrame.width
		}
		set {
			var frame = actualFrame
			frame.size.width = newValue
			actualFrame = frame
		}
	}
	
	var height: CGFloat {
		set {
			var frame = actualFrame
			frame.size.height = newValue
			actualFrame = frame
		}
		get {
			return actualFrame.height
		}
	}
	
	var xOrigin: CGFloat {
		set {
			var frame = actualFrame
			frame.origin.x = newValue
			actualFrame = frame
		}
		get {
			return actualFrame.minX
		}
	}
	
	var yOrigin: CGFloat {
		set {
			var frame = actualFrame
			frame.origin.y = newValue
			actualFrame = frame
		}
		get {
			return actualFrame.minY
		}
	}
	
	var origin: CGPoint {
		get {
			return actualFrame.origin
		}
		set {
			var frame = actualFrame
			frame.origin = newValue
			actualFrame = frame
		}
	}
	
	var size: CGSize {
		get {
			return actualFrame.size
		}
		set {
			var frame = actualFrame
			frame.size = newValue
			actualFrame = frame
		}
	}
	
	var bottom: CGFloat {
		get {
			return actualFrame.maxY
		}
		set {
			var frame = actualFrame
			frame.origin.y = newValue - frame.height
			actualFrame = frame
		}
	}
	
	var right: CGFloat {
		get {
			return actualFrame.maxX
		}
		set {
			var frame = actualFrame
			frame.origin.x = newValue - frame.width
			actualFrame = frame
		}
	}
	
	//superview related
	
	func setMargins(margins: UIEdgeInsets) {
		if let parent = superview {
			let newFrame = CGRect(x: margins.left,
				y: margins.top,
				width: parent.width - margins.left - margins.right,
				height: parent.height - margins.top - margins.bottom)
			actualFrame = newFrame
		}
	}
	
	func centerInSuperview() {
		if let parent = superview {
			var frame = actualFrame
			frame.origin.x = roundScreen((parent.bounds.width - self.width) / 2)
			frame.origin.y = roundScreen((parent.bounds.height - self.height) / 2);
			actualFrame = frame
		}
	}
	
	func centerVertically() {
		if let parent = superview {
			var frame = actualFrame
			frame.origin.y = roundScreen((parent.height - self.height) / 2)
			actualFrame = frame
		}
	}
	
	func centerHorizontally() {
		if let parent = superview {
			var frame = actualFrame
			frame.origin.x = roundScreen((parent.width - self.width) / 2)
			actualFrame = frame
		}
	}
	
	var bottomMargin: CGFloat {
		get {
			return self.superview!.height - self.bottom
		}
		set {
			var frame = self.actualFrame
			frame.origin.y = self.superview!.height - newValue - self.height
			actualFrame = frame
		}
	}
	
	var rightMargin: CGFloat {
		get {
			return self.superview!.width - self.right
		}
		set {
			var frame = actualFrame
			frame.origin.x = self.superview!.width - newValue - self.width
			actualFrame = frame
		}
	}
	
	var anchorPoint: CGPoint {
		get {
			return self.layer.anchorPoint
		}
		set {
			var newPoint = CGPoint(x: self.bounds.size.width * newValue.x, y: self.bounds.size.height * newValue.y)
			var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
			
			newPoint = CGPointApplyAffineTransform(newPoint, self.transform)
			oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform)
			
			var position = self.layer.position
			
			position.x -= oldPoint.x
			position.x += newPoint.x
			
			position.y -= oldPoint.y
			position.y += newPoint.y
			
			self.layer.position = position
			self.layer.anchorPoint = newValue
		}
	}
    
    func makeFrameIntegral() {
        var frame = self.actualFrame
        frame.makeIntegralInPlace()
        actualFrame = frame
    }
}

extension UIView {
	func boundsCenter() -> CGPoint {
		let frame = self.bounds
		return CGPoint(x: frame.midX, y: frame.midY)
	}
	
	func setCenterIntegral(center: CGPoint) {
		self.center = center
		let frame = self.frame
		self.frame = CGRect(origin: CGPoint(x: roundScreen(frame.origin.x), y: roundScreen(frame.origin.y)), size: frame.size)
	}
	
	func addSubviews(views: [UIView]) {
		for view in views {
			self.addSubview(view)
		}
	}
	
	func removeAllSubviews() {
		for view in self.subviews {
			view.removeFromSuperview()
		}
	}
}

func CGRectMakeWithCenter(centerX: CGFloat, centerY: CGFloat, width: CGFloat, height: CGFloat) -> CGRect {
    var rect = CGRect()
    rect.origin.x = centerX - width / 2.0
    rect.origin.y = centerY - height / 2.0
    rect.size.width = width; rect.size.height = height
    return rect
}

func CGPointCenterOfRect(rect: CGRect) -> CGPoint {
    var point = CGPoint()
    point.x = rect.origin.x + rect.size.width / 2.0
    point.y = rect.origin.y + rect.size.height / 2.0
    return point
}

func CGRectWithSize(size: CGSize) -> CGRect {
    var rect = CGRect()
    rect.origin = CGPointZero
    rect.size = size
    return rect
}
