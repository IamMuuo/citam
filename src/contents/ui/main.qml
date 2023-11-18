// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ApplicationWindow {
    id: root
    title: i18nc("@title:window", "CITAM")
    pageStack.initialPage:  Qt.resolvedUrl("ClassManagementPage.qml")
}
