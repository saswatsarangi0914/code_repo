class Name:
    def __init__(self):
        self.firstname = "Saswat"
        self.lastname = "Sarangi"
class Person:
    def __init__(self):
        self.name = Name()
        self.eyecolor = "Black"
        self.age = -1

person1 = Person()
print(person1.name.firstname)    
print(person1.name.lastname)  
print(person1.eyecolor)  
print(person1.age)  