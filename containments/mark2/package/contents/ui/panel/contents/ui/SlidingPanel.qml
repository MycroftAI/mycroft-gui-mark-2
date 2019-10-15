/*
 * Copyright 2018 by Marco Martin <mart@kde.org>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.0
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.1
import QtQuick.Window 2.2
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami
import QtQml.StateMachine 1.0 as DSM
import "quicksettings"

PlasmaCore.ColorScope {
    id: root
    Kirigami.Theme.colorSet: Kirigami.Theme.View
    colorGroup: PlasmaCore.Theme.ViewColorGroup

    readonly property real position: 1 - flickable.contentY / root.contentHeight

    readonly property real contentHeight: quickSettings.height + layout.anchors.margins * 2
    state: "closed"

    Rectangle {
        anchors.fill:parent
        color: "black"
        opacity: root.position * 0.8
        visible: root.position > 0
    }

    DSM.StateMachine {
        id: stateMachine
        initialState: closed
        running: true
        DSM.State {
            id: closed
            DSM.SignalTransition {
                targetState: opening
                signal: flickable.openRequested
            }
            onEntered: root.state = "closed"
        }
        DSM.State {
            id: opening
            DSM.TimeoutTransition {
                targetState: open
                timeout: Kirigami.Units.longDuration + 1
            }
            onEntered: root.state = "opening"
        }
        DSM.State {
            id: open
            DSM.SignalTransition {
                targetState: closed
                signal: flickable.closeRequested
            }
            onEntered: root.state = "open"
        }
    }

    states: [
        State {
            name: "dragging"
           // when: flickable.dragging || flickable.flicking
            PropertyChanges {
                target: flickable
                contentY: flickable.contentY
            }
        },
        State {
            name: "closed"
            PropertyChanges {
                target: flickable
                contentY: root.contentHeight
            }
        },
        State {
            name: "opening"
            PropertyChanges {
                target: flickable
                contentY: 0
            }
        },
        State {
            name: "open"
            PropertyChanges {
                target: flickable
                contentY: Math.min(flickable.contentY, root.contentHeight - root.height)
            }
        }
    ]
    transitions: Transition {
        NumberAnimation {
            target: flickable
            property: "contentY"
            duration: Kirigami.Units.longDuration
        }
    }

    Flickable {
        id: flickable
        anchors.fill: parent

        boundsBehavior: Flickable.StopAtBounds
        contentWidth: width
        contentHeight: flickableContents.implicitHeight

        signal openRequested
        signal closeRequested

        onFlickStarted: movementStarted()
        onFlickEnded: movementEnded()
        onMovementStarted: root.state = "dragging"
        onMovementEnded: {
            if (open.active && contentY <= root.contentHeight - root.height / 2) {print("primo caso")
                root.state = "open"
            } else if (contentY > root.contentHeight - root.height / 2) {print("close")
                closeRequested();
                root.state = "closed";
            } else {print("open")
                openRequested();
            }
        }
        MouseArea {
            id: flickableContents
            width: parent.width
            implicitHeight: layout.implicitHeight + layout.anchors.margins * 2

            ColumnLayout {
                id: layout
                spacing: 0

                anchors {
                    fill: parent
                    margins: Kirigami.Units.largeSpacing * 2
                }
                QuickSettings {
                    id: quickSettings
                    Layout.fillWidth: true
                    onDelegateClicked: root.close();
                }
                Item {
                    Layout.minimumHeight: root.height
                }
            }
        }
    }
}

