# photo_galary_with_bloc

A new Flutter project.

## Getting Started


### This Example uses Bloc 

### App Features 
#### - firebase email / password auth
#### - firebase google auth
#### - upload images to firebase storage
#### - save users in firebase firestore
#### - uses bloc pattern


### Steps To Work With This Example :

##### * Create New Firebase Project
##### * Enable Email Method In Authantcation Section
##### * Change Storage Rules To The Following 

###### rules_version = '2';
###### service firebase.storage {
###### match /b/{bucket}/o {
###### function isFolderOwner(userId){
###### return request.auth != null && request.auth.uid == userId;}
######  match /{userId}/{allPaths=**} {
######  allow create, read, update, write : if isFolderOwner(userId);
#}}}
##### * Connect You App With Firebase You Can Follow Steps In This Link
##### https://firebase.flutter.dev/docs/overview#installation
##### * In The Terminal Run This Command flutter pub get

