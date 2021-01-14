//
//  PlayerViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/01.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    let player = AVPlayer()
    
    // 의도한 화면 방향으로만 실행
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = player
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        play() // 창 열리자마자 재생
    }
    
    // 재생 버튼 클릭 시, 토글
    @IBAction func togglePlayButton(_ sender: Any) {
        if player.isPlaying {
            pause()
        } else {
            play()
        }
        playButton.isSelected = !playButton.isSelected
    }
    
    // 전체 화면 탭
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 재생 중일 때 터치하면 버튼이 나오게
        if(player.isPlaying) {
            UIView.animate(withDuration: 0.5) {
                self.playButton.alpha = 1
                self.closeButton.alpha = 1
            }
            
        }
        // 5초 후에도 여전히 재생 중인 경우는 일시정지할 마음이 없으므로 다시 감춤
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            if(self.player.isPlaying) {
                UIView.animate(withDuration: 0.5) {
                    self.playButton.alpha = 0
                    self.closeButton.alpha = 0
                }
            }
        }
    }
    
    func play() {
        player.play()
        playButton.isSelected = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) { // Change `2.0` to the desired number of seconds.
            // Code you want to be delayed
            // 버튼 페이드 아웃
            UIView.animate(withDuration: 0.5) {
                self.playButton.alpha = 0
                self.closeButton.alpha = 0
            }
        }
    }
    
    func pause() {
        player.pause()
        playButton.isSelected = false
    }
    
    // reset
    func reset() {
        pause()
        player.replaceCurrentItem(with: nil)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        reset()
        dismiss(animated: false, completion: nil)
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        guard self.currentItem != nil else { return false }
        return self.rate != 0
    }
}
