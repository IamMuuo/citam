import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {
    id: root
    title: i18nc("@title:window", "CITAM Management System")
    footer: RowLayout {
        Layout.fillWidth: true
        Kirigami.Label {
            anchors.centerIn: parent
            text: "(C) CITAM 2023 All Rights Reserved"
        }
    }

    Kirigami.GlobalDrawer {
        id: globalDrawer
        title: "CITAM"
        titleIcon: "gnome-logo-icon"
        bannerVisible: true
        spacing: 8
        actions: [
            Kirigami.Action {
                text: i18nc("@action:button", "Home")
                icon.name: "go-home"
            },
            Kirigami.Action {
                text: i18nc("@action:button", "Manage Teachers")
                icon.name: "resource-calendar-insert"
            },

            Kirigami.Action {
                text: i18nc("@action:button", "Manage Students")
                icon.name: "user"
            },

            Kirigami.Action {
                text: i18nc("@action:button", "Manage Classes")
                icon.name: "application-x-java"
            },
            Kirigami.Action {
                text: i18nc("@action:button", "Settings")
                icon.name: "gnome-settings"
            },

            Kirigami.Action {
                text: i18nc("@action:button", "Quit")
                icon.name: "window-close"
                shortcut: StandardKey.Quit
                onTriggered: {
                    Qt.quit()
                }
            }
        ]
    }

    header: Controls.ToolBar {
        Kirigami.Heading {
            anchors.centerIn: parent
            text: "Hi Erick "
        }
    }

    Kirigami.Card{
        anchors.centerIn: parent
        Layout.fillWidth: false
        contentItem: Kirigami.Label{
            wrapMode: Text.WordWrap
            text:" Hi there"
        }
        banner{
           source: "teacher.png"
           title: "Manage Teachers"
           height: 100
           width: 100
        }
        height: 300
        width: 300
    }

}
