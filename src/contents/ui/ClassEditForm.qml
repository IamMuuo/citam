// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.OverlaySheet {
    id: classEditSheet
    property string mode: "add"
    property alias teachers: teacherModel
    property var details: ({})
    property var initial_limit: details.limit

    title: mode == "add" ? i18n("Add A Class") : i18n("Edit a class")

    Kirigami.InlineMessage {
        id: message
        text: ""
        type: Kirigami.MessageType.Information
        showCloseButton: true
        visible: false
        z: 1
    }
    ColumnLayout {
        Kirigami.FormLayout {

            Connections {
                target: ClassController
                onSuccess: function () {
                    message.text = "Action Completed Successfully"
                    message.type = Kirigami.MessageType.Positive
                    message.visible = true
                }
                onNewError: function () {
                    message.text = ClassController.error()
                    message.type = Kirigami.MessageType.Error
                    message.visible = true
                }
            }

            id: layout
            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Basic Class Information")
            }

            Controls.TextField {
                id: gradeInput
                Kirigami.FormData.label: "Grade"
                placeholderText: i18nc("@label:textbox", "Grade (Required)")
                validator: RegExpValidator {
                    regExp: /^[0-9,/]+$/
                }
                text: details.grade === undefined ? "" : details.grade
            }

            Controls.ComboBox {
                id: streamInput
                Kirigami.FormData.label: "Stream"
                model: ["Red", "Green", "Blue", "Yellow"]
                displayText: i18n(currentText)
                width: parent.width

                onCurrentIndexChanged: {
                    currentValue = model[currentIndex]
                    currentText = currentValue.text
                    details.stream = currentText
                }
                editText: details.stream
            }

            Controls.TextField {
                id: limitInput
                Kirigami.FormData.label: "Class Limit"
                placeholderText: i18nc("@label:textbox", "Limit(Required)")
                validator: RegExpValidator {
                    regExp: /^[0-9,/]+$/
                }
                text: details.limit === undefined ? "" : details.limit
            }

            Controls.ComboBox {
                id: teacher
                Kirigami.FormData.label: "Teacher Name"
                model: ListModel {
                    id: teacherModel
                    ListElement {
                        text: "Banana"
                    }
                    ListElement {
                        text: "Apple"
                    }
                    ListElement {
                        text: "Coconut"
                    }
                }
                displayText: i18n(currentText)
                width: parent.width
                editable: false
                onCurrentIndexChanged: {
                    streamInput.currentText = streamInput.model[streamInput.currentIndex]
                }
                editText: details.class_teacher_name
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
                Kirigami.FormData.label: i18n("Actions")
            }

            RowLayout {
                Controls.Button {
                    text: i18n("Add")
                    icon.name: "list-add"
                    visible: mode == "add" ? true : false
                    onClicked: {
                        registerClass()
                    }
                }
                Controls.Button {
                    text: i18n("Modify")
                    icon.name: "edit-entry"
                    visible: mode == "add" ? false : true
                    onClicked: {
                        updateClassInfo()
                    }
                }
                Controls.Button {
                    text: i18n("Cancel")
                    icon.name: "dialog-cancel"
                    onClicked: {
                        classEditSheet.close()
                    }
                }
            }
        }
    }
    function verifyInputs() {
        if (Number(limitInput.text) < 3 || Number(limitInput.text) > 70) {
            message.text = "Please set a limit above 3 and less than 70"
            message.type = Kirigami.MessageType.Warning
            message.visible = true
            return false
        }
        if (Number(limitInput.text) < details.no_of_children
                && mode == "edit") {
            message.text = "Class limit cannot be lower than the number of pupils"
            message.type = Kirigami.MessageType.Warning
            message.visible = true
            return false
        }

        if (Number(gradeInput.text) > 12 || Number(gradeInput.text) < 1) {
            message.text = "Please input a grade between 1 and 12"
            message.type = Kirigami.MessageType.Warning
            message.visible = true
            return false
        }

        if (gradeInput.text == "" || limitInput == ""
                || teacher.currentText == "" || streamInput.currentText == "") {
            message.text = "Please ensure you fill the entire form"
            message.type = Kirigami.MessageType.Error
            message.visible = true
            return false
        }
        return true
    }

    function updateClassInfo() {
        if (verifyInputs()) {
            // add the items into a map
            var classInfo = {
                "id": details.id,
                "grade": gradeInput.text,
                "stream": streamInput.currentText,
                "limit": Number(limitInput.text)
            }

            ClassController.updateClass(classInfo)
        }
    }

    function registerClass() {
        if (verifyInputs()) {
            // add the items into a map
            var classInfo = {
                "id": details.id,
                "grade": gradeInput.text,
                "stream": streamInput.currentText,
                "limit": Number(limitInput.text),
                "class_teacher_id": parseInt(teacher.currentText)
            }
            console.log(classInfo);

            ClassController.registerClass(classInfo)
        }
    }
}
