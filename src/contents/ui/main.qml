// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>

import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ApplicationWindow {
    id: root

    title: i18n("citam")

    minimumWidth: Kirigami.Units.gridUnit * 20
    minimumHeight: Kirigami.Units.gridUnit * 20

    onClosing: App.saveWindowGeometry(root)

    onWidthChanged: saveWindowGeometryTimer.restart()
    onHeightChanged: saveWindowGeometryTimer.restart()
    onXChanged: saveWindowGeometryTimer.restart()
    onYChanged: saveWindowGeometryTimer.restart()

    Component.onCompleted: App.restoreWindowGeometry(root)

    // This timer allows to batch update the window size change to reduce
    // the io load and also work around the fact that x/y/width/height are
    // changed when loading the page and overwrite the saved geometry from
    // the previous session.
    Timer {
        id: saveWindowGeometryTimer
        interval: 1000
        onTriggered: App.saveWindowGeometry(root)
    }

    property int counter: 0

    globalDrawer: Kirigami.GlobalDrawer {
        title: i18n("citam")
        titleIcon: "applications-graphics"
        isMenu: !root.isMobile
        actions: [
            Kirigami.Action {
                text: i18n("Plus One")
                icon.name: "list-add"
                onTriggered: counter += 1
            },
            Kirigami.Action {
                text: i18n("About citam")
                icon.name: "help-about"
                onTriggered: pageStack.layers.pushDialogLayer('qrc:About.qml')
            },
            Kirigami.Action {
                text: i18n("Quit")
                icon.name: "application-exit"
                onTriggered: Qt.quit()
            }
        ]
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

    pageStack.initialPage: page

    Kirigami.Page {
        id: page

        title: i18n("Main Page")

        actions.main: Kirigami.Action {
            text: i18n("Plus One")
            icon.name: "list-add"
            tooltip: i18n("Add one to the counter")
            onTriggered: counter += 1
        }

        ColumnLayout {
            width: page.width

            anchors.centerIn: parent

            Kirigami.Heading {
                Layout.alignment: Qt.AlignCenter
                text: counter == 0 ? i18n("Hello, World!") : counter
            }

            Controls.Button {
                Layout.alignment: Qt.AlignHCenter
                text: i18n("+ 1")
                onClicked: counter += 1
            }
        }
    }
}
