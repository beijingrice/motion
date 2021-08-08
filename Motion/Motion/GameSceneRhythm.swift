//
//  GameScene.swift
//  Motion
//
//  Created by Rice on 2021/8/7.
//

import SpriteKit
import GameplayKit
import UIKit

var button_size : CGFloat = 750 / 4

class GameSceneRhythm: SKScene {
    
    let screen_size: CGRect = UIScreen.main.bounds
    
    let split : Int = 32 // Split screen into 32 pieces
    
    var screen_avaliable_height : CGFloat = 1344 - button_size
    
    // Game tick duration
    var tick_duration : CGFloat = 0.1
    
    //
    let note_height : Int = 10
    
    var tick : Int = 0
    var game_running : Bool = true
    
    var track1 : [Note] = []
    var track2 : [Note] = []
    var track3 : [Note] = []
    var track4 : [Note] = []
    var all_tracks : [[Note]] = []
    
    // Update the tick
    @objc func update_tick() {
        while(game_running) {
            tick += 1
            // print(self.tick)
            Thread.sleep(forTimeInterval: TimeInterval(tick_duration))
        }
    }
    
    func load(note : Note, track_num : Int) {
        
        
        // var unit = screen_avaliable_height / CGFloat(split)
        note.position = CGPoint(x: CGFloat(track_num) * CGFloat(button_size), y: self.screen_size.height)
        
        let duration_of_movement : CGFloat = CGFloat(tick_duration) * CGFloat(split)
        
        // send notes to bottom of screen
        let movement = SKAction.sequence([
            SKAction.moveTo(y: button_size - CGFloat((note_height / 2)), duration: TimeInterval(duration_of_movement))
        ])
        
        addChild(note)
        
        note.run(movement)
        
    }
    
    // Search for notes that need to load and load it
    func load_stuffs() {
        var currentTick = 0
        let queue = DispatchQueue(label: "Load Notes")
        queue.async { [self] in
            while(self.game_running){
                if (currentTick < self.tick) {
                for track_num in 0...3 {
                    let each = self.all_tracks[track_num]
                    for note in each {
                        if note.tick == self.tick {
                            load(note: note, track_num: track_num)
                        }
                    }
                }
                    currentTick += 1
                }
            }
        }
    }
    
    // Init tracks
    func init_tracks() {
        for x in 0...9 {
            
            /*
            track1.append(Note(rectOf: CGSize(width: button_size, height: 10)))
            track1[x].tick = x
            */
            track1.append(Note(imageNamed: "note"))
            track1[x].tick = x
        }
    }
    
    override func didMove(to view: SKView) {
        init_tracks()
        
        // Init all tracks
        all_tracks.append(track1)
        all_tracks.append(track2)
        all_tracks.append(track3)
        all_tracks.append(track4)
        // End init
        
        Thread.detachNewThreadSelector(#selector(update_tick), toTarget: self, with: nil)
        
        load_stuffs()
    }
    
    
    
}

