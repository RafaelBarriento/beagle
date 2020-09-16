/*
 * Copyright 2020 ZUP IT SERVICOS EM TECNOLOGIA E INOVACAO SA
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import UIKit
import BeagleSchema

/// Use this View when you need to add a Beagle component inside a native screen that have other UIViews and uses AutoLayout
public class BeagleView: UIView {
    
    // MARK: - Private Attributes
    
    private var beagleController: BeagleScreenViewController
    
    private var alreadyCalculateIntrinsicSize = true
    
    // MARK: - Initialization
    
    public convenience init(_ component: RawComponent) {
        self.init(.declarative(component.toScreen()))
    }
    
    public convenience init(_ screenType: ScreenType) {
        self.init(viewModel: .init(screenType: screenType))
    }
    
    required init(viewModel: BeagleScreenViewModel) {
        let controller = BeagleScreenViewController(viewModel: viewModel)
        self.beagleController = controller
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func didMoveToWindow() {
        guard let parentViewController = parentViewController else { return }
        parentViewController.addChild(beagleController)
        setupView()
        beagleController.didMove(toParent: parentViewController)
    }
    
    // MARK: - Private Functions

    private func setupView() {
        guard let beagleView = beagleController.view else {
            return
        }
        clipsToBounds = true
        addSubview(beagleView)
        beagleView.anchorTo(superview: self)
        invalidateIntrinsicContentSize()
    }
    
    public override var intrinsicContentSize: CGSize {
//        return CGSize(width: 200, height: 200)
        if case .view(let screenView) = beagleController.content, let content = screenView.subviews[safe: 0] {
            var size = CGSize(width: Double.nan, height: .nan)
            if !alreadyCalculateIntrinsicSize {
                alreadyCalculateIntrinsicSize = true
                switch content.yoga.flexDirection {
                case .column, .columnReverse:
                    size.height = frame.size.height
                case .row, .rowReverse:
                    size.width = frame.size.width
                default:
                    break
                }
            }
            return screenView.yoga.calculateLayout(with: size)
        }

        return super.intrinsicContentSize
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if case .view(let screenView) = beagleController.content {
            screenView.frame = bounds
            screenView.yoga.applyLayout(preservingOrigin: true)
            invalidateIntrinsicContentSize() // we need to calculate intrinsecSize a second time
            alreadyCalculateIntrinsicSize = false
        }
    }
}

private extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
