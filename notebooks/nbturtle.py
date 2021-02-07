#! /usr/bin/env python

"""
MIT License

Copyright (c) 2018 Robotic Intelligence Lab

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

import rospy
from turtlesim.msg import Pose
import matplotlib.pyplot as plt
from IPython import display

import os, time

prev_time = None

def callback(msg):
    global prev_time
    current_time = time.time()
    if not prev_time or \
        current_time - prev_time > 0.2:
            prev_time = current_time
            os.system('xwd -display :99 -name TurtleSim | xwdtopnm 2> /dev/null | pnmtopng > frame.png ')
            frame = plt.imread('frame.png')
            fig = plt.figure(num=1,figsize=(10,10),clear=True)
            plt.imshow(frame);
            plt.axis('off');
            display.display(plt.gcf())
            display.clear_output(wait=True)
                    
def plot():
    rospy.init_node('turtlesim_display') #, anonymous=True
    rospy.Subscriber('/turtle1/pose', Pose, callback)
    rospy.spin()
