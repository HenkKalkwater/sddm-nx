// SPDX-FileCopyrightText: 2020 Chris Josten
//
// SPDX-License-Identifier: BSL-1.0

import QtQuick 2.6
import QtQuick.VirtualKeyboard 2.4

InputPanel {
    id: virtualKeyboard
    property bool activated: false
    active: Qt.inputMethod.visible && activated
    //visible: active
}
