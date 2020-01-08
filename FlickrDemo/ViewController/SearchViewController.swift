//
//  FirstViewController.swift
//  FlickrDemo
//
//  Created by Wei Shih Chi on 2020/1/8.
//  Copyright © 2020 Jetshin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UITextFieldDelegate {
    
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    @IBOutlet weak var searchContentTextField: UITextField!
    @IBOutlet weak var searchPageNumberTextField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil);
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard));
        self.view.addGestureRecognizer(tapRecognizer);
        
        searchBtn.backgroundColor = UIColor.lightGray
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        
        if !searchContentTextField.text!.isEmpty && !searchPageNumberTextField.text!.isEmpty {
            searchBtn.backgroundColor = UIColor.link;
            searchBtn.isEnabled = true
        }
        else {
            searchBtn.backgroundColor = UIColor.lightGray
            searchBtn.isEnabled = false
        }
        return true;
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if !searchContentTextField.text!.isEmpty && !searchPageNumberTextField.text!.isEmpty {
            searchBtn.backgroundColor = UIColor.link;
            searchBtn.isEnabled = true
        }
        else {
            searchBtn.backgroundColor = UIColor.lightGray
            searchBtn.isEnabled = false
        }
        return true;
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !searchContentTextField.text!.isEmpty && !searchPageNumberTextField.text!.isEmpty {
            searchBtn.backgroundColor = UIColor.link;
            searchBtn.isEnabled = true
        }
        else {
            searchBtn.backgroundColor = UIColor.lightGray
            searchBtn.isEnabled = false
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    
    @IBAction func searchClick(_ sender: UIButton) {
        self.searchContentTextField.resignFirstResponder()
        self.searchPageNumberTextField.resignFirstResponder()
        performSegue(withIdentifier: "showResult", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResult" {
            let destination = segue.destination as! SearchResultViewController
            destination.searchContent = searchContentTextField.text!
            destination.searchNumberofPage = searchPageNumberTextField.text!
        }
    }
    @objc func keyboard(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIView.AnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                                       delay: TimeInterval(0),
                                       options: animationCurve,
                                       animations: { self.view.layoutIfNeeded() },
                                       completion: nil)
        }
    }
    @objc func dismissKeyboard() {
        self.searchContentTextField.resignFirstResponder();
        self.searchPageNumberTextField.resignFirstResponder();
    }
}

