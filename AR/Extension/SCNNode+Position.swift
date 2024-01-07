//
//  SCNNode+Size.swift
//  AR
//
//  Created by Muhammad Asad Chattha on 07/01/2024.
//

import SceneKit

extension SCNNode {
    
    var width: Float {
        return (boundingBox.max.x - boundingBox.min.x) * scale.x
    }

    var height: Float {
        return (boundingBox.max.y - boundingBox.min.y) * scale.y
    }
    
    func pivotOnTopLeft() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation(min.x, (max.y - min.y) + min.y, 0)
    }
    
    func pivotOnTopCenter() {
        let (min, max) = boundingBox
        pivot = SCNMatrix4MakeTranslation((max.x - min.x) / 2 + min.x, (max.y - min.y) + min.y, 0)
    }
}
