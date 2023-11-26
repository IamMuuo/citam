// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {
    id: root
    title: i18n("Manage Pupils")
    header: Controls.ToolBar {
        RowLayout {
            Controls.Button {
                text: i18n("Home")
                icon.name: "go-home"
                onClicked: function () {
                    pageStack.pop()
                    pageStack.push(Qt.resolvedUrl("Home.qml"))
                }
            }
        }
    }

    ListModel {
        id: model
        ListElement {
            head: "Add Student"
            description: "Adds a Student to the system"
            picture: "pupils.png"
            onclicked: function () {
                pageStack.pop();
                pageStack.push(Qt.resolvedUrl("StudentForm.qml"));
            }
        }
        ListElement {
            head: "Modify Student"
            description: "Updates a student information"
            picture: "update.png"
        }

        ListElement {
            head: "Search For Student"
            description: "Updates a student information"
            picture: "search.png"
        }

        ListElement {
            head: "View All Students"
            description: "Lists all students per given criteria"
            picture: "view.png"
            onclicked: function () {
                pageStack.pop()
                pageStack.push(Qt.resolvedUrl("StudentViewPage.qml"))
            }
        }
    }

    ColumnLayout {
        Kirigami.CardsLayout {
            Repeater {
                model: model
                delegate: Kirigami.Card {
                    id: card
                    banner {
                        source: Qt.resolvedUrl(picture)
                        title: `${head}`
                        height: 80
                        clip: true
                    }

                    height: 200
                    showClickFeedback: true
                    contentItem: Kirigami.Label {
                        width: parent.width
                        text: `${description}`
                        wrapMode: Text.WordWrap
                    }
                    onClicked: onclicked()
                }
            }
        }
    }
}
