//
//  ViewController.swift
//  UIKit-Dynamics
//
//  Created by Maryam on 2018-07-19.
//  Copyright © 2018 avanet.tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var greenSquare : UIView?
    var redSquare: UIView?
    
    var animator : UIDynamicAnimator?
    var attachmentBehavior: UIAttachmentBehavior?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setups
        initilaViewSetups()
       
        //initialize animator
        animator = UIDynamicAnimator(referenceView: self.view)
        
        // add gravity behaviour
        addGravity()
        addCollision()
        addAttachment()
        addItemBehaviour()
    }
    
    func initilaViewSetups() {
        // create shapes
        let dims1 = CGRect(x: 25, y: 25, width: 60, height: 60)
        greenSquare = UIView(frame: dims1)
        greenSquare?.backgroundColor = UIColor.green
        
        
        let dims2 = CGRect(x: 130, y:25 , width: 90, height: 90)
        redSquare = UIView(frame: dims2)
        redSquare?.backgroundColor = UIColor.red
        
        self.view.addSubview(greenSquare!)
        self.view.addSubview(redSquare!)
    }
    
    
    func addGravity() {
        let gravity = UIGravityBehavior(items: [greenSquare!, redSquare!])
        let direction = CGVector(dx: 0.0, dy: 1.0)
        gravity.gravityDirection = direction
        animator?.addBehavior(gravity)
    }
    
    
    func addCollision() {
        let collision = UICollisionBehavior(items: [greenSquare!, redSquare!])
        collision.translatesReferenceBoundsIntoBoundary = true
        collision.collisionDelegate = self
        animator?.addBehavior(collision)
    }
    
    func addAttachment(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
        greenSquare?.addGestureRecognizer(panGesture)
    }
    
    
    
    @objc func pan(_ panGesture:UIPanGestureRecognizer) {
        guard let panView = panGesture.view else {return}
        // get the location
        let location = panGesture.location(in: self.view)
        
        switch panGesture.state {
        case .began:
            let attachment = UIAttachmentBehavior(item: panView, attachedToAnchor: location)
            animator?.addBehavior(attachment)
            self.attachmentBehavior = attachment
            
        case .changed:
            if let attachatchmentBehavior = attachmentBehavior {
                attachmentBehavior?.anchorPoint = location
            }
            
        case .ended:
            fallthrough
            
        default:
//            if let attachmentBehavior = attachmentBehavior {
//                animator?.removeBehavior(attachmentBehavior)
//            }
//            attachmentBehavior = nil
            return
        }
        
    }
    
    
    func addItemBehaviour() {
        let itemBehaviour = UIDynamicItemBehavior(items: [greenSquare!, redSquare!])
        itemBehaviour.elasticity = 0.5
        animator?.addBehavior(itemBehaviour)
    }
    
    

   
}



extension ViewController: UICollisionBehaviorDelegate {
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item1: UIDynamicItem, with item2: UIDynamicItem, at p: CGPoint) {
        if let view1 = item1 as? UIView {
            view1.backgroundColor = UIColor.random()
        }
        
        if let view2  = item2 as? UIView {
            view2.backgroundColor = UIColor.random()
        }
    }
}






extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}




extension UIColor {
    static func random() -> UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 0.8)
    }
}
















