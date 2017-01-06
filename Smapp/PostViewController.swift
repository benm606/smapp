//
//  PostViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/5/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postTapped(_ sender: Any) {     //post to firebase databse
        
        if let uid = FIRAuth.auth()?.currentUser?.uid{   ///make sure all fields r filled and create postable object
            if let title = titleTextField.text{
                if let content = contentTextView.text{
                    let postObject: Dictionary<String, Any> = [
                        "uid" : uid,
                        "title" : title,
                        "content" : content
                    ]
                    
                    FIRDatabase.database().reference().child("posts").childByAutoId().setValue(postObject)
                    
                    let alert = UIAlertController(title: "Success", message: "Post sent", preferredStyle: .alert)  // popup message to say posted
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                    
                    print("posted to Firebase")
                }
            }
        }
     
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //when touched close keyboard
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
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
