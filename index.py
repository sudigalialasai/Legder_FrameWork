# app.py
from flask import Flask, jsonify, request
from flask_cors import CORS
import psycopg2  # pip install psycopg2


app = Flask(__name__)
CORS(app)


DB_HOST = "localhost"
DB_NAME = "signup"
DB_USER = "postgres"
DB_PASS = "123456"

conn = psycopg2.connect(dbname=DB_NAME, user=DB_USER,
                        password=DB_PASS, host=DB_HOST)


@app.route('/')
def home():
    return 'Hi'
cur = conn.cursor()


@app.route('/student', methods=['POST'])
def student():
    data = request.get_json()
    roll=(data['rollno'])
    rollno = int(data['rollno'])
    marks = int(data['marks'])
    # print(marks, rollno)
    cur.execute(" select * from marksofstudent where rollno="+str(roll))
    pre = cur.fetchone()
    # print(pre)
    if pre:
            return jsonify({'message':'rollno already exist'})
    
    else:    
        cur.execute(
                "INSERT INTO marksofstudent (rollno,marks) VALUES (%s,%s)", (rollno, marks))
        conn.commit()
        return jsonify({'message': 'success'})

@app.route('/view')

def view():
    cur.execute(" select * from marksofstudent")
    pre = cur.fetchall()
    print(pre)
    return jsonify({'data':pre})
if __name__ == "__main__":
    app.run(port=2000, debug=True)