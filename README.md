# Happy Birthday App

### App Information 
* Category: Lifestyle Apps
* Device Compatibility: iPhone X+
* Age Group: 12+

## Application Detail

### Introduction 
HBD App, or a simple Happy Birthday App, is developed using SwiftUI for the front-end
and Python Flask for the backend. The front-end is composed of three tab views, each with a
different functionality. The backend is split into three sections of API, tasks, and analytics. This
app aims to facilitate tracking birthdays easier for people without having to clutter their
calendars. It sends them an email notification every Monday at 9AM (CT) of upcoming
birthdays in that week and aggregates the upcoming birthdays in a summary view for easy
viewing. The calendar tab is also there to help people get quickly contextualized, and adding and
deleting birthday has never been easier! 

### Specification 
- Front-end developed with SwiftUI
- Back-end developed with Flask, subdivided into Analytics, Tasks, and API
- Back-end deployed on to cloud with Google Cloud Platform (App Engine)
- Used GCP datastore and storage to store user information and pictures / thumbnails
- Cloud functions scheduled with with Cloud Scheduler to automate sending out emails (using mailgun)
- GCP service has been halted since July 2022. 


### Things you could do 
- Change User Profile (short description to your profile picture) 
- Add important birthdays and sort them by importance and reminder interval
- Receive notifications of upcoming birthdays via email (mailgun)
- See a quickview of the calendar for easy contextualization


### App Sample Look
<img src="https://github.com/bspark2318/birthdayApp/blob/main/Screenshot/sample.png" 
     alt="Sample Application Look#1" width="640" height="360">

## Moving Forward

### Room for Improvements / Further Development
- Integrating calendar with people's birthdays 
- Moving over to iPhone's own notification systems instead of email 




