//
//  UserProfileViewController.swift
//  WodPodLab
//
//  Created by Hugo Perez on 24/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import UIKit
import PromiseKit
import SnapKit
import Eureka

class UserProfileViewController: FormViewController {
    
    fileprivate lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        
        
        return imageView
    }()

    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
     // Pasself.s the selected object to the new view controller.
    }
    */

}
