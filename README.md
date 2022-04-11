Reserve - CodePath iOS Project
===

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
This iOS application is like a book reservation dashboard. Users will be able to search for a specific book. They will also be able to see a catalog of all available books. The main focus on the application is the user being able to return books and reserve/checkout books. In addition, users will be able to see the history of the books they checked out. Finally, users will be able to favorite books they would like to read in the future, and users can write reviews of the books. The different objects that are part of the application will be users and books. A user will have a username and a password. A book will contain a book title, author, and isbn number that will uniquely identify the book. A user will be able to see a list of books they checkout and their favorite books. 

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:** Educational / Social Media
- **Mobile:** This app will be created using iOS. Functionality will be limited to iOS as we have no current plans to expand the application to other platforms.
- **Story:** Allows users to browse through a sophiscated catalog of books and be able to reserve them.
- **Market:** This app can be used by any individual. They are many types of books so anyone is safe to go on the application and checkout books after sign up.
- **Habit:** This app will be used as often as the user needs to check out a book or return a book. Users who read more are expected to return to the application more often.
- **Scope:** This application should only have a short reach as it will only be on iOS. If we decide to expand to other platforms then our reach will be larger. With more platforms users will be able to share books with one another.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can reserve/checkout a book
* User can return a book
* User can see a history of all the books they have checked out
* User can view a catalog of books 
* User can favorite books and view a list of their favorited books
* User can write reviews on books

**Optional Nice-to-have Stories**

* User can search for books

### 2. Screen Archetypes

* Login 
* Sign up
* Stream (Book catalog page)
    * User can view a catalog of books
    * User can tap to favorite books
    * User can write reviews on books
    * User can reserve/checkout a book
* Stream (favorite books page)
    * User can see a a list of their favorite books
* Stream (used books page)
    * User can see a history of all the books they have checked out
    * User can return a book
* Search
    * User can search for books
    

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Book Catalog 
* Favorite Books
* My Books
* Logout

**Flow Navigation** (Screen to Screen)

* Login
   => Book Catalog
* Sign up 
   => Book Catalog
* Book Catalog
   => Favorite Books
   => My Books 
   => Logout
* Favorite Books
   => Book Catalog
   => My Books
   => Logout
* My Books
   => Book Catalog
   => Favorite Books
   => Logout
* Logout
   => Login
   

## Wireframes
<img width="600" alt="sketch" src="https://user-images.githubusercontent.com/53790807/161641401-e035a2bf-ac0d-4197-8b0c-e1a30d3f96d1.png">

### [BONUS] Digital Wireframes & Mockups      
<img width="600" alt="sketch" src="https://user-images.githubusercontent.com/53790807/161654713-d6dce320-bfba-4807-9d71-98d468e30d13.png">

## Schema 
### Models
#### User
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | username      | String   | string username to login |
   | password      | String   | string password to login |
   | favorites     | Array    | array of boooks that the user has favorited |
   | checkouts     | Array    | array of books that the user had checked out form the catalog |
   
   
#### Book
   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the book (default field) |
   | title         | String   | name of the book  |
   | author        | String   | name of author who wrote the book |
   | status        | Boolean  | identify whether a book is available for checkout or not |
   | reviews       | Array    | list of reviews that people made about the book |
   
### Networking

List of network requests by screen

|  CRUD  | HTTP Verb |     Example     |
|:------:|:---------:|:---------------:|
| Create |  `POST`   | Making a review |
| Read   |  `GET`    | Get all favorite books from user |
| Delete |  `DELETE` | Unfavorite a book |

* Book Catalog
    * (Read/GET) Query all books available in the DB
        ```swift
         let query = PFQuery(className:"Books")
         query.findObjectsInBackground { (books: [PFObject]?, error: Error?) in
            if let error = error { 
               print(error.localizedDescription)
            } else if let books = books {
               print("Successfully retrieved \(books.count) books.")
           // TODO: Do something with posts...
            }
         }
         ```
    * (Create/POST) Create a new review for a book
        ```swift
        let query = PFQuery(className:"Book")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (book: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let book = book {
                book["reviews"].append("This book is awesome")
                book.saveInBackground()
            }
        }
        ```
    * (Create/POST) Checkout a book
        ```swift
        let query = PFQuery(className:"User")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                user["checkouts"].append("Lord of the Flies")
                book.saveInBackground()
            }
        }
        ```
    * (Create/POST) Favorite a book
        ```swift
        let query = PFQuery(className:"User")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                user["favorites"].append("The Great Gatsby")
                book.saveInBackground()
            }
        }
        ```
    * (Delete) Unfavorite a book  
        ```swift
        let query = PFQuery(className:"User")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                if let index = user["favorites"].firstIndex(of: "Lord of the Flies")                 {
                    user["favorites"].remove(at: index)
                }
                book.saveInBackground()
            }
        }
        ```
* Favorite Books
    * (Read/GET) Query all favorited books of logged in user
    * (Delete) Unfavorite a book
        ```swift
        let query = PFQuery(className:"User")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                if let index = user["favorites"].firstIndex(of: "Lord of the Flies")                 {
                    user["favorites"].remove(at: index)
                }
                book.saveInBackground()
            }
        }
        ```
    * (Create/POST) Create a new review for a book
        ```swift
        let query = PFQuery(className:"Book")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (book: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let book = book {
                book["reviews"].append("This book is awesome")
                book.saveInBackground()
            }
        }
        ```
* My Books 
    * (Read/GET) Query all checkedout books of logged in user
    * (Delete) Return book
        ```swift
        let query = PFQuery(className:"User")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (user: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                if let index = user["checkouts"].firstIndex(of: "Lord of the Flies")                 {
                    user["checkouts"].remove(at: index)
                }
                book.saveInBackground()
            }
        }
        ```
    * (Create/POST) Create a new review for a book
        ```swift
        let query = PFQuery(className:"Book")
        query.getObjectInBackground(withId: "xWMyZEGZ") { (book: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else if let book = book {
                book["reviews"].append("This book is awesome")
                book.saveInBackground()
            }
        }
        ```
