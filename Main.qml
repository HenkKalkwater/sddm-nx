import QtQuick 2.7
//import QtGamepad 1.0
import SddmComponents 2.0

import "components"
import "."

Rectangle {
    id: root
    color: "black"
    property LoginPane _userSelector
    property string _user
    property string _password
    
    Repeater {
        model: screenModel
        Image {
            x:      geometry.x
            y:      geometry.y
            width:  geometry.width
            height: geometry.height
            source: Style.background
            Loader {
                Component.onCompleted: console.log("%1, %2, %3 %4".arg(geometry.x).arg(geometry.y).arg(geometry.width).arg(geometry.height))
                anchors.fill: parent
                source: screenModel.primary == index ? "./components/LoginPane.qml" : ""
                onLoaded: {
                    if (screenModel.primary == index) {
                        _userSelector = item
                        _userSelector.userSelected.connect(root.userSelected)
                        _userSelector.closed.connect(root.userClosed)
                        _userSelector.hostname = sddm.hostname
                        console.log("Opening userSelect")
                        //startupAnim.start()
                    }
                }
                onStatusChanged: {
                    if (status == Loader.Error) {
                        console.log("Something went wrong!")
                    }
                }
            }
        }
    }
    
    Dialog {
        id: errorDialog
        anchors.fill: parent
        message: qsTr("Invalid password")
        onClosed: _userSelector.open()
    }
    
    SequentialAnimation {
        id: startupAnim
        running: _userSelector != null
        ColorAnimation {
            target: root
            property: "color"
            from: "black"
            to: "white"
            easing.type: Easing.InOutQuad
            duration: 250
        }
        PauseAnimation {
            duration: 300
        }
        ScriptAction {
            script: _userSelector.open()
        }
    }
    
    Connections {
        target: sddm
        enabled: _userSelector != null
        onLoginFailed: {
            errorDialog.show()
        }
    }
    
    function userSelected(name, password) {
        _user = name
        _password = password
        _userSelector.close()
    }
    
    function userClosed() {
        //errorDialog.show()
        sddm.login(_user, _password, _userSelector.sessionIndex)
    }
}
