import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

class NectorNotificationReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent?) {
        Log.e("yoyoyoyoyo", "============================> here")
        // NectorMethodChannel.onClickNotification()

    }
}
