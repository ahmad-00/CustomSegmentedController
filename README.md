# CustomSegmentedController
Custom segmented container view controller which holds view controllers as children

# Usage
Just call class's initializer and push to it

# Usage Example
```swift
let vc = CustomSegmentedController(title: "Main Title", backColor: UIColor.red, tabsTitle: ["First Tab title", "Second Tab title"], controllers: [FirstViewController(), SecondViewController()], selectedTab:"Index of defaulf selected controller")
navigationController?.pushViewController(vc, animated: true)
```
you can add as many viewcontrollers as you want and it will work fine. Just remember number of items in tabsTitle array and number of items in controllers must be equal.
