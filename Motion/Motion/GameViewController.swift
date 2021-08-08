//
//  GameViewController.swift
//  firstAid
//
//  Created by Rice on 2021/8/7.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIScreen.main.bounds.size.width)
        print(UIScreen.main.bounds.size.height)
        
        let scene = GameSceneRhythm(size: UIScreen.main.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)

        }
}
