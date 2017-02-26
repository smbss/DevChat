//
//  UsersVC.swift
//  DevChat
//
//  Created by Sandro Simes on 25/02/2017.
//  Copyright © 2017 Cappsule. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class UsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var users = [User]()
    private var selectedUsers = Dictionary<String, User>()
    
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
            // Fetching user info - Only runs one time (alternative: observeChildAdded)
        DataService.instance.usersRef.observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                // .value is a FIRDataEventType that asks for changed data
            print("FIRSnapshot: ", snapshot.debugDescription)
            if let users = snapshot.value as? Dictionary<String, AnyObject> {
                for (key, value) in users {
                    if let dict = value as? Dictionary<String, AnyObject> {
                        if let profile = dict["profile"] as? Dictionary<String, AnyObject> {
                            if let firstName = profile["firstName"] as? String {
                                let uid = key
                                let displayName = firstName
                                let user = User(uid: uid, displayName: displayName)
                                self.users.append(user)
                            }
                        }
                    }
                }
            }
            self.tableView.reloadData()
            print("UserArray: \(self.users)")
        })
    }
    
    @IBAction func backToCamera(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard selectedUsers.count <= 0 else {
            if let url = _videoURL {
                let videoName = "\(NSUUID().uuidString)-URL-\(url))"
                let ref = DataService.instance.videosStorageRef.child(videoName)
                
                _ = ref.putFile(url, metadata: nil, completion: { (meta: FIRStorageMetadata?, err: Error?) in
                    if err != nil {
                        print("Error uploading video: \(err?.localizedDescription)")
                    } else {
                        print("MetaVideoResponse: \(meta)")
                        let downloadURL = meta?.downloadURL()
                        //save this
                        print("DownloadURLVideo: \(downloadURL)")
                        print("SelectedUsersVideo:\(self.selectedUsers)")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            } else if let photo = _imageData {
                if let imageToData: Data = UIImageJPEGRepresentation(photo, CGFloat(1.0)) {
                    print("Successfully transformed UIImage to Data: \(imageToData)")
                    let photoName = "\(NSUUID().uuidString).jpg"
                    let ref = DataService.instance.imagesStorageRef.child(photoName)
                    _ = ref.put(imageToData as Data, metadata: nil, completion: { (meta: FIRStorageMetadata?, err: Error?) in
                        if err != nil {
                            print("Error uploading photo: \(err?.localizedDescription)")
                        } else {
                            print("MetaPhotoResponse: \(meta)")
                            let downloadURL = meta?.downloadURL()
                            //save this
                            print("DownloadURLPhoto: \(downloadURL)")
                            print("SelectedUsersPhoto:\(self.selectedUsers)")
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                } else {
                    print("Error: UIImage to Data failed")
                }
            }
            return
        }
        showAlert(title: "Can't send message", message: "Please select at least one user.", buttonText: "Ok")
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        let user = users[indexPath.row]
        cell.updateUI(user: user)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: true)
        let user = users[indexPath.row]
        selectedUsers[user.uid] = user
        print("SelectedUsers1: \(selectedUsers)")
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! UserCell
        cell.setCheckmark(selected: false)
        let user = users[indexPath.row]
        selectedUsers.removeValue(forKey: user.uid)
        print("SelectedUsers2: \(selectedUsers)")
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func showAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
