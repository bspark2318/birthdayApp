from xml.dom import UserDataHandler
from flask import Flask, abort, json
import requests
import logging

app = Flask(__name__)

## Configure Logging
logFormatter = '%(asctime)s - %(levelname)s - %(message)s'
logging.basicConfig(format=logFormatter, level=logging.DEBUG)

# Helper function to send a notification about birthdays
def send_message(owner_name, email, text_block):
    
    email_text = f"Hi {owner_name},\n\nHere is your weekly birthday notification!:\n\n{text_block}\nHave a great day!\n\nSincerely,\nHBD Team"
    
    return requests.post(
		"https://api.mailgun.net/v3/sandbox09cbcde124fc404aa8b91983a53c50c3.mailgun.org/messages",
		auth=("api", "139150b50b92e1ad91cc1207a39b227a-fe066263-452ebc72"),
		data={"from": "Mailgun Sandbox <postmaster@sandbox09cbcde124fc404aa8b91983a53c50c3.mailgun.org>",
			"to": f"Beloved HBD Customer <{email}>",
			"subject": "🎂 Birthday Notifications 🎂",
			"text": email_text})


@app.route("/tasks/ping_health")
def ping_health():
    """
    Pings the /api/health endpoint every hour
    
    Parameters: 
        None
        
    Returns:
        Status code and message 
    """
    logging.warning("PINGING API ENDPOINT")
    headers = dict()
    headers["X-Api-Key"] = 'abcdef123456'
    resp = requests.get("https://birthday-app-352106.uc.r.appspot.com/api/health", headers=headers)

    return "Successful", 200 


@app.route("/tasks/send_notifications")
def send_notifications():
    """
    Pings the /api/notify_birthdays endpoint every Monday morning. Receives the notification objects and proceeds to send each owner an email about a reminder for birthdays in the next 7 days
    
    Parameters: 
        None
        
    Returns:
        Status Code
    """
    logging.warning("PINGING API ENDPOINT")
    headers = dict()
    headers["X-Api-Key"] = 'abcdef123456'
    resp = requests.get("https://birthday-app-352106.uc.r.appspot.com/api/notify_birthdays", headers=headers)
    
    data = resp.json()
    
    for user_data in data:
        email = user_data["email"]
        owner_name = user_data["owner_name"]
        notifications = user_data["notifications"]
        print("notifications")
        print(notifications)
        text_block = ""
        if not notifications:
            text_block = "There are no birthdays in the next 7 days!"
        else: 
            for noti in notifications:
                noti_full_name = noti['full_name']
                noti_birthday = noti['birthday'][:10]
                noti_days_till = noti['days_till']
                noti_string = "{}: Birthday in {} ({})".format(noti_full_name, noti_days_till, noti_birthday)
                text_block += noti_string
                text_block += "\n"
        send_message(owner_name, email, text_block)
        
    return "Successful", 200 


if __name__ == "__main__":
    app.run(debug=True, port=6000)



