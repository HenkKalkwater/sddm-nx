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
        
        TextField {
            focus: true
            //anchors.top: parent.top
            property real _vkeyboardOffset: Qt.inputMethod.visible 
                ? root.height - Qt.inputMethod.keyboardRectangle.top : 0
            y: (parent.height - _vkeyboardOffset) / 2 - height / 2
            Behavior on y { NumberAnimation { duration: 100 }}
            
            anchors.left: parent.left
            anchors.right: parent.right
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
}
