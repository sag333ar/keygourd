//
//  AppBridge.swift
//  Runner
//
//  Created by Sagar on 16/10/23.
//

import UIKit
import Flutter

class AppBridge: NSObject {
    var window: UIWindow? = nil
    var webVC: WebViewController? = nil
    var controller: FlutterViewController? = nil

    func initiate(
        controller: FlutterViewController,
        window: UIWindow,
        webVC: WebViewController
    ) {
        self.window = window
        self.webVC = webVC
        self.controller = controller

        let bridgeChannel = FlutterMethodChannel(
            name: "app.keygourd/bridge",
            binaryMessenger: controller.binaryMessenger
        )

        bridgeChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard
                let arguments = call.arguments as? NSDictionary,
                let id = arguments ["id"] as? String
            else {
                debugPrint("Identifier for the flutter platform call not found")
                result(FlutterMethodNotImplemented)
                return
            }
            guard
                let webVC = self?.webVC
            else {
                debugPrint("WebView Controller is not set")
                result(FlutterMethodNotImplemented)
                return
            }
            switch (call.method) {
                case "getChainProps":
                    webVC.handlers[id] = { text in
                        result(text)
                    }
                    OperationQueue.main.addOperation {
                        webVC.webView.evaluateJavaScript("getChainProps('\(id)');")
                    }
                case "getFeed":
                    webVC.handlers[id] = { text in
                        result(text)
                    }
                    let type = arguments ["feed_type"] as? String ?? "trending"
                    OperationQueue.main.addOperation {
                        webVC.webView.evaluateJavaScript("getFeed('\(id)', '\(type)');")
                    }
                case "validatePostingKey":
                    guard 
                        let postingKey = arguments ["postingKey"] as? String,
                        let accountName = arguments ["accountName"] as? String
                    else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                    webVC.handlers[id] = { text in
                        result(text)
                    }
                    OperationQueue.main.addOperation {
                        webVC.webView.evaluateJavaScript("validatePostingKey('\(id)', '\(accountName)', '\(postingKey)');")
                    }
                case "validateActiveKey":
                    guard
                        let activeKey = arguments ["activeKey"] as? String,
                        let accountName = arguments ["accountName"] as? String
                    else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                    webVC.handlers[id] = { text in
                        result(text)
                    }
                    OperationQueue.main.addOperation {
                        webVC.webView.evaluateJavaScript("validateActiveKey('\(id)', '\(accountName)', '\(activeKey)');")
                    }
                case "validateMemoKey":
                    guard
                        let memoKey = arguments ["memoKey"] as? String,
                        let accountName = arguments ["accountName"] as? String
                    else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                    webVC.handlers[id] = { text in
                        result(text)
                    }
                    OperationQueue.main.addOperation {
                        webVC.webView.evaluateJavaScript("validateMemoKey('\(id)', '\(accountName)', '\(memoKey)');")
                    }
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
    }
}
