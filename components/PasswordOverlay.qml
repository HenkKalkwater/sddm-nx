// SPDX-FileCopyrightText: 2020 Chris Josten
//
// SPDX-License-Identifier: BSL-1.0

import QtQuick 2.6
import QtQuick.Controls 2.6


import ".."

FocusScope {
    id: overlay
    
    property string username
    
    signal passwordEntered(string password)
    signal cancelled()
    
    Connections {
        target: Qt.inputMethod
        onVisibleChanged: {
            if (!Qt.inputMethod.visible) cancelled()
        }
    }
    
    
    Rectangle {
        anchors.fill: parent
        color: Style.overlayColor
        Item {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.bottom: virtualKeyboard.top
            TextField {
                id: passwordField
                focus: true
                //anchors.top: parent.top
                /*property real _vkeyboardOffset: Qt.inputMethod.visible 
                    ? root.height - Qt.inputMethod.keyboardRectangle.top : 0
                y: (parent.height - _vkeyboardOffset) / 2 - height / 2*/
                Behavior on y { NumberAnimation { duration: 100 }}
                
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                //anchors.topMargin: Style.horizontalPadding
                anchors.leftMargin: Style.horizontalContentPadding
                anchors.rightMargin: Style.horizontalContentPadding
                
                padding: Style.mediumPadding
                color: Style.foregroundColor
                echoMode: TextInput.Password
                
                placeholderText: "Enter the password for %1".arg(username)
                //color: Style.foregroundColor
                font.pixelSize: Style.fontTitleSize
                
                background: Rectangle {
                    color: "#00000000"
                    border.width: Style.highlightBorderSize
                    border.color: Style.backgroundColor2
                }
                
                Keys.onEscapePressed: cancelled()
                
                
                onAccepted: {
                    passwordEntered(text)
                    text = ""
                }
            }
        }
         // Optional virtual keyboard
        Loader {
            id: virtualKeyboard
            source: Qt.resolvedUrl("VirtualKeyboard.qml")
            width: parent.width
            anchors.bottom: parent.bottom
            
            onLoaded: {
                item.activated = Style.virtualKeyboard
                Qt.inputMethod.show()
                //state = "visible"
            }
            
            //opacity: item ? item.visible ? 1 : 0 : 0
            state: item ? (item.active ? "visible" : "hidden" ) : "hidden"
            
            states: [
                State {
                    name: "visible"
                    PropertyChanges {
                        target: virtualKeyboard
                        anchors.bottomMargin: 0
                    }
                },
                State {
                    name: "hidden"
                    PropertyChanges {
                        target: virtualKeyboard
                        anchors.bottomMargin: -virtualKeyboard.height
                    }
                }
            ]
            
            transitions: [
                Transition {
                    from: "visible"
                    to: "hidden"
                    
                    SequentialAnimation {
                        NumberAnimation {
                            target: virtualKeyboard
                            property: "anchors.bottomMargin"
                            duration: 250
                            easing.type: Easing.InQuad
                        }
                        ScriptAction {
                            script: Qt.inputMethod.hide()
                        }
                    }
                },
                Transition {
                    from: "hidden"
                    to: "visible"
                    
                    SequentialAnimation {
                        ScriptAction {
                            script: Qt.inputMethod.show()
                        }
                        NumberAnimation {
                            target: virtualKeyboard
                            property: "anchors.bottomMargin"
                            duration: 250
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            ]
        }
    }
}
