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
    var scientists = [String: Scientist]()
}

// MARK: - Life cycle Methods

extension ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        loadData()
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
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: "scientists", withExtension: "json") else {
            fatalError("Unale to find 'scientists' JSON in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Unable to load JSON")
        }
        
        let decoder = JSONDecoder()
        guard let loadedScientists = try? decoder.decode([String: Scientist].self, from: data) else { fatalError("Unable to parse JSON")
        }
        
        scientists = loadedScientists
    }

    func textNode(str: String, font: UIFont, maxWidth: Int? = nil ) -> SCNNode {
        let text = SCNText(string: str, extrusionDepth: 0)
        text.flatness = 0.1
        text.font = font
        
        if let maxWidth {
            text.containerFrame = CGRect(origin: .zero, size: CGSize(width: maxWidth, height: 500))
            text.isWrapped = true
        }
        
        let textNode = SCNNode(geometry: text)
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        return textNode
    }
}


// MARK: - ARSCNViewDelegate

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        guard let name = imageAnchor.referenceImage.name else { return nil }
        guard let scientist = scientists[name] else { return nil }
        
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        plane.firstMaterial?.diffuse.contents = UIColor.clear

        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2

        let node = SCNNode()
        node.addChildNode(planeNode)

        // Add text of Scientist name to plane
        let spacing: Float = 0.005
        let titleNode = textNode(str: scientist.name, font: UIFont.boldSystemFont(ofSize: 10))
        titleNode.pivotOnTopLeft()
        titleNode.position.x += Float(plane.width / 2) + spacing
        titleNode.position.y += Float(plane.height / 2)

        let bioNode = textNode(str: scientist.bio, font: UIFont.boldSystemFont(ofSize: 4), maxWidth: 100)
        bioNode.pivotOnTopLeft()
        bioNode.position.x += Float(plane.width / 2) + spacing
        bioNode.position.y = titleNode.position.y -  titleNode.height - spacing

        // Add Text Nodes to Plane
        planeNode.addChildNode(titleNode)
        planeNode.addChildNode(bioNode)
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
