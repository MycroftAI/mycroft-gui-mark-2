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
import QtQuick.Controls 2.2 as Controls

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.kirigami 2.5 as Kirigami

import Mycroft 1.0 as Mycroft


Rectangle {
    id: root
    color: "black"
    visible: Mycroft.MycroftController.listening
    property int volume: Mycroft.MycroftController.listeningVolume

    // Block input to whatever is behind

    MouseArea {
        anchors.fill: parent
    }

    RowLayout {
        id: frame1
        anchors.centerIn: parent
        //Spacing is faked by items black space
        spacing: 0
        // Dynamic sizing of 4/6 of the screen size
        width: Math.min(root.width, root.height)/6 * 4
        height: width
        visible: true

        VolumeBar {
            strength: 0.5
        }
        VolumeBar {
            strength: 0.75
        }
        VolumeBar {
            strength: 1
        }
        VolumeBar {
            strength: 0.75
        }
        VolumeBar {
            strength: 0.5
        }
    }

    states: [
        State {
            when: Mycroft.MycroftController.listening
            PropertyChanges {
                target: root
                visible: true
                opacity: 1
            }
        },
        State {
            when: !Mycroft.MycroftController.listening
            PropertyChanges {
                target: root
                opacity: 0
                visible: false
            }
        }
    ]
    transitions: Transition {
        OpacityAnimator {
            duration: Kirigami.Units.longDuration
            easing.type: Easing.InOutQuad
        }
    }
}
