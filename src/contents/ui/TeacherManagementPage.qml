// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {

    Component.onCompleted: {
        refresh()
        refresh()
    }
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

            Controls.Button {
                text: i18n("New Teacher")
                icon.name: "list-add"
                onClicked: {
                    addUserForm.open()
                }
            }
            Controls.Button {
                text: i18n("Refresh")
                icon.name: "view-refresh"
                onClicked: refresh()
            }
        }
    }

    AddUserForm {
        id: addUserForm
    }

    // Main page
    ListModel {
        id: teacherModel
    }

    ColumnLayout {
        Repeater {
            model: teacherModel
            delegate: Kirigami.AbstractCard {
                contentItem: Item {
                    // implicitWidth/Height define the natural width/height of an item if no width or height is specified.
                    // The setting below defines a component's preferred size based on its content
                    implicitWidth: delegateLayout.implicitWidth
                    implicitHeight: delegateLayout.implicitHeight
                    GridLayout {
                        id: delegateLayout
                        anchors {
                            left: parent.left
                            top: parent.top
                            right: parent.right
                        }
                        rowSpacing: Kirigami.Units.largeSpacing
                        columnSpacing: Kirigami.Units.largeSpacing
                        columns: root.wideScreen ? 4 : 2

                        Kirigami.Heading {
                            Layout.fillHeight: true
                            level: 1
                            text: count
                        }

                        ColumnLayout {
                            Kirigami.Heading {
                                Layout.fillWidth: true
                                level: 2
                                text: name
                            }
                            Kirigami.Separator {
                                Layout.fillWidth: true
                                visible: contact.length > 0
                            }
                            Controls.Label {
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                text: contact
                                visible: contact.length > 0
                            }
                        }
                        Controls.Button {
                            Layout.alignment: Qt.AlignRight
                            Layout.columnSpan: 2
                            text: i18n("Edit")
                            onClicked: function () {
                                addUserForm.mode = "update"
                                addUserForm.details = model
                                addUserForm.open()
                            }

                            // onClicked: to be done... soon!
                        }
                    }
                }
            }
        }
    }
    function refresh() {
        LoginController.fetchAllUsers()
        var teachers = LoginController.getAllUsers()

        var count = 1
        teacherModel.clear()

        for (var teacher in teachers) {
            teacherModel.append({
                                    "first_name": `${teachers[teacher].first_name}`,
                                    "last_name": `${teachers[teacher].last_name}`,
                                    "name": `${teachers[teacher].first_name} ${teachers[teacher].last_name}`,
                                    "phone" : `${teachers[teacher].phone}`,
                                    "email":`${teachers[teacher].email}`,
                                    "contact": `Email: ${teachers[teacher].email} Phone: ${teachers[teacher].phone}`,
                                    "id": teachers[teacher].id,
                                    "count": count
                                })
            count++
        }
    }
}
