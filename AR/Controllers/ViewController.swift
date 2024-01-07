//
//  ViewController.swift
//  TestARKit
//
//  Created by Muhammad Asad Chattha on 19/08/2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet var sceneView: ARSCNView!

    // MARK: - Properties

}

// MARK: - Life cycle Methods

extension ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        trackingConfigirationAR()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}

// MARK: - Helper Methods

extension ViewController {

    func trackingConfigirationAR() {
        let configuration = ARImageTrackingConfiguration()
        guard let trackingImages = ARReferenceImage.referenceImages(inGroupNamed: "Scientists AR Resources", bundle: nil) else { return }
        configuration.trackingImages = trackingImages

        sceneView.session.run(configuration)
    }
}


// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }

        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.blue

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2

        let node = SCNNode()
        node.addChildNode(planeNode)
        return node
    }
}


// MARK: - Cube

extension ViewController {

    func makeCube() {
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let materail = SCNMaterial()
        materail.diffuse.contents = UIColor.red
        cube.materials = [materail]
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
        node.geometry = cube
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
    }
}
