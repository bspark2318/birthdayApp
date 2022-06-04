from flask import Flask, make_response, render_template
from google.cloud import datastore
import logging

app = Flask(__name__)

## Configure Logging
logFormatter = '%(asctime)s - %(levelname)s - %(message)s'
logging.basicConfig(format=logFormatter, level=logging.DEBUG)

## Dashboard
@app.route("/analytics/dashboard/")
def dashboard():
    """
    Analytics board for the datastore. 
    Keeps track of unique logins, query made for a number of API endpoints 
    Can be accessed with the following information 
    username: admin   password: mpcs52555

    Returns:
        template with information about top queries
    """
    datastore_client = datastore.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')    
    analytics_query = datastore_client.query(kind="Analytics")
    
    try:
        analytics_query.order = ["-api_total_count"]
        analytics = list(analytics_query.fetch(limit=25))
        logging.debug("Datastore query for Analytics executed successfully")
    except:
        logging.error("Error while executing datastore query for Analytics")
        return make_response("Error while retrievining list of Analytics", 400)
    
    return render_template('dashboard.html', analytics=analytics)


if __name__ == "__main__":
    app.run(debug=True, port=60)
    



