import os

def main():
    env_var=os.environ.get("PYTHON", "Não existe environment variable.")
    print(env_var)

if __name__ == "__main__":
    main()