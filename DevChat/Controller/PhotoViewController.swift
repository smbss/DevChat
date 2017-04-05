//
//  PhotoViewController.swift
//  DevChat
//
//  Created by smbss on 21/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private var backgroundImage: UIImage
    private var discardImage: Bool
    private var sendButton: UIButton
        // sendbutton needs to be instantiated because we may need to hide it
    
    init(image: UIImage) {
        self.discardImage = false
        self.backgroundImage = image
        self.sendButton = UIButton() // Defined on addButtons()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = backgroundImage
        view.addSubview(backgroundImageView)
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
    
    func sendSnap() {
        dismiss(animated: true, completion: nil)
    }
    
    func cancel() {
        discardImage = true
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = presentingViewController as? PendingMessagesVC {
            sendButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewWillDisappear - Photo § Discard: \(discardImage)")
        if let usersVC = presentingViewController as? CameraVC {
            guard discardImage else {
                usersVC.imageData = self.backgroundImage
                usersVC.mediaConfirmed = true
                return
            }
        }
    }
    
}
