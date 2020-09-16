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
import Beagle
import BeagleSchema

class NativeViewController: UIViewController {

    private lazy var firstLabel = makeLabel(text: "I'm a native UILabel")
    
//    private lazy var beagleView = BeagleView(Container(
//        widgetProperties: .init(style: Style()
//            .backgroundColor(grayColor)
//            .margin(.init(all: 20))
//            .padding(.init(all: 10))
//        )
//    ) {
//        Text(
//            "These buttons are rendered by Beagle",
//            widgetProperties: .init(style: .init(
//                margin: .init(bottom: 10),
//                flex: Flex().alignSelf(.center)
//            ))
//        )
//        Button(
//            text: "I'm a server-driven button",
//            onPress: [Alert(title: "Server-driven button", message: "I'm a server-driven button")]
//        )
//        Button(
//            text: "Navigate to Navigator",
//            onPress: [Navigate.openNativeRoute(.init(route: .navigateStep1Endpoint))]
//        )
//    })
    
    private lazy var beagleView = BeagleView(Container(widgetProperties: WidgetProperties(id: "container", style: Style(flex: Flex().flexWrap(.wrap)))) {
        Text("Yoga", widgetProperties: .init(Flex().shrink(0)))
        Button(
            text: "ADD",
            onPress: [AddChildren(componentId: "container", value: [AutoLayoutComponent()])]
        )
    })

    private lazy var secondLabel = makeLabel(text: "Another native UILabel after Beagle")

    private func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        label.backgroundColor = UIColor(hex: grayColor)
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(firstLabel)
        firstLabel.anchorCenterXToSuperview()
        firstLabel.anchor(
            top: topLayoutGuide.bottomAnchor,
            topConstant: 50
        )
        
        view.addSubview(beagleView)
//        beagleView.anchor(
//            top: firstLabel.bottomAnchor,
//            left: view.leftAnchor,
//            right: view.rightAnchor,
//            topConstant: 30,
//            leftConstant: 20,
//            rightConstant: 20
//        )
        
        let margin = view.layoutMarginsGuide
        beagleView.translatesAutoresizingMaskIntoConstraints = false
        beagleView.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: 50).isActive = true
        beagleView.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        beagleView.trailingAnchor.constraint(lessThanOrEqualTo: margin.trailingAnchor).isActive = true
                
        //        beagleView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        //        beagleView.heightAnchor.constraint(equalToConstant: 200).isActive = true
                
        beagleView.bottomAnchor.constraint(lessThanOrEqualTo: margin.bottomAnchor, constant: -50).isActive = true
                

        // TODO: make this second label work to allow using BeagleView inside AutoLayout
//        view.addSubview(secondLabel)
//        secondLabel.anchorCenterXToSuperview()
//        secondLabel.anchor(top: beagleView.bottomAnchor, topConstant: 30)
    }

    private let grayColor = "#EEEEEE"
}

class YogaSample: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        clipsToBounds = true
        
        yoga.isEnabled = true
        yoga.flexWrap = .wrap
        yoga.flexShrink = 1
        yoga.margin = 10
        yoga.padding = 10
        
        let label = UILabel()
        label.text = "YOGA"
        label.yoga.isEnabled = true
        label.yoga.marginBottom = 5
        addSubview(label)
        
        let button = UIButton(type: .system)
        button.setTitle("ADD", for: .normal)
        button.yoga.isEnabled = true
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        addSubview(button)
        
        let view3 = AutoLayoutWrapper(view: AutoLayoutSample())
        addSubview(view3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func add() {
//        let view = AutoLayoutWrapper(view: AutoLayoutSample())
//        addSubview(view)
        
        let view = UIView()
        view.backgroundColor = .cyan
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.yoga.isEnabled = true
        view.yoga.width = 100
        view.yoga.height = 100
        view.yoga.flexShrink = 1
        addSubview(view)
        
        markDirty()
    }
}

class AutoLayoutSample: UIView {
    let constraintView: UIView
    let heightConstraint: NSLayoutConstraint
    
    override init(frame: CGRect) {
        let view = UIView()
        self.constraintView = view
        self.heightConstraint = view.heightAnchor.constraint(equalToConstant: 100)
        super.init(frame: frame)
        
        backgroundColor = .yellow
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
        
        view.backgroundColor = .cyan
        addSubview(view)
        
        translatesAutoresizingMaskIntoConstraints = false
    
        let label = UILabel()
        label.text = "AUTO"
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        view.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5).isActive = true
        view.widthAnchor.constraint(equalToConstant: 50).isActive = true
        heightConstraint.isActive = true
        
        let button = UIButton(type: .system)
        button.setTitle("shrink", for: .normal)
        button.addTarget(self, action: #selector(shrink), for: .touchUpInside)
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        button.topAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func shrink() {
        UIView.animate(withDuration: 0.7) {
            self.heightConstraint.constant = 50
            self.superview?.markDirty() // we need to call on YogaWrapper
            self.rootLayoutIfNeeded()
        }
        
    }
}

// to be used inside a view with yoga
class AutoLayoutWrapper: UIView {
    let view: UIView
    
    init(view: UIView) {
        self.view = view
        super.init(frame: .zero)
        clipsToBounds = true
        
//        yoga.isEnabled = true
//        yoga.flexShrink = 1
        
        addSubview(view)
        
        view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        let botton = view.bottomAnchor.constraint(equalTo: bottomAnchor)
        botton.priority = .init(rawValue: 999)
        botton.isActive = true
        let leading = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        leading.priority = .init(rawValue: 999)
        leading.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        systemLayoutSizeFitting(size)
    }
    
}

struct AutoLayoutComponent: Widget {
    var widgetProperties: WidgetProperties = WidgetProperties()
    
    func toView(renderer: BeagleRenderer) -> UIView {
        return AutoLayoutWrapper(view: AutoLayoutSample())
    }
}

struct YogaComponent: ServerDrivenComponent {
    func toView(renderer: BeagleRenderer) -> UIView {
        return YogaSample()
    }
}

private extension UIView {
    func markDirty() {
        yoga.markDirty()
        var view: UIView? = self
        while let currentView = view {
            if !currentView.yoga.isEnabled {
                currentView.superview?.invalidateIntrinsicContentSize()
                currentView.setNeedsLayout()
                break
            }
            view = view?.superview
        }
    }
    
    func rootLayoutIfNeeded() { // for animations
        var view: UIView? = self
        while view?.superview != nil {
            view = view?.superview
        }
        view?.layoutIfNeeded()
    }
}
