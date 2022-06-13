// SPDX-FileCopyrightText: 2020 Chris Josten
//
// SPDX-License-Identifier: BSL-1.0

import QtQuick 2.6
import QtQuick.Controls 2.6

import ".."

FocusScope {
    id: dialogRoot
    
    visible: false
    enabled: visible
    property alias message: messageText.text
    signal closed()
    
    opacity: visible ? 1 : 0
    Behavior on opacity { NumberAnimation {} }
    
    Rectangle {
        anchors.fill: parent
        color: Style.overlayColor
    }
    
    Rectangle {
        anchors.centerIn: parent
        width: 600
        height: column.height
        color: Style.backgroundColor
        
        Column {
            id: column
            width: parent.width
            
            Text {
                id: messageText
                width: parent.width
                padding: Style.horizontalPadding
                font.pixelSize: Style.fontNormalSize
                color: Style.foregroundColor
            }
            
            Button {
                id: button
                flat: true
                focus: true
                width: parent.width
                leftPadding: Style.horizontalPadding
                rightPadding: leftPadding
                topPadding: Style.smallPadding
                bottomPadding: topPadding
                font.pixelSize: Style.fontNormalSize
                palette.buttonText: Style.highlightColor
                palette.brightText: Style.highlightColor
                palette.windowText: Style.highlightColor
                palette.button: Style.backgroundColor2
                palette.mid: Style.backgroundColor2
                onClicked: {
                    hide()
                }
                indicator: Cursor {
                    target: button.background
                    visible: button.visualFocus
                }
                text: qsTr("Close")
            }
        }
    }
    
    SequentialAnimation {
        id: hideAnimation
        NumberAnimation {
            target: dialogRoot
            property: "opacity"
            to: 0
        }
        ScriptAction {
            script: {
                dialogRoot.visible = false;
                dialogRoot.closed()
            }
        }
    }
    
    function show () {
        console.log("ErrorDialog open")
        visible = true;
        dialogRoot.focus = true;
    }
    
    function hide () {
        hideAnimation.start()
    }
}
