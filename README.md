# User Manager App

This application is a user management system built with Vue.js, Axios, and SweetAlert. The primary purpose of this application is to allow users to create and manage user accounts within different populations. It features dynamic form fields based on the selected population and includes error handling to display meaningful messages to users.

## Features
 - Population Selection: Users can select a population from a dropdown menu, which dynamically updates the form fields based on the selected population.
 - Dynamic Form Fields: The form fields change based on the selected population, ensuring that users provide the necessary information for each population type.
 - Form Submission: Users can submit the form to create a new user within the selected population. The form includes fields for username, password, and any additional fields required by the population.
 - Error Handling: The application uses SweetAlert to display error messages. If the submission fails, the user is informed about the specific errors (e.g., non-unique email or employee ID) with detailed messages.

## Setup
1. docker-compose up -d
2. docker exec -it vite_docker sh
3. npm i && npm run dev
4. url: http://localhost:8071/

## Back End project
The back end project can be found in https://github.com/arturhayne/user-manager

## Demo

[Watch the demo](https://drive.google.com/file/d/1rOEmYc8S1bqGIA356dqThk2XDUFHHVA7/preview)

In the video we can see the email is unique across Employee and External Contractors Population, but not in Freelancer population.



