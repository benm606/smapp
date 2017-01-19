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
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    var imageFileName = ""
    var imageUploadedToFirebase = false    //used to make sure photo is uploaded fully before being posted
    var tapTerm:UITapGestureRecognizer = UITapGestureRecognizer()
    var slidUp = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.alpha = 0    //set top bar coloring
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.postButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        
        self.titleTextField.delegate = self
        self.contentTextView.delegate = self
        self.titleTextField.tag = 1
        self.contentTextView.tag = 0
        
        tapTerm = UITapGestureRecognizer(target: self, action: #selector(PostViewController.slideUp(a:)))
        tapTerm.delegate = self
        contentTextView.addGestureRecognizer(tapTerm)
        
        self.titleTextField.addTarget(self, action: #selector(PostViewController.slideUp(a:)), for: UIControlEvents.touchDown)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //runs when photo selection is cancelled
        picker.dismiss(animated: true, completion: nil)   //close image picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //runs when photo is picked from library
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.previewImageView.image = pickedImage
            self.selectImageButton.isEnabled = false  //hide select image button
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)  //close image picker
        }
    }
    
    
    @IBAction func postTapped(_ sender: AnyObject) {     //post to firebase databse
        if(self.imageUploadedToFirebase){
            
            //this is where code could be to enable button when post ready to be posted
            
            if let uid = FIRAuth.auth()?.currentUser?.uid{   ///make sure all fields r filled and create postable object
                
                FIRDatabase.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value, with: {(snapshot) in
                    
                    
                    if let user = snapshot.value as? [String: AnyObject]{
                        let username = user["username"] as? String
                        if let category = self.titleTextField.text{
                            if let content = self.contentTextView.text{
                                let ref = FIRDatabase.database().reference().child("posts").childByAutoId()
                                let key = ref.key
                                
                                let time = FIRServerValue.timestamp()
                                
                                let postObject: Dictionary<String, Any> = [
                                    "uid" : uid,
                                    "category" : category,
                                    "content" : content,
                                    "username" : username!,
                                    "image" : self.imageFileName,
                                    "postID": key,
                                    "time": time
                                ]
                                
                                ref.setValue(postObject)
                                ref.child("likes").setValue(0)  //create likes saved int, set likes to zero to start
                                ref.child("userWhoLikedID").child("\(uid)").setValue("a")
                                ref.child("userWhoDisklikedID").child("\(uid)").setValue("a")
                                
                                //let ref1 = "\(ref)"
                                //ref.child("postID").setValue(ref1)
                                //print(ref1)
                                
                                
                                let alert = UIAlertController(title: "Success", message: "Post sent", preferredStyle: .alert)  // popup message to say posted
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                                    //runs when OK pressed, brings to main vc
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainVC")
                                    self.present(vc!, animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                                
                                print("posted to Firebase")
                                self.imageUploadedToFirebase = false
                            }
                        }
                    }
                    
                    
                    
                })
                
            }
        }
        
    }
    
    
    @IBAction func selectImageTapped(_ sender: Any) {
        slideDown()
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){                           //create random name to save photo under
        let randomName = randomStringWithLength(length: 10)
        let imageData = UIImageJPEGRepresentation(image, 0)
        let uploadRef = FIRStorage.storage().reference().child("images/\(randomName).jpg")
        
        let uploadTask = uploadRef.put(imageData!, metadata: nil){
            metadata, error in
            
            if error == nil{
                //success
                print("Successfully uploaded picture")
                self.imageUploadedToFirebase = true
                self.imageFileName = "\(randomName as String).jpg"
            }else{
                //error
                print("Error uloading image: \(error?.localizedDescription)")
            }
        }
    }
    
    func randomStringWithLength(length: Int) -> NSString{
        let characters: NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: NSMutableString = NSMutableString(capacity: length)
        for i in 0..<length{
            var len = UInt32(characters.length)
            var rand = arc4random_uniform(len)
            randomString.appendFormat("%C", characters.character(at: Int(rand)))
        }
        return randomString
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {   //when touched close keyboard
        view.endEditing(true)
        slideDown()
        super.touchesBegan(touches, with: event)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool        //return key pressed on title
    {
                                        // remove keyboard.
        textField.resignFirstResponder()
        slideDown()
        
        // Do not add a line break
        return false
    }
    func slideUp(a: Any){               //slide view up
        if(!slidUp){
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin = CGPoint(x: (self.view.frame.origin.x), y: (self.view.frame.origin.y - 110))
                })
            
            slidUp = true
        }
     }
    func slideDown(){               //slide view down
        if(slidUp){
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame.origin = CGPoint(x: (self.view.frame.origin.x), y: (self.view.frame.origin.y + 110))
            })
            slidUp = false
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()                 //done key pressed on content
            slideDown()
            return false
        }
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
