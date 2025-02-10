import random

def main():
    options=["pedra", "papel", "tesoura"]
    playerpick=input("Escolhe Pedra, Papel ou Tesoura\n").lower()
    pick=random.choice(options)
    if playerpick in options:
        if playerpick == "pedra":
            if pick == "papel":
                print(f"Perdes-te contra {pick}.")
            elif pick == "tesoura":
                print(f"Ganhas-te contra {pick}.")
            else:
                print(f"Empate contra {pick}.")
        elif playerpick == "papel":
            if pick == "pedra":
                print(f"Ganhas-te contra {pick}.")
            elif pick == "tesoura":
                print(f"Perdes-te contra {pick}.")
            else:
                print(f"Empate contra {pick}.")
        else:
            if pick == "pedra":
                print(f"Perdes-te contra {pick}.")
            elif pick == "papel":
                print(f"Ganhas-te contra {pick}.")
            else:
                print(f"Empate contra {pick}.")
    else:
        exit("Tens de escolher uma das opções.")

if __name__ == "__main__":
    main()