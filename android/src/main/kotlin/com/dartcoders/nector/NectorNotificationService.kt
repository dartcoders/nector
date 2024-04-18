import android.R
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat
import java.util.*

class NectorNotificationService(private val context: Context) {

        private val notificationManager =
                        context.getSystemService(Context.NOTIFICATION_SERVICE) as
                                        NotificationManager

        fun showNotification(mapData: HashMap<String, String>): Boolean {
                val launchIntent = getLaunchIntent()
                launchIntent?.setAction(Constants.NOTIFICATION_CLICK_ACTION)
                val activityIntent =
                                PendingIntent.getActivity(
                                                context,
                                                1,
                                                launchIntent,
                                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                                                                PendingIntent.FLAG_IMMUTABLE
                                                else 0
                                )
                val notification =
                                NotificationCompat.Builder(
                                                                context,
                                                                Constants.NOTIFICATION_CHANNEL_ID
                                                )
                                                .setContentTitle(mapData["title"])
                                                .setContentText(mapData["description"])
                                                .setSmallIcon(R.drawable.arrow_up_float)
                                                .setAutoCancel(true)
                                                .setContentIntent(activityIntent)
                                                .build()

                notificationManager.notify(1100, notification)
                return true
        }

        private fun getLaunchIntent(): Intent? {
                val packageName = context.packageName
                val packageManager = context.packageManager
                return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.CUPCAKE) {
                        packageManager.getLaunchIntentForPackage(packageName)
                } else {
                        TODO("VERSION.SDK_INT < CUPCAKE")
                }
        }
}
