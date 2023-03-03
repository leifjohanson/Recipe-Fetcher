//
//  InstructionView.swift
//  Fetch-iOS-Assessment
//
//  Created by Leif Johanson on 2/28/23.
//

import UIKit

class InstructionView: UIView {

    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var instructionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    
    private func configureView() {
        guard let view = self.loadViewFromNib(nibName: "InstructionView") else { return }
        view.frame = self.frame
        self.addSubview(view)
    }
    
    func configureView(instruction: String, stepNumber: String) {
        instructionLabel.text = instruction
        stepNumberLabel.text = stepNumber
        
        stepNumberLabel.addRightBorder(with: UIColor.init(red: 220/255, green: 220/255, blue: 220/255, alpha: 1), andWidth: 1)
    }

}
