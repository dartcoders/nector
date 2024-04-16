import android.R
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.core.app.NotificationCompat

class NectorNotificationService(private val context: Context) {

        private val notificationManager =
                        context.getSystemService(Context.NOTIFICATION_SERVICE) as
                                        NotificationManager

        fun showNotification(mapData: HashMap<String, String>) {

                Int

                val activityIntent =
                                PendingIntent.getBroadcast(
                                                context,
                                                3,
                                                Intent("com.nector.NOTIFICATION_CLICKED"),
                                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                                                                PendingIntent.FLAG_IMMUTABLE
                                                else 0
                                )

                val notification =
                                NotificationCompat.Builder(context, "Nector")
                                                .setContentTitle(mapData["title"])
                                                .setContentText(mapData["description"])
                                                .setSmallIcon(R.drawable.arrow_up_float)
                                                .setContentIntent(activityIntent)
                                                .build()

                notificationManager.notify(1, notification)
        }
}
