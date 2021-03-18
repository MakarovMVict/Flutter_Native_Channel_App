package BackGroundTasks

import android.content.Context
import android.icu.util.TimeUnit
import android.util.Log
import androidx.work.*
import kotlin.Exception

class SimpleBackgroundNativeTask(counter:Int,context: Context,workerParams: WorkerParameters):
        Worker(context, workerParams) {

    var stringToReturn="**PERIODIC_KOTLIN return data is $counter"
    var counter:Int=counter

    override fun doWork(): Result {

        try{
        counter++

        Log.d("android", "**doWork: background android counter is $counter ")
        return Result.success()
        }catch (e:Exception){
            Log.d("android", "**doWork:EXCEPTION ${e.toString()} ")
            return Result.failure()
        }

    }





}