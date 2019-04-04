/*
 * Copyright 2018 by Aditya Mehra <aix.m@outlook.com>
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

import QtQuick.Layouts 1.4
import QtQuick 2.4
import QtQuick.Controls 2.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.kirigami 2.5 as Kirigami
import org.kde.plasma.networkmanagement 0.2 as PlasmaNM

import Mycroft.Private.Mark2SystemAccess 1.0

Rectangle {
    id: networkSelectionView

    anchors.fill: parent

    Kirigami.Theme.inherit: false
    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
    color: Kirigami.Theme.backgroundColor

    property string pathToRemove
    property string nameToRemove
    property bool isStartUp: false

    function removeConnection() {
        handler.removeConnection(pathToRemove)
    }

    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
    }

    PlasmaNM.Handler {
        id: handler
    }

    PlasmaNM.AvailableDevices {
        id: availableDevices
    }

    PlasmaNM.NetworkModel {
        id: connectionModel
    }

    PlasmaNM.AppletProxyModel {
        id: appletProxyModel
        sourceModel: connectionModel
    }

    PlasmaCore.ColorScope {
        anchors.fill: parent
        colorGroup: PlasmaCore.Theme.ComplementaryColorGroup
        Kirigami.Theme.colorSet: Kirigami.Theme.Complementary

        ColumnLayout {
            spacing: 0
            anchors {
                fill: parent
                margins: Kirigami.Units.largeSpacing
            }


            Kirigami.Heading {
                id: connectionTextHeading
                level: 1
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
                font.bold: true
                text: i18n("Select Your Wi-Fi")
                color: Kirigami.Theme.highlightColor
            }
            Item {
                Layout.preferredHeight: Kirigami.Units.largeSpacing
            }

            Kirigami.Separator {
                Layout.preferredHeight: 1
                Layout.fillWidth: true
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ListView {
                    id: connectionView

                    model: appletProxyModel
                    currentIndex: -1
                    //boundsBehavior: Flickable.StopAtBounds
                    delegate: NetworkItem{}
                }
            }

            Kirigami.Separator {
                Layout.preferredHeight: 1
                Layout.fillWidth: true
            }

            Item {
                Layout.preferredHeight: Kirigami.Units.largeSpacing
            }

            RowLayout {
                Button {
                    Kirigami.Theme.inherit: false
                    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
                    icon.name: "go-previous-symbolic"
                    flat: true
                    onClicked: Mark2SystemAccess.networkConfigurationVisible = false;
                }
                Item {
                    Layout.fillWidth: true
                }
                Button {
                    Kirigami.Theme.inherit: false
                    Kirigami.Theme.colorSet: Kirigami.Theme.Complementary
                    icon.name: "view-refresh"
                    text: i18n("Refresh")
                    flat: true
                    onClicked: handler.requestScan();
                }
            }
        }
    }

    Kirigami.OverlaySheet {
        id: networkActions
        parent: networkSelectionView

        contentItem: ColumnLayout {
            implicitWidth: Kirigami.Units.gridUnit * 25

            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true
                wrapMode: Text.WordWrap
                text: i18n("Are you sure you want to forget the network %1?", nameToRemove)
            }
            RowLayout {
                Button {
                    Layout.fillWidth: true
                    text: i18n("Forget")

                    onClicked: {
                        removeConnection()
                        networkActions.close()
                    }
                }
                Button {
                    Layout.fillWidth: true
                    text: i18n("Cancel")

                    onClicked: {
                        networkActions.close()
                    }
                }
            }
        }
    }
}
