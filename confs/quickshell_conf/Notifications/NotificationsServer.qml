pragma Singleton
import Quickshell.Services.Notifications

NotificationServer {
    id: root

    keepOnReload: true
    bodySupported: true
    bodyMarkupSupported: true
    actionsSupported: true
    imageSupported: true

    onNotification: (notification) => {
        notification.tracked = true;
    }
}
