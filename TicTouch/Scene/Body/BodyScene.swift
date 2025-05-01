import SwiftUI
import SpriteKit

class BodyScene: SKScene {
    let bodyNames = [
        "Head",
        "Shoulder",
        "Arm",
        "Hand",
        "Leg",
        "Foot"
    ]
    
    
    let faceNames = [
        "Eye",
        "Nose",
        "Mouth"
    ]
    
    let textBox = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 240, height: 48), cornerRadius: 5)
    let textLabel = SKLabelNode(text: "Prova")
    let confirmButton = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 100, height: 48), cornerRadius: 5)
    let background = SKSpriteNode(imageNamed: "Man")
    var face = SKSpriteNode(imageNamed: "Face")
    let label = SKLabelNode(text: Bundle.localizedString(forKey: "Face", comment: ""))
    
    var currentSelectedDot: Dot? = nil
    var isTouching = false
    var isZoomedIn: Bool = false
    var partName: Binding<String>?
    var navPath : Binding<NavigationPath>?
    
    override func didMove(to view: SKView) {
        textBox.position = CGPoint(x: 20, y: size.height - 60)
        textBox.strokeColor = .greenVariant
        textBox.lineWidth = 3
        textBox.fillColor = .clear
        addChild(textBox)
        
        textLabel.position = CGPoint(x: 120, y: 17)
        textLabel.fontColor = .black
        textLabel.fontName = "SF Pro Rounded"
        textLabel.fontSize = 18
        textBox.addChild(textLabel)
        
        confirmButton.position = CGPoint(x: 268, y: size.height - 60)
        confirmButton.fillColor = .greenVariant
        confirmButton.lineWidth = 0
        confirmButton.name = "confirm"
        addChild(confirmButton)
        
        let confirmLabel = SKLabelNode(text: Bundle.localizedString(forKey: "Confirm", comment: "Confirm button text"))
        confirmLabel.fontSize = 14
        confirmLabel.fontColor = .white
        confirmLabel.fontName = "SF Pro Rounded"
        confirmLabel.position = CGPoint(x: 50, y: 18)
        confirmLabel.name = "confirm"
        confirmButton.addChild(confirmLabel)
        
        textBox.isHidden = true
        confirmButton.isHidden = true
        
        background.position = CGPoint(x: size.width / 2 , y: size.height / 2 )
        background.name = "background"
        addChild(background)
        
        face.position = CGPoint(x: size.width / 2 + 150, y: size.height / 2 + 300)
        face.name = Bundle.localizedString(forKey: "face", comment: "")
        face.color = .greenVariant
        face.size = CGSize(width: 50, height: 40)
        addChild(face)
        
        label.fontSize = 14
        label.position = CGPoint(x: 0, y: -35)
        label.fontColor = .black
        label.fontName = "SF Pro Rounded"
        label.name = "label"
        face.addChild(label)
        
        let parts: [(name: String, position: CGPoint, dimension: CGFloat)] = [
            (name: "Head",
             position: CGPoint(x: 0, y: 220),
             dimension: 96),
            (name: "L-Shoulder",
             position: CGPoint(x: -80, y: 85),
             dimension: 36),
            (name: "R-Shoulder",
             position: CGPoint(x: 80, y: 85),
             dimension: 36),
            (name: "L-Arm",
             position: CGPoint(x: -100, y: -15),
             dimension: 56),
            (name: "R-Arm",
             position: CGPoint(x: 100, y: -15),
             dimension: 56),
            (name:"L-Hand",
             position: CGPoint(x: -135, y: -120),
             dimension: 36),
            (name: "R-Hand",
             position: CGPoint(x: 135, y: -120),
             dimension: 36),
            (name: "L-Leg",
             position: CGPoint(x: -50, y: -175),
             dimension: 48),
            (name: "R-Leg",
             position: CGPoint(x: 50, y: -175),
             dimension: 48),
            (name: "L-Foot",
             position: CGPoint(x: -50, y: -300),
             dimension: 48),
            (name: "R-Foot",
             position: CGPoint(x: 50, y: -300),
             dimension: 48),
            (name: "L-Eye",
             position: CGPoint(x: -45, y: 210),
             dimension: 22),
            (name: "R-Eye",
             position: CGPoint(x: 45, y: 210),
             dimension: 22),
            (name: "Nose",
             position: CGPoint(x: 0, y: 195),
             dimension: 24),
            (name: "Mouth",
             position: CGPoint(x: 0, y: 165),
             dimension: 24)
        ]
        
        for (name, position, size) in parts {
            let node = SKShapeNode(rectOf: CGSize(width: CGFloat(size)*2, height: CGFloat(size)*2))
            node.position = position
            node.name = name
            node.fillColor = .clear
            node.lineWidth = 5.0
            node.alpha = 0.7
            node.strokeColor = .clear
            
            let dot = Dot()
            dot.name = "dot"
            node.addChild(dot)
            
            let ring = SKShapeNode(circleOfRadius: name == "Head" ? CGFloat(size) / 1.2 : CGFloat(size))
            ring.position = position
            ring.name = name + "-ring"
            ring.fillColor = .clear
            ring.lineWidth = 5.0
            ring.strokeColor = .greenVariant
            ring.alpha = 0
            background.addChild(ring)
            
            if faceNames.contains(strip(node.name!)) {
                node.isHidden = true
            }
            
            background.addChild(node)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in background.children {
            if let dot = node.childNode(withName: "dot") as? Dot {
                dot.deactivate()
            }
        }
        
        for node in nodes(at: location) {
            let strippedName = strip(node.name ?? "")
            
            if node.name == "confirm" {
                isTouching = true
                return
            }
            else if node.name == "face" {
                let pulse = SKAction.sequence([SKAction.scale(to: 1.2, duration: 0.1), SKAction.scale(to: 1, duration: 0.1)])
                face.removeAllActions()
                
                if !isZoomedIn {
                    zoomIn(background, CGPoint(x: size.width / 2 - 190, y: size.height - 255))
                    face.texture = SKTexture(imageNamed: "Body")
                    label.text = Bundle.localizedString(forKey: "Body", comment: "")
                } else {
                    zoomOut(background)
                    face.texture = SKTexture(imageNamed: "Face")
                    label.text = Bundle.localizedString(forKey: "Face", comment: "")
                }
                
                face.run(pulse)
            }
            else if bodyNames.contains(strippedName) || faceNames.contains(strippedName) {
                if let dot = node.childNode(withName: "dot") as? Dot {
                    dot.activate()
                    textLabel.text = Bundle.localizedString(forKey: "SelectedPart", comment: "Selected part label") + Bundle.localizedString(forKey: strippedName, comment: "")
                    textBox.isHidden = false
                    confirmButton.isHidden = false
                    partName?.wrappedValue = strippedName
                    
                    
                }
                if let ring = background.childNode(withName: node.name! + "-ring") as? SKShapeNode {
                    pulsate(node: ring)
                }
                return
            }
        }
        
        textBox.isHidden = true
        confirmButton.isHidden = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            if node.name == "confirm" && isTouching {
                vibrate()
                navPath?.wrappedValue.append("exercise")
                return
            }
        }
        isTouching = false
    }
    
    func zoomIn(_ node: SKSpriteNode, _ coordinate: CGPoint) {
        let position = node.convert(coordinate, to: self)
        let x = (node.position.x - position.x) * (1.5 - 1)
        let y = (node.position.y - position.y) * (1.5 - 1)
        let moveAction  = SKAction.move(by: CGVector(dx: x, dy: y), duration: 0.5)
        let scaleAction = SKAction.scale(by: 1.5, duration: 0.5)
        node.run(SKAction.group([moveAction, scaleAction]))
        
        for node in background.children {
            if bodyNames.contains(strip(node.name!)) {
                node.isHidden = true
            }
            
            if (faceNames.contains(strip(node.name!))) {
                node.isHidden = false
            }
        }
        
        isZoomedIn = true
    }
    
    func zoomOut(_ node: SKSpriteNode) {
        let moveAction = SKAction.move(to: CGPoint(x: size.width / 2, y: size.height / 2), duration: 0.5)
        let scaleAction = SKAction.scale(to: 1.0, duration: 0.5)
        node.run(SKAction.group([moveAction, scaleAction]))
        
        for node in background.children {
            if bodyNames.contains(strip(node.name!)) {
                node.isHidden = false
            }
            
            if (faceNames.contains(strip(node.name!))) {
                node.isHidden = true
            }
        }
        
        isZoomedIn = false
    }
    
    func pulsate(node: SKShapeNode) {
        node.removeAllActions()
        
        let pulsateUp = SKAction.group([
            SKAction.scale(to: 1.4, duration: 0.5),
            SKAction.fadeAlpha(to: 0.8, duration: 0.5)
        ])
        let pulsateDown = SKAction.group([
            SKAction.scale(to: 1, duration: 0.5),
            SKAction.fadeAlpha(to: 0, duration: 0.5)
        ])
        node.run(SKAction.sequence([pulsateUp, pulsateDown]))
    }
    
    func strip(_ name: String) -> String {
        return name.replacingOccurrences(of: "L-", with: "").replacingOccurrences(of: "R-", with: "")
    }
}
