class Person:
    def __init__(self,name,eyecolor,age):
        self.name = name
        self.eyecolor = eyecolor
        self.age = age

class Name:
    def __init__(self,firstname,lastname):
        self.firstname = firstname
        self.lastname = lastname

person1 = Person(Name("Saswat","Sarangi"),"black",33)
print(person1.name.firstname)
print(person1.name.lastname)
print(person1.eyecolor)
print(person1.age)
