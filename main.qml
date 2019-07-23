/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 2.0
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * ***** END LICENSE BLOCK ***** */

/*
 * Copyright (c) 2019, Filip Brcic <brcha@yandex.com>. All rights reserved.
 *
 * This file is part of QtsApp
 */

import QtQuick 2.13
import QtQuick.Window 2.13
import Qt.labs.platform 1.1
import QtWebEngine 1.9

Window {
    id: window
    visible: true
    width: 1000
    height: 600
    title: qsTr("QtsApp")

    property bool hasNotifications: false

    SystemTrayIcon {
        id: sysTray
        visible: true
        icon.source: window.hasNotifications?'qrc:/whatsapp_neon_96.png':'qrc:/whatsapp_gray_100.png'

        onActivated: {
            window.hasNotifications = false
            window.show()
            window.raise()
            window.requestActivate()
        }

        onMessageClicked: {
            window.hasNotifications = false
            window.show()
            window.raise()
        }

        menu: Menu {
            MenuItem {
                text: qsTr("Quit")
                onTriggered: Qt.quit()
            }
        }
    }

    WebEngineView {
        anchors.fill: parent
        url: 'https://web.whatsapp.com'
        profile: WebEngineProfile {
            // Mimic Chrome because WhatsApp filters by useragent on server-side
            httpUserAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'
            offTheRecord: false
            storageName: 'QtsApp'

            onPresentNotification: {
                if (!window.active)
                    hasNotifications = true
                sysTray.showMessage("Notification", notification)
            }

            onDownloadRequested: download.accept()
        }

        onFeaturePermissionRequested: {
            if (feature === WebEngineView.Notifications)
                grantFeaturePermission(securityOrigin, feature, true)
            else
                grantFeaturePermission(securityOrigin, feature, false)
        }
    }

    onClosing: {
        hide()
        close.accepted = false
    }
}
