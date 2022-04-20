//
//  CatalogViewController.swift
//  Reserve
//
//  Created by Edward Cluster on 4/12/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class CatalogViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var books = [PFObject]()
    
    @IBOutlet weak var tableView: UITableView!
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.keyboardDismissMode = .interactive
        // Do any additional setup after loading the view.
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let query = PFQuery(className: "Book")
        query.includeKeys(["author", "comments", "comments.author"])

        query.findObjectsInBackground { (books, error) in
            if books != nil {
                self.books = books!
                self.tableView.reloadData()
            } else {
                print("There are no books")
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let book = books[section]
        let comments = (book["comments"] as? [PFObject]) ?? []
        
        return comments.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let book = books[indexPath.section]
        let comments = (book["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookPostCell") as! BookPostCell
            cell.titleLabel.text = book["title"] as! String
            cell.authorLabel.text = book["author"] as! String
            
            let imageFile = book["cover"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.photoView.af.setImage(withURL: url)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let comment = PFObject(className: "Comments")
        comment["text"] = "This is a random comment"
        comment["book"] = book
        comment["author"] = PFUser.current()!
        
        book.add(comment, forKey: "comments")
        
        book.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
