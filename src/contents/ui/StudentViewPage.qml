// SPDX-License-Identifier: GPL-2.0-or-later
// SPDX-FileCopyrightText: 2023 Erick Muuo <hearteric57@gmail.com>
import QtQuick 2.15
import QtQuick.Controls 2.15 as Controls
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0
import QtQuick.Controls 1.4
import org.kde.kirigami 2.19 as Kirigami
import org.kde.citam 1.0

Kirigami.ScrollablePage {
    id: root
    title: i18n("Student Management Page")

    Component.onCompleted: {
        refreshPage()
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
                text: i18n("New Student")
                icon.name: "list-add-user"
                onClicked: {

                    //                    editForm.details = {}
                    //                    editForm.open()
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
        target: StudentController
        onStudentsFetched: {
            tableModel.clear()
            console.log(students)
            for (var student in students) {
                tableModel.append({
                                      "firstname": `${students[student].first_name}`,
                                      "lastname": `${students[student].last_name}`,
                                      "admno": `${students[student].admno}`,
                                      "age": `${students[student].age}`,
                                      "class": `${students[student]["class"].grade}`,
                                      "stream": `${students[student]["class"].stream}`,
                                      "teacher": `${students[student]["class"]["class_teacher"].first_name} ${students[student]["class"]["class_teacher"].last_name}`

                                  })
            }
        }
    }

    // Body
    TableView {
        anchors.fill: parent
        clip: true

        TableViewColumn {
            role: "firstname"
            title: "First Name"
        }

        TableViewColumn {
            role: "lastname"
            title: "Last Name"
        }

        TableViewColumn {
            role: "admno"
            title: "Admission Number"
        }

        TableViewColumn {
            role: "age"
            title: "Age"
        }
        TableViewColumn {
            role: "class"
            title: "Class"
        }
        TableViewColumn {
            role: "stream"
            title: "Stream"
        }
        TableViewColumn {
            role: "teacher"
            title: "Teacher"
        }

        model: ListModel {
            id: tableModel
        }
    }

    function refreshPage() {
        StudentController.fetchAllStudents()
    }
}
