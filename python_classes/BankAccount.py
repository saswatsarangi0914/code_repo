class BankAccount:
    def log(self,message):
        logFile = open("Log.txt","a")
        print(message,file=logFile)
        logFile.close()
    def getBalance(self):
        self.log("Balance checked at "+ str(self.balance))
        return self.balance
    def __init__(self,name,balance=0.0):
        self.name = name
        self.balance = balance
        self.log("Account Created Successfully for "+ self.name)
    def withDraw(self,amount):
        self.balance -= amount
        self.log("Balance post withdrawal "+str(self.balance))
    def depositAmount(self,amount):
        self.balance += amount
        self.log("Balance post deposit "+str(self.balance))

account1 = BankAccount("Saswat")
account1.depositAmount(40)
account1.withDraw(20)
print(account1.getBalance())
        
