# import the time module
import time
import os


def countdown():
    print('Instance Will shutdown after:')
    t = 300
    while t:
        mins, secs = divmod(t, 60)
        timer = '{:02d}:{:02d}'.format(mins, secs)
        print(timer, end="\r")
        time.sleep(1)
        t -= 1
    os.system('sudo shutdown now')

# if '__name__' == '__main__':
#     # function call
#     countdown()
