//
//  UIView+PGViewInteraction.swift
//  PGViewInteraction
//
//  Created by damon.p on 2021/07/27.
//

import UIKit

struct AssociatedKey {
    static var gesture: UInt8 = 0
    static var transform: UInt8 = 1
    static var options: UInt8 = 2
    static var inspectValue: UInt = 3
    static var delegateValue: UInt = 3
}

struct Constant {
    static var name: String = "ViewInteractionGesture"
}

class InnerObject<Element> {
    var element: Element
    
    init(element: Element) { self.element = element }
}

public struct Options {
    let scaleRate: CGFloat
    let beganDuration: TimeInterval
    let beganSpring: CGFloat
    let endedDuration: TimeInterval
    let endedSpring: CGFloat
    
    public init(scaleRate: CGFloat = 0.85,
         beganDuration: TimeInterval = 0.15,
         beganSpring: CGFloat = 0.25,
         endedDuration: TimeInterval = 0.4,
         endedSpring: CGFloat = 0.25
    ) {
        self.scaleRate = scaleRate
        self.beganDuration = beganDuration
        self.beganSpring = beganSpring
        self.endedDuration = endedDuration
        self.endedSpring = endedSpring
    }
}


extension UIView {
    public func setViewInteraction(value: Options = .init()) {
        _viewInteractionOptions = value
        _viewInteractionDelegate = ViewInteractionGestureDelegate()
        _viewInteractionGesture = UILongPressGestureRecognizer()
        _viewInteractionGesture?.delegate = _viewInteractionDelegate
    }
    
    public func removeViewInteraction() {
        self.removeViewInteractionGesture()
        self._viewInteractionDelegate = nil
    }
}

extension UIView {
    @IBInspectable public var viewInteractionable: Bool {
        get { self._viewInteractionValue }
        set {
            self._viewInteractionValue = newValue
            
            if newValue == true {
                self.setViewInteraction()
            } else {
                self.removeViewInteraction()
            }
        }
    }
}

extension UIView {
    func removeViewInteractionGesture() {
        self.gestureRecognizers?.filter{ $0.name == Constant.name }.forEach{ $0.view?.removeGestureRecognizer($0) }
    }
    
    func updateGesture(with gesture: UILongPressGestureRecognizer?) {
        guard let gesture = gesture else { return }
        guard self.isUserInteractionEnabled == true else { return }
        
        gesture.name = Constant.name
        
        self.removeViewInteractionGesture()
        self.addGestureRecognizer(gesture)
        
        gesture.minimumPressDuration = 0
        gesture.cancelsTouchesInView = false
        gesture.addTarget(self, action: #selector(onViewInteraction(gesture:)))
    }
    
    @objc public func onViewInteraction(gesture: UILongPressGestureRecognizer) {
        let value = self._viewInteractionOptions
        
        switch gesture.state {
            case .began:
                self._viewInteractionTransform = self.transform
                UIView.animate(withDuration: value.beganDuration, delay: 0.0, usingSpringWithDamping: value.beganSpring, initialSpringVelocity: 0.0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    self.transform = self.transform.scaledBy(x: value.scaleRate, y: value.scaleRate)
                }
                
            case .ended:
                UIView.animate(withDuration: value.endedDuration, delay: 0.0, usingSpringWithDamping: value.endedSpring, initialSpringVelocity: 0.0, options: [.curveEaseInOut]) { [weak self] in
                    guard let self = self else { return }
                    self.transform = self._viewInteractionTransform
                }
                
            default: ()
        }
    }
}

extension UIView {
    var _viewInteractionGesture: UILongPressGestureRecognizer? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.gesture) as? UILongPressGestureRecognizer
        }
        set {
            self.updateGesture(with: newValue)
            objc_setAssociatedObject(self, &AssociatedKey.gesture, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var _viewInteractionTransform: CGAffineTransform {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKey.transform) as? InnerObject<CGAffineTransform> else { return self.transform }
            return object.element
        }
        set {
            let object = InnerObject<CGAffineTransform>(element: newValue)
            objc_setAssociatedObject(self, &AssociatedKey.transform, object, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var _viewInteractionOptions: Options {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKey.options) as? InnerObject<Options> else { return .init() }
            return object.element
        }
        set {
            let object = InnerObject<Options>(element: newValue)
            objc_setAssociatedObject(self, &AssociatedKey.options, object, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var _viewInteractionValue: Bool {
        get {
            guard let object = objc_getAssociatedObject(self, &AssociatedKey.inspectValue) as? InnerObject<Bool> else { return false }
            return object.element
        }
        set {
            let object = InnerObject<Bool>(element: newValue)
            objc_setAssociatedObject(self, &AssociatedKey.inspectValue, object, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var _viewInteractionDelegate: ViewInteractionGestureDelegate? {
        get {
            objc_getAssociatedObject(self, &AssociatedKey.delegateValue) as? ViewInteractionGestureDelegate
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.delegateValue, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
}

class ViewInteractionGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.name == Constant.name { return false }
        return true
    }
}
