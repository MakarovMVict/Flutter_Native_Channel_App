package com.example.flutter_native_channel_app

import BackGroundTasks.SimpleBackgroundNativeTask
import android.app.job.JobParameters
import android.app.job.JobService
import android.icu.util.TimeUnit
import android.os.Build
import android.util.Log

import androidx.work.PeriodicWorkRequest
import androidx.work.WorkManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.RequiresApi
import java.time.Duration


class MainActivity: FlutterActivity() {
    private val CHANNEL = "flutterNativeText"
    private val CHANNEL_BACKGROUND="flutter_background"

    private lateinit var channel:MethodChannel
    private lateinit var channel_background:MethodChannel

    var counter:Int=0
    var backgroundCounter:Int=0
    var isBackgroundKotlinStarted:Boolean=false





    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel=MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)

        channel.setMethodCallHandler { call, result ->//вызываю метод через канал flutterNativeText
            result.success(

                    getSimpleNativeText()
            )
        // Note: this method is invoked on the main thread.
        }

        //background channel TODO сделать в фоновом режиме
        channel_background = MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger,CHANNEL_BACKGROUND)
        channel_background.setMethodCallHandler{call,result ->


            result.success(
//                    if (call.method == "getSimpleNativeTextPeriodic") {
//                        getSimpleNativeTextPeriodic()
//                    } else if (call.method == "startOrStopBackground") {
//                        startOrStopBackground()
//                    } else {
//                        Log.d("android", "**configureFlutterEngine: undefined ${call.method}")
//                    }
                    WorkManager.getInstance().enqueue(createWorkRequest)
            )

        }
    }





    private  fun getSimpleNativeText():String {//вызывает метод в flutter getText
       // var counter:Int=0
        counter+=2

        print("**kotlin text is $counter")

        channel.invokeMethod("getText", listOf("a", "b"), object : MethodChannel.Result {
            override fun success(result: Any?) {
                Log.d("Android", "**result = $result")

            }
            override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                Log.d("Android", "**$errorCode, $errorMessage, $errorDetails")
            }
            override fun notImplemented() {
                Log.d("Android", "**notImplemented")
            }
        })
        return "**native text ${counter}";
    }

    private  fun getSimpleNativeTextPeriodic():String {
        // var counter:Int=0
        //counter+=2
        backgroundCounter++

        print("**periodic_string_background text is $counter")

        channel_background.invokeMethod("periodic_string_background", backgroundCounter, object : MethodChannel.Result {
            override fun success(result: Any?) {
                Log.d("Android", "**PERIODIC result background = $backgroundCounter")

            }
            override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                Log.d("Android", "**PERIODIC $errorCode, $errorMessage, $errorDetails")
            }
            override fun notImplemented() {
                Log.d("Android", "**PERIODIC notImplemented")
            }
        })
        return "**native text ${counter}";

    }

    /**для работы с фоновыми службами на котлине**/


    @RequiresApi(Build.VERSION_CODES.N)
    var createWorkRequest:PeriodicWorkRequest = PeriodicWorkRequest.Builder(
            SimpleBackgroundNativeTask::class.java,
            4,
             java.util.concurrent.TimeUnit.SECONDS
    )
            .addTag("SimpleBackgroundNativeTask")
       //     .setInputData(data)
            .build()

     fun startOrStopBackground(){
        //var task:SimpleBackgroundNativeTask = SimpleBackgroundNativeTask(0,this);
         //TODO запусить/остановить фоновый процесс
         if(isBackgroundKotlinStarted){
             Log.d("Android", "**Background stopped! ")
             isBackgroundKotlinStarted=false
             WorkManager.getInstance().cancelAllWorkByTag("SimpleBackgroundNativeTask")
//             channel_background.invokeMethod("stopBackgroundAndShow", object : MethodChannel.Result {
//                 override fun success(result: Any?) {
//                     Log.d("Android", "**PERIODIC KOTLIN result background = $backgroundCounter")
//
//                 }
//                 override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
//                     Log.d("Android", "**PERIODIC $errorCode, $errorMessage, $errorDetails")
//                 }
//                 override fun notImplemented() {
//                     Log.d("Android", "**PERIODIC notImplemented")
//                 }
//             })
             Log.d("android", "**startOrStopBackground: SimpleBackgroundNativeTask stopped")


         }else{
             Log.d("Android", "**Background started! ")

             //запустить фоновый процесс
             isBackgroundKotlinStarted=true
            // WorkManager.getInstance().enqueue(createWorkRequest)
         }
     }




//    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
//    private fun startMyService() {
//      //  val builder = JobInfo.Builder(jobID, ComponentName(context, Myjob.service))
//    }

}

/**
 * для фонового режима
 */
//@RequiresApi(Build.VERSION_CODES.LOLLIPOP)
//class MyJob : JobService() {
//    override fun onStartJob(jobParameters: JobParameters?): Boolean {
//
//      println("**started job!")
//      return true
//    }
//    override fun onStopJob(jobParameters: JobParameters?): Boolean {
//        println("**stopped job!")
//
//        return true
//    }
//    //var builder = JobInfo.Builder(jobID, ComponentName(context, Myjob.service))
//
//}


