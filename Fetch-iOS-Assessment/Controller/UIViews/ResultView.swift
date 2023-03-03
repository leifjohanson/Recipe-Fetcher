//
//  ResultView.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 3/1/23.
//

import UIKit

class ResultView: UIView {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeIDLabel: UILabel!
    
    var tap = UITapGestureRecognizer()
    var id = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "ResultView") else { return }
        view.frame = self.frame
        self.addSubview(view)
    }
    
    func configureView(recipeImage: UIImage, recipeTitle: String, recipeID: String) {
        recipeImageView.layer.cornerRadius = 10
        
        recipeImageView.image = recipeImage
        recipeIDLabel.text = "ID: \(recipeID)"
        recipeTitleLabel.text = recipeTitle
        
        id = recipeID
    }

}
