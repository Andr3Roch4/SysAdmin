import calendar

MORSE_CODE_DICT = { 'A':'.-', 'B':'-...',
                    'C':'-.-.', 'D':'-..', 'E':'.',
                    'F':'..-.', 'G':'--.', 'H':'....',
                    'I':'..', 'J':'.---', 'K':'-.-',
                    'L':'.-..', 'M':'--', 'N':'-.',
                    'O':'---', 'P':'.--.', 'Q':'--.-',
                    'R':'.-.', 'S':'...', 'T':'-',
                    'U':'..-', 'V':'...-', 'W':'.--',
                    'X':'-..-', 'Y':'-.--', 'Z':'--..',
                    '1':'.----', '2':'..---', '3':'...--',
                    '4':'....-', '5':'.....', '6':'-....',
                    '7':'--...', '8':'---..', '9':'----.',
                    '0':'-----', ', ':'--..--', '.':'.-.-.-',
                    '?':'..--..', '/':'-..-.', '-':'-....-',
                    '(':'-.--.', ')':'-.--.-'}

def translate(string):
    morse=""
    for i in string:
        if i.isspace():
            morse+=" / "
        elif i.isalnum():
            if i.upper() not in MORSE_CODE_DICT:
                exit(f"Caracter '{i}' não encontrado.")
            for n in MORSE_CODE_DICT:
                if i.upper() == n:
                    morse+=f"{MORSE_CODE_DICT[n]} "
        else:
            exit("Caracter invalido.")

    return morse

def sexta(mes,ano):
    month_calendar=calendar.monthcalendar(ano,mes)
    for week in month_calendar:
        if week[4] == 13:
            return True
    
    return False

def knapsack(carry,weight,value):
    print(sorted(weight))
    highest_value=0
    for i in range(len(weight)):
        if i < carry:
            for n in range(len(weight)[:i]):
                total_weight=weight[i] + weight[n]
                if total_weight < 10:
                    highest_value=value[i]+value[n]

    return highest_value



def main():
    knapsack(10,[3,6,8],[50,60,100])
    #print(sexta(2,2023))
    #string=list(input("Frase para traduzir:\n"))
    #print(translate(string))

if __name__ == "__main__":
    main()