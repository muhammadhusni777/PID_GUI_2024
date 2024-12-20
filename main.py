######  PROGRAM MEMANGGIL WINDOWS PYQT5 ##########################

####### memanggil library PyQt5 ##################################
#----------------------------------------------------------------#
import time
from datetime import datetime
import sys
import serial
from PyQt5.QtCore import * 
from PyQt5.QtGui import * 
from PyQt5.QtQml import *
from PyQt5 import QtGui, QtCore, Qt,QtQml
from PyQt5.QtWidgets import *
from PyQt5.QtQuick import *  
import sys
from PyQt5.QtQml import QQmlApplicationEngine
from RadialBar import RadialBar
import threading
import os
#----------------------------------------------------------------#

import csv


def p_control(kp_val, error):
    res = kp_val*error
    return res

def i_control(ki_val, error, error_prev, T, i_prev):
    i_control_val = ki_val * T/2 * (error + error_prev) + i_prev
    
    if (i_control_val > 100):
        i_control_val = 100
        
    if (i_control_val < 0):
        i_control_val = 0

    return i_control_val

def d_control(kd_val, error, error_prev, T, d_prev):
    
    if (error - error_prev != 0):
        d_control_val = kd_val * 2/T * (error - error_prev) - d_prev
    else:
        d_control_val = 0
    
    if (d_control_val > 100):
        d_control_val = 100
        
    if (d_control_val < -100):
        d_control_val = -100
        
    return d_control_val


print ("DIBUAT OLEH MUHAMMAD HUSNI MUTTAQIN")

#current_time = dt.datetime.now()

baudrate = 9600
serial_status = 'disconnected'
serial_status_prev = 'disconnected'
print ("select your arduino port:")

def serial_ports():
    if sys.platform.startswith('win'):
        ports = ['COM%s' % (i + 1) for i in range(256)]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this excludes your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.*')
    else:
        raise EnvironmentError('Unsupported platform')

    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result
print(str(serial_ports()))

port = ""
ser = ""


save_time = 0
save_time_prev = 0


waktu = ""
dt = 0
dt_prev = time.time()


i=0

alpha = 0.0
sensor = 25
sensor_prev = 23
e = 0.0
e_prev = 0.0
setpoint = 37
kp = 0.0
ki = 0.0
kd = 0.0
p = 0.0
i = 0.0
i_prev = 0.0
d = 0.0
d_prev = 0.0
pid_control = 0.0
saturation = 100
i_windup = 100
offset = 0

pid_time = 0
pid_time_prev = 0
control_signal = 0
time_sampling = 0.5

clock = datetime.now()

analysis = ''
motor_response_equation = ''
step_value = 0
mode = ""

power_gui = 0

ser_bytes = '0'
serial_send_time = 0
serial_send_time_prev = 0

serial_read = 0

serial_data = ""
data = []
data_send = ""

ol_mode = ""
cl_mode = ""

ol_signal = "0"

action = "stop"


filename = "record.csv"
filename_prev = "record.csv"

record_status = ""






########## mengisi class table dengan instruksi pyqt5#############
#----------------------------------------------------------------#
class table(QObject):    
    def __init__(self, parent = None):
        super().__init__(parent)
        self.app = QApplication(sys.argv)
        #self.app.setWindowIcon(QIcon("eggpic.png"))
        self.engine = QQmlApplicationEngine(self)
        self.engine.rootContext().setContextProperty("backend", self)    
        self.engine.load(QUrl("main.qml"))
        sys.exit(self.app.exec_())
    
    @pyqtSlot(result=int)
    def get_tiempo(self):
        date_time = QDateTime.currentDateTime()
        unixTIME = date_time.toSecsSinceEpoch()
        #unixTIMEx = date_time.currentMSecsSinceEpoch()
        return unixTIME
    
    
    @pyqtSlot(result=float)
    def sensor_val_read(self):  return (sensor)
    
    
    @pyqtSlot(result=float)
    def control_signal(self):  return round(float(control_signal),0)
    

    @pyqtSlot(result=list)
    def port_val_read(self):  return (serial_ports())
    
    @pyqtSlot('QString')
    def mode(self, value):
        global mode
        mode = str(value)
        #print(mode)
        
    @pyqtSlot('QString')
    def action(self, value):
        global action
        action = str(value)
        #print(mode)
        
    
    
    @pyqtSlot('QString')
    def ol_mode(self, value):
        global ol_mode
        ol_mode = str(value)
        #print(ol_mode)
        
    @pyqtSlot('QString')
    def ol_signal(self, value):
        global ol_signal
        ol_signal = float(value)
        #print(ol_signal)
        
    @pyqtSlot('QString')
    def cl_mode(self, value):
        global cl_mode
        cl_mode = str(value)
        #print(cl_mode)
    
    
    @pyqtSlot('QString')
    def setpoint(self, value):
        global setpoint
        setpoint = float(value)
        #print(setpoint)
        

    @pyqtSlot('float')
    def setP_control(self, value):
        global kp
        kp = float(value)
        #ser.write(alpha.encode())
    
    @pyqtSlot('float')
    def setI_control(self, value):
        global ki
        ki = float(value)
        #print(ki_control)
        

        
    @pyqtSlot('float')
    def setD_control(self, value):
        global kd
        kd = float(value)
       

    @pyqtSlot('QString')
    def connection(self, status):
        global serial_status
        serial_status = status
        print(status)
        #print(port)
        
        
    @pyqtSlot('QString')
    def port_number(self, port_number):
        global port
        port = str(port_number)  
        print(port)
        
    @pyqtSlot('QString', 'QString')
    def filename(self, value, value2):
        global filename
        global record_status
        
        filename = str(value) + str(".csv")
        record_status = str(value2)
        print(filename, record_status)
        
    @pyqtSlot('QString')
    def port_closed(self, message):
        if (serial_status == 'connected'):
            try:
                ser.close()
            except:
                t1.stop()
                sys.exit()
            
    
    
        
        
def pid_control_process(num):
    global error
    global error_prev
    global sensor
    global e
    global e_prev
    global T
    global p
    global kp
    global i
    global ki
    global i_prev
    global d
    global kd
    global d_prev
    global pid_control
    global serial_send_time
    global serial_send_time_prev
    global serial_read
    global serial_data
    global ser
    global serial_status_prev
    
    global save_time_prev
    global save_time
    global control_signal
    global ol_signal
    
    global pid_time
    global pid_time_prev
    global time_sampling
    global filename
    global filename_prev
    global record_status
    global clock
    
    
    
    
    while True:
        clock = datetime.now()
        #print(ki_control)
        
        if (os.path.isfile(filename)):
            pass
        else:
            if (record_status == "true"):
                print(f"membuat file'{filename}'.....")
                fields = ['time', 'setpoint', 'sensor', 'sinyal kendali']
                filename = str(filename)    
                with open(filename, 'a') as csvfile:
                    # creating a csv writer object
                    csvwriter = csv.writer(csvfile)
                    # writing the fields
                    csvwriter.writerow(fields)
            
        
        
        
        
        if (mode == "CL"):
            if (cl_mode == "pid"):
                #dt = round(time.time() - dt_prev ,3)
                pid_time = time.time() - pid_time_prev
                if(pid_time > time_sampling):
                    #######calculate error#################
                    e = setpoint - sensor
                    
                    #######proportional control############
                    p = p_control(kp, e)
                    
                    ########integral control###############
                    i = i_control(ki, e, e_prev, time_sampling, i_prev)
                        
                    #########derivative control##############
                    d = d_control(kd, e, e_prev, time_sampling, d_prev)

                    ######### p + i + d control###############
                    pid_control = p + i + d
                    if (pid_control > 100):
                        pid_control = 100
                    
                    if (pid_control < 0):
                        pid_control = 0
        
                    if (action == "run"):
                        control_signal = pid_control
                    else:
                        control_signal = 0
                    
                    i_prev = i
                    d_prev = d
                    e_prev = e
                    print(p,i,d,pid_control , e - e_prev)
                    pid_time_prev = time.time()
                
                
            
            if(cl_mode == "on_off"):
                p = 0.0
                i = 0
                d = 0
                if (setpoint > sensor):
                    if (action == "run"):
                        control_signal = 100
                    else:
                        control_signal = 0
                else:
                    control_signal = 0
            
                
        else:
            p = 0
            i = 0
            d = 0
            control_signal = ol_signal
        
        
        if (serial_status == 'connected'):
            if (serial_status != serial_status_prev):
            
                ser = serial.Serial(str(port),9600,timeout=2)
                ser.flushInput()
            if ser:  # Only proceed if ser was successfully opened
                try:
                    serial_data = ser.readline().decode('utf-8').strip()
                    sensor = float(serial_data)
                    
                except ValueError as ve:
                    sensor = sensor
                    #print(f"Error converting serial data to float: {ve}")
                    
                except serial.SerialException as e:
                    
                    print(f"Serial error: {e}")
                except Exception as e:
                    print(f"Unexpected error: {e}")
            
            
            
            #print(serial_data, humidity)
            serial_send_time = time.time() - serial_send_time_prev
            
            if (serial_send_time > 0.5):
                #print(clock)
                
                if (record_status == "true"):
                    fields = [str(clock), str(setpoint), str(sensor), str(control_signal)]
                    filename = str(filename)    
                    with open(filename, 'a') as csvfile:
                        # creating a csv writer object
                        csvwriter = csv.writer(csvfile)
                        # writing the fields
                        csvwriter.writerow(fields)
                
                
                
                try:
                    #print(p, i, d,control_signal, sensor)
                    if (action == "run"):
                        ser.write(str(int(control_signal)).encode())
                    else:
                        p = 0
                        i = 0
                        d = 0
                        control_signal = 0
                        ser.write(str((0)).encode())
                    
                    serial_read = 1
                except serial.SerialException as e:
                    print(f"Error writing to serial: {e}")
                serial_send_time_prev = time.time()
            else:
                serial_read = 0
                
        else :
            if (serial_status != serial_status_prev):
                ser.close()
        
        
        
        dt_prev = time.time()
        
        serial_status_prev = serial_status
        
        filename_prev = filename
        time.sleep(0.00000001)



#----------------------------------------------------------------#

########## memanggil class table di mainloop######################
#----------------------------------------------------------------#    
if __name__ == "__main__":
    
    t1 = threading.Thread(target=pid_control_process, args=(1,))
    t1.start()
    main = table()
    
    
#----------------------------------------------------------------#