from fileinput import filename 
from flask import *  
app = Flask(__name__)   
  
@app.route('/')   
def main():   
    return "hello"
  
@app.route('/upload', methods = ['POST'])   
def success():   
    if request.method == 'POST':   
        f = request.files['file'] 
        f.save(f.filename)   
        return "ok"
        #return render_template("Acknowledgement.html", name = f.filename)   
  
if __name__ == '__main__':   
    app.run(debug=True, host="0.0.0.0", port=8124)