/*
 * Copyright (C) 2019 Florent Revest <revestflo@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import org.asteroid.controls 1.0
import org.asteroid.utils 1.0
import QtQuick.VirtualKeyboard 2.0
import QtQuick.VirtualKeyboard.Settings 2.15

import Wifi 1.0

Application {
    id: app

    centerColor: "#b04d1c"
    outerColor: "#421c0a"

	property int ssid : 0	
	property var db : ""
 	property var datasize : 0 
 	property var database:[]
 	property var status : wifi.wifiStatus()
 	property var connectStatus: wifi.wifiConnectStatus()
 	
Wifi{
 		id:wifi
 	}


 	
function readData() {
		database = []
	   	var list = db.split(";")
	   	var len = list.length-1
	   	var x = 0;
		for (var j = 0; j < len; ++j) {
			var tmp = list[j].split(":");
			database.push({"name":tmp[0], "address":tmp[1]})  			
		}   	
		datasize = database.length
		
	} 	
    
LayerStack {
   		id: layerStack
		firstPage: statusPage

	}    
    
Component {
	id:scanPage
	Item {	
    Spinner {
 		id: wifiList
		anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Dims.h(60)
		model: datasize
		delegate: SpinnerDelegate { text: database[index].name}
	}
	IconButton {
		width: Dims.l(30)
    	height: width
		anchors { 
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: Dims.iconButtonMargin
        }
		iconName: "ios-add-circle-outline"
		onClicked: { 
 			ssid = wifiList.currentIndex	
 			layerStack.push(passwordPage)
 		}
	}
	}

}
	
Component {
	id:statusPage
	Item{
	IconButton {
		id: wifiIcon
		width: Dims.l(30)
    	height: width
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top : parent.top
		iconName: "ios-wifi"
		opacity: status ? 0.8 : 0.2
		onClicked:{
       		status = !status
        	wifi.wifiEnable(status) 
        }
	}
	
	Label {
       	id: wifiStatus 
       	anchors.horizontalCenter: parent.horizontalCenter 
        anchors.top :  wifiIcon.bottom
        textFormat: Text.RichText
        text: status ? "Wifi ON" : "Wifi OFF"
        font.pixelSize: Dims.h(10) 
    	horizontalAlignment: Text.AlignHCenter
	}
     Label {
       	id: wifiConnectState
       	anchors.horizontalCenter: parent.horizontalCenter 
        anchors.top :  wifiStatus.bottom
        textFormat: Text.RichText
        text: connectStatus ? "Connected" : "Not connected"
        font.pixelSize: Dims.h(8) 
    	horizontalAlignment: Text.AlignHCenter
	}   
	IconButton {
		width: Dims.l(25)
    	height: width
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top : wifiConnectState.bottom
		iconName: "ios-add-circle-outline"
		onClicked: { 
 			db = wifi.wifiScan()
 			readData()		
 			layerStack.push(scanPage)
 		}
	}
	
	}	
	}
	
Component{
	id:passwordPage
	Item{
		TextField {
			id: passwdField
			anchors.horizontalCenter : parent.horizontalCenter
			anchors.verticalCenter : parent.verticalCenter
			width: Dims.w(80)
			previewText: qsTrId("Password")
			inputMethodHints: Qt.ImhNumbersOnly & Qt.ImhUppercaseOnly  //Qt::ImhLatinOnly
		}
		HandWritingKeyboard {
				anchors.fill: parent
		}
		IconButton {
 			anchors.bottom : parent.bottom
 			anchors.horizontalCenter : parent.horizontalCenter		
 			iconName: "ios-checkmark-circle-outline"
 			onClicked: {
 				wifi.wifiConnect(database[ssid],passwdField.text)
 				layerStack.pop(statusPage)
 			}
		}
	}
}
	
	
}

    
	
