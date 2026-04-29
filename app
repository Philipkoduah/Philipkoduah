from flask import Flask, render_template_string, request, redirect, url_for

app = Flask(__name__)

# In-memory financial records (for demo purposes)
transactions = []

HTML_TEMPLATE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Tracking Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background-color: #f4f6f8;
        }
        h1 {
            color: #333;
        }
        .container {
            max-width: 900px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        form {
            margin-bottom: 30px;
        }
        input, select {
            padding: 10px;
            margin: 5px;
            width: 200px;
        }
        button {
            padding: 10px 20px;
            background: #2d89ef;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: left;
        }
        .income {
            color: green;
        }
        .expense {
            color: red;
        }
        .summary {
            margin-top: 20px;
            font-size: 18px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Financial Tracking Dashboard</h1>

    <form method="POST" action="/add">
        <input type="text" name="description" placeholder="Description" required>
        <input type="number" step="0.01" name="amount" placeholder="Amount" required>
        <select name="type" required>
            <option value="">Select Type</option>
            <option value="Income">Income</option>
            <option value="Expense">Expense</option>
        </select>
        <button type="submit">Add Transaction</button>
    </form>

    <table>
        <tr>
            <th>Description</th>
            <th>Amount</th>
            <th>Type</th>
        </tr>
        {% for t in transactions %}
        <tr>
            <td>{{ t.description }}</td>
            <td class="{{ t.type.lower() }}">
                ${{ "%.2f"|format(t.amount) }}
            </td>
            <td>{{ t.type }}</td>
        </tr>
        {% endfor %}
    </table>

    <div class="summary">
        <p><strong>Total Income:</strong> ${{ "%.2f"|format(total_income) }}</p>
        <p><strong>Total Expenses:</strong> ${{ "%.2f"|format(total_expense) }}</p>
        <p><strong>Balance:</strong> ${{ "%.2f"|format(balance) }}</p>
    </div>
</div>
</body>
</html>
"""

@app.route("/")
def index():
    total_income = sum(t["amount"] for t in transactions if t["type"] == "Income")
    total_expense = sum(t["amount"] for t in transactions if t["type"] == "Expense")
    balance = total_income - total_expense

    return render_template_string(
        HTML_TEMPLATE,
        transactions=transactions,
        total_income=total_income,
        total_expense=total_expense,
        balance=balance
    )

@app.route("/add", methods=["POST"])
def add_transaction():
    description = request.form["description"]
    amount = float(request.form["amount"])
    transaction_type = request.form["type"]

    transactions.append({
        "description": description,
        "amount": amount,
        "type": transaction_type
    })

    return redirect(url_for("index"))

if __name__ == "__main__":
    app.run(debug=True)