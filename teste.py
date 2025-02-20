import re

class Pessoa:
    def __init__(self, nome, idade):
        self.nome=nome
        self.idade=idade
    def __str__(self):
        print(f"{self.nome} com {self.idade} anos")

def operacao(conta, int1, int2):
    match conta:
        case "+":
            resultado=int1+int2
        case "-":
            resultado=int1-int2
        case "*":
            resultado=int1*int2
        case "/":
            resultado=int1/int2
        case _:
            print("Que conta queres fazer?")
    return resultado

def calculadora():
    print("Calculadora")
    try:
        while True:
            calculadora=input("")
            int1,int2=re.split("[+|-|-|*|/]+", calculadora)
            conta="".join([i for i in calculadora if (i in ["+", "-", "-", "*", "/"])])
            resultado=operacao(conta,int(int1),int(int2))
            print(f"={resultado}")
    except KeyboardInterrupt:
        exit()

def read():
    with open("teste1.txt", "w") as file:
        file.write("\ntres")

def main():
    calculadora()

if __name__ == "__main__":
    main()