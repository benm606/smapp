//
//  ViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/4/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class ViewController: UIViewController{ //,UITextFieldDelegate {

    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func signInTapped(_ sender: Any) {        //sign in button
    
    let username = usernameTextField.text
    let password = passwordTextField.text

    FIRAuth.auth()?.signIn(withEmail: username!, password: password!, completion: { (user, error) in
        if error != nil {
            //error logging in
            let alert = UIAlertController(title: "Error", message: "Incorrect Username/Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            //success
            let alert = UIAlertController(title: "Logged In", message: "You Are Logged In", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    })
        /*usernameTextField.delegate = self
           
        
        func textFieldShouldReturn(usernameTextField: UITextField!) -> Bool {
            usernameTextField.resignFirstResponder()
            return true
        }*/
        
    }
    
    
    

}

