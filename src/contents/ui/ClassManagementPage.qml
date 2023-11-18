// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {
    id: root
    title: i18n("Manage Classes")

    Component.onCompleted: {
        ClassController.fetchClassInformation()
        refreshPage()
    }

    ClassEditForm{
        id: editForm
    }

    Kirigami.InlineMessage {
        id: message
        text: ""
        type: Kirigami.MessageType.Information
        showCloseButton: true
        visible: false
        z: 1
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
                text: i18n("New class")
                icon.name: "list-add"
                onClicked: {
                    editForm.open()
                }
            }
            Controls.Button {
                text: i18n("Refresh")
                icon.name: "view-refresh"
                onClicked: function () {
                    refreshPage()
                }
            }
        }
    }

    Connections {
        target: ClassController
        onClassesRecieved: function () {
            message.text = "Found classes"
            message.visible = true
        }
    }

    ListModel {
        id: model
    }
    ColumnLayout {

        Kirigami.CardsLayout {
            Repeater {
                model: model
                delegate: Kirigami.Card {
                    id: card
                    //                    clip: true
                    banner {
                        source: Qt.resolvedUrl("pupils.png")
                        title: `${grade} ${stream}`
                    }

                    height: 200
                    actions: [
                        Kirigami.Action {
                            text: i18n("Edit Class")
                            icon.name: "edit-entry"
                        },
                        Kirigami.Action {
                            text: i18n("Delete Class")
                            icon.name: "edit-delete"
                        }
                    ]
                    contentItem: Kirigami.Label {
                        width: parent.width
                        text: `Grade ${grade} ${stream} has ${no_of_children} children  and a limit of ${limit}, The current class teacher is ${class_teacher_name}`
                        wrapMode: Text.WordWrap
                    }
                }
            }
        }
    }

    function refreshPage() {
        // call the api
        model.clear()
        ClassController.fetchClassInformation()

        // Refresh the ui
        var classes = ClassController.classes()
        console.log(classes)
        for (var cls in classes) {

            model.append({
                             "grade": classes[cls].grade,
                             "stream": classes[cls].stream,
                             "limit": classes[cls].limit,
                             "no_of_children": classes[cls].children.length,
                             "children": classes[cls].children,
                             "class_teacher_name": classes[cls].class_teacher.first_name,
                             "class_teacher": classes[cls].class_teacher
                         })
        }
    }
}
