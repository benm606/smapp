//
//  AccountViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/11/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var scoreButtonText: UIButton!
    @IBOutlet weak var usernameButtonText: UIButton!
    @IBOutlet weak var cat1TextField: UITextField!
    @IBOutlet weak var cat2TextField: UITextField!
    @IBOutlet weak var cat3TextField: UITextField!
    @IBOutlet weak var cat4TextField: UITextField!
    @IBOutlet weak var cat5TextField: UITextField!
    @IBOutlet weak var cat6TextField: UITextField!
    @IBOutlet weak var cat7TextField: UITextField!
    @IBOutlet weak var cat8TextField: UITextField!
    @IBOutlet weak var cat9TextField: UITextField!
    @IBOutlet weak var cat10TextField: UITextField!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var feedLabelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.alpha = 0    //set top bar coloring
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        //self.saveButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.logOutButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.feedLabelButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        if let uid = FIRAuth.auth()?.currentUser?.uid{
            FIRDatabase.database().reference().child("users").child(uid).child("categories").observeSingleEvent(of: .value, with: { (snapshot) in
                if let post = snapshot.value as? [String: AnyObject]{
                    self.cat1TextField.text = post["cat1"] as? String    //set the textfield cats as followed cats
                    self.cat2TextField.text = post["cat2"] as? String
                    self.cat3TextField.text = post["cat3"] as? String
                    self.cat4TextField.text = post["cat4"] as? String
                    self.cat5TextField.text = post["cat5"] as? String
                    self.cat6TextField.text = post["cat6"] as? String
                    self.cat7TextField.text = post["cat7"] as? String
                    self.cat8TextField.text = post["cat8"] as? String
                    self.cat9TextField.text = post["cat9"] as? String
                    self.cat10TextField.text = post["cat10"] as? String
                }
                
            })
            
            FIRDatabase.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value, with: { (snapshot) in
                if let username = snapshot.value as? [String: AnyObject]{
                    self.usernameButtonText.setTitle(username["username"] as? String, for: .normal)       //set username to users username
                }
                
            })
            
            FIRDatabase.database().reference().child("users").child(uid).child("score").observeSingleEvent(of: .value, with: { (snapshot) in
                if let score = snapshot.value as? [String: AnyObject]{
                    self.scoreButtonText.setTitle("\(score["score"] as! Int)", for: .normal)       //set score to users score
                }
                
            })
            
        }
        
        self.cat1TextField.delegate = self
        self.cat2TextField.delegate = self
        self.cat3TextField.delegate = self
        self.cat4TextField.delegate = self
        self.cat5TextField.delegate = self
        self.cat6TextField.delegate = self
        self.cat7TextField.delegate = self
        self.cat8TextField.delegate = self
        self.cat9TextField.delegate = self
        self.cat10TextField.delegate = self
        
        
        self.cat1TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat2TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat3TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat4TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat5TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat6TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat7TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat8TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat9TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)
        self.cat10TextField.addTarget(self, action: #selector(AccountViewController.saveChanges(textField:)), for: UIControlEvents.editingChanged)

     

        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func logOutTapped(_ sender: Any) { //log out user
        //saveChanges()
        do{
            try FIRAuth.auth()?.signOut()
            //successfully logged out
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.present(vc!, animated: true, completion: nil)
        }catch{
            //if error logging out
            print("Error logging out user.")
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //when touched close keyboard
        view.endEditing(true)
       // saveChanges()
        super.touchesBegan(touches, with: event)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
       // saveChanges()
        
    }
    
    func saveChanges(textField: UITextField) {
        if let uid = FIRAuth.auth()?.currentUser?.uid{   ///make sure all fields r filled and create postable object
            
            FIRDatabase.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value, with: {(snapshot) in
                if let userDictionary = snapshot.value as? [String: AnyObject]{
                    for user in userDictionary{
                        
                        if let cat1 = self.cat1TextField.text{
                            if let cat2 = self.cat2TextField.text{
                                if let cat3 = self.cat3TextField.text{
                                    if let cat4 = self.cat4TextField.text{
                                        if let cat5 = self.cat5TextField.text{
                                            if let cat6 = self.cat6TextField.text{
                                                if let cat7 = self.cat7TextField.text{
                                                    if let cat8 = self.cat8TextField.text{
                                                        if let cat9 = self.cat9TextField.text{
                                                            if let cat10 = self.cat10TextField.text{
                                                                let ref = FIRDatabase.database().reference().child("users").child(uid).child("categories")
                                                                
                                                                let postObject: Dictionary<String, Any> = [
                                                                    "cat1" : cat1,
                                                                    "cat2" : cat2,
                                                                    "cat3" : cat3,
                                                                    "cat4" : cat4,
                                                                    "cat5" : cat5,
                                                                    "cat6" : cat6,
                                                                    "cat7" : cat7,
                                                                    "cat8" : cat8,
                                                                    "cat9" : cat9,
                                                                    "cat10" : cat10
                                                                ]
                                                                
                                                                ref.setValue(postObject)
                                                                print("saved updated values")
                                                            }
                                                        }
                                                    }
                                                
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
