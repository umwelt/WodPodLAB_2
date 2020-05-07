//
//  CustomPushRow.swift
//  WodPodLab
//
//  Created by Hugo Perez on 27/04/2020.
//  Copyright © 2020 WodPod. All rights reserved.
//

import Eureka
import UIKit
import SwiftyJSON

final class WodPresenterRow: PresenterRow<PushSelectorCell<String>, WodDetailViewController>, RowType {

}

final class MovementPresenterRow: PresenterRow<MovsCell, SearchMovementsTableViewController>, RowType {
    
    public var activeSet: Sets = Sets(JSON.null)
    public var searchString: String = ""

}

open class PresenterRow<Cell: CellType, VCType: TypedRowControllerType>: OptionsRow<Cell>, PresenterRowType where Cell: BaseCell, VCType: UIViewController, VCType.RowValue == Cell.Value {

    public var presentationMode: PresentationMode<VCType>?
    public var onPresentCallback: ((FormViewController, VCType) -> Void)?
    public typealias PresentedControllerType = VCType
    
    

    required public init(tag: String?) {
        super.init(tag: tag)
    }
    open override func customDidSelect() {
        super.customDidSelect()
        guard let presentationMode = presentationMode, !isDisabled else { return }
        if let controller = presentationMode.makeController() {
            controller.row = self
            controller.title = selectorTitle ?? controller.title
            onPresentCallback?(cell.formViewController()!, controller)
            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
        } else {
            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
        }
    }
}
