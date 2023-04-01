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
import Connman 0.2


Application {
    id: app

    centerColor: "#b04d1c"
    outerColor: "#421c0a"

property var passphrase : ""
 	

    
LayerStack {
   	id: layerStack
	firstPage: wifiStatusPage
}    
    
Component {
	id: wifiStatusPage
	Item{
	id:rootM
	
	TechnologyModel {
		id: wifiModel
    	name: "wifi"
    	onCountChanged: {
    		console.log("COUNT CHANGE " + count)
    	}	
    	onScanRequestFinished: {
    		console.log("SCAN FINISH")
    		
    	}	
	}

	NetworkTechnology {
		id: wifiStatus
    	path: "/net/connman/technology/wifi"
	}
	
	IconButton {
		id: wifiIcon
		width: Dims.l(30)
    	height: width
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.top : parent.top
		iconName: "ios-wifi"
		opacity: wifiStatus.powered  ? 0.8 : 0.2
		onClicked:{
        	 wifiStatus.powered = !wifiStatus.powered
        }
	}
	
	Label {
       	id: wifiState 
       	anchors.horizontalCenter: parent.horizontalCenter 
        anchors.top :  wifiIcon.bottom
        textFormat: Text.RichText
        text: wifiStatus.powered ? "Wifi ON" : "Wifi OFF"
        font.pixelSize: Dims.h(10) 
    	horizontalAlignment: Text.AlignHCenter
	}
     Label {
       	id: wifiConnectState
       	anchors.horizontalCenter: parent.horizontalCenter 
        anchors.top :  wifiState.bottom
        textFormat: Text.RichText
        text: wifiStatus.connected ? "Connected" : "Not connected"
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
			layerStack.push(wifiSettingsPage)
 		}
	}
	
	}	
}
	
Component{
	id:passwordPage
	Item{
	id:rootM
		TextField {
			id: passwdField
			anchors.horizontalCenter : parent.horizontalCenter
			anchors.verticalCenter : parent.verticalCenter
			width: Dims.w(80)
			
			previewText: qsTrId("Password")
			inputMethodHints: Qt.ImhLowercaseOnly//Qt.ImhNumbersOnly & Qt.ImhUppercaseOnly  //Qt::ImhLatinOnly
		}
		HandWritingKeyboard {
				anchors.fill: parent
		}
		IconButton {
 			anchors.bottom : parent.bottom
 			anchors.horizontalCenter : parent.horizontalCenter		
 			iconName: "ios-checkmark-circle-outline"
 			onClicked: {
 				passphrase = passwdField.text
 				layerStack.pop(rootM)
 			}
		}
	}
}

Component{
	id: wifiSettingsPage
    Item {
    id: rootM
	
	TechnologyModel {
    	id: wifiModel
    	name: "wifi"
	}
	
	//Part of code from * 
	UserAgent {
        id: userAgent
        onUserInputRequested: {
            var view = {
                "fields": []
            };
            for (var key in fields) {
                view.fields.push({
                	"name": key,
                    "id": key.toLowerCase(),
                    "type": fields[key]["Type"],
                    "requirement": fields[key]["Requirement"]
			});
            console.log(key + ":");
            for (var inkey in fields[key]) {
            	console.log("    " + inkey + ": " + fields[key][inkey]);
            }
            }
            userAgent.sendUserReply({"Passphrase": passphrase})
        }

        onErrorReported: {
            console.log("Got error from model: " + error);
        }
    }
	
	Spinner {
 		id: wifiList
		anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: Dims.h(60)
		model: wifiModel
		delegate: SpinnerDelegate { 
			text: modelData.name
			MouseArea {
        		anchors.fill: parent
        		onClicked: {
        			layerStack.push(passwordPage)
					//modelData.requestConnect()         		
         		}
        	}
		}
	}	
	
	
	
	IconButton {
	 	anchors.top : wifiList.bottom
	 	anchors.horizontalCenter : parent.horizontalCenter		
	 	iconName: "ios-checkmark-circle-outline"
	 	onClicked: {
	       	wifiModel.get(wifiList.currentIndex).requestConnect()
	    }
	}
}
}

}






//*https://raw.githubusercontent.com/nemomobile-ux/glacier-settings/e989b473629e1290ab55f57f166bf36462e99117/src/plugins/wifi/WifiSettings.qml

