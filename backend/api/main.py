rm import base64
from flask import Flask, Response, request, make_response, jsonify, json, abort
from google.cloud import datastore
from functools import wraps
from google.cloud import storage
import datetime
import uuid
import re
import logging

app = Flask(__name__)
CLOUD_STORAGE_BUCKET = "birthday_app_52555"

## Configure Logging
logFormatter = '%(asctime)s - %(levelname)s - %(message)s'
logging.basicConfig(format=logFormatter, level=logging.DEBUG)

"""
API Key decorator
"""
def require_api_key(f):
    """
    Validates that every request made to the /api/ endpoints have the 
    correct api-key for authorization
    
    Parameters: 
        f: Function to be decorated
        
    Returns:
        decorated function
    """
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if request.headers.get('X-Api-Key') != "abcdef123456":
            logging.error("Wrong API Key")
            abort(401)
        return f(*args, **kwargs)
    return decorated_function


# Helper function for making updates to the query counts
def update_query(query_type, userID): 
    datastore_client = datastore.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')    
    queries_query = datastore_client.query(kind="Analytics")    
    queries_query.add_filter("userID", "=", userID)
    
    try:
        query_entity = list(queries_query.fetch())
        logging.debug("Datastore query executed successfully for queries")
    except:
        logging.error("Error while executing datastore query for queries")
        return make_response("Error while retrievining queries", 400)
    
    if query_entity:
        query_entity = query_entity[0]
    else:
        kind = "Analytics"
        key = datastore_client.key(kind, userID)
        query_entity = datastore.Entity(key)
        query_entity["userID"] = userID
        query_entity["login_count"] = 1
        query_entity["api_create_birthday"] = 0
        query_entity["api_update_birthday"] = 0
        query_entity["api_delete_birthday"] = 0
    
    query_entity[query_type] = query_entity[query_type] + 1
    
    if query_type != "login_count" :
        query_entity["api_total_count"] = query_entity["api_total_count"] + 1


    try:
        datastore_client.put(query_entity)   
        logging.debug("Query entity successfully updated")
    except: 
        logging.error("Error while executing datastore request for query entity")
        return make_response("Error: Error while uploading query entity", 400)

    return 


@app.route("/api/add_birthday", methods=["POST"])
@require_api_key
def add_birthday():
    """
    Adds a new birthday for the client
    
    Parameters: 
        None
        
    Returns:
        Status update along with response code 
    """
    data = request.json
    
    datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
    kind = "Birthday"
    
    try:
        key = datastore_client.key(kind, data["birthdayID"])
        entity = datastore.Entity(key)
        entity["first_name"] = data['first_name']
        entity["last_name"] = data['last_name']
        entity["owner"] = data['owner']
        entity["birthday"] = data['birthday']
        entity["birthdayID"] = data['birthdayID']
        entity["importance"] = data['importance']
        entity["notificationEnabled"] = data['notificationEnabled']
        entity["notifications"] = data['notifications']
        datastore_client.put(entity)   
        logging.debug("Birthday entity successfully put in datastore")
    except: 
        logging.error("Error while executing datastore request for birthday entity")
        return make_response("Error: Error while uploading birthday entity", 400)
    
    try: 
        update_query("api_create_birthday", data["owner"])
        logging.debug("Adding info to Analytics table in datastore")
    except:
        logging.error("Error while executing datastore request for Analytics entity")
        return make_response("Error: Error while uploading Analytics entity", 400)
        
    return make_response("Birthday Successfully uploaded", 201)


@app.route("/api/get_birthdays")
@require_api_key
def get_birthdays():
    """
    Returns all the birthdays that belong to a client
    
    Parameters: 
        None
        
    Returns:
        return_array: JSONified array of birthday objects 
    """
    datastore_client = datastore.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')    
    userID =  request.headers.get('UserID')
    
    datastore_client = datastore.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')    
    
    return_array = []
    
    query = datastore_client.query(kind="Birthday")
    query.add_filter("owner", "=", userID)
    try:
        birthday_entities = list(query.fetch())
        logging.debug("Datastore query for retrieving birthdays executed successfully")
    except:
        logging.error("Error while executing datastore query for retrieving birthdays")
        return make_response("Error: Error while fetching birthday entities", 400)
    
    return jsonify(birthday_entities), 200

@app.route("/api/update_birthday", methods=["PUT"])
@require_api_key
def update_birthday():
    """
    Returns the updated birthday information 
    
    Parameters: 
        None
        
    Returns:
        Updated birthday object
    """
    data = request.json
    
    datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
    
    query = datastore_client.query(kind="Birthday")
    query.add_filter("birthdayID", "=", data["birthdayID"])
    
    try:
        logging.debug("Datastore query executed successfully")
        birthday_entity = list(query.fetch())
    except:
        logging.error("Error while executing datastore query")
        return make_response("Error: Error while fetching birthday entity", 400)
    
    if not birthday_entity:
        logging.error(f"No birthday with the id { data['birthdayID'] } found")
        return make_response("Error: Birthday not found", 400)
    
    birthday_entity = birthday_entity[0]
    
    for key, value in data.items():
        birthday_entity[key] = value
    
    try:
        logging.debug("Birthday entity successfully updated in datastore")
        datastore_client.put(birthday_entity)    
    except: 
        logging.error("Error while executing datastore request for birthday entity")
        return make_response("Error: Error while updating entity", 400)
    
    try: 
        update_query("api_update_birthday", data["owner"])
        logging.debug("Adding info to Analytics table in datastore")
    except:
        logging.error("Error while executing datastore request for Analytics entity")
        return make_response("Error: Error while uploading Analytics entity", 400)
    
    return jsonify(birthday_entity), 200

@app.route("/api/delete_birthday", methods=["DELETE"])
@require_api_key
def delete_birthday():
    """
    Delete target birthday
    
    Parameters: 
        None
        
    Returns:
        Status update string and response code
    """
    birthdayID =  request.headers.get('birthdayID')
    userID =  request.headers.get('userID')
    datastore_client = datastore.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')    
    key = datastore_client.key("Birthday", birthdayID)
    
    try:
        datastore_client.delete(key);
        logging.debug("Datastore deletion executed successfully")
    except:
        logging.error("Error while executing datastore query for deletion")
        return make_response("Error: Error while deleting a birthday entity", 400)
    
    try: 
        update_query("api_delete_birthday", userID)
        logging.debug("Adding info to Analytics table in datastore")
    except:
        logging.error("Error while executing datastore request for Analytics entity")
        return make_response("Error: Error while uploading Analytics entity", 400)
    
    return "Successfully deleted", 204



@app.route("/api/create_user", methods=["POST"])
@require_api_key
def create_user():
    """
    Create a new user in datastore
    
    Parameters: 
        None 
        
    Returns:
        Status update along with response code 
    """
    data = request.json
    
    datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
    
    try:
        kind = "User"
        key = datastore_client.key(kind, data["userID"])
        entity = datastore.Entity(key)
        for key, value in data.items():
            entity[key] = value
        datastore_client.put(entity)   
        logging.debug("User entity successfully put in datastore")
    except: 
        logging.error("Error while executing datastore request for User entity")
        return make_response("Error: Error while uploading User entity", 400)
    
    try:
        kind = "Analytics"
        key = datastore_client.key(kind, data["userID"])
        entity = datastore.Entity(key)
        entity["userID"] = data["userID"]
        entity["login_count"] = 1
        entity["api_create_birthday"] = 0
        entity["api_update_birthday"] = 0
        entity["api_delete_birthday"] = 0
        datastore_client.put(entity)   
        logging.debug("Analytics entity successfully put in datastore")
    except: 
        logging.error("Error while executing datastore request for Analytics entity")
        return make_response("Error: Error while uploading Analytics entity", 400)
    
    return make_response("User Successfully uploaded", 201)


@app.route("/api/retrieve_user")
@require_api_key
def retrieve_user():
    """
    Fetches the target user information by ID
    
    Parameters: 
        None
        
    Returns:
        Targer User Data
    """
    datastore_client = datastore.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')    
    userID =  request.headers.get('UserID')
    query = datastore_client.query(kind="User")
    query.add_filter("userID", "=", userID)
    try:
        userEntity = list(query.fetch())
        logging.debug("Datastore query for retrieving a user executed successfully")
    except:
        logging.error("Error while executing datastore query for retrieving user data")
        return make_response("Error: Error while fetching user entity", 400)
     
    if not userEntity:
        logging.error("No user with the user id found")
        return make_response("No data to fetch for user entity", 400)
     
    try: 
        update_query("login_count", userID)
        logging.debug("Adding info to Analytics table in datastore")
    except:
        logging.error("Error while executing datastore request for Analytics entity")
        return make_response("Error: Error while uploading Analytics entity", 400)
    
    userEntity = userEntity[0]
    return jsonify(userEntity), 200

@app.route("/api/update_user", methods=["PUT"])
@require_api_key
def update_user():
    """
    Updates the target user and return the object
    
    Parameters: 
        None
        
    Returns:
        Updated user JSON object
    """
    data = request.json
    
    datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
    
    query = datastore_client.query(kind="User")
    query.add_filter("userID", "=", data["userID"])
    
    try:
        logging.debug("Datastore query executed successfully")
        user_entity = list(query.fetch())
    except:
        logging.error("Error while executing datastore query")
        return make_response("Error: Error while fetching user entity", 400)
    
    if not user_entity:
        logging.error(f"No user with the id { data['userID'] } found")
        return make_response("Error: User not found", 400)
    
    user_entity = user_entity[0]
    
    for key, value in data.items():
        user_entity[key] = value
    
    try:
        logging.debug("User entity successfully updated in datastore")
        datastore_client.put(user_entity)    
    except: 
        logging.error("Error while executing datastore request for User entity")
        return make_response("Error: Error while updating entity", 400)
    
    return jsonify(user_entity), 200

@app.route("/api/upload_photo", methods=["PUT"])
@require_api_key
def upload_photo():
    """
    Updates the target user's profile picture 
    
    Parameters: 
        None
        
    Returns:
        Target user information
    """
    data = request.json
    datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
    
    query = datastore_client.query(kind="User")
    query.add_filter("userID", "=", data["userID"])
    
    try:
        user_entity = list(query.fetch())
        logging.debug("Datastore query executed successfully")
    except:
        logging.error("Error while executing datastore query")
        return make_response("Error: Error while fetching user entity", 400)
    
    if not user_entity:
        logging.error(f"No user with the id { data['userID'] } found")
        return make_response("Error: User not found", 400)
    
    user_entity = user_entity[0]
    
    photo = data['photo'] 
    blob = None
    
    if photo:
        storage_client = storage.Client.from_service_account_json('birthday-app-352106-2de15f68bece.json')
        bucket_name = CLOUD_STORAGE_BUCKET
        bucket = storage_client.bucket(bucket_name)

        blob = bucket.blob(str(uuid.uuid1()) +".png")
        base64_img_bytes = photo.encode('utf-8')
        decoded_image_data = base64.decodebytes(base64_img_bytes)
        
        try:
            blob.upload_from_string(decoded_image_data, content_type="png")
            print(f"File uploaded: {data['userID']} picture to {blob.public_url}")
            logging.debug(f"File {data['userID']} picture uploaded successfully to Cloud Storage")
        except: 
            logging.error(f"Error while executing upload of file {data['userID']}")
            return make_response("Error: Error while uploading photo", 400)
    
    user_entity["profile_pic_url"] = blob.public_url
    user_entity['profile_pic_thumbnail_url'] = re.sub(f'\/{blob.name}$', f'-thumbnail/thumbnail_{blob.name}', blob.public_url)
    
    try:
        logging.debug("User entity successfully updated in datastore")
        datastore_client.put(user_entity)    
    except: 
        logging.error("Error while executing datastore request for User entity")
        return make_response("Error: Error while updating entity", 400)
    
    return jsonify(user_entity), 200


@app.route("/api/health")
@require_api_key
def health_check():
    """
    Uploads a timestamp to "Health Check" entity on datastore. Primarily for checking Cron Task

    Returns:
        Status Codes
    """
    if request.headers.get('X-Appengine-Cron') == "true":
        logging.info("Health Check request coming from Cron")
    kind = "Health Check"
    now = datetime.datetime.now() 
    date_time = now.strftime("%m/%d/%Y, %H:%M:%S")
    
    try:
        datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
        key = datastore_client.key(kind, date_time)
        entity = datastore.Entity(key)
        entity["time_stamp"] = date_time
        datastore_client.put(entity)   
        logging.debug("Health Check successfully completed")
    except: 
        logging.error("Error while executing datastore request for Health Check entity")
        return make_response("Error: Error while uploading Health Check entity", 400)
            
    return Response(status=200)

# Helper function for checking the number of days between bdays
def calculate_number_of_days(birthdate_str):
    birthdate_comp = birthdate_str[:10].split("-")
    month =int(birthdate_comp[1])
    day = int(birthdate_comp[2])
    today = datetime.datetime.now() 
    birthday = datetime.datetime(today.year, month, day)
    
    if birthday < today:
        return False
    
    return (birthday - today).days
    
    
@app.route("/api/notify_birthdays")
@require_api_key
def notify_birthdays(): 
    """
    Queries the datastore for all users and birthdays. 
    Filters out the birthdays within the next 7 days, 
    and organizes them into a list of notifications.
    Sent over to Tasks endpoint to send email notifications.

    Returns:
        Array of notifications
    """
    if request.headers.get('X-Appengine-Cron') == "true":
        logging.info("Email request coming from Cron")
    
    datastore_client = datastore.Client.from_service_account_json("birthday-app-352106-2de15f68bece.json")
    query = datastore_client.query(kind="User")
    
    try:
        user_entities = list(query.fetch())
        logging.debug("Datastore query executed successfully")
        info_dict = dict()
    
        for user in user_entities:
            data = dict()
            data["email"] = user["email"]
            data["owner_name"] = user["first_name"] + " " + user["last_name"]
            data["notifications"] = []
            info_dict[user["userID"]] = data
    except:
        logging.error("Error while executing datastore query")
        return make_response("Error: Error while fetching user entity", 400)
    
    query = datastore_client.query(kind="Birthday")
    
    try:
        birthday_entities = list(query.fetch())
        logging.debug("Datastore query executed successfully")
        
    except:
        logging.error("Error while executing datastore query")
        return make_response("Error: Error while fetching user entity", 400)
    
    notifications = []
    
    for birthday in birthday_entities:
        userID = birthday['owner']
        notification_enabled = birthday['notificationEnabled']
        if not notification_enabled:
            continue
        
        if userID not in info_dict:
            logging.error("Error while matching birthday to a owner")
            return make_response("Error: Error while matching birthday to a owner", 400)
        
        birthdate_str = birthday['birthday']
        success = calculate_number_of_days(birthdate_str)
        if success and success < 8:
            data = dict()
            data['full_name'] = birthday['first_name'] + " " + birthday['last_name']
            data['birthday'] = birthdate_str
            data['days_till'] = success 
            info_dict[userID]['notifications'].append(data)
    
    for _, val in info_dict.items():
        val["notifications"] = sorted(val["notifications"], key=lambda d: d['days_till'])
        notifications.append(val)
    
    return jsonify(notifications), 200


if __name__ == "__main__":
    app.run(debug=True, port=8000)




