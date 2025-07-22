from flask import Flask, render_template, request, redirect, session

app = Flask(__name__)
app.secret_key = 'secret_key'

users = {
    "admin": "1234",
    "kenzy": "pass"
}
orders = {
    "1001": {
        "order_id": "1001",
        "delivery_date": "2024-06-01",
        "product_name": "Smartphone",
        "company": "DHL",
        "contact": "123456789",
        "email": "dhl@email.com",
        "status": "Shipped"
    },
    "1002": {
        "order_id": "1002",
        "delivery_date": "2024-06-03",
        "product_name": "Laptop",
        "company": "FedEx",
        "contact": "987654321",
        "email": "fedex@email.com",
        "status": "Processing"
    }
}
@app.route("/", methods=["GET", "POST"])
def login():
    error = None
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        if username in users and users[username] == password:
            session["user"] = username
            return redirect("/track")
        else:
            error = "Invalid credentials"
    return render_template("login.html", error=error)

@app.route("/track", methods=["GET", "POST"])
def track():
    if "user" not in session:
        return redirect("/")
    
    order_data = None
    error = None
    if request.method == "POST":
        order_id = request.form["order_id"]
        if order_id in orders:
            order_data = orders[order_id]
        else:
            error = "Order not found"
    return render_template("track.html", order=order_data, error=error)

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")

if __name__ == "__main__":
    app.run(debug=True)
