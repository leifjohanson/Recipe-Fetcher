//
//  IngredientView.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/28/23.
//

import UIKit

class IngredientView: UIView {

    @IBOutlet weak var ingredientLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var ingredientLabelContainerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "IngredientView") else { return }
        view.frame = self.frame
        self.addSubview(view)
    }
    
    func configureView(ingredient: String, quantity: String) {
        self.ingredientLabel.text = ingredient
        self.quantityLabel.text = quantity
        
        ingredientLabelContainerView.addRightBorder(with: UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1), andWidth: 1)
    }

}

extension UIView {
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func addLeftBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: frame.size.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        addSubview(border)
    }
    
    func addRightBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        border.frame = CGRect(x: frame.size.width - borderWidth, y: 0, width: borderWidth, height: frame.size.height)
        addSubview(border)
    }
}
