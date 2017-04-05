//
//  CameraVC.swift
//  DevChat
//
//  Created by smbss on 21/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit
import FirebaseAuth

class CameraVC: SwiftyCamViewController, SwiftyCamViewControllerDelegate {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var mediaConfirmed: Bool!
//    var messageListButton: UIButton!
//    var signOutButton: UIButton!
    var flipCameraButton: UIButton!
    var flashButton: UIButton!
    var captureButton: SwiftyRecordButton!
    
    private var _imageData: UIImage?
    private var _videoURL: URL?
    
    var imageData: UIImage? {
        set {
            _imageData = newValue
        } get {
            return _imageData
        }
    }
    
    var videoURL: URL? {
        set {
            _videoURL = newValue
        } get {
            return _videoURL
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraDelegate = self
        maximumVideoDuration = 10.0
        addButtons()
        mediaConfirmed = false
        print("CurrentUserUID: \(FIRAuth.auth()?.currentUser?.uid)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("VideoURL: \(videoURL)")
        print("ImageData: \(imageData)")
        guard !mediaConfirmed else {
            if let video = videoURL {
                performSegue(withIdentifier: "CameraToUserList", sender: video)
            } else if let image = imageData {
                performSegue(withIdentifier: "CameraToUserList", sender: image)
            }
            return
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let usersVC = segue.destination as? UsersVC {
            if let imageData = sender as? UIImage {
                usersVC.imageData = imageData
                self._imageData = nil
            } else if let videoURL = sender as? URL {
                usersVC.videoURL = videoURL
                self._videoURL = nil
            }
        }
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
        let newVC = PhotoViewController(image: photo)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didBeginRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did Begin Recording")
        captureButton.growButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 0.0
            self.flipCameraButton.alpha = 0.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishRecordingVideo camera: SwiftyCamViewController.CameraSelection) {
        print("Did finish Recording")
        captureButton.shrinkButton()
        UIView.animate(withDuration: 0.25, animations: {
            self.flashButton.alpha = 1.0
            self.flipCameraButton.alpha = 1.0
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFinishProcessVideoAt url: URL) {
        let newVC = VideoViewController(videoURL: url)
        self.present(newVC, animated: true, completion: nil)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
        let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
        focusView.center = point
        focusView.alpha = 0.0
        view.addSubview(focusView)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            focusView.alpha = 1.0
            focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }, completion: { (success) in
            UIView.animate(withDuration: 0.15, delay: 0.5, options: .curveEaseInOut, animations: {
                focusView.alpha = 0.0
                focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
            }, completion: { (success) in
                focusView.removeFromSuperview()
            })
        })
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
        print(zoom)
    }
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
        print(camera)
    }
    
    func showAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func cameraSwitchAction(_ sender: Any) {
        switchCamera()
    }
    
    @objc private func toggleFlashAction(_ sender: Any) {
        flashEnabled = !flashEnabled
        
        if flashEnabled == true {
            flashButton.setImage(#imageLiteral(resourceName: "flash"), for: UIControlState())
        } else {
            flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        }
    }
    
    @objc private func messageListButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "CameraToPendingMessages", sender: nil)
    }
    
    @objc private func signOutButtonPressed(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            print("Successfully signed out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            showAlert(title: "Error signing out", message: signOutError.localizedDescription, buttonText: "Ok")
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func addButtons() {
        captureButton = SwiftyRecordButton(frame: CGRect(x: view.frame.midX - 37.5, y: view.frame.height - 100.0, width: 75.0, height: 75.0))
        self.view.addSubview(captureButton)
        captureButton.delegate = self
        
        flipCameraButton = UIButton(frame: CGRect(x: (((view.frame.width / 2 - 37.5) / 2) - 15.0), y: view.frame.height - 74.0, width: 30.0, height: 23.0))
        flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
        flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
        self.view.addSubview(flipCameraButton)
        
        let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) + ((view.frame.width / 2) - 37.5) - 9.0)
        
        flashButton = UIButton(frame: CGRect(x: test, y: view.frame.height - 77.5, width: 18.0, height: 30.0))
        flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
        flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
        self.view.addSubview(flashButton)
        
        let signOutButton = UIButton(frame: CGRect(x: view.frame.width/2 + 100, y: 30, width: 35.0, height: 35.0))
        signOutButton.setImage(#imageLiteral(resourceName: "logOut"), for: UIControlState())
        signOutButton.addTarget(self, action: #selector(signOutButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(signOutButton)
        
        let messageListButton = UIButton(frame: CGRect(x: 30, y: 30, width: 35.0, height: 35.0))
        messageListButton.setImage(#imageLiteral(resourceName: "messageList"), for: UIControlState())
        messageListButton.addTarget(self, action: #selector(messageListButtonPressed(_:)), for: .touchUpInside)
        self.view.addSubview(messageListButton)
    }
}

