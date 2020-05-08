//
//  NewsDetailsViewController.swift
//  NyNews
//
//  Created by APPLE on 06/05/20.
//  Copyright © 2020 Isha Ramdasi. All rights reserved.
//

import UIKit
import WebKit

class NewsDetailsViewController: UIViewController {
    
    @IBOutlet weak var favouriteButton: UIButton!
    var viewModel : NewsDetailsViewModel {
        didSet {
            fileName = self.viewModel.getNewsDetails().url ?? ""
        }
    }
    fileprivate var webView: WKWebView
    var fileName: String = ""
    
    // MARK: - life cycle
    
    init(viewModel: NewsDetailsViewModel) {
        webView = WKWebView()
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        webView.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileName = self.viewModel.getNewsDetails().url ?? ""
        viewConfigurations()
        setFavouriteBtnImage(favouriteButton)
        // Do any additional setup after loading the view.
    }
    
    //MARK - Helper methods
    /*
     Load url in webview
     */
    
    fileprivate func viewConfigurations() {
        //These are the changes for UnderTopBars & UnderBottomBars
        edgesForExtendedLayout = []
        extendedLayoutIncludesOpaqueBars = false
        
        // Remove all cache
        URLCache.shared.removeAllCachedResponses()

        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        webView = WKWebView(frame: self.view.bounds)
        webView.navigationDelegate = self
        
        let urlWeb:URL?
        urlWeb = URL(string: fileName)
        if urlWeb?.absoluteURL == nil {
             webView.load(URLRequest(url: URL(string: URL(string: fileName.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) ?? fileName)!.absoluteString)!))
        } else {
            webView.load(URLRequest(url: (urlWeb?.absoluteURL)!))
        }
               
        self.view.addSubview(webView)
        self.view.sendSubviewToBack(webView)
        
    }
    
    /*
     Mark a news as favourite or remove a favourite one from the list
     */
    @IBAction func makeFavourite(_ sender: UIButton) {
        if sender.isSelected {
            //make unfavourite
            sender.setImage(UIImage(named: "notFavourite"), for: .normal)
            viewModel.handleFavouriteButtonAction(choice: false)
        } else {
            //make favourite
            sender.setImage(UIImage(named: "favourite"), for: .normal)
            viewModel.handleFavouriteButtonAction(choice: true)
        }
        sender.isSelected = !sender.isSelected
    }
    
    /*
     Set button image as per user selection
     */
    private func setFavouriteBtnImage(_ sender: UIButton) {
        if !viewModel.getNewsDetails().favourite {
            //make unfavourite
            sender.setImage(UIImage(named: "notFavourite"), for: .normal)
        } else {
            //make favourite
            sender.setImage(UIImage(named: "favourite"), for: .normal)
        }
    }
}

//MARK - Web View delegates
extension NewsDetailsViewController: WKNavigationDelegate {
    //MARK: WebView Delegates
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            
            let url = navigationAction.request.url
            let shared = UIApplication.shared
            
            if shared.canOpenURL(url!) {
                shared.open(url!, options: [:], completionHandler: nil)
            }
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        }
        
        decisionHandler(WKNavigationActionPolicy.allow)
    }
}
