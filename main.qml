import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtQuick.Extras.Private 1.0
import QtCharts 2.1
import "controls"

import QtQuick 2.9
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Window {
	id: root
	visible: true
	width: 1400
	height: 880
	title:"PRAKTIKUM SISTEM KENDALI SEDERHANA"
	color:"#141428"//"#2a2f30" 
	property bool fullscreen: false
	//flags: Qt.WindowFullScreen // Qt.Dialog 
	//visibility: "FullScreen"
	
	property color state_color: "#F23D4C" // Definisikan variabel warna
	
	property string mode: "OL"
	property string ol_mode: "analog"
	property string ol_signal: "0"
	property string cl_mode: "on_off"
	
	
	Image{
		  width :100
		  height : 100
          x:20
          y:20         
          source:"upi.png"
		  
	}
	
	
	Image{
		  width :150
		  height : 75
          x:700
          y:30         
          source:"praktisi mengajar.png"
		  
	}
	
	
	Text {
					
					//anchors.horizontalCenter: parent.horizontalCenter
					x: 150
					y : 30
					
					text: "PRAKTIKUM SISTEM KENDALI SEDERHANA"
					font.family: "Helvetica"
					font.pointSize: 20
					color: "#04f4fc"
				}
				
	Text {
					
					//anchors.horizontalCenter: parent.horizontalCenter
					x: 280
					y : 70
					
					text: "MKB - UPI PURWAKARTA"
					font.family: "Helvetica"
					font.pointSize: 15
					color: "#04f4fc"
				}

	
				
				
	
	Text {
					
					//anchors.horizontalCenter: parent.horizontalCenter
					x: 50
					y : 550
					
					text: "SUPPORTED BY :"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
					visible : false
				}
	
	
	Image{
		  width :80
		  height : 80
          x:50
          y:580         
          source:"kelasrobot.png"
		  visible : false
		  
	}
	
	Image{
		  width :120
		  height : 120
          x:180
          y:570         
          source:"ardumeka.png"
		  visible : false
		  
	}
	
	
	
	Text {
					
					//anchors.horizontalCenter: parent.horizontalCenter
					x: 50
					y : 670
					
					text: "KELAS ROBOT"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
					visible : false
				}
	
	
	
	
	
	
	Rectangle{
		x : 900
		y : 0
		width : 350
		height : 200
		color : "transparent"
		visible : true
		border.color: "#04f4fc"
        border.width: 1
	
	
	
	
	
	Text {
					x : 30
					y : 10
					
					text: "ARDUINO PORT :"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}
				
				
	ComboBox {
		id : cb1
		x: 30
		y : 40

	}
	
	
	Text {
					x : 30
					y : 100
					
					text: "BAUD RATE :"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}
				
				
	ComboBox {
		id : cb2
		x: 30
		y : 130
		model: ['9600', '115200']
	}
	
	Text {
					x : 200
					y : 40
					
					text: "CONNECTION :"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}
	
	Button {
		id: connect
		x :210
		y :80
		width : 100
		height : 100
		text: ""
		font.pixelSize : 20
		
		Rectangle{
			id:connect_color
			width : parent.width
			height: parent.height
			color:"#172026"
			
			Image{
			width : parent.width
			height : parent.height
			source : "connect logo.png"
			
			}
			
			
		}
		
		
		palette {
      		button: "transparent"
			buttonText: "black"
		}
		
		onClicked:{
			if(connect_color.color == "#172026"){
				connect_color.color = "#e66b22"
				backend.connection("connected")
				backend.port_number(cb1.currentText)
				console.log(cb1.currentText)
			}else
				if(connect_color.color == "#e66b22"){
				connect_color.color = "#172026" 
				backend.connection("disconnected")
				}
		}
			
			
	}
	
	
	
	
	
	
	}


Text {
					x : 20
					y : 580
					
					text: "SYSTEM :"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}	
	
	
Button {
		id: bt00
		x :20
		y :600
		height : 90
		text: "RUN"
		checkable : true
		
		onClicked:{
			
			if(bt00.checked == true){
				backend.action("run")
				text = "STOP";
				
				
			} else
				backend.action("stop")
				text = "run";
				
				
				
		}
		
		palette { 
		button: "#04f4fc"
		buttonText: "black"		
		}
		
	}


Button {
		id : record_button
		x :500
		y :650
		text: "RECORD"
		checkable : true
		
		
		palette { 
		button: "#04f4fc"
		buttonText: "black"		
		}
		
		onClicked:{
			backend.filename((file.text), (record_button.checked))
		
		}
		
}

Text {
					x : 320
					y : 580
					text: "MODE"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}


Text {
					x : 200
					y : 610
					text: "OPEN LOOP"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}

	CustomSwitch{
		id: ledSwitch1
		x:300
		y:600
		backgroundHeight: 25
		backgroundWidth: 75
		
		onSwitched:{
			
			if(on == true){
				block_diagram.source = "CL.png"
				state_color = "#16FF00"
				mode = "CL"
				
				ol_properties.visible = false
				cl_properties.visible = true
				
				}
			else{
				mode = "OL"
				block_diagram.source= "OL.png"
				state_color = "#F23D4C"
				
				cl_properties.visible = false
				ol_properties.visible = true
			}
			
				backend.mode(mode)
			
			}
		
		}
		
			Text {
					x : 380
					y : 610
					text: "CLOSE LOOP"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}

			Text {
					x : 200
					y : 660
					text: "FILE :"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}
				
			TextField {
					id : file
					x : 250
					y : 650
					text: "record"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "black"
				}
	
	
	
	
	
Button {
		id: clear_buffer
		x :200
		y :500
		visible : false
		text: "clear buffer"
		onClicked:{
			backend.clear_buffer("yes")
			}
		palette { 
		button: "#04f4fc"
		buttonText: "black"		
		}	
		
	}

		
	
	
	Rectangle {
	id: radialbox
	x: 660
	y: 150
	visible: true
	width: 120
	height: 120
	color:"transparent"
	
	
	
	
	Text {
					anchors.horizontalCenter: parent.horizontalCenter
					y : 120
					
					text: "SETPOINT VALUE (SP)"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#04f4fc"
				}
	
	CircularSlider {
                id : slider1
				value : 36
                width: parent.width
                height: parent.height
                startAngle: 40
                endAngle: 320
                rotation: 180
                trackWidth: 4
                progressWidth: 17
                minValue: min_sp.text
                maxValue: max_sp.text
                progressColor: "#04f4fc"
				interactive: true
                capStyle: Qt.FlatCap

                handle: Rectangle {
                    transform: Translate {
                        x: (slider1.handleWidth - width) / 2
                        y: slider1.handleHeight / 2
                    }

                    width: 10
                    height: slider1.height / 2
                    color: "#FFac89"
                    radius: width / 2
                    antialiasing: true
                }

                Label {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -40
                    rotation: 180
                    font.pointSize: 22
                    color: "#04f4fc"
                    text: Number(slider1.value).toFixed(1)
                }
            }
	
	
	TextInput {
					//anchors.horizontalCenter: parent.horizontalCenter
					id : min_sp
					x : -10
					y : 100
					
					text: "0"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#04f4fc"
				}
				
	TextInput {
					//anchors.horizontalCenter: parent.horizontalCenter
					id : max_sp
					x : 120
					y : 100
					
					text: "50"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#04f4fc"
				}
	}
	
	
	Rectangle {
	x: 660
	y: 290
	id: radialbox2
	visible: true
	width: 120
	height: 120
	color:"transparent"
	
	Text {
					anchors.horizontalCenter: parent.horizontalCenter
					y : 120
					
					text: "CONTROL SIGNAL (R(S))"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#F23D4C"
				}
	
	
	
	CircularSlider {
                id: radial2
				value : 40
                width: parent.width
                height: parent.height
                startAngle: 40
                endAngle: 320
                rotation: 180
                trackWidth: 5
                progressWidth: 17
                minValue: 0
                maxValue: 100
                progressColor: "#F23D4C"
				interactive: false
                capStyle: Qt.FlatCap

                handle: Rectangle {
                    transform: Translate {
                        x: (radial2.handleWidth - width) / 2
                        y: radial2.handleHeight / 2
                    }

                    width: 10
                    height: radial2.height / 2
                    color: "#FFac89"
                    radius: width / 2
                    antialiasing: true
                }

                Label {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -40
                    rotation: 180
                    font.pointSize: 26
                    color: "#F23D4C"
                    text: Number(radial2.value).toFixed()
                }
            }
	
	}
	
	
	Rectangle {
	x: 670
	y: 580
	id: error_rect
	visible: true
	width: 100
	height: 100
	color:"transparent"
	radius : width/2
	border.width : 2
	border.color : "#FFB91A"
	
	Label {
                    anchors.centerIn: parent
                    rotation: 0
                    font.pointSize: 26
                    color: "#FFB91A"
                    text: (Number(slider1.value) - Number(gauge2.value)).toFixed(1)
                }
	
	Text {
					anchors.horizontalCenter: parent.horizontalCenter
					y : 105
					
					text: "ERROR (e)"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#FFB91A"
				}
	
	
	}
	
	
	Rectangle{
			x: 850
			y: 210
			color : "transparent"
			width : 400
			height : 200
			anchors.leftMargin : 237.5
			anchors.bottomMargin : 50
			visible : true
			border.width : 1
			border.color : "#04f4fc"
			
			Image {
			id : block_diagram
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			height : parent.height - 4
			width : parent.width - 4
			source : "OL.png"
			}
			
			
			
	
	}
	
	Rectangle{
			id : ol_properties
			x: 850
			y: 420
			color : "transparent"
			width : 400
			height : 270
			anchors.leftMargin : 237.5
			anchors.bottomMargin : 50
			visible : true
			border.width : 1
			border.color : "#04f4fc"
			
			Text {
					anchors.horizontalCenter: parent.horizontalCenter
					y : 10
					
					text: "OPENLOOP PROPERTIES"
					font.family: "Helvetica"
					font.pointSize: 12
					color: state_color
				}
				
				
			Text {
					x : 90
					y : 55
					
					text: "ANALOG"
					font.family: "Helvetica"
					font.pointSize: 12
					color: state_color
				}
				
		Text {
					x : 250
					y : 55
					
					text: "DIGITAL"
					font.family: "Helvetica"
					font.pointSize: 12
					color: state_color
				}
				
		Text {
					x : 10
					y : 85
					
					text: "R(s)"
					font.family: "Helvetica"
					font.pointSize: 14
					color: state_color
				}
				
		Slider{
			id : analog
			x : 20
			y : 120
			from : 0
			to : 100
			width : 300
			visible : true
			onValueChanged:{
				ol_signal = (analog.value).toString()
			}
			
			Text {
					x : 310
					y : 5
					
					text: (analog.value).toFixed()
					font.family: "Helvetica"
					font.pointSize: 14
					color: state_color
				}
			
		}
		
		
		Button{
			id : digital
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			text : "0"
			checkable : true
			visible : false
			
			onClicked:{
				if(digital.checked == true){
					digital.text = "100"
					ol_signal = "100"
				}else {
					digital.text = "0"
					ol_signal = "0"
				}
			
			}
		
		}
		
		
		CustomSwitch{
		id: lamp
		anchors.horizontalCenter: parent.horizontalCenter
		y:50
		backgroundHeight: 25
		backgroundWidth: 75
		
		onSwitched:{
			
			if(on == true){
				ol_mode = "digital"
				digital.visible = true
				analog.visible = false
				
				
				
				}
			else{
				ol_mode = "analog"
				digital.visible = false
				analog.visible = true
				
			}
			
			backend.ol_mode(ol_mode)
			}
		
		}
				
	}
	
	
	Rectangle{
			id : cl_properties
			x: 850
			y: 420
			color : "transparent"
			width : 400
			height : 270
			anchors.leftMargin : 237.5
			anchors.bottomMargin : 50
			visible : false
			border.width : 1
			border.color : "#04f4fc"
			
			Text {
					anchors.horizontalCenter: parent.horizontalCenter
					y : 10
					
					text: "CONTROLLER PROPERTIES"
					font.family: "Helvetica"
					font.pointSize: 12
					color: state_color
				}
		
		Text {
					x : 100
					y : 55
					
					text: "ON/OFF"
					font.family: "Helvetica"
					font.pointSize: 12
					color: state_color
				}
				
		Text {
					x : 250
					y : 55
					
					text: "PID"
					font.family: "Helvetica"
					font.pointSize: 12
					color: state_color
				}
		
		
		CustomSwitch{
		id: ledSwitch2
		anchors.horizontalCenter: parent.horizontalCenter
		y:50
		backgroundHeight: 25
		backgroundWidth: 75
		
		onSwitched:{
			
			if(on == true){
				cl_mode = "pid"
				
				
				}
			else{
				cl_mode = "on_off"
				
			}
			
			backend.cl_mode(cl_mode)
			}
		
		}
		
		Text {
					x : 10
					y : 100
					text: "Kp : "
					font.family: "Helvetica"
					font.pointSize: 15
					color: state_color
				}
				
		TextField {
					id: kp
					x : 50
					y : 95
					text: "0"
					font.family: "Helvetica"
					font.pointSize: 15
					height : 40
					width : 100
					
				}
				
		Text {
					x : 170
					y : 100
					text: "Ki : "
					font.family: "Helvetica"
					font.pointSize: 15
					color: state_color
				}
				
		TextField {
					id: ki
					x : 210
					y : 90
					font.family: "Helvetica"
					height : 40
					width : 100
					font.pointSize: 15
					text: "0"
					
					
				}
				
		Text {
					x : 10
					y : 160
					text: "Kd : "
					font.family: "Helvetica"
					font.pointSize: 15
					color: state_color
					
					
				}
				
		TextField {
					id: kd
					x : 50
					y : 155
					
					font.family: "Helvetica"
					font.pointSize: 15
					height : 40
					width : 100
					text: "0"
					
				}
				

				
		Slider{
		id : t_val
		x : 50
		y : 210
		width : 150
		from : 200
		to : 2000
		
		visible : false
		Text{
		y : 5
		x : 160
		text : (t_val.value).toFixed() + "ms"
		font.family: "Helvetica"
		font.pointSize: 15
		color: state_color
		
		}
		
		}
		
		Button{
		x :200
		y :150
		width : 100
		height : 50
		text: "RESET"
		
		palette {
      		button: state_color
			buttonText: "black"
		}
		}
		
		Button{
		id : save_setting
		x :290
		y :210
		width : 100
		height : 50
		text: "save setting"
		
		palette {
      		button: state_color
			buttonText: "black"
		}
		
		onClicked:{
		backend.setP_control(kp.text)
		backend.setI_control(ki.text)
		backend.setD_control(kd.text)
		//backend.time_sampling(t_val.value)
		
		
		}
		
		}
			
			
	
	}
	
	
	Rectangle {
		id:rect2
		x: 660
		y: 440
		
		width: 120
		height: 120
		color: "transparent"
		
		Text {
					anchors.horizontalCenter: parent.horizontalCenter
					y : 120
					
					text: "SENSOR VALUE (PV & C(S))"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#16FF00"
				}

		CircularSlider {
                id: gauge2
				value  :22.5
                width: parent.width
                height: parent.height
                startAngle: 40
                endAngle: 320
                rotation: 180
                trackWidth: 5
                progressWidth: 17
                minValue: min_sensor.text
                maxValue: max_sensor.text
                progressColor: "#16FF00"
				interactive: false
                capStyle: Qt.FlatCap

                handle: Rectangle {
                    transform: Translate {
                        x: (gauge2.handleWidth - width) / 2
                        y: gauge2.handleHeight / 2
                    }

                    width: 10
                    height: gauge2.height / 2
                    color: "#FFac89"
                    radius: width / 2
                    antialiasing: true
                }

                Label {
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: -40
                    rotation: 180
                    font.pointSize: 16
                    color: "#16FF00"
                    text: Number(gauge2.value).toFixed(2)
                }
            }
			
			
		TextInput {
					//anchors.horizontalCenter: parent.horizontalCenter
					id : min_sensor
					x : -10
					y : 100
					
					text: "0"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#16FF00"
				}
				
	TextInput {
					//anchors.horizontalCenter: parent.horizontalCenter
					id : max_sensor
					x : 120
					y : 100
					
					text: "50"
					font.family: "Helvetica"
					font.pointSize: 10
					color: "#16FF00"
				}
	
	
	}
	
	
	Rectangle {
            id: chart1
            x: 10
            y: 150
            width: 630
            height: 400
            visible: true
            color: "transparent"
			border.width : 1
			border.color : "#04f4fc"
			
			
			
            ChartView {
				x : -20
                id: cv
                height: parent.height
				width : parent.width
                property double valueCH3: 0
                property double valueCH2: 0
                //theme: ChartView.ChartThemeDark
                property double valueCH4: 0
                title: ""
                legend.visible: false
                property double startTIME: 0
                property int timcnt: 0
                property double periodGRAPH: 30 //30
                property double intervalTM: 200 //200
                //anchors.fill: parent
				backgroundColor:"transparent"
                
				ValueAxis {
                    id: yAxis
                    max: top_chart.text
                    min: down_chart.text
                    //labelFormat: "%d"
                    tickCount: 1
					labelsColor: "#04f4fc"
                }
				
				
				ValueAxis {
                    id: yAxis1
                    max: 50
                    min: 20
                    //labelFormat: "%d"
                    tickCount: 1
					labelsColor: "#04f4fc"
				}
				
				
				
				LineSeries {
					
                    id: lines1
                    name: "SETPOINT"
                    width: 1
                    color: "#04f4fc"
                    axisX: DateTimeAxis {
                        id: eje
                        format: "HH:mm:ss"
                        visible:true
						labelsColor: "#04f4fc"
                    }
                    axisY: yAxis
                }
				
				
                LineSeries {
                    id: lines2
                    name: "HEAT"
                    width: 1
                    color: "#16FF00"
                    axisX: eje
                    axisY: yAxis
					
                }
				
                property double valueCH1: 0
                antialiasing: true
            }
			
			
			TextInput {
				id : top_chart
				x : 580
				y : 20
				font.family: "Helvetica"
				font.pointSize: 15
				color: state_color
				text : "40"
			
			}
			
			TextInput {
				id : down_chart
				x : 580
				y : 330
				font.family: "Helvetica"
				font.pointSize: 15
				color: state_color
				text : "19"
			
			}
            
		}
	
	
	Text {
					x : 1000
					y : 700
					
					text: "Written by : Muhammad Husni"
					font.family: "Helvetica"
					font.pointSize: 12
					color: "#04f4fc"
				}
	
	Button{
			id : detailed
			x : 500
			y : 600
			text : "detailed graph"
			checkable : true
			visible : true
			
			onClicked:{
				if(detailed.checked == true){
					pid_graph.visible = true
				}else {
					pid_graph.visible = false
				}
			
			}
		
		}
	
	
	Rectangle{
			id : pid_graph
			x: 850
			y: 0
			color : "transparent"
			width : 400
			height : 725
			anchors.leftMargin : 237.5
			anchors.bottomMargin : 50
			visible : false
			border.width : 1
			border.color : "#04f4fc"
			
	}
	
	

	
	
	
	Component.onCompleted: {
		cv.startTIME = backend.get_tiempo()*1000
		
	}
	
	
	onClosing: {
		backend.connection("disconnected")
        console.log("Window is closing")
    }
	
	
	
	
	Timer{
		id:guitimer
		interval: 20
		repeat: true
		running: true
		onTriggered: {
			gauge2.value = backend.sensor_val_read()
			cb1.model = backend.port_val_read()
			backend.mode(mode)
			backend.cl_mode(cl_mode)
			
			backend.ol_mode(ol_mode)
			backend.ol_signal(ol_signal)
			
			backend.setpoint(slider1.value)
			
			radial2.value = backend.control_signal()
			
		}
		
		
	}
	
	
	
	Timer {
                id: tm
                repeat: true
				interval : cv.intervalTM
                running: true
                onTriggered: {
                        cv.timcnt = cv.timcnt + 1
                        //cv1.timcnt = cv1.timcnt + 1
                        cv.valueCH1 = parseFloat(slider1.value)
                        cv.valueCH2 = parseFloat(gauge2.value)
                        //cv3.valueCH1 = radial5.value//parseFloat(slider1.value)
                        
						
						if (lines1.count>cv.periodGRAPH*1000/cv.intervalTM){
							lines1.remove(0)
							lines2.remove(0)
							//lines3.remove(0)
							
						}

                        lines1.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv.valueCH1)
                        lines2.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv.valueCH2)
						//lines3.append(cv.startTIME+cv.timcnt*cv.intervalTM ,cv3.valueCH1)
						
						
						lines1.axisX.min = new Date(cv.startTIME - cv.periodGRAPH*1000 + cv.timcnt*cv.intervalTM)
						lines1.axisX.max = new Date(cv.startTIME + cv.timcnt*cv.intervalTM)
			
                        lines2.axisX.min = new Date(cv.startTIME - cv.periodGRAPH*1000 + cv.timcnt*cv.intervalTM)
                        lines2.axisX.max = new Date(cv.startTIME + cv.timcnt*cv.intervalTM)
						
						//lines3.axisX.min = new Date(cv.startTIME - cv.periodGRAPH*1000 + cv.timcnt*cv.intervalTM)
                        //lines3.axisX.max = new Date(cv.startTIME + cv.timcnt*cv.intervalTM)
						
						
                    }
            }
        
}