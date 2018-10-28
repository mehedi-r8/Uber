//
//  LeftSidePanelVC.swift
//  Uber
//
//  Created by MEHEDI.R8 on 10/24/18.
//  Copyright © 2018 R8soft. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    let currentUserId = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var accountTypeLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var pickupModelbl: UILabel!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var profileImage: RoundImageView!
    @IBOutlet weak var loginLogutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickupModeSwitch.isOn = false
        pickupModeSwitch.isHidden = true
        pickupModelbl.isHidden = true
        
        observerPassengerAndDriver()
        if Auth.auth().currentUser == nil {
            emailLbl.text = ""
            accountTypeLbl.text = ""
            profileImage.isHidden = true
            loginLogutBtn.setTitle("Login", for: .normal)
        } else {
            emailLbl.text = Auth.auth().currentUser?.email
            accountTypeLbl.text = ""
            profileImage.isHidden = false
            loginLogutBtn.setTitle(MSG_SIGN_OUT, for: .normal)
        }
    }
    
    
    func observerPassengerAndDriver() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.accountTypeLbl.text = "Passenger"
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.accountTypeLbl.text = "Driver"
                        self.pickupModeSwitch.isHidden = false
                        if let switchstatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool {
                            self.pickupModeSwitch.isOn = switchstatus

                        }
                        
                        
                        self.pickupModelbl.isHidden = false
                    }
                }
            }
        })
    }
    
    @IBAction func switchWasToggle(_ sender: Any) {
        if pickupModeSwitch.isOn {
            pickupModelbl.text = MSG_PICKUP_MODE_ENABLED
            appDelegate.MenuContainerVC.toggleLeftPanel()
            
            if currentUserId != nil {
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues([ACCOUNT_PICKUP_MODE_ENABLED: true])
            } else {
                print("error")
            }
            
        } else {
            pickupModelbl.text = MSG_PICKUP_MODE_DISABLED
            appDelegate.MenuContainerVC.toggleLeftPanel()
            if currentUserId != nil {
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues([ACCOUNT_PICKUP_MODE_ENABLED: false])
            }
        }
    }
    
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        } else {
            do {
                try Auth.auth().signOut()
                emailLbl.text = ""
                accountTypeLbl.text = ""
                profileImage.isHidden = true
                pickupModelbl.text = ""
                pickupModeSwitch.isHidden = true
                loginLogutBtn.setTitle(MSG_SIGN_UP_SIGN_IN, for: .normal)
                
            } catch {
                print("problem")
            }
        }
        
        
    }
}
