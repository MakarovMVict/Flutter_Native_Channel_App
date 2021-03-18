package com.example.flutter_native_channel_app

import io.flutter.app.FlutterApplication

import io.flutter.plugins.GeneratedPluginRegistrant
//import be.tramckrijte.workmanager.WorkmanagerPlugin

class App: FlutterApplication(), io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
      //  WorkmanagerPlugin.setPluginRegistrantCallback(this)

    }

    override fun registerWith(registry: io.flutter.plugin.common.PluginRegistry?) {
        //GeneratedPluginRegistrant.registerWith(registry)
    }


}