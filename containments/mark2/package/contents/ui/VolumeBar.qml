import QtQuick 2.4
import QtQuick.Layouts 1.4

Item {
    id: bar
    property real strength

    Layout.fillWidth: true
    Layout.fillHeight: true

    Rectangle {
        anchors.centerIn: parent
        width: parent.width/3*2
        radius: width
        height: {
            var val = (root.volume * 2) * bar.strength;
            if (val < 0)
                val = 0;
            else if (val > 15)
                val = 15;
            return 36 + 36 * val;
        }
        color: "#40DBB0"
        opacity: {
            if (root.volume < 2)
                return 0.7;
            else if (root.volume < 5)
                return 0.8;
            else if (root.volume < 8)
                return 0.9;
            else
                return 1.0;
        }

        Behavior on height {
            PropertyAnimation {
                property: "height"
                duration: 50
                easing.type: Easing.InOutQuad
            }
        }
    }
}

