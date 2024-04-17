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

        private val intentAction: String = "com.nector.NOTIFICATION_CLICKED"

        fun showNotification(mapData: HashMap<String, String>) {

                val activityIntent =
                                PendingIntent.getBroadcast(
                                                context,
                                                800,
                                                Intent(intentAction),
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

                notificationManager.notify(1100, notification)
        }
}
