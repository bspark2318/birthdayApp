

API Commands 

All the commands required JSON file of some sort, so has not been replicated here. Many of the methods returned Methods not allowed as well, 
so instaed I recommend testing each endpoint throught the functionalities actualized in the application

    - https://birthday-app-352106.uc.r.appspot.com/api/add_birthday : Try adding a birthday in the scroll view with the plus button
    - https://birthday-app-352106.uc.r.appspot.com/api/get_birthdays : When user logins, automatically fired
    - https://birthday-app-352106.uc.r.appspot.com/api/update_birthday : Try updating a birthday by clicking on a update on the scroll view of people's birthday 
    - https://birthday-app-352106.uc.r.appspot.com/api/delete_birthday : Try deleting a birthday in the same view
    - https://birthday-app-352106.uc.r.appspot.com/api/create_user : User sign in for the first time automatically fires this
    - https://birthday-app-352106.uc.r.appspot.com/api/retrieve_user : User login automatically fires it
    - https://birthday-app-352106.uc.r.appspot.com/api/update_user : Try updating the user information on the profile view
    - https://birthday-app-352106.uc.r.appspot.com/api/upload_photo : Try updating a photo on the profile view

Analytics Endpoint 
- Can be accomplished by simply visitng: https://birthday-app-352106.uc.r.appspot.com/analytics/dashboard/
- username: admin password: mpcs52555


Tasks related Curl Commands for API

curl -H "X-Api-Key: abcdef123456" "https://birthday-app-352106.uc.r.appspot.com/api/health"

curl  -H "X-Api-Key: abcdef123456" "https://birthday-app-352106.uc.r.appspot.com/api/notify_birthdays"