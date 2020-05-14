pragma Singleton
import QtQuick 2.0

QtObject {
    property color backgroundColor: "#FF444444"
    property color backgroundColor2: "#FF888888"
    property color foregroundColor: "white"
    
    property color overlayColor: "#cc000000"
    
    property color highlightColor: "#FFAAAAFF"
    property color highlightColor2: "blue"

    property real highlightGap: 1
    property int highlightBorderSize: 8
    
    property real smallPadding: 16
    property real mediumPadding: 32
    property real horizontalPadding: 32
    property real horizontalContentPadding: 64
    
    property int iconSize: 32
    property int fontTitleSize: 32
    property int fontNormalSize: 24
    
    property string background: config.background ? config.background : Qt.resolvedUrl("bg.png")
}
