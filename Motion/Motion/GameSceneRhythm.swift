//
//  GameScene.swift
//  Motion
//
//  Created by Rice on 2021/8/7.
//

import SpriteKit
import GameplayKit
import UIKit

var screen_width : CGFloat = 750
var screen_height : CGFloat = 1344

var button_size : CGFloat = screen_width / 4

class GameSceneRhythm: SKScene {
    
    var button1 : Button = Button(imageNamed: "button_released")
    var button2 : Button = Button(imageNamed: "button_released")
    var button3 : Button = Button(imageNamed: "button_released")
    var button4 : Button = Button(imageNamed: "button_released")
    var all_buttons : [Button] = []
    
    var judgement_line : SKSpriteNode = SKSpriteNode(imageNamed: "judgement_line")
    
    var judge_pos_y : CGFloat = button_size * 2
    
    var pressed_texture = SKTexture(imageNamed: "button_pressed")
    var released_textture = SKTexture(imageNamed: "button_released")
    
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
        note.position = CGPoint(x: CGFloat(track_num) * CGFloat(button_size) + (button_size/2), y: screen_height)
        
        let duration_of_movement : CGFloat = CGFloat(tick_duration) * CGFloat(split)
        
        // send notes to bottom of screen
        let movement = SKAction.sequence([
            SKAction.moveTo(y: judge_pos_y, duration: TimeInterval(duration_of_movement))
        ])
        
        addChild(note)
        
        note.run(movement)
        
    }
    
    // Search for notes that need to load and load it
    
    func load_stuffs()
    {
        var currentTick = 0
        let queue = DispatchQueue(label: "Load Notes")
        queue.async
        {
            [self] in
            while (self.game_running)
            {
                if currentTick < self.tick
                {
                    for track_num in 0...3
                    {
                        let each = self.all_tracks[track_num]
                        for note in each
                        {
                            if note.tick == self.tick {
                                load(note: note, track_num: track_num)
                                continue
                            }
                        }
                    }
                    currentTick += 1
                }
            }
        }
    }
    
    func remove_passed_note()
    {
        let queue = DispatchQueue(label: "Remove notes")
        queue.async { [self] in
            while (self.game_running)
            {
                for each in all_tracks {
                    for note in each {
                        if note.position.y <= judge_pos_y {
                            note.removeFromParent()
                        }
                    }
                }
            }
        }
    }
    
    // Change texture of button, based on button's status
    func change_button_img(button : Button) {
        if button.pressed {
            button.texture = self.pressed_texture
        } else {
            if !button.pressed {
                button.texture = self.released_textture
            }
        }
    }
    
    func destroy_note(note : Note) {
        note.removeFromParent()
    }
    
    
    
    // Init tracks
    func _init() {
        
        // Init tracks
        for x in 0...9 {
            track1.append(Note(imageNamed: "note"))
            track1[x].tick = x
        }
        for x in 0...9 {
            track2.append(Note(imageNamed: "note"))
            track2[x].tick = x
        }
        for x in 0...9 {
            track3.append(Note(imageNamed: "note"))
            track3[x].tick = x
        }
        for x in 0...9 {
            track4.append(Note(imageNamed: "note"))
            track4[x].tick = x
        }
        all_tracks.append(track1)
        all_tracks.append(track2)
        all_tracks.append(track3)
        all_tracks.append(track4)
        // End init
        
        // Init buttons
        button1.track = 1
        button2.track = 2
        button3.track = 3
        button4.track = 4
        all_buttons.append(button1)
        all_buttons.append(button2)
        all_buttons.append(button3)
        all_buttons.append(button4)
        for x in 0...3 {
            all_buttons[x].position = CGPoint(x: button_size * CGFloat(x) + (button_size / 2), y: button_size + 20)
        }
        // End init
        
        judgement_line.position = CGPoint(x: screen_width / 2, y: judge_pos_y)
        addChild(judgement_line)
        
        for each in all_buttons {
            addChild(each)
        }
        
    }
    
    override func didMove(to view: SKView) {
        _init()
        
        Thread.detachNewThreadSelector(#selector(update_tick), toTarget: self, with: nil)
        
        load_stuffs()
        remove_passed_note()
    }
    
    func get_track(x : CGFloat) -> Int? {
        if (button_size * 0 <= x && button_size * 1 > x) {
            return 0
        }
        if (button_size * 1 <= x && button_size * 2 > x) {
            return 1
        }
        if (button_size * 2 <= x && button_size * 3 > x) {
            return 2
        }
        if (button_size * 3 <= x && button_size * 4 > x) {
            return 3
        }
        return nil
    }
    
    func touchDown(atPoint pos : CGPoint) {
        let track : Int = get_track(x: pos.x)!
        all_buttons[track].pressed = true
        change_button_img(button: all_buttons[track])
    }
    
    func touchUp(atPoint pos : CGPoint) {
        let track : Int = get_track(x: pos.x)!
        all_buttons[track].pressed = false
        change_button_img(button: all_buttons[track])
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchDown(atPoint: t.location(in: self))
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    
    
}

