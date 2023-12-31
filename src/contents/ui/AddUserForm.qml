// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.OverlaySheet {
    id: root

    // Properties
    property string mode: "create"
    property int user: 2
    property var details: ({})

    header: Kirigami.Heading {
        text: mode == "create" ? i18nc("@title:window",
                                       "Add New User") : i18nc("@title:window",
                                                               "Update User")
    }
    // Form
    Kirigami.FormLayout {
        Connections {
            target: LoginController
            onUserModified: {
                message.text = LoginController.successMsg()
                message.type = Kirigami.MessageType.Positive
                message.visible = true
            }
            onNewError: {
                message.text = LoginController.error()
                message.type = Kirigami.MessageType.Error
                message.visible = true
            }
        }

        Layout.fillWidth: true

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
                    Kirigami.FormData.label: i18nc("@label:textbox",
                                                   "First Name:")
                    // Placeholder text is visible before you enter anything
                    placeholderText: i18n("First Name (required)")
                    // What to do after input is accepted (i.e. pressed enter)
                    // In this case, it moves the focus to the next field
                    onAccepted: lastNameField.activeFocus()
                    text: details.first_name === undefined ? "" : details.first_name
                }

                Controls.TextField {
                    id: lastNameField
                    // Provides label attached to the textfield
                    Kirigami.FormData.label: i18nc("@label:textbox",
                                                   "Last Name:")
                    // Placeholder text is visible before you enter anything
                    placeholderText: i18n("Last Name (required)")
                    // What to do after input is accepted (i.e. pressed enter)
                    // In this case, it moves the focus to the next field
                    onAccepted: emailField.forceActiveFocus()
                    text: details.last_name === undefined ? "" : details.last_name
                }
            }

            Kirigami.Heading {
                text: i18n("Contact Information")
                level: 1
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
            }

            RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Controls.TextField {
                    id: emailField
                    // Provides label attached to the textfield
                    Kirigami.FormData.label: i18nc("@label:textbox", "Email:")
                    // Placeholder text is visible before you enter anything
                    placeholderText: i18n("Email (required)")
                    // What to do after input is accepted (i.e. pressed enter)
                    // In this case, it moves the focus to the next field
                    onAccepted: phoneField.activeFocus()
                    text: details.email === undefined ? "" : details.email
                }

                Controls.TextField {
                    id: phoneField
                    // Provides label attached to the textfield
                    Kirigami.FormData.label: i18nc("@label:textbox", "Phone:")
                    // Placeholder text is visible before you enter anything
                    placeholderText: i18n("Phone(required)")
                    // What to do after input is accepted (i.e. pressed enter)
                    // In this case, it moves the focus to the next field
                    onAccepted: passwordField.forceActiveFocus()
                    text: details.phone === undefined ? "" : details.phone
                }
            }

            Kirigami.Heading {
                text: i18n("Other Information")
                level: 1
            }

            Kirigami.Separator {
                Kirigami.FormData.isSection: true
            }

            ColumnLayout {
                spacing: 8
                Layout.fillWidth: true
                Controls.TextField {
                    id: passwordField
                    // Provides label attached to the textfield
                    Kirigami.FormData.label: i18nc("@label:textbox",
                                                   "New Password:")
                    // Placeholder text is visible before you enter anything
                    placeholderText: i18n("Password (required)")
                    // What to do after input is accepted (i.e. pressed enter)
                    // In this case, it moves the focus to the next field
                    echoMode: "Password"
                    Layout.fillWidth: true

                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: confirmPassord.forceActiveFocus()
                }
                Controls.TextField {
                    id: confirmPassord
                    // Provides label attached to the textfield
                    Kirigami.FormData.label: i18nc("@label:textbox",
                                                   "Confirm Password:")
                    // Placeholder text is visible before you enter anything
                    placeholderText: i18n("Confirm Password (required)")
                    // What to do after input is accepted (i.e. pressed enter)
                    // In this case, it moves the focus to the next field
                    echoMode: "Password"
                    Layout.fillWidth: true

                    horizontalAlignment: TextInput.AlignHCenter
                    onAccepted: firstNameField.forceActiveFocus()
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
    function addUser() {
        message.visible = false
        if (validatePasswords() && validateInputs()) {
            let payload = {
                "first_name": firstNameField.text.trim(),
                "last_name": lastNameField.text.trim(),
                "email": emailField.text.trim(),
                "phone": phoneField.text.trim(),
                "password": passwordField.text.trim(),
                "user_type": user
            }
            LoginController.registerUser(payload)
            clearFields()
        }
    }

    function clearFields() {
        firstNameField.text = ""
        lastNameField.text = ""
        emailField.text = ""
        phoneField.text = ""
        passwordField.text = ""
        confirmPassord.text = ""
    }

    function deleteUser() {
        var payload = {
            "id": details.id
        }
        LoginController.deleteUser(payload)
    }

    function updateUser() {
        if (confirmPassord.text != passwordField.text) {
            message.text = "Passwords do not match"
            message.type = Kirigami.MessageType.Error
            message.visible = true
            return false
        }
        let payload = {
            "id": details.id,
            "first_name": firstNameField.text.trim(),
            "last_name": lastNameField.text.trim(),
            "email": emailField.text.trim(),
            "phone": phoneField.text.trim(),
            "user_type": user
        }

        LoginController.updateUser(payload)
    }

    function validatePasswords() {
        if (confirmPassord.text != passwordField.text) {
            message.text = "Passwords do not match"
            message.type = Kirigami.MessageType.Error
            message.visible = true
            return false
        }
        if (confirmPassord.text == "" || passwordField.text == "") {
            message.text = "Please ensure you fill passwords"
            message.type = Kirigami.MessageType.Error
            message.visible = true
            return false
        }
        return true
    }

    function validateInputs() {
        if (firstNameField.text == "" || lastNameField.text == ""
                || phoneField.text == "" || emailField.text == "") {
            message.text = "Please ensure you fill passwords"
            message.type = Kirigami.MessageType.Error
            message.visible = true
            return false
        }
        return true
    }
}
