//
//  VideoViewController.swift
//  DevChat
//
//  Created by smbss on 21/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var videoURL: URL
    private var discardVideo: Bool
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    init(videoURL: URL) {
        self.discardVideo = false
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        player = AVPlayer(url: videoURL)
        playerController = AVPlayerViewController()
        
        guard player != nil && playerController != nil else {
            return
        }
        playerController!.showsPlaybackControls = false
        
        playerController!.player = player!
        self.addChildViewController(playerController!)
        self.view.addSubview(playerController!.view)
        playerController!.view.frame = view.frame
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player!.currentItem)
        
        let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        let sendButton = UIButton(frame: CGRect(x: view.frame.width/2 + 120, y: 10.0, width: 30, height: 30))
        sendButton.setImage(#imageLiteral(resourceName: "send_snap"), for: UIControlState())
        sendButton.addTarget(self, action: #selector(sendSnap), for: .touchUpInside)
        view.addSubview(sendButton)
        print("view.frame.width: \(view.frame.width)")
        print("view.frame.size.width: \(view.frame.width)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        player?.play()
    }
    
    func sendSnap() {
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        discardVideo = true
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewWillDisappear - Video § Discard: \(discardVideo)")
        if let usersVC = self.presentingViewController as? CameraVC {
            guard discardVideo else {
                usersVC.videoURL = self.videoURL
                usersVC.mediaConfirmed = true
                return
            }
        }
    }
    
    @objc fileprivate func playerItemDidReachEnd(_ notification: Notification) {
        if self.player != nil {
            self.player!.seek(to: kCMTimeZero)
            self.player!.play()
        }
    }
}
