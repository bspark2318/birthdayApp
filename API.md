API Endpoints

# API
## End-Point 1
End-Point: https://birthday-app-352106.uc.r.appspot.com/api/add_birthday
Request-Type: POST
Returns: Response status codes

Description:
    Adds a new birthday for the client

Query parameters:
    None

Status codes:
    200 — when the request succeeds to fetch the list of books,
    400 — if an error occurs.

## End-Point 2

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/get_birthdays
Request-Type: GET
Returns: Birthdays objects for a client

Description:
    Returns all the birthdays that belong to a client

Query parameters:
    None

Status codes:
    200 — when the request succeeds to fetch the list of birthdays
    400 — if an error occurs.

## End-Point 3

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/update_birthday
Request-Type: PUT
Returns: Updated birthday information

Description:
    Returns the updated birthday information 

Query parameters:
    None

Status codes:
    200 — when the request succeeds to update the target birthday 
    400 — if an error occurs.

## End-Point 4

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/delete_birthday
Request-Type: DELETE
Returns: Status update and response code

Description:
    Delete target birthday

Query parameters:
    None

Status codes:
    204 — when the request succeeds to delete the target birthday 
    400 — if an error occurs.    

## End-Point 5

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/create_user
Request-Type: POST
Returns: Status update and response code

Description:
    Create a new user in datastore

Query parameters:
    None

Status codes:
    201 — when the request succeeds to delete the target birthday 
    400 — if an error occurs.    
    
## End-Point 6

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/retrieve_user
Request-Type: GET
Returns: Target user information

Description:
    Fetches the target user information by ID

Query parameters:
    None

Status codes:
    200 — when the request succeeds to delete the target birthday 
    400 — if an error occurs.    
    

## End-Point 7

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/update_user
Request-Type: PUT
Returns: Target user information

Description:
    Updates the target user and return the object

Query parameters:
    None

Status codes:
    200 — when the request succeeds to updates the target user 
    400 — if an error occurs.   
    
## End-Point 8

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/upload_photo
Request-Type: PUT
Returns: Target user information

Description:
    Updates the target user's profile picture 

Query parameters:
    None

Status codes:
    200 — when the request succeeds to updates the target user 
    400 — if an error occurs. 

## End-Point 9

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/health
Request-Type: GET
Returns: Response code

Description:
    Uploads a timestamp to "Health Check" entity on datastore. Primarily for checking Cron Task

Query parameters:
    None

Status codes:
    200 — when the request succeeds
    400 — if an error occurs. 

## End-Point 10

End-Point: https://birthday-app-352106.uc.r.appspot.com/api/notify_birthdays
Request-Type: GET
Returns: list of notifications to make

Description:
    Queries the datastore for all users and birthdays. Filters out the birthdays within the next 7 days, and organizes them into a list of notifications.Sent over to Tasks endpoint to send email notifications.

Query parameters:
    None

Status codes:
    200 — when the request succeeds 
    400 — if an error occurs. 


# Analytics
## End-Point 1

End-Point: https://birthday-app-352106.uc.r.appspot.com/analytics/dashboard/
Request-Type: GET
Returns: Analytics Board

Description:
    Analytics board for the datastore. 
    Keeps track of unique logins, query made for a number of API endpoints 
    Can be accessed with the following information 
    username: admin   password: mpcs52555

Query parameters:
    None

Status codes:
    400 — if an error occurs. 


# Tasks

## End-Point 1

End-Point: https://birthday-app-352106.uc.r.appspot.com/tasks/ping_health/
Request-Type: GET
Returns: Response Code

Description:
    Pings the /api/health endpoint every hour

Query parameters:
    None

Status codes:
    200 — if successful
    400 — if an error occurs. 

## End-Point 2

End-Point: https://birthday-app-352106.uc.r.appspot.com/tasks/send_notifications/
Request-Type: GET
Returns: Response Code

Description:
    Pings the /api/notify_birthdays endpoint every Monday morning. Receives the notification objects and proceeds to send each owner an email about a reminder for birthdays in the next 7 days

Query parameters:
    None

Status codes:
    200 — if successful
    400 — if an error occurs. 
