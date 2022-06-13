// SPDX-FileCopyrightText: 2020 Chris Josten
//
// SPDX-License-Identifier: BSL-1.0

import QtQuick 2.6
import QtQuick.Controls 2.6
import QtGraphicalEffects 1.0
import ".."

AbstractButton {
    id: userDelegateRoot
    //property alias icon: userPic.source
    //property alias name: userName.text
    focusPolicy: Qt.StrongFocus
    readonly property real _innerWidth: 180
    readonly property real _innerHeight: 220
    
    //cursorShape: Qt.PointingHandCursor
    
    indicator: Cursor {
        target: backgroundItem
        visible: userDelegateRoot.visualFocus
    }
    background: Item {
        id: backgroundItem
        anchors.centerIn: parent
        width: contentItem.width + 2 * Style.highlightBorderSize
        height: contentItem.height + 2 * Style.highlightBorderSize
        
        Rectangle {
            id: backgroundItemInner
            anchors.centerIn: parent
            color: userDelegateRoot.down ? Style.backgroundColor : Style.backgroundColor2
            implicitWidth: parent.width - 2 * Style.highlightBorderSize
            implicitHeight: parent.height - 2 * Style.highlightBorderSize
            visible: false
        }
        
        DropShadow {
            anchors.fill: backgroundItemInner
            horizontalOffset: 3
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: "#80000000"
            source: backgroundItemInner
        }
    }
    contentItem: Item {
        id: contentItem
        implicitWidth: _innerWidth
        implicitHeight: _innerHeight
        
        Image {
            id: userPic
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            width: parent.width
            height: width
            source: userDelegateRoot.icon.source
        }
        
        Text {
            id: userName
            anchors.top: userPic.bottom
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            
            text: userDelegateRoot.text
            font.pixelSize: Style.fontNormalSize
            color: Style.foregroundColor
        }
    }
}
