from tkinter import *
import sys  
sys.path.append("KPI_DB_Persistance")
from recordsRepository import populateDatabase, getCompare

class MainWindow:
    def __init__(self, win):
        self.lbl1=Label(win, text='Year to start')
        self.lbl3=Label(win, text='Avg math 2019')
        self.lbl4=Label(win, text='Avg math 2020')
        self.t1=Entry(bd=3)
        self.t1.insert(END, "2019")
        self.t3=Entry()
        self.t4=Entry()
        self.btn1 = Button()
        self.btn2 = Button(win, text='Subtract')
        self.lbl1.place(x=100, y=50)
        self.t1.place(x=200, y=50)
        self.b1=Button(win, text='Start db population', command=self.start)
        self.b2=Button(win, text='Generate result')
        self.b2.bind('<Button-1>', self.sub)
        self.b1.place(x=50, y=150)
        self.b2.place(x=200, y=150)
        self.lbl3.place(x=100, y=200)
        self.t3.place(x=200, y=200)
        self.lbl4.place(x=100, y=250)
        self.t4.place(x=200, y=250)
    def start(self):
        populateDatabase(self.t1.get())
    def sub(self, event):
        res = getCompare()
        self.t3.insert(END, res[0])
        self.t4.insert(END, res[1])

def main():
    window=Tk()
    mywin=MainWindow(window)
    window.title('KPI.DB.Python')
    window.geometry("400x300+10+10")
    window.mainloop()
    
if __name__ == "__main__":
    main()
else:
    raise Exception("Invalid start point")


