//
//  MainViewController.swift
//  Smapp
//
//  Created by Ben Mesnik on 1/6/17.
//  Copyright © 2017 Ben Mesnik. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var postsTableView: UITableView!
    @IBOutlet var fullPostView: UIView!
    @IBOutlet weak var selectionLikeImageView: UIImageView!
    @IBOutlet weak var selectionDislikeImageView: UIImageView!
    @IBOutlet weak var selectionSaveImageView: UIImageView!
    @IBOutlet weak var selectionShareImageView: UIImageView!
    @IBOutlet weak var selectionCenterImageView: UIImageView!
    
    var posts = NSMutableArray()
    var touchPressedX = CGFloat()
    var touchReleasedX = CGFloat()
    var touchPressedY = CGFloat()
    var touchReleasedY = CGFloat()
    var touchDown = false
    var selectionLikeHighlighted = false
    var selectionDislikeHighlighted = false
    var selectionShareHighlighted = false
    var selectionSaveHighlighted = false
    var postID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.selectionCenterImageView.alpha = 0
        self.selectionLikeImageView.alpha = 0
        self.selectionDislikeImageView.alpha = 0
        self.selectionSaveImageView.alpha = 0
        self.selectionShareImageView.alpha = 0
        
        self.navigationController?.navigationBar.alpha = 0    //set top bar coloring
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        loadData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        FIRDatabase.database().reference().child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            if let postsDictionary = snapshot.value as? [String: AnyObject]{
                for post in postsDictionary{
                    self.posts.add(post.value)       //fill table with posts from posts folder-
                }
                self.postsTableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.posts.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {      //called with reloadData()-
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        
        // Configure the cell...
        let post = self.posts[indexPath.row] as! [String: AnyObject]  //indexPath.row is the post number?-
        cell.titleLabel.text = post["title"] as? String
        cell.contentTextView.text = post["content"] as? String
        
        if let imageName = post["image"] as? String{
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion:{ (data, error) -> Void in  //max data size 25 mb
                if error == nil{   //successfully took image data from firebase
                    //success
                    let image = UIImage(data: data!)
                    cell.postImageView.image = image
                    
                    cell.titleLabel.alpha = 0                   //slowly fade in post with animation
                    cell.contentTextView.alpha = 0
                    cell.postImageView.alpha = 0
                    UIView.animate(withDuration: 0.4, animations: {
                        cell.titleLabel.alpha = 1
                        cell.contentTextView.alpha = 1
                        cell.postImageView.alpha = 1
                    })
                    
                }else{
                    //error
                    print("Error downloading image: \(error?.localizedDescription)")
                }
            })
        }
        
        return cell
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .alert)  // popup message to say posted
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //runs when OK pressed, brings to main vc
            do{
                try FIRAuth.auth()?.signOut()
                //successfully logged out
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
                self.present(vc!, animated: true, completion: nil)
            }catch{
                //if error logging out
                print("Error logging out user.")
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            //runs when no pressed, brings to main vc
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let touchPoint = touch.location(in: self.selectionCenterImageView)
            if(self.selectionCenterImageView.bounds.contains(touchPoint)){     //if center of wheel touced
                UIView.animate(withDuration: 0.2, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.7
                    self.selectionLikeImageView.alpha = 0.4
                    self.selectionDislikeImageView.alpha = 0.4
                    self.selectionSaveImageView.alpha = 0.4
                    self.selectionShareImageView.alpha = 0.4
                })
                selectionLikeHighlighted = false     //set which spoke highlighted for end action
                selectionDislikeHighlighted = false
                selectionShareHighlighted = false
                selectionSaveHighlighted = false
            }
        }
        //if touches.first?.view == selectionCenterImageView
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var touchPoint = touch.location(in: self.selectionLikeImageView)
            if(self.selectionLikeImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.4
                    self.selectionLikeImageView.alpha = 0.7
                    self.selectionDislikeImageView.alpha = 0.4
                    self.selectionSaveImageView.alpha = 0.4
                    self.selectionShareImageView.alpha = 0.4
                })
                selectionLikeHighlighted = true
                selectionDislikeHighlighted = false
                selectionShareHighlighted = false
                selectionSaveHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionDislikeImageView)
            if(self.selectionDislikeImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.4
                    self.selectionLikeImageView.alpha = 0.4
                    self.selectionDislikeImageView.alpha = 0.7
                    self.selectionSaveImageView.alpha = 0.4
                    self.selectionShareImageView.alpha = 0.4
                })
                selectionLikeHighlighted = false
                selectionDislikeHighlighted = true
                selectionShareHighlighted = false
                selectionSaveHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionShareImageView)
            if(self.selectionShareImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.4
                    self.selectionLikeImageView.alpha = 0.4
                    self.selectionDislikeImageView.alpha = 0.4
                    self.selectionSaveImageView.alpha = 0.4
                    self.selectionShareImageView.alpha = 0.7
                })
                selectionLikeHighlighted = false
                selectionDislikeHighlighted = false
                selectionShareHighlighted = true
                selectionSaveHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionSaveImageView)
            if(self.selectionSaveImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.4
                    self.selectionLikeImageView.alpha = 0.4
                    self.selectionDislikeImageView.alpha = 0.4
                    self.selectionSaveImageView.alpha = 0.7
                    self.selectionShareImageView.alpha = 0.4
                })
                selectionLikeHighlighted = false
                selectionDislikeHighlighted = false
                selectionShareHighlighted = false
                selectionSaveHighlighted = true
            }
            touchPoint = touch.location(in: self.selectionCenterImageView)
            if(self.selectionCenterImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.7
                    self.selectionLikeImageView.alpha = 0.4
                    self.selectionDislikeImageView.alpha = 0.4
                    self.selectionSaveImageView.alpha = 0.4
                    self.selectionShareImageView.alpha = 0.4
                })
                selectionLikeHighlighted = false
                selectionDislikeHighlighted = false
                selectionShareHighlighted = false
                selectionSaveHighlighted = false
            }
            
            touchPoint = touch.location(in: self.selectionLikeImageView)
            if(self.selectionLikeImageView.bounds.contains(touchPoint) == false){
                touchPoint = touch.location(in: self.selectionDislikeImageView)
                if(self.selectionDislikeImageView.bounds.contains(touchPoint) == false){
                    touchPoint = touch.location(in: self.selectionCenterImageView)
                    if(self.selectionCenterImageView.bounds.contains(touchPoint) == false){
                        touchPoint = touch.location(in: self.selectionShareImageView)
                        if(self.selectionShareImageView.bounds.contains(touchPoint) == false){
                            touchPoint = touch.location(in: self.selectionSaveImageView)
                            if(self.selectionSaveImageView.bounds.contains(touchPoint) == false){
                                
                                UIView.animate(withDuration: 0.2, animations: {     //unhighlight selection wheel spokes
                                    self.selectionCenterImageView.alpha = 0.4
                                    self.selectionLikeImageView.alpha = 0.4
                                    self.selectionDislikeImageView.alpha = 0.4
                                    self.selectionSaveImageView.alpha = 0.4
                                    self.selectionShareImageView.alpha = 0.4
                                })
                                selectionLikeHighlighted = false
                                selectionDislikeHighlighted = false
                                selectionShareHighlighted = false
                                selectionSaveHighlighted = false
                            }
                        }
                        
                    }
                }
            }
        }
        
        if let touchX = touches.first?.preciseLocation(in: fullPostView).x{
            if let touchY = touches.first?.preciseLocation(in: fullPostView).y{
                if(touchDown == false){           //set the first touch x and y once
                    touchPressedX = touchX
                    touchPressedY = touchY
                    touchDown = true
                }
                touchReleasedX = touchX
                touchReleasedY = touchY
            }
        }
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touchDown){  //make sure there was a drag
            touchDown = false
            if(selectionLikeHighlighted){     //like image selected
                //print("Like image")
                
                if let touch = touches.first{
                    let touchPoint = touch.location(in: self.postsTableView)
                    var indexPath1 =  self.postsTableView.indexPathForRow(at: touchPoint) //get cell index for current picture

                    let post = self.posts[(indexPath1?.row)!] as! [String: AnyObject]  //get likes int from firebase
                    var a = post["likes"] as? Int
                    a = a!+1
                    let refFullString = post["ref"] as? String
                    //let stringSize = (refFullString?.characters.count)!
                    let index = refFullString?.index((refFullString?.endIndex)!, offsetBy: 20)
                    let refShortString = refFullString?.substring(from: index!)
                    print("\(refShortString)")
                    //ref?.child("likes").setValue(a)
 
                    
                    let numberOfRows = self.postsTableView.numberOfRows(inSection: 0) - 1
                    if(numberOfRows > (indexPath1?.row)!){                    //chek if last image in column
                        indexPath1?.row = (indexPath1?.row)! + 1
                        self.postsTableView.scrollToRow(at: indexPath1!, at: UITableViewScrollPosition.top, animated: true)//go to next post
                        // self.postsTableView.reloadData() //refresh
                    }
                }
            }
            if(selectionDislikeHighlighted){
                print("Dislike image")
            }
            if(selectionShareHighlighted){
                print("Share/Next image")
            }
            if(selectionSaveHighlighted){
                print("Save image")
            }
            //let horizontalChange:CGFloat = touchReleasedX - touchPressedX   // x and y change of drag
            //let verticalChange: CGFloat = touchPressedY - touchReleasedY
            
            //print(horizontalChange)
            //print(verticalChange)
        }
        UIView.animate(withDuration: 0.2, animations: {     //hide selection wheel
            self.selectionCenterImageView.alpha = 0
            self.selectionLikeImageView.alpha = 0
            self.selectionDislikeImageView.alpha = 0
            self.selectionSaveImageView.alpha = 0
            self.selectionShareImageView.alpha = 0
        })
        super.touchesEnded(touches, with: event)
    }
    
    
    func likePost(_ post: String){
        let ref = FIRDatabase.database().reference()
        let keyToPost = ref.child("posts").childByAutoId().key
    }
    func savePost(_ post: String){
        
    }
    func dislikePost(_ post: String){
        
    }
    func nextPost(){
        
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
