//
//  NoSQLQueryResultViewController.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.19
//

import Foundation
import UIKit
import AWSDynamoDB

class NoSQLQueryResultViewController: UITableViewController {
    
    @IBOutlet weak var queryDescriptionLabel: UILabel!
    
    var queryType: String?
    var queryDescription: String?
    var table: Table?
    var paginatedOutput: AWSDynamoDBPaginatedOutput?
    var results: [AWSDynamoDBObjectModel]?
    var loading: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        queryDescriptionLabel.text = queryDescription
        title = queryType
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let results = results, results.count > 0 {
            return results.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = results, results.count > 0 {
            return (table?.orderedAttributeKeys.count)!
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let results = results, results.count > 0 {
            return "\(section+1)"
        } else {
            return " "
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let results = results, results.count > 0 {
            showEditOptionsForIndexPath(indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if results?.count == 0 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "NoSQLQueryNoResultCell", for: indexPath)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoSQLQueryResultCell", for: indexPath) as! NoSQLQueryResultCell
        let model = results?[indexPath.section]
        let modelDictionary: [AnyHashable: Any] = model!.dictionaryValue
        let attributeKey = table?.tableAttributeName!(table!.orderedAttributeKeys[indexPath.row])
        cell.attributeNameLabel.text = attributeKey!
        cell.attributeValueLabel.text = "\(modelDictionary[(table?.orderedAttributeKeys[indexPath.row])!]!)"
        if (!loading) && (paginatedOutput?.lastEvaluatedKey != nil) && indexPath.section == self.results!.count - 1 {
            self.loadMoreResults()
        }
        return cell

    }
    
    // MARK: - User Action Methods
    
    func loadMoreResults() {
        loading = true
        paginatedOutput?.loadNextPage(completionHandler: {(error: Error?) in
            if error != nil {
                print("Failed to load more results: \(error)")
                DispatchQueue.main.async(execute: {
                    self.showAlertWithTitle("Error", message: "Failed to load more more results: \(error?.localizedDescription)")
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    self.results!.append(contentsOf: self.paginatedOutput!.items)
                    self.tableView.reloadData()
                    self.loading = false
                })
            }
        })
    }
    
    func showEditOptionsForIndexPath(_ indexPath: IndexPath) {
        let alartController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let updateAction: UIAlertAction = UIAlertAction(title: "Update", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.showUpdateConfirmationForIndexPath(indexPath)
        })
        let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action: UIAlertAction) -> Void in
            self.showDeleteConfirmationForIndexPath(indexPath)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alartController.addAction(updateAction)
        alartController.addAction(deleteAction)
        alartController.addAction(cancelAction)
        self.present(alartController, animated: true, completion: nil)
    }
    
    func showUpdateConfirmationForIndexPath(_ indexPath: IndexPath) {
        let alartController: UIAlertController = UIAlertController(title: nil, message: "Do you want to update your item?", preferredStyle: .actionSheet)
        let proceedAction: UIAlertAction = UIAlertAction(title: "Update", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.updateItemForIndexPath(indexPath)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alartController.addAction(proceedAction)
        alartController.addAction(cancelAction)
        self.present(alartController, animated: true, completion: { _ in })
    }
    
    func updateItemForIndexPath(_ indexPath: IndexPath) {
        let item: AWSDynamoDBObjectModel = self.results![indexPath.section]
        
        let updateItemCompletionBlock: ([AWSDynamoDBObjectModel]) -> Void = { (items: [AWSDynamoDBObjectModel]) -> Void in
            DispatchQueue.main.async(execute: {
                self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                self.results = items
                self.tableView.reloadData()
            })
        }
        
        table?.updateItem?(item, completionHandler: {(error: NSError?) -> Void in
            if let error = error { // Handle error if any
                var errorMessage = "Error Occurred: \(error.localizedDescription)"
                if (error.domain == AWSServiceErrorDomain && error.code == AWSServiceErrorType.accessDeniedException.rawValue) {
                    errorMessage = "Access denied. You are not allowed to update this item."
                }
                self.showAlertWithTitle("Error", message: errorMessage)
                return
            }
            // Handle Get
            if (self.paginatedOutput == nil) {
                updateItemCompletionBlock([item])
            } else { // Handle Query / Scan (Paginated operations)
                self.paginatedOutput!.reload(completionHandler: {(error: Error?) in
                    updateItemCompletionBlock(self.paginatedOutput!.items)
                })
            }
        })
    }
    
    func showDeleteConfirmationForIndexPath(_ indexPath: IndexPath) {
        let alartController: UIAlertController = UIAlertController(title: nil, message: "Do you want to delete your item?", preferredStyle: .actionSheet)
        let proceedAction: UIAlertAction = UIAlertAction(title: "Proceed", style: .destructive, handler: {(action: UIAlertAction) -> Void in
            self.removeItemForIndexPath(indexPath)
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alartController.addAction(proceedAction)
        alartController.addAction(cancelAction)
        self.present(alartController, animated: true, completion: nil)
    }
    
    func removeItemForIndexPath(_ indexPath: IndexPath) {
        table?.removeItem?(self.results![indexPath.section], completionHandler: {(error: NSError?) -> Void in
            if let error = error { // Handle error if any
                var errorMessage = "Error Occurred: \(error.localizedDescription)"
                if (error.domain == AWSServiceErrorDomain && error.code == AWSServiceErrorType.accessDeniedException.rawValue) {
                    errorMessage = "Access denied. You are not allowed to delete this item."
                }
                self.showAlertWithTitle("Error", message: errorMessage)
                return
            }
            if (self.paginatedOutput == nil) {
                DispatchQueue.main.async(execute: {
                    self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    self.results = []
                    self.tableView.reloadData()
                })
            }
            else {
                self.paginatedOutput!.reload(completionHandler: {(error: Error?) -> Void in
                    DispatchQueue.main.async(execute: {
                        self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        self.results = self.paginatedOutput!.items
                        self.tableView.reloadData()
                    })
                })
            }
        })
    }
    
    // MARK: - Utility Methods
    
    func showAlertWithTitle(_ title: String, message: String) {
        let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

class NoSQLQueryResultCell: UITableViewCell {
    
    @IBOutlet weak var attributeNameLabel: UILabel!
    @IBOutlet weak var attributeValueLabel: UILabel!
}
