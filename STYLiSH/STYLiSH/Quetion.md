## Question

**Pass Data**

1. How does we pass data from cell to view controller? Please decribe the whole porcess step by step.
    
    A: 在 cell 中設置 protocol 與 一個 delegate (變數) ，
        讓 VC 繼承 cell 的 protocol，並將自己 (self) assign to cell.delegate，
        因 VC 繼承 protocol，所以 VC 會做 protocol 指定的事情 (function in protocol)，
        VC 可以透過這些 function 拿到 cell 的資料，並對資料做任何它想做的事

2. When did you trigger the action for pass data? For what reason you design the process like this?
    
    A: 在 textFieldDidEndEditing 的 function 中，可以拿到 user 輸入的 text，呼叫 passData ( )，讓 didChangeUserData 的 function 可以拿到 user 輸入的資料

**UITableView**

1. The section header usually sticked on the top of the table view when the section contents are visible. How do we make the header do not stick on the top of the screen even if the section contents are still visible.

    A: 在 storyboard 中把 table view 的 style 改為 groped；亦可在 code 中新增此行：
        let tableView = UITableView ( frame: .zero, style: .grouped ) 

2. UITableView has a default seperated line below each cell, how do we remove it?
    
    A: 在 storyboard 中把 seperator 改為 none.

3. If the auto layout inside the cell has changed, we should we do so that the iOS system will update the app's view.(信用卡與貨到付款切換的時候，cell 畫面會有變化) 

    A: call the reloadData ( ) function 
        

**UISegmentedControl**
1. How does we change UISegmentedControl's color? Which property should we modify?

    A: UISegmentedControl.tintColor 

2. Which property should we modify for controling segment count?

    A: UISegmentedControl.numberOfSegments

3. If we want to trigger an action when user tap the segmented control element, which control event should we choose?

    A: UISegmentedControl.selectedSegmentIndex

**UITextField**
1. How do we change the text inset of UITextField?

    A: UITextField.text = "...."

2. Which porperty can control the keyboard type of UITextField?

    A: UITextInputTraits -> keyboardType

3. How to remove the default border line for UITextField?

    A: change UITextField borderStyle into none or something custom

4. How do we make the UIPickerView as the UITextField's keyboard?

    A:  UITextField.inputView = UIPickerView

5. How do we know user finish edit on a UITextField?

    A: inherit to UITextFieldDelegate, and call the func "textFieldDidEndEditing" 

**UIPickerView**
1. How to create a picker view?

    A: let thePicker = UIPickerView ( )

2. How to set the content of a UIPickerView?

    A: inherit to UIPickerView and set the func below:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {}
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {}
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {}
