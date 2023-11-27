package com.example.keygourd

import android.annotation.SuppressLint
import android.content.Context
import android.net.Uri
import android.os.Build
import android.view.View
import android.webkit.JavascriptInterface
import android.webkit.WebResourceRequest
import android.webkit.WebResourceResponse
import android.webkit.WebView
import android.webkit.WebViewClient
import android.widget.FrameLayout
import androidx.annotation.RequiresApi
import androidx.webkit.WebViewAssetLoader
import com.google.gson.Gson
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
    private var webView: WebView? = null
    var handlers: MutableMap<String, MethodChannel.Result> = mutableMapOf()
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        if (webView == null) {
            setupView()
        }
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "app.keygourd/bridge"
        ).setMethodCallHandler { call, result ->
            val id = call.argument<String?>("id")
            if (id == null) {
                result.error(
                    "UNAVAILABLE",
                    "Identifier for the flutter platform call not found",
                    null
                )
                return@setMethodCallHandler
            }
            handlers[id] = result
            when (call.method) {
                "getChainProps" -> {
                    webView?.evaluateJavascript(
                        "getChainProps('$id');",
                        null
                    )
                }
                "getFeed" -> {
                    val feedType = call.argument<String?>("feed_type") ?: "trending"
                    webView?.evaluateJavascript(
                        "getFeed('$id', '$feedType');",
                        null
                    )
                }
                "validatePostingKey" -> {
                    val postingKey = call.argument<String?>("postingKey")
                    val accountName = call.argument<String?>("accountName")
                    if (postingKey == null || accountName == null) {
                        result.error(
                            "UNAVAILABLE",
                            "postingKey or accountName not supplied",
                            null
                        )
                        return@setMethodCallHandler
                    }
                    webView?.evaluateJavascript(
                        "validatePostingKey('$id', '$accountName', '$postingKey');",
                        null
                    )
                }
                "validateActiveKey" -> {
                    val activeKey = call.argument<String?>("activeKey")
                    val accountName = call.argument<String?>("accountName")
                    if (activeKey == null || accountName == null) {
                        result.error(
                            "UNAVAILABLE",
                            "activeKey or accountName not supplied",
                            null
                        )
                        return@setMethodCallHandler
                    }
                    webView?.evaluateJavascript(
                        "validateActiveKey('$id', '$accountName', '$activeKey');",
                        null
                    )
                }
                "validateMemoKey" -> {
                    val memoKey = call.argument<String?>("memoKey")
                    val accountName = call.argument<String?>("accountName")
                    if (memoKey == null || accountName == null) {
                        result.error(
                            "UNAVAILABLE",
                            "memoKey or accountName not supplied",
                            null
                        )
                        return@setMethodCallHandler
                    }
                    webView?.evaluateJavascript(
                        "validateMemoKey('$id', '$accountName', '$memoKey');",
                        null
                    )
                }
                else -> {
                    result.error(
                        "UNAVAILABLE",
                        "Identifier for the flutter platform call not found",
                        null
                    )
                }
            }
        }
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupView() {
        val params = FrameLayout.LayoutParams(0, 0)
        webView = WebView(this)
        val decorView = this.window.decorView as FrameLayout
        decorView.addView(webView, params)
        webView?.visibility = View.GONE
        webView?.settings?.javaScriptEnabled = true
        webView?.settings?.domStorageEnabled = true
//        webView?.webChromeClient = WebChromeClient()
        WebView.setWebContentsDebuggingEnabled(true)
        val assetLoader = WebViewAssetLoader.Builder()
            .addPathHandler("/assets/", WebViewAssetLoader.AssetsPathHandler(this))
            .build()
        val client: WebViewClient = object : WebViewClient() {
            override fun shouldInterceptRequest(
                view: WebView,
                request: WebResourceRequest
            ): WebResourceResponse? {
                return assetLoader.shouldInterceptRequest(request.url)
            }

            override fun shouldInterceptRequest(
                view: WebView,
                url: String
            ): WebResourceResponse? {
                return assetLoader.shouldInterceptRequest(Uri.parse(url))
            }
        }
        webView?.webViewClient = client
        webView?.addJavascriptInterface(WebAppInterface(this), "Android")
        webView?.loadUrl("https://appassets.androidplatform.net/assets/index.html")
    }
}

class WebAppInterface(private val mContext: Context) {
    @JavascriptInterface
    fun postMessage(id: String, type: String, data: String, valid: Boolean, error: String) {
        val main = mContext as? MainActivity ?: return
        if (valid && error.isEmpty()) {
            main.handlers[id]?.success(data)
        } else {
            val gson = Gson()
            val eventData = JSEvent(type, error, "", id)
            val jsonText = gson.toJson(eventData)
            main.handlers[id]?.success(jsonText ?: "")
        }
        main.handlers.remove(id)
    }
}

data class JSEvent(
    val type: String,
    val error: String,
    val data: String,
    var id: String,
)