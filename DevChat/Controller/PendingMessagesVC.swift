//
//  PendingMessagesVC.swift
//  DevChat
//
//  Created by smbss on 27/02/2017.
//  Copyright © 2017 smbss. All rights reserved.
//

import UIKit

class PendingMessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var pendingMessages = [PendingMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("PendingMessagesVC will appear")
        DataService.instance.userPendingMessagesRef.observe(.value, with: { (snapshot) in
            print("FIRSnapshotMessages: ", snapshot.debugDescription)
            if let pendingMessages = snapshot.value as? Dictionary<String, AnyObject> {
                if self.pendingMessages.count > 0  {
                    self.pendingMessages.removeAll()
                }
                for (key, value) in pendingMessages {
                    if let pendingMessage = value as? Dictionary<String, AnyObject> {
                        let message = PendingMessage(pendingMessageUID: key, pendingMessage: pendingMessage)
                        print("PedingMessage: \(message)")
                        self.pendingMessages.append(message)
                    }
                }
            }
            self.pendingMessages.sort(by: { $1.dateCreated! < $0.dateCreated! })
            self.tableView.reloadData()
            print("MessagesArray: \(self.pendingMessages)")
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataService.instance.userPendingMessagesRef.removeAllObservers()
    }
    
    @IBAction func backToCamera(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        let message = pendingMessages[indexPath.row]
        cell.updateUI(pendingMessage: message)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pendingMessage = pendingMessages[indexPath.row]
        let messageRef = DataService.instance.userPendingMessagesRef.child(pendingMessage.messageUID!)
        let openCountUpdated = pendingMessages[indexPath.row].openCount! + 1
        messageRef.updateChildValues(["openCount" : openCountUpdated])
        if let mediaType = pendingMessage.mediaType {
            if let mediaUrlString = pendingMessage.mediaURL {
                let url = URL(string: mediaUrlString)
                if mediaType == "video" {
                    let newVC = VideoViewController(videoURL: url!)
                    self.present(newVC, animated: true, completion: nil)
                } else if mediaType == "image" {
                    print("Opening image")
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        if error != nil {
                            print("URLSession data error: \(error?.localizedDescription)")
                            return
                        }
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data!) {
                                print("Image: \(image)")
                                print("Image data: \(data)")
                                let newVC = PhotoViewController(image: image)
                                self.present(newVC, animated: true, completion: nil)
                            }
                        }
                    }).resume()
                } else {
                    print("Present error: mediaType != video or image")
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingMessages.count
    }
    
    func showAlert(title: String, message: String, buttonText: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}