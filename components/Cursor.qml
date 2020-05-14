import QtQuick 2.6
import ".."

Rectangle {
    id: highlightItem
    property Item target
    
    anchors.centerIn: parent
    implicitWidth: target.width + Style.highlightGap
    implicitHeight: target.height + Style.highlightGap
    color: "#00000000"
    radius: 3
    border.width: Style.highlightBorderSize - 2 * Style.highlightGap
    border.color: Style.highlightColor
    SequentialAnimation on border.color {
        loops: Animation.Infinite
        ColorAnimation {
            from: Style.highlightColor
            to: Style.highlightColor2
            easing.type: Easing.InQuad
            duration: 3000
        }
        ColorAnimation {
            from: Style.highlightColor2
            to: Style.highlightColor
            easing.type: Easing.OutQuad
            duration: 3000
        }
    }
}
