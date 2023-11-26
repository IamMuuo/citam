// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {
    id: root

    property string mode: "create"
    property var parentsList: []

    title: i18n(mode == "create" ? "Add New Student" : "Update Student")
    Component.onCompleted: {
        StudentController.fetchAllParents()
        ClassController.fetchClassInformation()
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
        }
    }

    Kirigami.FormLayout {

        Connections {
            target: StudentController
            onParentsFetched: {
                console.log(parents)
                console.log(parents[0].last_name)

                parentsModel.clear()
                for (var p in parents) {

                    parentsModel.append({
                                            "id": parents[p].id,
                                            "name": `${parents[p].first_name} ${parents[p].last_name}`,
                                            "first_name": parents[p].first_name,
                                            "last_name": parents[p].last_name,
                                            "email": parents[p].email,
                                            "phone": parents[p].phone
                                        })
                }
            }
        }

        Connections {
            target: ClassController
            onClassesFetched: {
                console.log(classes)
                classModel.clear()
                for (var cls in classes) {
                    classModel.append({
                                          "id": classes[cls].id,
                                          "class": `${classes[cls].grade} ${classes[cls].stream}`,
                                          "grade": classes[cls].grade,
                                          "stream": classes[cls].stream,
                                          "limit": classes[cls].limit,
                                          "no_of_children": classes[cls].children.length,
                                          "children": classes[cls].children,
                                          "claname": classes[cls].class_teacher.first_name,
                                          "class_teacher": classes[cls].class_teacher
                                      })
                }
            }
        }

        ColumnLayout {
            spacing: 12
            Kirigami.InlineMessage {
                Layout.fillWidth: true
                id: message
                visible: false
                text: ""
                type: Kirigami.MessageType.Information
                showCloseButton: true
            }
            Kirigami.Heading {
                text: i18n("Basic Information")
                level: 1
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
            }

            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Controls.TextField {
                    id: firstNameField
                    Kirigami.FormData.label: i18n("First Name:")
                    placeholderText: i18n("First Name (required)")
                    onAccepted: lastNameField.activeFocus()
                    text: details.first_name === undefined ? "" : details.first_name
                }

                Controls.TextField {
                    id: lastNameField
                    Kirigami.FormData.label: i18n("Last Name:")
                    placeholderText: i18n("Last Name (required)")
                    onAccepted: ageInput.forceActiveFocus()
                    text: details.last_name === undefined ? "" : details.last_name
                }
            }

            Controls.TextField {
                id: ageInput
                Kirigami.FormData.label: "Age"
                placeholderText: i18nc("@label:textbox", "Age (Required)")
                validator: RegExpValidator {
                    regExp: /^[0-9,/]+$/
                }
                text: details.grade === undefined ? "" : details.grade
            }

            Kirigami.Heading {
                text: i18n("Parent Information")
                level: 1
            }

            Controls.ComboBox {
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"
                model: ListModel {
                    id: parentsModel
                }

                displayText: currentIndex === -1 ? "Choose Parent" : currentText
                onCurrentIndexChanged: {
                    if (currentIndex != -1) {
                        parentFirstNameField.visible = false
                        parentLastNameField.visible = false
                        phoneField.visible = false
                        emailField.visible = false
                    }
                }
            }

            RowLayout {
                Controls.TextField {
                    id: parentFirstNameField
                    placeholderText: i18n("Parent's First Name (required)")
                    onAccepted: lastNameField.activeFocus()
                    text: details.first_name === undefined ? "" : details.first_name
                }
                Controls.TextField {
                    id: parentLastNameField
                    placeholderText: i18n("Parent's Last Name (required)")
                    onAccepted: lastNameField.activeFocus()
                    text: details.first_name === undefined ? "" : details.first_name
                }
            }
            Controls.TextField {
                id: emailField
                Layout.fillWidth: true
                placeholderText: i18n("Parent's Email (required)")
                onAccepted: phoneField.activeFocus()
                text: details.email === undefined ? "" : details.email
            }

            Controls.TextField {
                id: phoneField
                Layout.fillWidth: true
                placeholderText: i18n("Parent's Phone(required)")
                validator: RegExpValidator {
                    regExp: /^[0-9,/]+$/
                }
                onAccepted: passwordField.forceActiveFocus()
                text: details.phone === undefined ? "" : details.phone
            }

            Kirigami.Heading {
                text: i18n("Class Information")
                level: 1
            }
            Controls.ComboBox {
                Layout.fillWidth: true
                textRole: "class"
                valueRole: "id"
                model: ListModel {
                    id: classModel
                }

                displayText: currentIndex === -1 ? "Choose Class" : currentText
                onCurrentIndexChanged: {

                }
            }
            Controls.ComboBox {
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "type"
                model: [
                    {"type": 1, "name": "Regular"},
                    {"type":2,"name":"Programme"},
                ]

                displayText: currentIndex === -1 ? "Choose type" : currentText
                onCurrentIndexChanged: {

                }
            }


            Kirigami.Heading {
                text: i18n("Actions")
                level: 1
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Controls.Button {
                    visible: mode == "create" ? true : false
                    icon.source: "list-add-user"
                    text: "Add User"
                    onClicked: addUser()
                }
                Controls.Button {
                    visible: mode == "update" ? true : false
                    icon.name: "im-invisible-user"
                    text: "Update User"
                    onClicked: {
                        updateUser()
                    }
                }
                Controls.Button {
                    visible: mode == "update" ? true : false
                    icon.name: "im-kick-user"
                    text: "Delete User"
                    onClicked: deleteUser()
                }
                Controls.Button {
                    icon.name: "dialog-cancel"
                    text: "Cancel"
                    onClicked: function () {
                        root.close()
                    }
                }
            }
        }
    }
}
