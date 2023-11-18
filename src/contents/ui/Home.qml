import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {
    // init
    onVisualFocusChanged:  function(){
        console.log("focus")
//        stats = LoginController.getAllUsers()
    }

    id: root
    title: i18nc("@title:window", "CITAM Management System")
    footer: RowLayout {
        Layout.fillWidth: true
        Kirigami.Label {
            anchors.centerIn: parent
            text: "(C) CITAM 2023 All Rights Reserved"
        }
    }

    // Overlay sheets
    AddUserForm{
        id: addUserForm
    }

    AddStudentForm{
        id: addStudentForm
    }

    header: Controls.ToolBar {
        Kirigami.Heading {
            anchors.centerIn: parent
            text: "Hello,  " + LoginController.getUser()["first_name"]
        }
    }

    // Dashboard Quick Cards
    ListModel {
        id: dashCards

        ListElement {
            title: "Manage Students"
            img: "pupils.png"
            description: "Easily manage student's information"
            todo: function(){
                addStudentForm.open()
            }

        }

        ListElement {
            title: "Manage Teachers"
            img: "teacher.png"
            description: "Easily manage teacher information"
            todo: function(){
                addUserForm.open()
            }

        }

        ListElement {
            title: "Manage Classes"
            img: "class.png"
            description: "Easily manage class related information"
            todo: function(){
                pageStack.pop();
                pageStack.push(Qt.resolvedUrl("ClassManagementPage.qml"))
            }

        }

        ListElement {
            title: "Manage Trips"
            img: "trips.png"
            description: "Easily manage home trips"
            todo: function(){}
        }
    }

    ListModel{
        id: quickCards

        ListElement{
            title: "Number of All Users"
            quantity: 40

        }

        ListElement{
            title: "Number of Students"
            quantity: 30

        }

        ListElement{
            title: "Number of Teachers"
            quantity: 30
        }

        ListElement{
            title: "Number of Parents"
            quantity: 10
        }


    }

    ColumnLayout {
//            Layout.alignment: Qt.AlignHCenter
        RowLayout{
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignHCenter
            Repeater{
                model: quickCards
                Kirigami.AbstractCard{
                    header: Kirigami.Heading{
                        text: i18n(quantity)
                        horizontalAlignment: Text.AlignHCenter
                        level: 1
                    }
                    contentItem: Kirigami.Label{
                        text: i18n(title)
                    }
                }

            }
        }

        Kirigami.CardsLayout {
            visible: !root.pageStack.wideMode
            Layout.topMargin: Kirigami.Units.largeSpacing
            Layout.leftMargin: Kirigami.Units.gridUnit
            Layout.rightMargin: Kirigami.Units.gridUnit
            rows: 3

            Repeater {
                model: dashCards
                delegate: Kirigami.Card {
                    banner {
                        source: Qt.resolvedUrl(img)


                        title: title
                        titleAlignment: Qt.AlignBottom | Qt.AlignLeft
                        width: 200
                        height: 200
                        fillMode: Image.PreserveAspectCrop
                    }
                    width: 200
                    height: 200

                    contentItem: Kirigami.Label {
                        text: i18n(description)
                    }

                    implicitWidth: Kirigami.Units.gridUnit * 30
                    Layout.maximumWidth: Kirigami.Units.gridUnit * 30
                    activeFocusOnTab: true
                    showClickFeedback: true
                    onClicked:  todo()
                }
            }
        }
    }
}
