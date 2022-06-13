// SPDX-FileCopyrightText: 2020 Chris Josten
//
// SPDX-License-Identifier: BSL-1.0

import QtQuick 2.6
import QtGraphicalEffects 1.6

Item {
    property alias source: image.source
    property alias color: colorOverlay.color
    
    // I thought this should be standard
    implicitWidth: image.implicitWidth
    implicitHeight: image.implicitHeight
    Image {
        id: image
        visible: false
        anchors.fill: parent
        smooth: true
    }
    
    ColorOverlay {
        id: colorOverlay
        anchors.fill: parent
        source: image
    }
}
