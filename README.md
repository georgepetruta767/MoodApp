MoodUp - a Mobile Mental Health Application

There is a rising concern about increasing rates of anxiety and depression among
children and young people. Mental health problems cause major distress and a
harmful impact on social relationships, school or even physical health. Digital surveillance of symptoms offers a promising and innovative way to de-
liver interventions for depression and psychotic disorders. Therefore, mobile health
(mHealth) offers an incredibly powerful platform for monitoring and management
of mental health symptoms.

This application's objective is to reduce the user's recurring symptoms of anxiety and depression by        providing data about their daily life events and grading each one depending on their mood.  After having graded some events, the user will be able to visualize, in charts, how their mood was influenced by different factors such as location, time, people's characteristics and so on.


![image](https://github.com/user-attachments/assets/cd408ea3-ad45-475b-a56c-5a9fa815ae0b)

Frontend-wise, this application has been developed using AngularTS and the Ionic framework for the UI components. ASP.NET Core 6 has been used to develop the server part of this application (backend), with an integrated postgreSQL relational database. Therefore, the architecture is a basic client-server one, the 2 communicating with each other through HTTP. Regarding the backend, there are a few more things worth-mentioning: the Entity Framework Core Object Relational Mapper (with a database first approach) has been used to generate the C# code for all the database tables that contribute to the correct functioning of the app, the ASP.NET Core Identity Provider has been used to achieve user management, because it offer built-in support for all user-related operations such as: register, login, change password etc. 

![image](https://github.com/user-attachments/assets/012c9982-7015-4780-905a-3c2a2d259ee4)
