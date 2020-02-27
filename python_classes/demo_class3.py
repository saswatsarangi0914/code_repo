class Name:
    def __init__(self,firstname,lastname):
        self.firstname = firstname
        self.lastname = lastname
        self.log("firsname and lastname created")
    def log(self,message):
        myLog = open("Log.txt","a")
        print(message,file=myLog)
        myLog.close()
class Person:
    def __init__(self,firstname="",lastname=""):
        self.name = Name(firstname=firstname,lastname=lastname)
        self.eyecolor = "Black"
        self.age = -1

person1 = Person(firstname="Swagat",lastname="Sarangi")
print(person1.name.firstname)    
print(person1.name.lastname)  
print(person1.eyecolor)  
print(person1.age)  