from flask import Flask

app = Flask(__name__)

@app.route ("/")
def index():
    return "This Is Blessvin's Project for Jiitak. \n Looking Forward to Hearing Back from you all!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=8080)
