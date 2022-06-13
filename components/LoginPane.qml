// SPDX-FileCopyrightText: 2020 Chris Josten
//
// SPDX-License-Identifier: BSL-1.0

import QtQuick 2.6
import QtQuick.Controls 2.6
import QtGraphicalEffects 1.6

import QtQuick.Layouts 1.6

import ".."
import "."
Item {
    // This rectangle spans the screen
    id: loginPaneRoot
    // Emitted when an user is selected
    signal userSelected(string user, string password)
    signal closed()
    property string hostname
    property int sessionIndex
    property bool _open: false
    property string _user
    property string _realUser
    
    // Gives a blur effect to the background
    Item {
        id: background
        opacity: 0
        anchors.fill: parent
        Image {
            id: effectSource
            source: Style.background //refers to the root in Main.qml
            anchors.fill: parent
            visible: false
        }
        GaussianBlur {
            id: blur
            anchors.fill: effectSource
            source: effectSource
            radius: 16
            samples: 16
        }
    }
    
    // The actual pane
    Rectangle {
        id: userSelector
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -height
        width: parent.width
        height: content.height
        color: Style.backgroundColor
        Column {
            id: content
            width: parent.width
            Title {
                text: "Who is using %1?".arg(loginPaneRoot.hostname)
                anchors.left: parent.left
                anchors.leftMargin: Style.horizontalContentPadding
            }
            
            Divider {}
            Item { height: Style.mediumPadding; width: 1; }
            FocusScope {
                width: parent.width
                height: 220
                Row {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: Style.highlightBorderSize + Style.highlightGap * 2
                    /*ListModel {
                        id: userModel
                        ListElement { realName: "test1"; icon: "file:///home/chris/.face.icon";}
                        ListElement { realName: "test2"; icon: "file:///home/chris/.face.icon";}
                        ListElement { realName: "test3"; icon: "file:///home/chris/.face.icon";}
                    }*/
                    Repeater {
                        model: userModel
                        UserDelegate {
                            focus: true
                            text: model.realName
                            icon.source: model.icon
                            onClicked: {
                                _user = model.name
                                _realUser = model.realName
                                showPasswordOverlay()
                            }
                        }
                    }
                }
            }
            Item { height: Style.mediumPadding; width: 1; }
            Divider {}
            //Item { height: Style.mediumPadding; width: 1; }
            RowLayout {
                height: Style.iconSize + Style.mediumPadding
                anchors.left: parent.left
                anchors.leftMargin: Style.horizontalContentPadding
                anchors.right: parent.right
                anchors.rightMargin: anchors.leftMargin
                TintedImage {
                    Layout.preferredWidth: Style.iconSize
                    Layout.preferredHeight: Style.iconSize
                    
                    color: Style.foregroundColor
                    source: "../icons/keyboard.svg"
                }
                ComboBox {
                    Layout.fillHeight: true
                    //height: parent.height
                    Layout.preferredWidth: 400
                    model: keyboard.layouts
                    flat: true
                    font.pixelSize: Style.fontNormalSize
                    
                    palette.buttonText: Style.foregroundColor
                    palette.button: Style.backgroundColor
                    palette.mid: Style.backgroundColor2
                    palette.dark: Style.foregroundColor
                    palette.light: Style.backgroundColor
                    palette.window: Style.backgroundColor
                    
                    textRole: "longName"
                    currentIndex: keyboard.currentLayout
                    onCurrentIndexChanged: keyboard.currentLayout = currentIndex
                }
                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }
                ComboBox {
                    id: sessionIndex
                    Layout.fillHeight: true
                    //height: parent.height
                    Layout.preferredWidth: 400
                    model: sessionModel
                    flat: true
                    font.pixelSize: Style.fontNormalSize
                    
                    palette.buttonText: Style.foregroundColor
                    palette.button: Style.backgroundColor
                    palette.mid: Style.backgroundColor2
                    palette.dark: Style.foregroundColor
                    palette.light: Style.backgroundColor
                    palette.window: Style.backgroundColor
                    
                    textRole: "name"
                    currentIndex: sessionModel.lastIndex
                    onCurrentIndexChanged: loginPaneRoot.sessionIndex = currentIndex
                }
                
            }
            //Item { height: Style.mediumPadding; width: 1; }
        }
        
        ParallelAnimation {
            id: userSelectorShow
            NumberAnimation {
                target: background
                property: "opacity"
                from: 0
                to: 1
                duration: 100
            }
            NumberAnimation {
                target: userSelector
                property: "anchors.bottomMargin"
                from: -userSelector.height
                to: 0
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
        SequentialAnimation {
            id: userSelectorHide
            ParallelAnimation {
                NumberAnimation {
                    target: userSelector
                    property: "anchors.bottomMargin"
                    from: 0
                    to: -userSelector.height
                    duration: 150
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: background
                    property: "opacity"
                    from: 1
                    to: 0
                    duration: 100
                }
            }
            ScriptAction {
                script: closed()
            }
        }
    }
    
    PasswordOverlay {
        id: passwordOverlay
        enabled: false
        anchors.fill: parent
        opacity: enabled ? 1 : 0
        Behavior on opacity { NumberAnimation {} }
        
        username: _realUser
        
        onPasswordEntered: {
            hidePasswordOverlay()
            userSelected(_user, password)
        }
        onCancelled: hidePasswordOverlay()
    }
    
    function showPasswordOverlay() {
        userSelector.enabled = false;
        passwordOverlay.enabled = true;
        passwordOverlay.focus = true;
    }
    
    function hidePasswordOverlay() {
        userSelector.enabled = true;
        passwordOverlay.enabled = false;
    }
    
    function open() {
        if (!_open) userSelectorShow.start()
    }
    
    function close() {
        console.log("Closing pane")
        /*if (_open)*/ userSelectorHide.start()
    }
    
}
