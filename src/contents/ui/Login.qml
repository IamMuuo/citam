// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.Page {

    id: loginPage

    Kirigami.ScrollablePage {
        anchors.fill: parent
        Kirigami.InlineMessage {
            id: message
            Layout.fillWidth: true
            visible: false
            type: Kirigami.MessageType.Information
            text: "Hi there"
            showCloseButton: true
        }

        Kirigami.FormLayout {
            anchors.centerIn: parent

            Kirigami.Separator{
                Kirigami.FormData.label: i18n("Login To Citam")
                Kirigami.FormData.isSection: true
            }

            Controls.TextField {
                id: usernameInput
                placeholderText: i18nc("@label:textbox", "Email")
                horizontalAlignment: TextInput.AlignHCenter
            }

            Controls.TextField {
                id: passwordInput
                placeholderText: i18nc("@label:textbox", "Password")
                echoMode: "Password"
                horizontalAlignment: TextInput.AlignHCenter
            }

            Controls.Button {
                ColumnLayout.fillWidth: true
                id: loginButton
                text: i18nc("@action:button", "Login")
                onClicked: login()
            }
            Controls.BusyIndicator {
                id: loadingIndicator
                visible: false
                Layout.fillWidth: true
            }
        }
    }

    Connections{
        target: LoginController
        onNewError:{
            message.text = LoginController.error()
            message.type = Kirigami.MessageType.Error
            message.visible= true
        }
    }



    // Verification
    function verifyLoginInput() {
        if (usernameInput.text == "" || passwordInput.text == "") {
            message.text = "Please ensure you fill your username and password and try that again";
            message.type = Kirigami.MessageType.Warning;
            message.visible = true;
            return false;
        }
        return true;
    }


    // Login feature
    function login(){
        loginButton.visible = false
        loadingIndicator.visible = true;
        if(verifyLoginInput()){
            var ok = LoginController.login(usernameInput.text, passwordInput.text);
        }
        loadingIndicator.visible = false;
        loginButton.visible = true
    }
}
