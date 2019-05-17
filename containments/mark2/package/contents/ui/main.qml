/*
 *  Copyright 2019 Marco Martin <mart@kde.org>
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

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.0 as Controls

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.5 as Kirigami

import org.kde.plasma.private.volume 0.1 as PA

import "./panel/contents/ui" as Panel

import Mycroft 1.0 as Mycroft
import Mycroft.Private.Mark2SystemAccess 1.0

Item {
    id: root
    width: 480
    height: 640

//BEGIN properties
    property Item toolBox
    readonly property bool smallScreenMode: Math.min(width, height) < Kirigami.Units.gridUnit * 18

//END properties

//BEGIN slots
    Component.onCompleted: {
        Mycroft.MycroftController.start();
    }

    Timer {
        interval: 10000
        running: Mycroft.MycroftController.status != Mycroft.MycroftController.Open
        onTriggered: {
            print("Trying to connect to Mycroft");
            Mycroft.MycroftController.start();
        }
    }

    
//END slots

    Rectangle {
        anchors.fill: parent
        z: mainParent.z + 1
        // Avoid hiding everything completely
        color: Qt.rgba(0, 0, 0, (1 - plasmoid.configuration.fakeBrightness) * 0.8)
    }

    MouseArea {
        id: mainParent

        rotation: {
            switch (plasmoid.configuration.rotation) {
            case "CW":
                return 90;
            case "CCW":
                return -90;
            case "UD":
                return 180;
            case "NORMAL":
            default:
                return 0;
            }
        }
        anchors.centerIn: parent
        width: rotation == 0 || rotation == 180 ? parent.width : parent.height
        height: rotation == 0 || rotation == 180 ? parent.height : parent.width

        property int startMouseY: -1
        property int startVolume: -1
        preventStealing: false;

        drag.filterChildren: true
        drag.target: skillView

        onPressed: {
            if (networkingArea.visible) {
                return;
            }
            startVolume = volSlider.value
            startMouseY = mouse.y
        }
        onPositionChanged: {
            if (networkingArea.visible) {
                return;
            }
            var delta = startMouseY - mouse.y;
            if (Math.abs(delta) > Kirigami.Units.gridUnit*2) {
                mainParent.preventStealing = true
            }
            if (mainParent.preventStealing) {
                var volume = Math.max(0, Math.min(1, startVolume + (delta/height)))
                Mycroft.MycroftController.sendRequest("mycroft.volume.set", {"percent": volume});
                feedbackTimer.running = true;
                volSlider.show();
            } else {
                mouse.accepted = false;
            }
        }
        onReleased: mainParent.preventStealing = false;
        onCanceled: mainParent.preventStealing = false;
        

//BEGIN PulseAudio
        PA.SinkModel {
            id: paSinkModel
        }
        PA.VolumeFeedback {
            id: feedback
        }
        Timer {
            id: feedbackTimer
            interval: 250
            onTriggered: feedback.play(paSinkModel.preferredSink.index);
        }
        VolumeFeedbackGraphics {
            id: volSlider
        }
//END PulseAudio

//BEGIN VirtualKeyboard
        VirtualKeyboardLoader {
            id: virtualKeyboard
            z: 1000
        }
//END VirtualKeyboard

        AnimatedImage {
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height)
            height: width
            fillMode: Image.PreserveAspectFit
            source: "thinking.gif";
        }

        Panel.SlidingPanel {
            id: panel
            z: 999
            width: mainParent.width
            height: mainParent.height
            edge: {
                switch (mainParent.rotation) {
                case -90:
                    return Qt.LeftEdge;
                case 90:
                    return Qt.RightEdge;
                case 180: return Qt.BottomEdge;
                case 0:
                default:
                    return Qt.TopEdge;
                }
            }
            //HACK for rotation
            contentItem.rotation: mainParent.rotation
            contentItem.transform: Translate {
                x: root.width/2 - panel.contentItem.width/2
                y: root.height/2 - panel.contentItem.height/2
            }
            dragMargin: Kirigami.Units.gridUnit * 2
            dim: true
        }
        Rectangle {
            z: 998
            anchors.fill:parent
            color: "black"
            opacity: panel.position * 0.8
            visible: panel.position > 0
        }

        Mycroft.SkillView {
            id: skillView
            anchors.fill: parent
            Kirigami.Theme.colorSet: Kirigami.Theme.Complementary

            bottomPadding: virtualKeyboard.state == "visible" ? virtualKeyboard.height : 0
        }

        Controls.Button {
            anchors.centerIn: parent
            text: "start"
            visible: Mycroft.MycroftController.status == Mycroft.MycroftController.Closed
            onClicked: Mycroft.MycroftController.start();
        }

        Rectangle {
            id: networkingArea
            anchors.fill: parent

            visible: Mark2SystemAccess.networkConfigurationVisible

            Kirigami.Theme.inherit: false
            Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
            color: Kirigami.Theme.backgroundColor

            PlasmaCore.ColorScope {
                anchors {
                    fill: parent
                    bottomMargin: virtualKeyboard.state == "visible" ? virtualKeyboard.height : 0
                }
                colorGroup: PlasmaCore.Theme.ComplementaryColorGroup

                NetworkingLoader {
                    id: networkingLoader
                    anchors.fill: parent
                }
            }
        }
    }
}
