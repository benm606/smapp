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
    
    @IBOutlet weak var selectionCenterImageView: UIImageView!
    @IBOutlet weak var popularCategoryButton: UIButton!
    @IBOutlet weak var recentCategoryButton: UIButton!
    @IBOutlet weak var categoryMenuButton: UIButton!
    @IBOutlet weak var grayBackgroundCoat: UIImageView!
    
    @IBOutlet weak var selectionNextImageView: UIImageView!
    @IBOutlet weak var selectionBackImageView: UIImageView!
    @IBOutlet weak var selectionSaveImageView: UIImageView!
    
    var posts = NSMutableArray()
    var touchPressedX = CGFloat()
    var touchReleasedX = CGFloat()
    var touchPressedY = CGFloat()
    var touchReleasedY = CGFloat()
    var touchDown = false
    var selectionLikeHighlighted = false
    var selectionSaveHighlighted = false
    var selectionBackHighlighted = false
    var selectionNextHighlighted = false
    var postID: String!
    var categoryMenuOpen = false
    var likesRank = NSMutableArray()
    var likesRankIndexPathsRows = NSMutableArray()
    var likesRankRow = Int()
    var likesRankIndexPath = IndexPath()
    var sortByLikes = true
    var sortByTime = false
    var recentRank = NSMutableArray()
    var recentRankIndexPathsRows = NSMutableArray()
    var recentRankRow = Int()
    var recentRankIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.postsTableView.delegate = self
        self.postsTableView.dataSource = self
        
        self.selectionCenterImageView.alpha = 0
        self.selectionLikeImageView.alpha = 0
        self.selectionSaveImageView.alpha = 0
        self.selectionNextImageView.alpha = 0
        self.selectionBackImageView.alpha = 0
        self.grayBackgroundCoat.alpha = 0
        
        self.likesRankIndexPath = IndexPath(row: 0, section: 0)
        self.likesRankRow = 0
        self.recentRankIndexPath = IndexPath(row: 0, section: 0)
        self.recentRankRow = 0
        
        //hide buttons
        self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
        self.popularCategoryButton.alpha = 0
        self.recentCategoryButton.alpha = 0
        
        self.navigationController?.navigationBar.alpha = 0    //set top bar coloring
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
        self.popularCategoryButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        self.recentCategoryButton.backgroundColor = UIColor(red: 150/255, green: 10/255, blue: 10/255, alpha: 1.0)
        
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
                    
                    let post1 = post.value as! [String: AnyObject]  //indexPath.row is the post number?-
                    
                    /*                  sort by likes                         */
                    
                    let currentPostLikes = post1["likes"] as! Int
                    self.likesRank.add(currentPostLikes)
                    self.likesRankIndexPathsRows.add(self.likesRankRow)
                    self.likesRankRow = self.likesRankRow + 1
                    
                    
                    if(self.likesRank.count > 1){
                        for (index, element) in self.likesRank.enumerated() {
                            if(self.likesRank[(self.likesRank.count - 1)] as! Int > element as! Int){
                                self.likesRank.exchangeObject(at: index, withObjectAt: (self.likesRank.count - 1))
                                self.likesRankIndexPathsRows.exchangeObject(at: index, withObjectAt: (self.likesRankIndexPathsRows.count - 1))
                            }
                        }
                        
                    }
                    /*          ^^             ^^     */
                    
                    /*              sort by time               */
                    
                    // if(FIRAuth.auth()?.currentUser?.uid == ("j1Bj5gGjH1eoJtP4CcgFbDJYxNt2")){  //only my account can do(for later deleting old posts)
                    if let t = post1["time"] as? TimeInterval{
                        let time = Date(timeIntervalSince1970: t/1000)
                        
                        self.recentRank.add(time)
                        self.recentRankIndexPathsRows.add(self.recentRankRow)
                        self.recentRankRow = self.recentRankRow + 1
                        
                        
                        if(self.recentRank.count > 1){
                            for (index, element) in self.recentRank.enumerated() {
                                let date1 = self.recentRank[(self.recentRank.count - 1)] as! Date
                                let date2 = element as! Date
                                if(date1.compare(date2 as Date) == ComparisonResult.orderedDescending){
                                    self.recentRank.exchangeObject(at: index, withObjectAt: (self.recentRank.count - 1))
                                    self.recentRankIndexPathsRows.exchangeObject(at: index, withObjectAt: (self.recentRankIndexPathsRows.count - 1))
                                }
                            }
                            
                        }
                        
                    }
                    //  }
                    
                    /*       ^^             ^^              */
                    
                    /*              sort by category               */

                    
                    self.posts.add(post.value)       //fill table with posts from posts folder-
                }
                
                self.likesRankRow = 0    //set as second index value since first image index already used
                
                
                self.postsTableView.reloadData()
                
                self.likesRankIndexPath.row = self.likesRankIndexPathsRows[0] as! Int   //set next row as next row in array
                self.likesRankIndexPath.section = 0
                self.postsTableView.scrollToRow(at: self.likesRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to first/ top liked post
                
                
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
        //cell.likeCountLabel.text = post["likes"] as? String
        cell.likeCountLabel.text = "\(post["likes"] as! Int)"
        cell.contentTextView.text = post["content"] as? String
        cell.usernameLabel.text = post["username"] as? String
        
        cell.likeCountLabel.alpha = 0                   //slowly fade in post with animation
        cell.usernameLabel.alpha = 0
        cell.contentTextView.alpha = 0
        cell.postImageView.alpha = 0
        if let imageName = post["image"] as? String{
            let imageRef = FIRStorage.storage().reference().child("images/\(imageName)")
            imageRef.data(withMaxSize: 25 * 1024 * 1024, completion:{ (data, error) -> Void in  //max data size 25 mb
                if error == nil{   //successfully took image data from firebase
                    //success
                    let image = UIImage(data: data!)
                    cell.postImageView.image = image
                    
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        cell.likeCountLabel.alpha = 1
                        cell.usernameLabel.alpha = 1
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
                    self.selectionCenterImageView.alpha = 0.8
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false     //set which spoke highlighted for end action
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
        }
        //if touches.first?.view == selectionCenterImageView
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            var touchPoint = touch.location(in: self.selectionLikeImageView)
            if(self.selectionLikeImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.8
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = true
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionSaveImageView)
            if(self.selectionSaveImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.8
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = true
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionBackImageView)
            if(self.selectionBackImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.8
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = false
                selectionBackHighlighted = true
                selectionNextHighlighted = false
            }
            touchPoint = touch.location(in: self.selectionNextImageView)
            if(self.selectionNextImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.6
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.8
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = true
            }
            touchPoint = touch.location(in: self.selectionCenterImageView)
            if(self.selectionCenterImageView.bounds.contains(touchPoint)){
                UIView.animate(withDuration: 0.1, animations: {     //highlight selection wheel spokes
                    self.selectionCenterImageView.alpha = 0.8
                    self.selectionLikeImageView.alpha = 0.6
                    self.selectionSaveImageView.alpha = 0.6
                    self.selectionNextImageView.alpha = 0.6
                    self.selectionBackImageView.alpha = 0.6
                })
                selectionLikeHighlighted = false
                selectionSaveHighlighted = false
                selectionBackHighlighted = false
                selectionNextHighlighted = false
            }
            
            touchPoint = touch.location(in: self.selectionLikeImageView)
            if(self.selectionLikeImageView.bounds.contains(touchPoint) == false){
                touchPoint = touch.location(in: self.selectionSaveImageView)
                if(self.selectionSaveImageView.bounds.contains(touchPoint) == false){
                    touchPoint = touch.location(in: self.selectionCenterImageView)
                    if(self.selectionCenterImageView.bounds.contains(touchPoint) == false){
                        touchPoint = touch.location(in: self.selectionBackImageView)
                        if(self.selectionBackImageView.bounds.contains(touchPoint) == false){
                            touchPoint = touch.location(in: self.selectionNextImageView)
                            if(self.selectionNextImageView.bounds.contains(touchPoint) == false){
                                
                                UIView.animate(withDuration: 0.2, animations: {     //unhighlight selection wheel spokes
                                    self.selectionCenterImageView.alpha = 0.6
                                    self.selectionLikeImageView.alpha = 0.6
                                    self.selectionSaveImageView.alpha = 0.6
                                    self.selectionNextImageView.alpha = 0.6
                                    self.selectionBackImageView.alpha = 0.6
                                })
                                selectionLikeHighlighted = false
                                selectionSaveHighlighted = false
                                selectionBackHighlighted = false
                                selectionNextHighlighted = false
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
                
                likePost(likesRankIndexPath)
                nextPost()
                //print("Like image")
                
            }
            if(selectionSaveHighlighted){
                // print("Save image")
            }
            if(selectionBackHighlighted){
                goBackPost()
                //print("Go Back an image")
                
            }
            if(selectionNextHighlighted){
                nextPost()
                // print("Next image")
            }
            //let horizontalChange:CGFloat = touchReleasedX - touchPressedX   // x and y change of drag
            //let verticalChange: CGFloat = touchPressedY - touchReleasedY
            
            //print(horizontalChange)
            //print(verticalChange)
        }
        UIView.animate(withDuration: 0.2, animations: {     //hide selection wheel
            self.selectionCenterImageView.alpha = 0
            self.selectionLikeImageView.alpha = 0
            self.selectionSaveImageView.alpha = 0
            self.selectionNextImageView.alpha = 0
            self.selectionBackImageView.alpha = 0
        })
        super.touchesEnded(touches, with: event)
    }
    
    
    func likePost(_ indexPath1: IndexPath){
        let post = self.posts[(indexPath1.row)] as! [String: AnyObject]  //get likes int from firebase
        let ref = post["postID"] as! String
        
        
        let base = FIRDatabase.database().reference()
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        
        
        /////////////in progress, one like only
        
        
        let b = post["userWhoLikedID"] as? [String: Any]
            if let c = b?["\(uid)"] as? String{
                //user already liked post
                
            }else{
                //user hasent liked post yet
                var a = post["likes"] as? Int
                a = a!+1
                
                base.child("posts").child(ref).child("likes").setValue(a)
                base.child("posts").child(ref).child("userWhoLikedID").child("\(uid)").setValue("a")
                
            }
        
        
        
        
        ///////////////////
        
        
    }
    func savePost(_ post: String){
        
    }
    func goBackPost(){
        if(sortByLikes){
            if(0 < likesRankRow){                    //chek if first image in column
                self.likesRankRow = self.likesRankRow - 1           //increment array location counter
                
                self.likesRankIndexPath.row = self.likesRankIndexPathsRows[likesRankRow] as! Int   //set next row as previous row in array
                self.likesRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: likesRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next top liked post
            }else{
                //no more posts to go back to
                print("No post before")
            }
        }else if(sortByTime){
            if(0 < recentRankRow){                    //chek if first image in column
                self.recentRankRow = self.recentRankRow - 1           //increment array location counter
                
                self.recentRankIndexPath.row = self.recentRankIndexPathsRows[recentRankRow] as! Int   //set next row as previous row in array
                self.recentRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: recentRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next tmost recent post
            }else{
                //no more posts to go back to
                print("No post before")
            }
        }
    }
    func nextPost(){            //go to next post
        let numberOfRows = self.postsTableView.numberOfRows(inSection: 0)   //get number oftotal rows
        if(sortByLikes){
            if(numberOfRows > likesRankRow + 1){                    //chek if last image in column
                self.likesRankRow = self.likesRankRow + 1           //increment array location counter
                self.likesRankIndexPath.row = self.likesRankIndexPathsRows[likesRankRow] as! Int   //set next row as next row in array
                self.likesRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: likesRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next top liked post
            }else{
                //no more posts to view
                print("No more posts")
            }
        }else if(sortByTime){
            if(numberOfRows > recentRankRow + 1){                    //chek if last image in column
                
                self.recentRankRow = self.recentRankRow + 1           //increment array location counter
                self.recentRankIndexPath.row = self.recentRankIndexPathsRows[recentRankRow] as! Int   //set next row as next row in array
                self.recentRankIndexPath.section = 0
                
                self.postsTableView.scrollToRow(at: recentRankIndexPath, at: UITableViewScrollPosition.top, animated: false)//go to next tmost recent post
            }else{
                //no more posts to view
                print("No more posts")
            }
        }
    }
    
    @IBAction func categoryMenuTapped(_ sender: Any) {                  //open category menu, dropdown look
        if(categoryMenuOpen){                           //category menu already open, so close it
            categoryMenuOpen = false
            UIView.animate(withDuration: 0.2, animations: {
                self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
                
                self.popularCategoryButton.alpha = 0
                self.recentCategoryButton.alpha = 0
                self.grayBackgroundCoat.alpha = 0
            })
            
        }else{                                          //category menu closed, so open it
            categoryMenuOpen = true
            UIView.animate(withDuration: 0.2, animations: {
                self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: (self.categoryMenuButton.frame.origin.y + self.popularCategoryButton.frame.height - 4))
                self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: (self.categoryMenuButton.frame.origin.y + self.popularCategoryButton.frame.height + self.recentCategoryButton.frame.height - 4))
                
                self.popularCategoryButton.alpha = 1
                self.recentCategoryButton.alpha = 1
                self.grayBackgroundCoat.alpha = 0.5
            })
        }
    }
    
    @IBAction func recentCategoryTapped(_ sender: Any) {                //recent selected as category
        categoryMenuOpen = false
        sortByTime = true
        sortByLikes = false
        recentRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle("Recent", for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.recentCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
    }
    
    @IBAction func popularCategoryTapped(_ sender: Any) {                   //popular selected as category
        categoryMenuOpen = false
        sortByLikes = true
        sortByTime = false
        likesRankRow = -1
        nextPost()
        self.categoryMenuButton.setTitle("Popular", for: .normal)
        UIView.animate(withDuration: 0.2, animations: {
            self.popularCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            self.recentCategoryButton.frame.origin = CGPoint(x: (self.popularCategoryButton.frame.origin.x ), y: self.categoryMenuButton.frame.origin.y)
            
            self.popularCategoryButton.alpha = 0
            self.recentCategoryButton.alpha = 0
            self.grayBackgroundCoat.alpha = 0
        })
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
    
    
    
    /*    for tommorow
    
                    postimageview? alpha less when wheel shown so easier to see
                    add category sort/side bar
    
        
     
     
     to do
        category sort
        user score
        side bar
        save image
        manage categories
        first and last image screen
        list of posts users already saw so they dont view again when reopening app?
    
    
    
    
    
    
    
    
    
    
    */
    
}
