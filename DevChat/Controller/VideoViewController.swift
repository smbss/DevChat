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
    
    var player: AVPlayer?
    var playerController : AVPlayerViewController?
    
    private var videoURL: URL
    private var discardVideo: Bool
    private var sendButton: UIButton
        // sendbutton needs to be instantiated because we may need to hide it
    
    init(videoURL: URL) {
        self.discardVideo = false
        self.videoURL = videoURL
        self.sendButton = UIButton() // Defined on addButtons()
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
        
        addButtons()
    }
    
    func addButtons() {
        let cancelButton = UIButton(frame: CGRect(x: 30.0, y: 30.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        self.sendButton = UIButton(frame: CGRect(x: view.frame.width/2 + 100, y: 30.0, width: 30, height: 30))
        sendButton.setImage(#imageLiteral(resourceName: "send"), for: UIControlState())
        sendButton.addTarget(self, action: #selector(sendSnap), for: .touchUpInside)
        view.addSubview(sendButton)
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = presentingViewController as? PendingMessagesVC {
            sendButton.isHidden = true
        }
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
