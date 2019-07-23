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

    SystemTrayIcon {
        id: sysTray
        visible: true
        icon.source: 'qrc:/whatsapp_gray_100.png'

        onActivated: {
            window.show()
            window.raise()
            window.requestActivate()
        }
    }

    WebEngineView {
        anchors.fill: parent
        url: 'https://web.whatsapp.com'
        profile: WebEngineProfile {
            id: whatsappNotifications
            // Mimic Chrome because WhatsApp filters by useragent on server-side
            httpUserAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36'

            onPresentNotification: sysTray.showMessage("Notification", notification);
        }

        onFeaturePermissionRequested: featurePermissionReqHandler(securityOrigin, feature)

        function featurePermissionReqHandler(securityOrigin, feature) {
            if (feature === WebEngineView.Notifications)
                grantFeaturePermission(securityOrigin, feature, true);
            else
                grantFeaturePermission(securityOrigin, feature, false);
        }
    }
}
