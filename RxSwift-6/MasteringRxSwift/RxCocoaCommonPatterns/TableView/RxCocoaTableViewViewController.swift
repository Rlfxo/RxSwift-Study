//
//  Mastering RxSwift
//  Copyright (c) KxCoding <help@kxcoding.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//


import UIKit
import RxSwift
import RxCocoa


class RxCocoaTableViewViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let priceFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = NumberFormatter.Style.currency
        f.locale = Locale(identifier: "Ko_kr")
        
        return f
    }()
    
    let bag = DisposeBag()
    
    let nameObservable = Observable.of(appleProducts.map { $0.name })
    let productObservable = Observable.of(appleProducts)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameObservable.bind(to: listTableView.rx.items) {
            tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
            cell.textLabel?.text = element
            return cell
        }
        .disposed(by: bag)
        
        Observable.zip(listTableView.rx.modelSelected(Product.self),listTableView.rx.itemSelected)
            .bind{[weak self] (product, indexPath) in
                self?.listTableView.deselectRow(at: indexPath, animated: true)
                print(product.name)
            }
            .disposed(by: bag)
    }
}




