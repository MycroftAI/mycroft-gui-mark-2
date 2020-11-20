import QtQuick 2.9
import QtAV 1.7
        
Rectangle {
    color: "black"
    
    AVPlayer {
        id: player
        loops: MediaPlayer.Infinite
        source: "assets/mycroft-logo-animated.mp4"
        
        onStopped: {
            player.play()
        }
   }

    VideoOutput2 {
        id: video
        opengl: true
        width: 800
        height: 480
        anchors.centerIn: parent
        fillMode: VideoOutput.PreserveAspectCrop
        source: player
        
        Keys.onSpacePressed: {
            player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play()
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                player.playbackState == MediaPlayer.PlayingState ? player.pause() : player.play()
            }
        }
    }
    
    Component.onCompleted: {
        player.play()
    }
}
